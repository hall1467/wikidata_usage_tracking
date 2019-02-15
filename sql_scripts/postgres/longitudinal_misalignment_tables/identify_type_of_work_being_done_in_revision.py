"""
Splits into months. Also checks that revisions are from
namespace 0. Note, already filtered upstream in recent changes.

Usage:
    identify_type_of_work_being_done_in_revision (-h|--help)
    identify_type_of_work_being_done_in_revision <input_original> <input_sample> <output>
                                                 [--debug]
                                                 [--verbose]

Options:
    -h, --help        This help message is printed
    <input_original>  Path to original editted file with comments
    <input_sample>    Path to sampled file
    <output>          Where month output will be written
    --debug           Print debug logging to stderr
    --verbose         Print dots and stuff to stderr  
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



    input_original_file = mysqltsv.Reader(open(args['<input_original>'],
        'rt', encoding='utf-8', errors='replace'), headers=False,
        types=[int, int, int, str, str, int, int, str, int, int, str, str, str])

    input_sample_file = mysqltsv.Reader(open(args['<input_sample>'],
        'rt', encoding='utf-8', errors='replace'), headers=False,
        types=[str, int, int, str, str, str, str, int, str, str, int, int, int, str, str, str])

    output_file = mysqltsv.Writer(
        open(args['<output>'], "w"), 
        headers=[
                 'page_title',
                 'namespace',
                 'period',
                 'gender',
                 'coordinate_location',
                 'us_location',
                 'edit_type',
                 'rev_id',
                 'expected_quality',
                 'expected_quality_quantile',
                 'page_views',
                 'yyyy',
                 'mm',
                 'does_parent_exist',
                 'parent_weighted_sum',
                 'parent_id'])

    verbose = args['--verbose']

    run(input_original_file, input_sample_file, output_file, verbose)


def run(input_original_file, input_sample_file, output_file, verbose):

    revision_comments = defaultdict(str)

    for i, line in enumerate(input_original_file):


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Processing original revisions: {0}\n".format(i))  
            sys.stderr.flush()


        revision_comments[line[6]] = line[7]

    for i, line in enumerate(input_sample_file):

        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Processing sample revisions: {0}\n".format(i))  
            sys.stderr.flush()

        
        comment = None
        if line[7] in revision_comments:
            comment = revision_comments[line[7]]
        else:
            sys.exit("Rev comment not found in rev: {0}\n".format(line[7]))

            
        # output_file.write([
        #     line[0],
        #     line[1],
        #     line[2],
        #     line[3],
        #     line[4],
        #     line[5],
        #     line[6],
        #     line[7],
        #     line[8],
        #     line[9],
        #     line[10],
        #     line[11],
        #     line[12],
        #     line[13],
        #     line[14],
        #     line[15],
        #     line[16]])


main()

