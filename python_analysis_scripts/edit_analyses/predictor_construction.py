"""
Take labelled data and aggregates to create predictors for a model.



Usage:
    predictor_construction (-h|--help)
    predictor_construction <input> <output>
                           [--debug]
                           [--verbose]

Options:
    -h, --help  This help message is printed
    <input>     Path to input file to process.                           
    <output>    Where output will be written
    --debug     Print debug logging to stderr
    --verbose   Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
import sys
import mysqltsv
from collections import defaultdict
import datetime
import statistics
import re


logger = logging.getLogger(__name__)


EDIT_KIND_RE = \
    re.compile(r'/\* (wb(set|create|edit|remove)([a-z]+)((-[a-z]+)*))', re.I)
GENERIC_EDIT_COMMENT_RE = \
    re.compile(r'/\* wbeditentity-update:[\d]+\| \*/$', re.I)
BOT_RE = re.compile(r'.*(ro)?bot\b', re.I)
PROPERTY_RE = re.compile(r'.*\[\[property:p([\d]+)\]\]', re.I)


def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_file = mysqltsv.Reader(
        open(args['<input>'],'rt'), headers=True, 
        types=[str, str, str, str, str, int, str, str, str, str, str, str, str,
            str])


    output_file = mysqltsv.Writer(open(args['<output>'], "w"), headers=[
        'user', 'username', 'session_start', 'mean_in_seconds', 
        'std_in_seconds', 'namespace_0_edits', 'namespace_1_edits', 
        'namespace_2_edits', 'namespace_3_edits', 'namespace_4_edits', 
        'namespace_5_edits', 'namespace_120_edits', 'namespace_121_edits', 
        'edits', 'bot', 'human', 'session_length_in_seconds', 
        'inter_edits_less_than_5_seconds', 
        'inter_edits_between_5_and_20_seconds', 
        'inter_edits_greater_than_20_seconds',
        'claims', 'distinct_claims', 'distinct_pages', 'disinct_edit_kinds', 
        'generic_bot_comment', 'bot_revision_comment', 'sitelink_changes', 
        'alias_changed', 'label_changed', 'description_changed', 'edit_war', 
        'inter_edits_less_than_2_seconds', 'things_removed', 'things_modified'])

    verbose = args['--verbose']

    run(input_file, output_file, verbose)


def run(input_file, output_file, verbose):
    
    agg_stats = defaultdict(lambda: defaultdict(lambda: defaultdict(int)))
    inter_edit_times = defaultdict(lambda: defaultdict(list))
    edit_type = defaultdict(lambda: defaultdict(list))
    usernames = defaultdict(lambda: defaultdict(list))
    agg_unique_attributes = defaultdict(lambda: defaultdict(lambda:
        defaultdict(lambda: defaultdict(int))))


    namespace_0_total = 0
    edit_kind_regex_total = 0


    for i, line in enumerate(input_file):

        user = line["user"]
        start = line["session_start"]
        end = line["session_end"]
        comment = line["comment"]
        previous_timestamp = line["prev_timestamp"]
        timestamp = line["timestamp"]
        title_with_n = str(line["namespace"])+line["title"]

        agg_stats[user][start][line["namespace"]] += 1
        agg_stats[user][start]['edits'] += 1
        edit_type[user][start] = line["edit_type"]
        usernames[user][start] = line["username"]


        # Iteration 2 of predictor creation: looking at comments

        if line["namespace"] == 0 and comment:

            if EDIT_KIND_RE.match(comment):

                edit_kind = EDIT_KIND_RE.match(comment).group(1)
                agg_unique_attributes[user][start]["edit_kind"][edit_kind] = 1

                if EDIT_KIND_RE.match(comment).group(3) == 'sitelink':

                    agg_stats[user][start]["sitelinks_changed"] += 1

                elif EDIT_KIND_RE.match(comment).group(3) == 'aliases':

                    agg_stats[user][start]["alias_changed"] += 1

                elif EDIT_KIND_RE.match(comment).group(3) == 'label':

                    agg_stats[user][start]["label_changed"] += 1

                elif EDIT_KIND_RE.match(comment).group(3) == 'description':

                    agg_stats[user][start]["description_changed"] += 1

                elif EDIT_KIND_RE.match(comment).group(3) == 'claim' or \
                    EDIT_KIND_RE.match(comment).group(3) == 'claims':

                    agg_stats[user][start]["claim_changed"] += 1

                    if EDIT_KIND_RE.match(comment).group(4) == '-create':
                        agg_stats[user][start]["claim_creation"] += 1

                    if PROPERTY_RE.match(comment):

                        claim = PROPERTY_RE.match(comment).group(1)
                        # print("MATCHED BY PROPERTY REGEX", comment, user, line['username'], line['timestamp'], claim)
                        agg_unique_attributes[user][start]["claims"][claim] = 1

                        comment_title_with_n = comment + title_with_n
                        if EDIT_KIND_RE.match(comment).group(4) != \
                            '-update-qualifiers' and \
                            user in agg_unique_attributes and \
                            start in agg_unique_attributes[user] and \
                            "com" in agg_unique_attributes[user][start] and \
                            comment_title_with_n in \
                            agg_unique_attributes[user][start]["com"]:

                                agg_stats[user][start]["edit_war"] = 1
                        else:

                            agg_unique_attributes[user]\
                                                 [start]\
                                                 ["com"]\
                                                 [comment_title_with_n] = 1
                    # else:
                        # print("NOT MATCHED BY PROPERTY REGEX", comment, user, line['username'], line['timestamp'])
                if EDIT_KIND_RE.match(comment).group(4) == '-set' or \
                    EDIT_KIND_RE.match(comment).group(4) == '-update':

                    agg_stats[user][start]["things_modified"] += 1

                if EDIT_KIND_RE.match(comment).group(4) == '-remove':

                    agg_stats[user][start]["things_removed"] += 1

            # else:
                # print("NOT MATCHED BY EDIT KIND REGEX", comment, user, line['username'], line['timestamp'])

            if BOT_RE.match(comment):
                # print("MATCHED BY BOT REGEX", comment, user, line['username'], line['timestamp'])
                agg_stats[user][start]["bot_revision_comment"] = 1
            # else:
                # print("NOT MATCHED BY BOT REGEX", comment, user, line['username'], line['timestamp'])

            if GENERIC_EDIT_COMMENT_RE.match(comment):

                agg_stats[user][start]["generic_bot_comment"] = 1
                
            
        
        # Iteration 2 of predictor creation: titles

        agg_unique_attributes[user][start]["pages"][title_with_n] = 1



        session_length = datetime.datetime(int(end[0:4]),
                                           int(end[4:6]),
                                           int(end[6:8]),
                                           int(end[8:10]),
                                           int(end[10:12]),
                                           int(end[12:14]))\
                         -\
                         datetime.datetime(int(start[0:4]),
                                           int(start[4:6]),
                                           int(start[6:8]),
                                           int(start[8:10]),
                                           int(start[10:12]),
                                           int(start[12:14]))

        agg_stats[user][start]['session_length'] =\
            session_length.total_seconds()

        if previous_timestamp:
            inter_edit_time = datetime.datetime(int(timestamp[0:4]),
                                                int(timestamp[4:6]),
                                                int(timestamp[6:8]),
                                                int(timestamp[8:10]),
                                                int(timestamp[10:12]),
                                                int(timestamp[12:14]))\
                              -\
                              datetime.datetime(int(previous_timestamp[0:4]),
                                                int(previous_timestamp[4:6]),
                                                int(previous_timestamp[6:8]),
                                                int(previous_timestamp[8:10]),
                                                int(previous_timestamp[10:12]),
                                                int(previous_timestamp[12:14]))

            inter_edit_times[user][start]\
                .append(inter_edit_time.total_seconds())


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Revisions analyzed: {0}\n".format(i))  
            sys.stderr.flush()



    for user in agg_stats:
        for session_start in agg_stats[user]:

            inter_edit_mean = "NULL"
            inter_edit_std = "NULL"
            inter_edits_less_than_2_seconds = 0
            inter_edits_less_than_5_seconds = 0
            inter_edits_between_5_and_20_seconds = 0
            inter_edits_greater_than_20_seconds = 0



            if user in inter_edit_times and\
                session_start in inter_edit_times[user]:
                
                inter_edit_mean = statistics\
                    .mean(inter_edit_times[user][session_start])

                if len(inter_edit_times[user][session_start]) > 1:
                    inter_edit_std = statistics\
                        .stdev(inter_edit_times[user][session_start])
                else:
                    continue

                for inter_edit_time in inter_edit_times[user][session_start]:
                    if inter_edit_time < 2:
                        inter_edits_less_than_2_seconds += 1
                    if inter_edit_time < 5:
                        inter_edits_less_than_5_seconds += 1
                    elif inter_edit_time >= 5 and inter_edit_time <= 20:
                        inter_edits_between_5_and_20_seconds += 1
                    else:
                        inter_edits_greater_than_20_seconds += 1
            else:
                continue


            if edit_type[user][session_start] == "bot":
                bot_edit = "TRUE"
                human_edit = "FALSE"
            else:
                bot_edit = "FALSE"
                human_edit = "TRUE"


            output_file.write(
                [user,
                 usernames[user][session_start],
                 session_start,
                 inter_edit_mean,
                 inter_edit_std,
                 agg_stats[user][session_start][0],
                 agg_stats[user][session_start][1],
                 agg_stats[user][session_start][2],
                 agg_stats[user][session_start][3],
                 agg_stats[user][session_start][4],
                 agg_stats[user][session_start][5],
                 agg_stats[user][session_start][120],
                 agg_stats[user][session_start][121],
                 agg_stats[user][session_start]["edits"],
                 bot_edit,
                 human_edit,
                 agg_stats[user][session_start]["session_length"],
                 inter_edits_less_than_5_seconds,
                 inter_edits_between_5_and_20_seconds,
                 inter_edits_greater_than_20_seconds,
                 agg_stats[user][session_start]["claim_creation"],
                 len(agg_unique_attributes[user][session_start]["claims"]),
                 len(agg_unique_attributes[user][session_start]["pages"]),
                 len(agg_unique_attributes[user][session_start]["edit_kind"]),
                 agg_stats[user][session_start]["generic_bot_comment"],
                 agg_stats[user][session_start]["bot_revision_comment"],
                 agg_stats[user][session_start]["sitelinks_changed"],
                 agg_stats[user][session_start]["alias_changed"],
                 agg_stats[user][session_start]["label_changed"],
                 agg_stats[user][session_start]["description_changed"],
                 agg_stats[user][session_start]["edit_war"],
                 inter_edits_less_than_2_seconds,
                 agg_stats[user][session_start]["things_removed"],
                 agg_stats[user][session_start]["things_modified"]])


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Sessions processed: {0}\n".format(i))  
            sys.stderr.flush()





main()

