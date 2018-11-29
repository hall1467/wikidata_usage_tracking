"""
Takes a data file of pages views and weighted sums for the "universe" of used 
Wikidata and the weighted sums for all items longitudinally.

For each month:

1. Adds missing weighted_sums for non-existent items
2. Returns weighted sum for all existing and currently non-existent items

Usage:
    misalignment_preprocessor (-h|--help)
    misalignment_preprocessor <input_universe> <input_monthly_item_quality> <output>
                              [--debug]
                              [--verbose]

Options:
    -h, --help                    This help message is printed
    <input_universe>              Path to Wikidata universe of
                                  items file to process.
    <input_monthly_item_quality>  Path to monthly item quality
                                  file to process.
    <output>                      Where output will be written
    --debug                       Print debug logging to stderr
    --verbose                     Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
from collections import defaultdict
import mysqltsv
import sys
import re


logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_universe_file = mysqltsv.Reader(open(args['<input_universe>'],
        'rt', encoding='utf-8', errors='replace'), headers=False,
        types=[int, str, int])

    input_monthly_item_quality_file = mysqltsv.Reader(
        open(args['<input_monthly_item_quality>'],
        'rt', encoding='utf-8', errors='replace'), headers=False,
        types=[int, str, int, int, str, float])


    output_file = mysqltsv.Writer(
        open(args['<output>'], "w"), 
        headers=[
                 'page_title',
                 'year',
                 'month',
                 'weighted_sum',
                 'page_views'])


    verbose = args['--verbose']

    run(input_universe_file, input_monthly_item_quality_file, output_file, 
        verbose)


def run(input_universe_file, input_monthly_item_quality_file, output_file, 
        verbose):

    universe_of_entities = defaultdict(float)

    for i, line in enumerate(input_universe_file):



        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Processing universe entity: {0}\n".format(i))  
            sys.stderr.flush()



        universe_of_entities[line[1]] = line[2]


    prev_month = None
    monthly_entity_weighted_sums = defaultdict(lambda: defaultdict(float))

    for i, line in enumerate(input_monthly_item_quality_file):


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Processing item quality entry: {0}\n".format(i))  
            sys.stderr.flush()


        page_title = line[1]
        monthly_timestamp = str(line[3])
        weighted_sum = line[5]

        if prev_month and prev_month != monthly_timestamp:
            sys.stderr.write("Outputting month {0}. On quality entry: {1}\n"
                .format(prev_month,i))  
            sys.stderr.flush()
            
            for univ_entity in universe_of_entities:

                output_weighted_sum = None

                if univ_entity in monthly_entity_weighted_sums and \
                    prev_month in monthly_entity_weighted_sums[univ_entity]:

                    # Add 1 since we have a class for non-existent items
                    output_weighted_sum = 1 + \
                        monthly_entity_weighted_sums[univ_entity][prev_month]
                else:
                    output_weighted_sum = 0


                year = prev_month[0:4]
                month = prev_month[4:6]                

                output_file.write([
                    univ_entity,
                    year,
                    month,
                    output_weighted_sum,
                    universe_of_entities[univ_entity]])


            monthly_entity_weighted_sums = \
                defaultdict(lambda: defaultdict(float))


        monthly_entity_weighted_sums[page_title][monthly_timestamp] = \
            weighted_sum
        prev_month = monthly_timestamp




main()

