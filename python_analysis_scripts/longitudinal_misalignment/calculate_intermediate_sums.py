"""
Post processing (subset of columns) to calculate intermediate sum edit counts 
and other variables. Date sorted.

Usage:
    calculate_intermediate_sums (-h|--help)
    calculate_intermediate_sums <input> <output>
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
import operator
from collections import defaultdict
import mysqltsv


logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_file = mysqltsv.Reader(open(args['<input>'], "r"), headers=True,
        types=[int, float, int, int, int, int])

    output_file = mysqltsv.Writer(open(args['<output>'], "w"), headers=[
        'yyyymm', 'aligned_entities', 'difference_in_alignment_with_previous',
        'bot_edits', 'semi_automated_edits', 'non_bot_edits', 'anon_edits',
        'current_bot_edits_count', 'current_semi_automated_edits_count', 
        'current_non_bot_edits_count', 'current_anon_edits_count'])

    verbose = args['--verbose']

    run(input_file, output_file, verbose)


def run(input_file, output_file, verbose):

    current_bot_edits_count = 0
    semi_automated_edits_count = 0
    non_bot_edits_count = 0
    anon_edits_count = 0
    all_edits_count = 0

    previous_alignment = 0

    for i, line in enumerate(input_file):

        
        current_bot_edits_count += line['bot_edits']
        semi_automated_edits_count += line['semi_automated_edits']
        non_bot_edits_count += line['non_bot_edits']
        anon_edits_count += line['anon_edits']

        output_file.write([line['yyyymm'], 
                           line['aligned_entities'],
                           line['aligned_entities'] - previous_alignment,
                           line['bot_edits'], 
                           line['semi_automated_edits'], 
                           line['non_bot_edits'], 
                           line['anon_edits'],  
                           current_bot_edits_count, 
                           semi_automated_edits_count, 
                           non_bot_edits_count, 
                           anon_edits_count])

        previous_alignment = line['aligned_entities']

main()

