"""
Wasted edits occur after maximum quality class has been reached for an entity.
The input will have an order: entity, year, month

Usage:
    wasted_edit_analysis (-h|--help)
    wasted_edit_analysis <input> <output>
                         [--debug]
                         [--verbose]

Options:
    -h, --help  This help message is printed
    <input>     Path to misalignment/edit breakdown file to process.
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


logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_file = mysqltsv.Reader(open(args['<input>'],
        'rt', encoding='utf-8', errors='replace'), headers=False,
        types=[str, int, int, str, str, int, int, int, int, int])


    output_file = mysqltsv.Writer(
        open(args['<output>'], "w"), 
        headers=[ 
                 'bot_edits',
                 'semi_automated_edits',
                 'non_bot_edits',
                 'anon_edits'])

    verbose = args['--verbose']

    run(input_file, output_file, verbose)


def run(input_file, output_file, verbose):

    entity_discovered = {}
    wasted_edits = defaultdict(lambda: defaultdict(int))


    previous_entity = None
    highest_view_class_number = 0
    attained = False


    for i, line in enumerate(input_file):

        entity = line[0]
        qual = line[3]
        views = line[4]
        bot_edits = line[5]
        semi_automated_edits = line[6]
        non_bot_edits = line[7]
        anon_edits = line[8]


        quality_class_number = 0

        if qual == 'A':
            quality_class_number = 5
        elif qual == 'B':
            quality_class_number = 4
        elif qual == 'C':
            quality_class_number = 3
        elif qual == 'D':
            quality_class_number = 2
        elif qual == 'E':
            quality_class_number = 1


        view_class_number = 0

        if views == 'A':
            view_class_number = 5
        elif views == 'B':
            view_class_number = 4
        elif views == 'C':
            view_class_number = 3
        elif views == 'D':
            view_class_number = 2
        elif views == 'E':
            view_class_number = 1



        if entity in entity_discovered:
            if view_class_number <= quality_class_number and attained:
                
                wasted_edits[entity]["bot_edits"]\
                    += bot_edits
                wasted_edits[entity]["semi_automated_edits"]\
                    += semi_automated_edits
                wasted_edits[entity]["non_bot_edits"]\
                    += non_bot_edits
                wasted_edits[entity]["anon_edits"]\
                    += anon_edits

            else:
                wasted_edits[entity]["bot_edits"] = 0
                wasted_edits[entity]["semi_automated_edits"] = 0
                wasted_edits[entity]["non_bot_edits"] = 0
                wasted_edits[entity]["anon_edits"] = 0


        else:
            entity_discovered[entity] = 1


        if view_class_number <= quality_class_number:
            attained = True
        else:
            attained = False


        previous_entity = entity

 
        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Entity-months processed: {0}\n".format(i))  
            sys.stderr.flush()


    all_bot_edits = 0
    all_semi_automated_edits = 0
    all_non_bot_edits = 0
    all_anon_edits = 0


    # Adding up totals by edit type
    for entity in wasted_edits:

        all_bot_edits += wasted_edits[entity]["bot_edits"]
        all_semi_automated_edits += wasted_edits[entity]["semi_automated_edits"]
        all_non_bot_edits += wasted_edits[entity]["non_bot_edits"]
        all_anon_edits += wasted_edits[entity]["anon_edits"]


    output_file.write([
        all_bot_edits,
        all_semi_automated_edits,
        all_non_bot_edits,
        all_anon_edits])



main()

