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
        types=[str, int, int, str, str, int, int, int, int, int, int, int, int, 
        int, int, int, int, int, int, int])


    output_file = mysqltsv.Writer(
        open(args['<output>'], "w"), 
        headers=[ 
                 'bot_edits',
                 'semi_automated_edits',
                 'non_bot_edits',
                 'other_anon_edits',
                 'anon_ten_recall_bot_edits',
                 'anon_twenty_recall_bot_edits',
                 'anon_thirty_recall_bot_edits',
                 'anon_forty_recall_bot_edits',
                 'anon_fifty_recall_bot_edits',
                 'anon_sixty_recall_bot_edits',
                 'anon_seventy_recall_bot_edits',
                 'anon_eighty_recall_bot_edits',
                 'anon_ninety_recall_bot_edits',
                 'anon_one_hundred_recall_bot_edits',
                 'bot_edits_proportion',
                 'semi_automated_edits_proportion',
                 'non_bot_edits_proportion',
                 'other_anon_edits_proportion',
                 'anon_ten_recall_bot_edits_proportion',
                 'anon_twenty_recall_bot_edits_proportion',
                 'anon_thirty_recall_bot_edits_proportion',
                 'anon_forty_recall_bot_edits_proportion',
                 'anon_fifty_recall_bot_edits_proportion',
                 'anon_sixty_recall_bot_edits_proportion',
                 'anon_seventy_recall_bot_edits_proportion',
                 'anon_eighty_recall_bot_edits_proportion',
                 'anon_ninety_recall_bot_edits_proportion',
                 'anon_one_hundred_recall_bot_edits_proportion',
                 'all_types_of_anon_edits_proportion'])

    verbose = args['--verbose']

    run(input_file, output_file, verbose)


