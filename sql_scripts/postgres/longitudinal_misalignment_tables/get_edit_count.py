"""
Returns an integer that is the number of rows with a parent id from a 
revision dataset for a given period.

Usage:
    get_edit_count (-h|--help)
    get_edit_count <input>
                    [--debug]
                    [--verbose]

Options:
    -h, --help  This help message is printed
    <input>     Path to misalignment/edit
                breakdown file to process.
    --debug     Print debug logging to stderr
    --verbose   Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
import mysqltsv
import sys
import re
import json


logger = logging.getLogger(__name__)

def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_file = mysqltsv.Reader(open(args['<input>'],
        'rt', encoding='utf-8', errors='replace'), headers=False,
        types=[int, int, int, str, str, int, int, str, int, int, str, str, str])


    revision_output_file = sys.stdout


    verbose = args['--verbose']

    run(input_file, revision_output_file, verbose)


def run(input_file, revision_output_file, verbose):


    revision_with_parent_id_count = 0

    for i, line in enumerate(input_file):

        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Processing revision: {0}\n".format(i))  
            sys.stderr.flush()
            
        parent_rev_id = line[8]

        if parent_rev_id:
            revision_with_parent_id_count += 1


    revision_output_file.write(revision_with_parent_id_count)


main()

