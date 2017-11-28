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


logger = logging.getLogger(__name__)


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
        'title', 'rev_id', 'user', 'username', 'comment', 'namespace', 
        'timestamp', 'prev_timestamp', 'session_start', 'session_end', 
        'session_index', 'session_events', 'event_index', 'edit_type'])

    verbose = args['--verbose']

    run(input_file, output_file, verbose)


def run(input_file, output_file, verbose):
    
    agg_stats = defaultdict(lambda: defaultdict(lambda: defaultdict(int)))
    inter_edit_times = defaultdict(lambda: defaultdict(list))
    edit_type = defaultdict(lambda: defaultdict(list))

    for i, line in enumerate(input_file):
        agg_stats[line["user"]][line["session_start"]][line["namespace"]] += 1
        agg_stats[line["user"]][line["session_start"]]['edits'] += 1
        edit_type[line["user"]][line["session_start"]] = line["edit_type"]

        session_length = datetime.datetime(line["session_start"][0:4],
                                           line["session_start"][4:6],
                                           line["session_start"][6:8],
                                           line["session_start"][8:10],
                                           line["session_start"][10:12],
                                           line["session_start"][12:14]) -\
                         datetime.datetime(line["session_end"][0:4],
                                           line["session_end"][4:6],
                                           line["session_end"][6:8],
                                           line["session_end"][8:10],
                                           line["session_end"][10:12],
                                           line["session_end"][12:14])

        agg_stats[line["user"]][line["session_start"]]['session_length'] += session_length

        if line["prev_timestamp"] != "NULL":
            inter_edit_time = datetime.datetime(line["timestamp"][0:4],
                                                line["timestamp"][4:6],
                                                line["timestamp"][6:8],
                                                line["timestamp"][8:10],
                                                line["timestamp"][10:12],
                                                line["session_start"][12:14]) -\
                              datetime.datetime(line["prev_timestamp"][0:4],
                                                line["prev_timestamp"][4:6],
                                                line["prev_timestamp"][6:8],
                                                line["prev_timestamp"][8:10],
                                                line["prev_timestamp"][10:12],
                                                line["prev_timestamp"][12:14])

            inter_edit_times[line["user"]][line["session_start"]].append(inter_edit_time)


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Revisions analyzed: {0}\n".format(i))  
            sys.stderr.flush()


    for user in agg_stats:
        for session_start in agg_stats[user]:
            inter_edit_mean = mean(inter_edit_times[user][session_start])
            inter_edit_std = stdev(inter_edit_times[user][session_start])

            output_file.write(
                [inter_edit_mean,
                 inter_edit_std,
                 agg_stats[user][session_start][0],
                 agg_stats[user][session_start][120],
                 agg_stats[user][session_start]["edits"],
                 edit_type[user][session_start],
                 agg_stats[user][session_start]["session_length"]])


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Sessions processed: {0}\n".format(i))  
            sys.stderr.flush()





main()

