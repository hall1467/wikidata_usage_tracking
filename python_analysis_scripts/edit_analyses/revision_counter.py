"""
Selects number of distinct revisions.



Usage:
    revision_counter (-h|--help)
    revision_counter <input>
                     [--debug]
                     [--verbose]

Options:
    -h, --help  This help message is printed
    <input>     Path to input file to process.                           
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
        types=[str, str, str, str, str, int, str, str, str, str, str, str, 
            str, str])


    verbose = args['--verbose']

    run(input_file, verbose)


def run(input_file, verbose):
    
    sessions = defaultdict(lambda: defaultdict(int))


    for i, line in enumerate(input_file):
        sessions[line["user"]][line["session_start"]] = 1


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Revisions analyzed: {0}\n".format(i))  
            sys.stderr.flush()


    session_sum = 0
    for user in sessions:
        for session_start in sessions[user]:
            session_sum += 1

    print("Sessions: {0}".format(session_sum))


main()

