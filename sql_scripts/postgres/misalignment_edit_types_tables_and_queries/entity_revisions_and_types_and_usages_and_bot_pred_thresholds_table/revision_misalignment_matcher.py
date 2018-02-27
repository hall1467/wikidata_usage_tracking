"""
Match edits to following month so that they can be joined with
misalignment data for that month.

Usage:
    revision_misalignment_matcher (-h|--help)
    revision_misalignment_matcher <revisions_input> <output>
                                  [--debug]
                                  [--verbose]

Options:
    -h, --help         This help message is printed
    <revisions_input>  Path to revisions file to process.
    <output>           Where output will be written
    --debug            Print debug logging to stderr
    --verbose          Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
from collections import defaultdict
import mysqltsv
import re
import sys


logger = logging.getLogger(__name__)



def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    revisions_input_file = mysqltsv.Reader(
        open(args['<revisions_input>'],'rt'),
        headers=False, types=[str, int, str, str, str, int, int, int, str, str, 
        str, str, str, str, str])


    output_file = mysqltsv.Writer(open(args['<output>'], "w"))

    verbose = args['--verbose']


    run(revisions_input_file, output_file, verbose)


def run(revisions_input_file, output_file, verbose):


    for i, line in enumerate(revisions_input_file):


        current_year = line[6]
        current_month = line[7]

        misalignment_matching_year, misalignment_matching_month =\
            increment(current_year, current_month)

        output_file.write(
            [line[0],
             line[1],
             line[2],
             line[3],
             line[4],
             line[5],
             line[6],
             line[7],
             line[8],
             line[9],
             line[10],
             line[11],
             line[12],
             line[13],
             line[14],
             misalignment_matching_year,
             misalignment_matching_month])


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Revisions processed: {0}\n".format(i))  
            sys.stderr.flush()



def increment(year, month):

    if month == 12:
        incremented_date_year = year + 1
        incremented_date_month = 1
    else:
        incremented_date_year = year
        incremented_date_month = month + 1

    return incremented_date_year, incremented_date_month



main()


