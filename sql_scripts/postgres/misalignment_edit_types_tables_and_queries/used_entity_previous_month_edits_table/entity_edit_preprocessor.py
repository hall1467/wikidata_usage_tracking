"""
Entity edit preprocessor to match edits to following month and to aggregate
monthly edits for an entity. Input file has edits sorted by time

Usage:
    entity_edit_preprocessor (-h|--help)
    entity_edit_preprocessor <input_edit_data> <output>
                             [--debug]
                             [--verbose]

Options:
    -h, --help         This help message is printed
    <input_edit_data>  Path to edit file to process.
    <output>           Where output will be written
    --debug            Print debug logging to stderr
    --verbose          Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
from collections import defaultdict
import mysqltsv
import re
import sys


logger = logging.getLogger(__name__)



def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_edit_data_file = mysqltsv.Reader(open(args['<input_edit_data>'],
        'rt', encoding='utf-8', errors='replace'), headers=False,
        types=[str, int, int, int, int, int, int])


    output_file = mysqltsv.Writer(open(args['<output>'], "w"))

    verbose = args['--verbose']


    run(input_edit_data_file, output_file, verbose)


def run(input_edit_data_file, output_file, verbose):

    # Gets updated as months go by
    edits = defaultdict(lambda: defaultdict(int))

    previous_entity = None
    previous_iteration_year = None
    previous_iteration_month = None

    for i, line in enumerate(input_edit_data_file):
        
        current_entity = line[0]
        current_year = line[1]
        current_month = line[2]

        if current_entity == previous_entity:

            # Create entries between previous and current entry of entity

            incremented_date_year = previous_iteration_year
            incremented_date_month = previous_iteration_month
            
            while int(str(current_year) + str(current_month).zfill(2)) >\
                int(str(incremented_date_year) +
                str(incremented_date_month).zfill(2)):

                # run increment
                incremented_date_year, incremented_date_month =\
                    increment(incremented_date_year, incremented_date_month)


                output_file.write(
                    [current_entity, 
                     incremented_date_year, 
                     incremented_date_month,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     edits[previous_entity]['bot'], 
                     edits[previous_entity]['semi_automated'], 
                     edits[previous_entity]['non_bot'],
                     edits[previous_entity]['anon'],
                     edits[previous_entity]['anon_ten_recall_bot'],
                     edits[previous_entity]['anon_twenty_recall_bot'],
                     edits[previous_entity]['anon_thirty_recall_bot'],
                     edits[previous_entity]['anon_forty_recall_bot'],
                     edits[previous_entity]['anon_fifty_recall_bot'],
                     edits[previous_entity]['anon_sixty_recall_bot'],
                     edits[previous_entity]['anon_seventy_recall_bot'],
                     edits[previous_entity]['anon_eighty_recall_bot'],
                     edits[previous_entity]['anon_ninety_recall_bot'],
                     edits[previous_entity]['anon_one_hundred_recall_bot']])


            incremented_date_year, incremented_date_month =\
                increment(incremented_date_year, incremented_date_month)


        else:

            # First create remaining entries for previous entity
            last_date_for_edits_to_occur = 201705

            while previous_entity != None and (last_date_for_edits_to_occur >=
                int(str(incremented_date_year) +
                str(incremented_date_month).zfill(2))):
                
                incremented_date_year, incremented_date_month =\
                    increment(incremented_date_year, incremented_date_month)


                output_file.write(
                    [current_entity, 
                     incremented_date_year, 
                     incremented_date_month,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     edits[previous_entity]['bot'], 
                     edits[previous_entity]['semi_automated'], 
                     edits[previous_entity]['non_bot'],
                     edits[previous_entity]['anon'],
                     edits[previous_entity]['anon_ten_recall_bot'],
                     edits[previous_entity]['anon_twenty_recall_bot'],
                     edits[previous_entity]['anon_thirty_recall_bot'],
                     edits[previous_entity]['anon_forty_recall_bot'],
                     edits[previous_entity]['anon_fifty_recall_bot'],
                     edits[previous_entity]['anon_sixty_recall_bot'],
                     edits[previous_entity]['anon_seventy_recall_bot'],
                     edits[previous_entity]['anon_eighty_recall_bot'],
                     edits[previous_entity]['anon_ninety_recall_bot'],
                     edits[previous_entity]['anon_one_hundred_recall_bot']])



            # Handle current entity which has not been seen in other iterations.
            incremented_date_year, incremented_date_month =\
                increment(current_year, current_month)



        edits[current_entity]['bot'] += line[3]
        edits[current_entity]['semi_automated'] += line[4]
        edits[current_entity]['non_bot'] += line[5]
        edits[current_entity]['anon'] += line[6]
        edits[current_entity]['anon_ten_recall_bot'] += line[7]
        edits[current_entity]['anon_twenty_recall_bot'] += line[8]
        edits[current_entity]['anon_thirty_recall_bot'] += line[9]
        edits[current_entity]['anon_forty_recall_bot'] += line[10]
        edits[current_entity]['anon_fifty_recall_bot'] += line[11]
        edits[current_entity]['anon_sixty_recall_bot'] += line[12]
        edits[current_entity]['anon_seventy_recall_bot'] += line[13]
        edits[current_entity]['anon_eighty_recall_bot'] += line[14]
        edits[current_entity]['anon_ninety_recall_bot'] += line[15]
        edits[current_entity]['anon_one_hundred_recall_bot'] += line[16]


        output_file.write(
            [current_entity, 
             incremented_date_year, 
             incremented_date_month,
             line[3],
             line[4],
             line[5],
             line[6],
             line[7],
             line[8],
             line[9],
             line[10],
             line[11],
             line[12],
             line[13],
             line[14],
             line[15],
             line[16],
             edits[previous_entity]['bot'], 
             edits[previous_entity]['semi_automated'], 
             edits[previous_entity]['non_bot'],
             edits[previous_entity]['anon'],
             edits[previous_entity]['anon_ten_recall_bot'],
             edits[previous_entity]['anon_twenty_recall_bot'],
             edits[previous_entity]['anon_thirty_recall_bot'],
             edits[previous_entity]['anon_forty_recall_bot'],
             edits[previous_entity]['anon_fifty_recall_bot'],
             edits[previous_entity]['anon_sixty_recall_bot'],
             edits[previous_entity]['anon_seventy_recall_bot'],
             edits[previous_entity]['anon_eighty_recall_bot'],
             edits[previous_entity]['anon_ninety_recall_bot'],
             edits[previous_entity]['anon_one_hundred_recall_bot']])


        previous_entity = current_entity
        previous_iteration_year = incremented_date_year
        previous_iteration_month = incremented_date_month


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Entity-months processed: {0}\n".format(i))  
            sys.stderr.flush()



def increment(year, month):

    if month == 12:
        incremented_date_year = year + 1
        incremented_date_month = 1
    else:
        incremented_date_year = year
        incremented_date_month = month + 1

    return incremented_date_year, incremented_date_month



main()


