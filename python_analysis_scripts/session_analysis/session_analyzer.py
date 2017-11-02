"""
Takes in session data for each revision and calculates the number 
of edits of different mean frequencies. 
Input file has revisions sorted by time

Usage:
    session_analyzer (-h|--help)
    session_analyzer <input_revision_data> <output>
                             [--debug]
                             [--verbose]

Options:
    -h, --help             This help message is printed
    <input_revision_data>  Path to revision file to process.
    <output>               Where output will be written
    --debug                Print debug logging to stderr
    --verbose              Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
from collections import defaultdict
import mysqltsv
import json
import datetime
import sys


logger = logging.getLogger(__name__)



def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_revision_data_file = mysqltsv.Reader(open(
        args['<input_revision_data>'],'rt', encoding='utf-8', errors='replace'),
        headers=True, types=[str, str, str, int, str, str, int, int, int, int])


    output_file = mysqltsv.Writer(open(args['<output>'], "w"))

    verbose = args['--verbose']


    run(input_revision_data_file, output_file, verbose)


def run(input_revision_data_file, output_file, verbose):


    user_sessions_time_diff = defaultdict(lambda: defaultdict(float))
    user_sessions_size = defaultdict(lambda: defaultdict(int))
    user_sessions_time_diff_mean = defaultdict(lambda: defaultdict(float))

    sessions_grouping_sizes = defaultdict(lambda: defaultdict(int))


    for i, line in enumerate(input_revision_data_file):
        if line["session_events"] < 10 or line["prev_timestamp"] is None:
            continue

        
          

        current_revision_time_parsed = datetime.datetime(
                                           int(line["timestamp"][0:4]),
                                           int(line["timestamp"][4:6]),
                                           int(line["timestamp"][6:8]),
                                           int(line["timestamp"][8:10]),
                                           int(line["timestamp"][10:12]),
                                           int(line["timestamp"][12:14])
                                       )

        last_revision_time_parsed = datetime.datetime(
                                           int(line["prev_timestamp"][0:4]),
                                           int(line["prev_timestamp"][4:6]),
                                           int(line["prev_timestamp"][6:8]),
                                           int(line["prev_timestamp"][8:10]),
                                           int(line["prev_timestamp"][10:12]),
                                           int(line["prev_timestamp"][12:14])
                                       )


        user_sessions_time_diff[line['user']][line['session_start']] +=\
            (current_revision_time_parsed - last_revision_time_parsed)\
                .total_seconds()
        
        user_sessions_size[line['user']][line['session_start']] += 1

        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Revisions processed: {0}\n".format(i))  
            sys.stderr.flush()


    # compute session mean time differences and compute groupings
    for username in user_sessions_time_diff:
        for session in user_sessions_time_diff[username]:

            time_difference = user_sessions_time_diff[username][session]
            size = user_sessions_size[username][session]
            session_mean = time_difference/size

            if session_mean <= 5:
                sessions_grouping_sizes[session[0:6]]['under_5_seconds'] +=\
                    user_sessions_size[username][session]
            elif session_mean > 5 and session_mean <= 10:
                sessions_grouping_sizes[session[0:6]]['5_to_10_seconds'] +=\
                    user_sessions_size[username][session]
            elif session_mean > 10 and session_mean <= 20:
                sessions_grouping_sizes[session[0:6]]['10_to_20_seconds'] +=\
                    user_sessions_size[username][session]
            elif session_mean > 20 and session_mean <= 100:
                sessions_grouping_sizes[session[0:6]]['20_to_100_seconds'] +=\
                    user_sessions_size[username][session]
            else:
                sessions_grouping_sizes[session[0:6]]['over_100_seconds'] +=\
                    user_sessions_size[username][session]
    

    # results
    for month in sorted(sessions_grouping_sizes):
        output_file.write([
            month,
            sessions_grouping_sizes[month]['under_5_seconds'],
            sessions_grouping_sizes[month]['5_to_10_seconds'],
            sessions_grouping_sizes[month]['10_to_20_seconds'],
            sessions_grouping_sizes[month]['20_to_100_seconds'],
            sessions_grouping_sizes[month]['over_100_seconds']])


main()


