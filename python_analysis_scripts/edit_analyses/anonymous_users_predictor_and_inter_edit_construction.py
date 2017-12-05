"""
Take labelled data and aggregates to create predictors for a model.



Usage:
    anonymous_users_predictor_and_inter_edit_construction (-h|--help)
    anonymous_users_predictor_and_inter_edit_construction <input> <predictor_output> <inter_edit_output>
                                                          [--debug]
                                                          [--verbose]

Options:
    -h, --help           This help message is printed
    <input>              Path to input file to process.                           
    <predictor_output>   Where predictor output will be written
    <inter_edit_output>  Where inter edit output will be written
    --debug              Print debug logging to stderr
    --verbose            Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
import sys
import mysqltsv
from collections import defaultdict
import datetime
import statistics


logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_file = mysqltsv.Reader(
        open(args['<input>'],'rt'), headers=True, 
        types=[str, str, str, str, str, int, str, str, str, str, str, str, str])


    predictor_output_file = mysqltsv.Writer(
        open(args['<predictor_output>'], "w"),
        headers=['username', 'session_start',
                 'mean_in_seconds', 'std_in_seconds', 'namespace_0_edits', 
                 'namespace_1_edits', 'namespace_2_edits', 'namespace_3_edits',
                 'namespace_4_edits', 'namespace_5_edits', 
                 'namespace_120_edits', 'namespace_121_edits', 'edits',
                 'session_length_in_seconds', 
                 'inter_edits_less_than_5_seconds', 
                 'inter_edits_between_5_and_20_seconds', 
                 'inter_edits_greater_than_20_seconds'])


    inter_edit_output_file = mysqltsv.Writer(
        open(args['<inter_edit_output>'], "w"),
        headers=['username', 'session_start', 'inter_edit'])

    verbose = args['--verbose']

    run(input_file, predictor_output_file, inter_edit_output_file, verbose)


def run(input_file, predictor_output_file, inter_edit_output_file, verbose):
    
    agg_stats = defaultdict(lambda: defaultdict(lambda: defaultdict(int)))
    inter_edit_times = defaultdict(lambda: defaultdict(list))

    for i, line in enumerate(input_file):
        agg_stats[line["username"]][line["session_start"]][line["namespace"]]\
            += 1
        agg_stats[line["username"]][line["session_start"]]['edits'] += 1

        session_length = datetime.datetime(int(line["session_end"][0:4]),
                                           int(line["session_end"][4:6]),
                                           int(line["session_end"][6:8]),
                                           int(line["session_end"][8:10]),
                                           int(line["session_end"][10:12]),
                                           int(line["session_end"][12:14]))\
                         -\
                         datetime.datetime(int(line["session_start"][0:4]),
                                           int(line["session_start"][4:6]),
                                           int(line["session_start"][6:8]),
                                           int(line["session_start"][8:10]),
                                           int(line["session_start"][10:12]),
                                           int(line["session_start"][12:14]))

        agg_stats[line["username"]][line["session_start"]]['session_length'] +=\
            session_length.total_seconds()

        if line["prev_timestamp"]:
            previous_timestamp = line["prev_timestamp"]
            inter_edit_time = datetime.datetime(int(line["timestamp"][0:4]),
                                                int(line["timestamp"][4:6]),
                                                int(line["timestamp"][6:8]),
                                                int(line["timestamp"][8:10]),
                                                int(line["timestamp"][10:12]),
                                                int(line["timestamp"][12:14]))\
                              -\
                              datetime.datetime(int(previous_timestamp[0:4]),
                                                int(previous_timestamp[4:6]),
                                                int(previous_timestamp[6:8]),
                                                int(previous_timestamp[8:10]),
                                                int(previous_timestamp[10:12]),
                                                int(previous_timestamp[12:14]))

            inter_edit_times[line["username"]][line["session_start"]]\
                .append(inter_edit_time.total_seconds())


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Revisions analyzed: {0}\n".format(i))  
            sys.stderr.flush()


    for username in agg_stats:
        for session_start in agg_stats[user]:

            inter_edit_mean = "NULL"
            inter_edit_std = "NULL"
            inter_edits_less_than_5_seconds = 0
            inter_edits_between_5_and_20_seconds = 0
            inter_edits_greater_than_20_seconds = 0



            if username in inter_edit_times and\
                session_start in inter_edit_times[username]:
                inter_edit_mean = statistics\
                    .mean(inter_edit_times[username][session_start])

                for inter_edit in inter_edit_times[username][session_start]:
                    inter_edit_output_file.write(
                        [username, 
                         session_start,
                         inter_edit])

                if len(inter_edit_times[username][session_start]) > 1:
                    inter_edit_std = statistics\
                        .stdev(inter_edit_times[username][session_start])
                else:
                    continue

                for inter_edit_time in inter_edit_times[username][session_start]:
                    if inter_edit_time < 5:
                        inter_edits_less_than_5_seconds += 1
                    elif inter_edit_time >= 5 and inter_edit_time <= 20:
                        inter_edits_between_5_and_20_seconds += 1
                    else:
                        inter_edits_greater_than_20_seconds += 1
            else:
                continue


            predictor_output_file.write(
                [username, 
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
                 agg_stats[user][session_start]["session_length"],
                 inter_edits_less_than_5_seconds,
                 inter_edits_between_5_and_20_seconds,
                 inter_edits_greater_than_20_seconds])


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Sessions processed: {0}\n".format(i))  
            sys.stderr.flush()





main()

