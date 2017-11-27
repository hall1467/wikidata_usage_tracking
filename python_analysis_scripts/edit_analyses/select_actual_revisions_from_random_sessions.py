"""
Takes revision event data file and random session data file. Returns revisions
that are part of the random sessions



Usage:
    select_actual_revisions_from_random_sessions (-h|--help)
    select_actual_revisions_from_random_sessions <input_revision_event_data> <input_random_session_data> <output>
                                                 [--debug]
                                                 [--verbose]

Options:
    -h, --help                   This help message is printed
    <input_revision_event_data>  Path to input revision event data file to 
                                 process.
    <input_random_session_data>  Path to input random session data file to 
                                 process.                             
    <output>                     Where output will be written
    --debug                      Print debug logging to stderr
    --verbose                    Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
import sys
from collections import defaultdict
import mysqltsv


logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_revision_event_data_file = mysqltsv.Reader(
        open(args['<input_revision_event_data>'],'rt'), headers=True, 
        types=[str, str, str, str, str, str, str, str, str, str, str, str, str])

    input_random_session_data_file = mysqltsv.Reader(
        open(args['<input_random_session_data>'],'rt'), headers=False, 
        types=[str, str, str, str, str])


    output_file = mysqltsv.Writer(open(args['<output>'], "w"), headers=[
        'title', 'rev_id', 'user', 'username', 'comment', 'namespace', 
        'timestamp','prev_timestamp', 'session_start', 'session_end', 
        'session_index', 'session_events', 'event_index'])

    verbose = args['--verbose']

    run(input_revision_event_data_file, input_random_session_data_file, 
        output_file, verbose)


def run(input_revision_event_data_file, input_random_session_data_file, 
    output_file, verbose):
    
    random_sessions = defaultdict(lambda: defaultdict(int))


    for i, line in enumerate(input_random_session_data_file):
        random_sessions[line[0]][line[1]] = 1


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Random sessions returned: {0}\n".format(i))  
            sys.stderr.flush()



    for i, line in enumerate(input_revision_event_data_file):
        if line["user"] in random_sessions and\
            line["session_start"] in random_sessions[line["user"]]:

            output_file.write(
                [line["title"],
                 line["rev_id"],
                 line["user"],
                 line["username"],
                 line["comment"],
                 line["namespace"],
                 line["timestamp"],
                 line["prev_timestamp"],
                 line["session_start"],
                 line["session_end"],
                 line["session_index"],
                 line["session_events"],
                 line["event_index"]])


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Revisions considered: {0}\n".format(i))  
            sys.stderr.flush()


main()

