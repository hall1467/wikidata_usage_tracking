"""
Match monthly edit data to the following month so that it can be combined with 
item quality datasets.

Usage:
    match_monthly_edits_with_following_month (-h|--help)
    match_monthly_edits_with_following_month <input> <output>
                                    [--debug]
                                    [--verbose]

Options:
    -h, --help  This help message is printed
    <input>     Path to file to process.
    <output>    Where revisions results
                will be written
    --debug     Print debug logging to stderr
    --verbose   Print dots and stuff to stderr  
"""



import docopt
import sys
import logging
import mwxml
import gzip
from collections import defaultdict
import mysqltsv
import re

logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )


    input_file = mysqltsv.Reader(open(args['<input>'], "r"), headers=False,
        types=[str, str, float, int, int])

    revisions_output_file = mysqltsv.Writer(open(args['<output>'], "w"))

    verbose = args['--verbose']

    run(input_file, revisions_output_file, verbose)


def run(input_file, output_file, verbose):

    for i, line in enumerate(input_file):

        if int(line[1]) == 12:
            new_date = str(int(line[0]) + 1)[2:4] + "01"
        else:
            if int(line[1]) < 9:
                new_date = line[0][2:4] + "0" + str(int(line[1]) + 1)
            else:
                new_date = line[0][2:4] + str(int(line[1]) + 1)

        output_file.write([line[0], line[1], new_date, line[2], line[3], line[4]
            ])



main()

