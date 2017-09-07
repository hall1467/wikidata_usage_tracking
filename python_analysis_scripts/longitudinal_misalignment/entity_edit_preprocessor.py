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
import bz2
import re
from collections import defaultdict
import sys


logger = logging.getLogger(__name__)



def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_edit_data_file = mysqltsv.Reader(bz2.open(args['<input_edit_data>'],
        'rt', encoding='utf-8', errors='replace'), headers=False,
        types=[str, int, int, int, int, int, int, int])


    output_file = mysqltsv.Writer(open(args['<output>'], "w"))

    verbose = args['--verbose']


    run(input_edit_data_file, output_file, verbose)


def run(input_edit_data_file, output_file, verbose):

    # Gets updated as months go by
    edits = defaultdict(lambda: defaultdict(int))


    for i, line in enumerate(input_edit_data_file):
        
        if int(line[2]) == 12:
            new_year = line[1] + 1
            new_month = 1
        else:
            new_year = line[1]
            new_month = line[2] + 1

    
        edits[line[0]]['bot_edits'] += line[3]
        edits[line[0]]['semi_automated_edits'] += line[4]
        edits[line[0]]['non_bot_edits'] += line[5]
        edits[line[0]]['anon_edits'] += line[6]
        edits[line[0]]['all_edits'] += line[7]


        output_file.write([line[0], 
                           new_year, 
                           new_month,
                           edits[line[0]]['bot_edits'], 
                           edits[line[0]]['semi_automated_edits'], 
                           edits[line[0]]['non_bot_edits'],
                           edits[line[0]]['anon_edits'],
                           edits[line[0]]['all_edits']])


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Entity-months processed: {0}\n".format(i))  
            sys.stderr.flush()



main()