def run(input_file, output_file, verbose):

    entity_discovered = {}
    wasted_edits = defaultdict(lambda: defaultdict(int))


    previous_entity = None
    attained = False

    all_bot_edits = 0
    all_semi_automated_edits = 0
    all_non_bot_edits = 0
    all_other_anon_edits = 0
    all_anon_ten_recall_bot_edits = 0
    all_anon_twenty_recall_bot_edits = 0
    all_anon_thirty_recall_bot_edits = 0
    all_anon_forty_recall_bot_edits = 0
    all_anon_fifty_recall_bot_edits = 0
    all_anon_sixty_recall_bot_edits = 0
    all_anon_seventy_recall_bot_edits = 0
    all_anon_eighty_recall_bot_edits = 0
    all_anon_ninety_recall_bot_edits = 0
    all_anon_one_hundred_recall_bot_edits = 0


    for i, line in enumerate(input_file):

        entity = line[0]
        qual = line[3]
        views = line[4]
        bot_edits = line[5]
        semi_automated_edits = line[6]
        non_bot_edits = line[7]
        other_anon_edits = line[8]
        anon_ten_recall_bot_edits = line[9]
        anon_twenty_recall_bot_edits = line[10]
        anon_thirty_recall_bot_edits = line[11]
        anon_forty_recall_bot_edits = line[12]
        anon_fifty_recall_bot_edits = line[13]
        anon_sixty_recall_bot_edits = line[14]
        anon_seventy_recall_bot_edits = line[15]
        anon_eighty_recall_bot_edits = line[16]
        anon_ninety_recall_bot_edits = line[17]
        anon_one_hundred_recall_bot_edits = line[18]


        all_bot_edits += bot_edits
        all_semi_automated_edits += semi_automated_edits
        all_non_bot_edits += non_bot_edits
        all_other_anon_edits += other_anon_edits
        all_anon_ten_recall_bot_edits += anon_ten_recall_bot_edits
        all_anon_twenty_recall_bot_edits += anon_twenty_recall_bot_edits
        all_anon_thirty_recall_bot_edits += anon_thirty_recall_bot_edits
        all_anon_forty_recall_bot_edits += anon_forty_recall_bot_edits
        all_anon_fifty_recall_bot_edits += anon_fifty_recall_bot_edits
        all_anon_sixty_recall_bot_edits += anon_sixty_recall_bot_edits
        all_anon_seventy_recall_bot_edits += anon_seventy_recall_bot_edits
        all_anon_eighty_recall_bot_edits += anon_eighty_recall_bot_edits
        all_anon_ninety_recall_bot_edits += anon_ninety_recall_bot_edits
        all_anon_one_hundred_recall_bot_edits\
            += anon_one_hundred_recall_bot_edits


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
                wasted_edits[entity]["other_anon_edits"]\
                    += other_anon_edits
                wasted_edits[entity]["anon_ten_recall_bot_edits"]\
                    += anon_ten_recall_bot_edits
                wasted_edits[entity]["anon_twenty_recall_bot_edits"]\
                    += anon_twenty_recall_bot_edits
                wasted_edits[entity]["anon_thirty_recall_bot_edits"]\
                    += anon_thirty_recall_bot_edits
                wasted_edits[entity]["anon_forty_recall_bot_edits"]\
                    += anon_forty_recall_bot_edits
                wasted_edits[entity]["anon_fifty_recall_bot_edits"]\
                    += anon_fifty_recall_bot_edits
                wasted_edits[entity]["anon_sixty_recall_bot_edits"]\
                    += anon_sixty_recall_bot_edits
                wasted_edits[entity]["anon_seventy_recall_bot_edits"]\
                    += anon_seventy_recall_bot_edits
                wasted_edits[entity]["anon_eighty_recall_bot_edits"]\
                    += anon_eighty_recall_bot_edits
                wasted_edits[entity]["anon_ninety_recall_bot_edits"]\
                    += anon_ninety_recall_bot_edits
                wasted_edits[entity]["anon_one_hundred_recall_bot_edits"]\
                    += anon_one_hundred_recall_bot_edits
            else:
                wasted_edits[entity]["bot_edits"] = 0
                wasted_edits[entity]["semi_automated_edits"] = 0
                wasted_edits[entity]["non_bot_edits"] = 0
                wasted_edits[entity]["other_anon_edits"] = 0
                wasted_edits[entity]["anon_ten_recall_bot_edits"] = 0
                wasted_edits[entity]["anon_twenty_recall_bot_edits"] = 0
                wasted_edits[entity]["anon_thirty_recall_bot_edits"] = 0
                wasted_edits[entity]["anon_forty_recall_bot_edits"] = 0
                wasted_edits[entity]["anon_fifty_recall_bot_edits"] = 0
                wasted_edits[entity]["anon_sixty_recall_bot_edits"] = 0
                wasted_edits[entity]["anon_seventy_recall_bot_edits"] = 0
                wasted_edits[entity]["anon_eighty_recall_bot_edits"] = 0
                wasted_edits[entity]["anon_ninety_recall_bot_edits"] = 0
                wasted_edits[entity]["anon_one_hundred_recall_bot_edits"] = 0


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


    all_wasted_bot_edits = 0
    all_wasted_semi_automated_edits = 0
    all_wasted_non_bot_edits = 0
    all_wasted_other_anon_edits = 0
    all_wasted_anon_ten_recall_bot_edits = 0
    all_wasted_anon_twenty_recall_bot_edits = 0
    all_wasted_anon_thirty_recall_bot_edits = 0
    all_wasted_anon_forty_recall_bot_edits = 0
    all_wasted_anon_fifty_recall_bot_edits = 0
    all_wasted_anon_sixty_recall_bot_edits = 0
    all_wasted_anon_seventy_recall_bot_edits = 0
    all_wasted_anon_eighty_recall_bot_edits = 0
    all_wasted_anon_ninety_recall_bot_edits = 0
    all_wasted_anon_one_hundred_recall_bot_edits = 0

    # Adding up totals by edit type
    for entity in wasted_edits:

        all_wasted_bot_edits += wasted_edits[entity]["bot_edits"]
        all_wasted_semi_automated_edits\
            += wasted_edits[entity]["semi_automated_edits"]
        all_wasted_non_bot_edits += wasted_edits[entity]["non_bot_edits"]
        all_wasted_other_anon_edits += wasted_edits[entity]["other_anon_edits"]
        all_wasted_anon_ten_recall_bot_edits\
            += wasted_edits[entity]["anon_ten_recall_bot_edits"]
        all_wasted_anon_twenty_recall_bot_edits\
            += wasted_edits[entity]["anon_twenty_recall_bot_edits"]
        all_wasted_anon_thirty_recall_bot_edits\
            += wasted_edits[entity]["anon_thirty_recall_bot_edits"]
        all_wasted_anon_forty_recall_bot_edits\
            += wasted_edits[entity]["anon_forty_recall_bot_edits"]
        all_wasted_anon_fifty_recall_bot_edits\
            += wasted_edits[entity]["anon_fifty_recall_bot_edits"]
        all_wasted_anon_sixty_recall_bot_edits\
            += wasted_edits[entity]["anon_sixty_recall_bot_edits"]
        all_wasted_anon_seventy_recall_bot_edits\
            += wasted_edits[entity]["anon_seventy_recall_bot_edits"]
        all_wasted_anon_eighty_recall_bot_edits\
            += wasted_edits[entity]["anon_eighty_recall_bot_edits"]
        all_wasted_anon_ninety_recall_bot_edits\
            += wasted_edits[entity]["anon_ninety_recall_bot_edits"]
        all_wasted_anon_one_hundred_recall_bot_edits\
            += wasted_edits[entity]["anon_one_hundred_recall_bot_edits"]


    all_wasted_types_of_anon_edits =\
        all_wasted_other_anon_edits +\
        all_wasted_anon_ten_recall_bot_edits +\
        all_wasted_anon_twenty_recall_bot_edits +\
        all_wasted_anon_thirty_recall_bot_edits +\
        all_wasted_anon_forty_recall_bot_edits +\
        all_wasted_anon_fifty_recall_bot_edits +\
        all_wasted_anon_sixty_recall_bot_edits +\
        all_wasted_anon_seventy_recall_bot_edits +\
        all_wasted_anon_eighty_recall_bot_edits +\
        all_wasted_anon_ninety_recall_bot_edits +\
        all_wasted_anon_one_hundred_recall_bot_edits

    all_types_of_anon_edits =\
        all_other_anon_edits +\
        all_anon_ten_recall_bot_edits +\
        all_anon_twenty_recall_bot_edits +\
        all_anon_thirty_recall_bot_edits +\
        all_anon_forty_recall_bot_edits +\
        all_anon_fifty_recall_bot_edits +\
        all_anon_sixty_recall_bot_edits +\
        all_anon_seventy_recall_bot_edits +\
        all_anon_eighty_recall_bot_edits +\
        all_anon_ninety_recall_bot_edits +\
        all_anon_one_hundred_recall_bot_edits


    output_file.write([
        all_wasted_bot_edits,
        all_wasted_semi_automated_edits,
        all_wasted_non_bot_edits,
        all_wasted_other_anon_edits,
        all_wasted_anon_ten_recall_bot_edits,
        all_wasted_anon_twenty_recall_bot_edits,
        all_wasted_anon_thirty_recall_bot_edits,
        all_wasted_anon_forty_recall_bot_edits,
        all_wasted_anon_fifty_recall_bot_edits,
        all_wasted_anon_sixty_recall_bot_edits,
        all_wasted_anon_seventy_recall_bot_edits,
        all_wasted_anon_eighty_recall_bot_edits,
        all_wasted_anon_ninety_recall_bot_edits,
        all_wasted_anon_one_hundred_recall_bot_edits,
        all_wasted_bot_edits/\
            all_bot_edits,
        all_wasted_semi_automated_edits/\
            all_semi_automated_edits,
        all_wasted_non_bot_edits/\
            all_non_bot_edits,
        all_wasted_other_anon_edits/\
            all_other_anon_edits,
        all_wasted_anon_ten_recall_bot_edits/\
            all_anon_ten_recall_bot_edits,
        all_wasted_anon_twenty_recall_bot_edits/\
            all_anon_twenty_recall_bot_edits,
        all_wasted_anon_thirty_recall_bot_edits/\
            all_anon_thirty_recall_bot_edits,
        all_wasted_anon_forty_recall_bot_edits/\
            all_anon_forty_recall_bot_edits,
        all_wasted_anon_fifty_recall_bot_edits/\
            all_anon_fifty_recall_bot_edits,
        all_wasted_anon_sixty_recall_bot_edits/\
            all_anon_sixty_recall_bot_edits,
        all_wasted_anon_seventy_recall_bot_edits/\
            all_anon_seventy_recall_bot_edits,
        all_wasted_anon_eighty_recall_bot_edits/\
            all_anon_eighty_recall_bot_edits,
        all_wasted_anon_ninety_recall_bot_edits/\
            all_anon_ninety_recall_bot_edits,
        all_wasted_anon_one_hundred_recall_bot_edits/\
            all_anon_one_hundred_recall_bot_edits,
        all_wasted_types_of_anon_edits/\
            all_types_of_anon_edits])



main()

