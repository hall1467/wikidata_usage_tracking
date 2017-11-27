"""
Selects revisions if the session it's part of contains property or item edits.



Usage:
    select_revisions_containing_property_or_item_edits (-h|--help)
    select_revisions_containing_property_or_item_edits <input> <output>
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

    input_file_used_in_second_iteration = mysqltsv.Reader(
        open(args['<input>'],'rt'), headers=True, 
        types=[str, str, str, str, str, int, str, str, str, str, str, str, str])


    output_file = mysqltsv.Writer(open(args['<output>'], "w"), headers=[
        'title', 'rev_id', 'user', 'username', 'comment', 'namespace', 
        'timestamp', 'prev_timestamp', 'session_start', 'session_end', 
        'session_index', 'session_events', 'event_index'])

    verbose = args['--verbose']

    run(input_file, input_file_used_in_second_iteration, output_file, verbose)


def run(input_file, input_file_used_in_second_iteration, output_file, verbose):
    
    has_property_or_item_edits = defaultdict(lambda: defaultdict(int))


    for i, line in enumerate(input_file):
        if line["namespace"] == 0 or line["namespace"] == 120:
            has_property_or_item_edits[line["user"]][line["session_start"]] = 1


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("First pass, revisions checked: {0}\n".format(i))  
            sys.stderr.flush()


    for i, line in enumerate(input_file_used_in_second_iteration):
        if line["user"] in has_property_or_item_edits and\
            line["session_start"] in has_property_or_item_edits[line["user"]]:
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
            sys.stderr.write("Second pass, revisions checked: {0}\n".format(i))  
            sys.stderr.flush()


main()

