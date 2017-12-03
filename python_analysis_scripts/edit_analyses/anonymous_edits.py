"""
Takes revision event data file. Keeps just anonymous user data.



Usage:
    anonymous_edits (-h|--help)
    anonymous_edits <input> <output>
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
from collections import defaultdict
import mysqltsv
import re


logger = logging.getLogger(__name__)

REGESTERED_USER_ID_RE = re.compile(r'^(\d)+$')


def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_file = mysqltsv.Reader(
        open(args['<input>'],'rt'), headers=True, 
        types=[str, str, str, str, str, str, str, str, str, str, str, str, str])


    output_file = mysqltsv.Writer(open(args['<output>'], "w"), headers=[
        'title', 'rev_id', 'user', 'username', 'comment', 'namespace', 
        'timestamp','prev_timestamp', 'session_start', 'session_end', 
        'session_index', 'session_events', 'event_index'])

    verbose = args['--verbose']

    run(input_file, output_file, verbose)


def run(input_file, output_file, verbose):


    for i, line in enumerate(input_file):

        if not line["user"]:
            if line["username"]:
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

