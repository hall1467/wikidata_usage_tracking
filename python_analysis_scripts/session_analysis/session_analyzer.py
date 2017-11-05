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


    output_file = mysqltsv.Writer(open(args['<output>'], "w"), headers=[
        'yyyymm', 'under_five_seconds', 'five_to_ten_seconds',
        'ten_to_twenty_seconds', 'twenty_to_one_hundred_seconds',
        'over_one_hundred_seconds'])


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


            next_date_year, next_date_month =\
                increment(int(session[0:4]), int(session[4:6]))
            next_date =\
                str(next_date_year) + str(next_date_month.zfill(2))


            if session_mean <= 5:
                sessions_grouping_sizes[next_date]['under_five'] +=\
                    user_sessions_size[username][session]
            elif session_mean > 5 and session_mean <= 10:
                sessions_grouping_sizes[next_date]['five_to_ten'] +=\
                    user_sessions_size[username][session]
            elif session_mean > 10 and session_mean <= 20:
                sessions_grouping_sizes[next_date]['ten_to_twenty'] +=\
                    user_sessions_size[username][session]
            elif session_mean > 20 and session_mean <= 100:
                sessions_grouping_sizes[next_date]['twenty_to_one_hundred'] +=\
                    user_sessions_size[username][session]
            else:
                sessions_grouping_sizes[next_date]['over_one_hundred'] +=\
                    user_sessions_size[username][session]
    

    # results
    for month in sorted(sessions_grouping_sizes):
        output_file.write([
            month,
            sessions_grouping_sizes[month]['under_five'],
            sessions_grouping_sizes[month]['five_to_ten'],
            sessions_grouping_sizes[month]['ten_to_twenty'],
            sessions_grouping_sizes[month]['twenty_to_one_hundred'],
            sessions_grouping_sizes[month]['over_one_hundred']])



def increment(year, month):

    if month == 12:
        incremented_date_year = year + 1
        incremented_date_month = 1
    else:
        incremented_date_year = year
        incremented_date_month = month + 1

    return incremented_date_year, incremented_date_month



main()


