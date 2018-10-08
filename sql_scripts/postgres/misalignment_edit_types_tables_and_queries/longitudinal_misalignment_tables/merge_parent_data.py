"""
Merges parent quality information with revision metadata.

Usage:
    merge_parent_data (-h|--help)
    merge_parent_data <revision_input> <parent_input> <output>
                      [--debug]
                      [--verbose]

Options:
    -h, --help        This help message is printed
    <revision_input>  Path to revision edit file to process.
    <parent_input>    Path to parent edit file to process.
    <output>          Where output will be written
    --debug           Print debug logging to stderr
    --verbose         Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
from collections import defaultdict
import mysqltsv
import sys


logger = logging.getLogger(__name__)

def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    revision_input_file = mysqltsv.Reader(open(args['<revision_input>'],
        'rt', encoding='utf-8', errors='replace'), headers=True,
        types=[str, int, str, str, str, float, float, float, str, str, str, 
        str, str, str, str])

    parent_input_file = mysqltsv.Reader(open(args['<parent_input>'],
        'rt', encoding='utf-8', errors='replace'), headers=True,
        types=[int, int, float])

    output_file = mysqltsv.Writer(
        open(args['<output>'], "w"), 
        headers=[
                 'page_title',
                 'namespace',
                 'edit_type',
                 'agent_type',
                 'rev_id',
                 'weighted_sum',
                 'expected_quality',
                 'expected_quality_quantile',
                 'page_views',
                 'yyyy',
                 'mm',
                 'quality_difference',
                 'gender',
                 'instance_of',
                 'subclass_of',
                 'parent_weighted_sum'])

    verbose = args['--verbose']

    run(revision_input_file, parent_input_file, output_file, verbose)


def run(revision_input_file, parent_input_file, output_file, verbose):


    parent_revisions = defaultdict(lambda: defaultdict(int))

    for i, line in enumerate(parent_input_file):
        

        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Processing parent data: {0}\n".format(i))  
            sys.stderr.flush()

        parent_revisions[line['rev_id']][line['parent_id']] = \
            line['parent_weighted_sum']

    for i, line in enumerate(revision_input_file):

        
        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Merging revision metadata: {0}\n".format(i))  
            sys.stderr.flush()

        p_weighted_sum = None
        
        if line['rev_id'] in parent_revisions:
            p_weighted_sum = parent_revisions[line['rev_id']][line['parent_id']]

                
            output_file.write([
                line['page_title'],
                line['namespace'],
                line['edit_type'],
                line['agent_type'],
                line['rev_id'],
                line['weighted_sum'],
                line['expected_quality'],
                line['expected_quality_quantile'],
                line['page_views'],
                line['yyyy'],
                line['mm'],
                line['quality_difference'],
                line['gender'],
                line['instance_of'],
                line['subclass_of'],
                p_weighted_sum])


main()

