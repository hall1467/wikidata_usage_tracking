"""
Extracts weighted_score from json returned from ores.
Returns in tsv format.

Usage:
    extract_weighted_score (-h|--help)
    extract_weighted_score <input> <output>
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
from collections import defaultdict
import mysqltsv
import sys
import re
import json


logger = logging.getLogger(__name__)


EDIT_KIND_RE = re.compile(r'/\* (wb(set|create|edit|remove)([a-z]+)((-[a-z]+)*))', re.I)


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
                 'namespace',
                 'page_title',
                 'edit_type',
                 'agent_type',
                 'page_views',
                 'rev_id',
                 'weighted_score',])

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
        weighted_score = probabilities['E'] * 1 + probabilities['D'] * 2 + \
            probabilities['C'] * 3 + probabilities['B'] * 4 + \
            probabilities['B'] * 5 
        output_edit_type = None
        output_agent_type = None





        output_file.write([
            json_line['namespace'],
            json_line['page_title'],
            json_line['edit_type'],
            json_line['agent_type'],
            json_line['page_views'],
            json_line['rev_id'],
            weighted_score])



main()

