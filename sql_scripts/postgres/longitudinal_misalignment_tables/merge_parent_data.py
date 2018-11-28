"""
Merges parent quality information with revision metadata.

Usage:
    extract_and_merge_data.py (-h|--help)
    extract_and_merge_data.py <child_input> <parent_input> <output>
                              [--debug]
                              [--verbose]

Options:
    -h, --help      This help message is printed
    <child_input>   Path to revision edit file to process.
    <parent_input>  Path to parent edit file to process.
    <output>        Where output will be written
    --debug         Print debug logging to stderr
    --verbose       Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
from collections import defaultdict
import mysqltsv
import sys
import json


logger = logging.getLogger(__name__)

def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    child_input_file = open(args['<child_input>'])

    parent_input_file = open(args['<parent_input>'])

    output_file = mysqltsv.Writer(
        open(args['<output>'], "w"), 
        headers=[
                 'namespace',
                 'page_title',
                 'edit_type',
                 'page_views',
                 'rev_id',
                 'weighted_sum',
                 'misalignment_year',
                 'misalignment_month',
                 'period',
                 'parent_weighted_sum'])

    verbose = args['--verbose']

    run(child_input_file, parent_input_file, output_file, verbose)


def run(child_input_file, parent_input_file, output_file, verbose):


    parent_weighted_sum_dict = defaultdict(int)

    for i, line in enumerate(parent_input_file):
        
        json_line = json.loads(line)


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Processing parent data: {0}\n".format(i))  
            sys.stderr.flush()


        extracted_score = extract_score(line)

        if extracted_score:
            parent_weighted_sum_dict[line['child_rev_id']] = \
                extracted_score

    for i, line in enumerate(child_input_file):

        
        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Merging revision metadata: {0}\n".format(i))  
            sys.stderr.flush()


        extracted_score = extract_score(line)

        if extracted_score:
            parent_weighted_sum_dict[line['child_rev_id']] = \
                extracted_score
        else:
            # We don't want this revision if it does not produce a score
            continue

        p_weighted_sum = None
        
        if line['rev_id'] in parent_weighted_sum_dict:
            p_weighted_sum = parent_weighted_sum_dict[line['rev_id']]
                
        
        output_file.write([
            line['namespace'],
            line['page_title'],
            line['edit_type'],
            line['page_views'],
            line['rev_id'],
            line['weighted_sum'],
            line['misalignment_year'],
            line['misalignment_month'],
            line['period'],
            p_weighted_sum])



def extract_score(json_line):
    if 'error' in json_line['score']['itemquality']:
        return None

    probabilities = \
        json_line['score']['itemquality']['score']['probability']
    p_weighted_sum = (probabilities['E'] * 0 + probabilities['D'] * 1 + \
        probabilities['C'] * 2 + probabilities['B'] * 3 + \
        probabilities['A'] * 4) + 1

    return p_weighted_sum



main()

