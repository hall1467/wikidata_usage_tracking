"""
Extracts weighted_score from json returned from ores.
Returns in tsv format.

Usage:
    extract_weighted_score_from_parent (-h|--help)
    extract_weighted_score_from_parent <input> <output>
                                       [--debug]
                                       [--verbose]

Options:
    -h, --help  This help message is printed
    <input>     Path to edit file to process.
    <output>    Where output will be written
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

    input_file = open(args['<input>'])

    output_file = mysqltsv.Writer(
        open(args['<output>'], "w"), 
        headers=[
                 'rev_id',
                 'parent_id',
                 'parent_weighted_sum'])

    verbose = args['--verbose']

    run(input_file, output_file, verbose)


def run(input_file, output_file, verbose):


    for i, line in enumerate(input_file):


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Processing revision: {0}\n".format(i))  
            sys.stderr.flush()


        json_line = json.loads(line)
        if 'error' in json_line['score']['itemquality']:
            continue
        probabilities = \
            json_line['score']['itemquality']['score']['probability']
        p_weighted_sum = (probabilities['E'] * 0 + probabilities['D'] * 1 + \
            probabilities['C'] * 2 + probabilities['B'] * 3 + \
            probabilities['A'] * 4) + 1

        output_file.write([
            json_line['next_rev_id'],
            json_line['rev_id'],
            p_weighted_sum])


main()

