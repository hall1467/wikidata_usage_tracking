"""
Merges parent quality information with revision metadata.
Also, extracts weighted scores.
Writes out based on period.

Usage:
    extract_and_merge_data.py (-h|--help)
    extract_and_merge_data.py <child_input> <parent_input> <output_period_1> <output_period_2> <output_period_3> <output_period_4>
                              [--debug]
                              [--verbose]

Options:
    -h, --help         This help message is printed
    <child_input>      Path to revision edit file to process.
    <parent_input>     Path to parent edit file to process.
    <output_period_1>  Where output for period 1 (2013-2014) will be written
    <output_period_2>  Where output for period 2 (2014-2015) will be written
    <output_period_3>  Where output for period 3 (2015-2016) will be written
    <output_period_4>  Where output for period 4 (2016-2017) will be written
    --debug            Print debug logging to stderr
    --verbose          Print dots and stuff to stderr  
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

    output_period_1_file = mysqltsv.Writer(
        open(args['<output_period_1>'], "w"), 
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

    output_period_2_file = mysqltsv.Writer(
        open(args['<output_period_2>'], "w"), 
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

    output_period_3_file = mysqltsv.Writer(
        open(args['<output_period_3>'], "w"), 
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

    output_period_4_file = mysqltsv.Writer(
        open(args['<output_period_4>'], "w"), 
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

    run(child_input_file, parent_input_file, output_period_1_file,
        output_period_2_file, output_period_3_file, output_period_4_file, verbose)


def run(child_input_file, parent_input_file, output_period_1_file,
    output_period_2_file, output_period_3_file, output_period_4_file, verbose):


    parent_weighted_sum_dict = defaultdict(int)

    for i, line in enumerate(parent_input_file):
        
        json_line = json.loads(line)


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Processing parent data: {0}\n".format(i))  
            sys.stderr.flush()


        extracted_score = extract_score(json_line)

        if extracted_score:
            parent_weighted_sum_dict[json_line['child_rev_id']] = \
                extracted_score

    for i, line in enumerate(child_input_file):

        
        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Merging revision metadata: {0}\n".format(i))  
            sys.stderr.flush()

        json_line = json.loads(line)
        extracted_score = extract_score(json_line)

        if extracted_score:
            parent_weighted_sum_dict[json_line['rev_id']] = \
                extracted_score
        else:
            # We don't want this revision if it does not produce a score
            continue

        p_weighted_sum = None
        
        if json_line['rev_id'] in parent_weighted_sum_dict:
            p_weighted_sum = parent_weighted_sum_dict[json_line['rev_id']]
                
        if json_line['period'] == 1:
            output_period_1_file.write([
                json_line['namespace'],
                json_line['page_title'],
                json_line['agent_type'],
                json_line['page_views'],
                json_line['rev_id'],
                json_line['weighted_sum'],
                json_line['misalignment_year'],
                json_line['misalignment_month'],
                json_line['period'],
                p_weighted_sum])
        elif json_line['period'] == 2:
            output_period_2_file.write([
                json_line['namespace'],
                json_line['page_title'],
                json_line['agent_type'],
                json_line['page_views'],
                json_line['rev_id'],
                json_line['weighted_sum'],
                json_line['misalignment_year'],
                json_line['misalignment_month'],
                json_line['period'],
                p_weighted_sum])
        elif json_line['period'] == 3:
            output_period_3_file.write([
                json_line['namespace'],
                json_line['page_title'],
                json_line['agent_type'],
                json_line['page_views'],
                json_line['rev_id'],
                json_line['weighted_sum'],
                json_line['misalignment_year'],
                json_line['misalignment_month'],
                json_line['period'],
                p_weighted_sum])
        else:
            output_period_4_file.write([
                json_line['namespace'],
                json_line['page_title'],
                json_line['agent_type'],
                json_line['page_views'],
                json_line['rev_id'],
                json_line['weighted_sum'],
                json_line['misalignment_year'],
                json_line['misalignment_month'],
                json_line['period'],
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

