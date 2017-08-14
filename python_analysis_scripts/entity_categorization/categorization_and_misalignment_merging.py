"""
Joins categorization and misalignment datasets

Usage:
    categorization_and_misalignment_merging (-h|--help)
    categorization_and_misalignment_merging <input_categorization> <input_misalignment> <number_of_instances> <output>
                                            [--verbose]


Options:
    -h, --help             This help message is printed
    <input_categorization> Path to categorization tsv file to process.
    <input_misalignment>   Path to misalignment tsv file to process.
    <number_of_instances>  Number of instances minimum.
    <output>               Where results will be writen.
    --verbose              Print dots and stuff to stderr  
"""


import docopt
import sys
import mysqltsv
from collections import defaultdict
import operator

import logging

logger = logging.getLogger(__name__)

def main(argv=None):
    args = docopt.docopt(__doc__)

    input_file_categorization = mysqltsv.Reader(
        open(args['<input_categorization>'], "r"), 
        headers=False, types=[str, str, str])

    input_file_misalignment = mysqltsv.Reader(
        open(args['<input_misalignment>'], "r"), 
        headers=False, types=[str, str, str])

    number_of_instances = int(args['<number_of_instances>'])
    verbose = args['--verbose']

    output_file = mysqltsv.Writer(open(args['<output>'], "w"))

    run(input_file_categorization, input_file_misalignment, output_file, 
        number_of_instances, verbose)


def run(input_file_categorization, input_file_misalignment, output_file, 
    number_of_instances, verbose):
    
    category_count = defaultdict(int)
    entity_category = defaultdict(lambda: defaultdict(dict))
    misalignment_category_count = defaultdict(int)
    misalignment_over_category = defaultdict(float)

    misalignment_entities_sum = 0

    for i, entry in enumerate(input_file_categorization):
        category_count[entry[2]] += 1
        entity_category[entry[0]][entry[2]] = 1


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Categorized entities processed: {0}\n".format(i))  
            sys.stderr.flush()
        
        # if i == 1000000:
        #     break


    for entry in input_file_misalignment:

        misalignment_entities_sum += 1

        for category in entity_category[entry[0]]:
            misalignment_category_count[category] += 1



    for entry in misalignment_category_count:
        if misalignment_category_count[entry] >= number_of_instances:
            misalignment_over_category[entry] =\
                (misalignment_category_count[entry]/misalignment_entities_sum)/(category_count[entry]/len(entity_category))
        

    sorted_misalignment_over_category =\
        sorted(misalignment_over_category.items(), key=operator.itemgetter(1), 
        reverse=True)
   
    for entry in sorted_misalignment_over_category:
        output_file.write([entry[0], entry[1], misalignment_category_count[entry[0]]])

main()

