"""
Extract out parent ORES scores and convert to json.

Usage:
    convert_to_json (-h|--help)
    convert_to_json <input> <revision_output>
                    [--debug]
                    [--verbose]

Options:
    -h, --help                This help message is printed
    <input>                   Path to misalignment/edit
                              breakdown file to process.
    <revision_output>         Where revision output will be written
    --debug                   Print debug logging to stderr
    --verbose                 Print dots and stuff to stderr  
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
        types=[int, int, int, str, str, int, int, str, int, int, str, str])


    revision_output_file = open(args['<revision_output>'], "w")


    verbose = args['--verbose']

    run(input_file, revision_output_file, verbose)


def run(input_file, revision_output_file, verbose):


    for i, line in enumerate(input_file):

        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Processing revision: {0}\n".format(i))  
            sys.stderr.flush()
            
        # Temporarily renames parent rev_id to be rev_id
        revision_output_file.write(json.dumps({
                    'misalignment_year' : line[0],
                    'misalignment_month' : line[1],
                    'namespace' : line[2],
                    'page_title': line[3],
                    'edit_type': line[4],
                    'page_views': line[5],
                    'child_rev_id': line[6],
                    'rev_id' = line[8],
                    'period': line[9],
                    'gender': line[10],
                    'coordinate_location': line[11],
                    'us_location': line[12],
                }) + "\n")


main()

