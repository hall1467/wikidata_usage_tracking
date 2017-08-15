"""
Joins entity sitelink usage and page datasets so that the page ids referenced by 
sitelinks are known.

Usage:
    sitelink_usage_and_id_merging (-h|--help)
    sitelink_usage_and_id_merging <input_sitelinks> <input_id> <output>
                                  [--verbose]


Options:
    -h, --help        This help message is printed
    <input_sitelinks> Path to file with sitelink usages to process.
    <input_id>        Path to file with page ids to process.
    <output>          Where results will be writen.
    --verbose         Print dots and stuff to stderr  
"""


import docopt
import sys
import mysqltsv
from collections import defaultdict
import operator
import json

import logging

logger = logging.getLogger(__name__)

def main(argv=None):
    args = docopt.docopt(__doc__)

    input_file_sitelinks = open(args['<input_sitelinks>'], "r")

    input_file_id = open(args['<input_id>'], "r")


    verbose = args['--verbose']

    output_file = open(args['<output>'], "w")

    run(input_file_sitelinks, input_file_id, output_file, verbose)


def run(input_file_sitelinks, input_file_id, output_file, verbose):

    sitelink_usages = defaultdict(lambda: defaultdict(dict))
    page_usages = defaultdict(lambda: defaultdict(dict))

    for i, line in enumerate(input_file_sitelinks):

        json_line = json.loads(line)
        sitelink_usages[json_line['wikidb']][json_line['page_title']] =\
            json_line


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Sitelink usages processed: {0}\n".format(i))  
            sys.stderr.flush()
        
        # if i == 1000000:
        #     break

    for i, line in enumerate(input_file_id):

        json_line = json.loads(line)
        print(line)
        print(json_line)

        page_usages[json_line['wikidb']][json_line['page_title']] =\
            json_line

        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Pages processed: {0}\n".format(i))  
            sys.stderr.flush()

    for wikidb in sitelink_usages:
        for page_title in sitelink_usages[wikidb]:
            if wikidb in page_usages and page_title in page_usages[wikidb]:
                print("in both!")



    # category_count = defaultdict(int)
    # entity_category = defaultdict(lambda: defaultdict(dict))
    # misalignment_category_entity = defaultdict(list)
    # misalignment_category_count = defaultdict(int)
    # misalignment_over_category = defaultdict(float)

    # misalignment_entities_sum = 0




    # for entry in input_file_misalignment:

    #     misalignment_entities_sum += 1

    #     for category in entity_category[entry[0]]:
    #         misalignment_category_count[category] += 1
    #         misalignment_category_entity[category].append(entry[0])


    # for entry in misalignment_category_count:
    #     if misalignment_category_count[entry] >= number_of_instances:
    #         misalignment_over_category[entry] =\
    #             (misalignment_category_count[entry]/misalignment_entities_sum)/(category_count[entry]/len(entity_category))
        

    # sorted_misalignment_over_category =\
    #     sorted(misalignment_over_category.items(), key=operator.itemgetter(1), 
    #     reverse=True)
   
    # for entry in sorted_misalignment_over_category:
    #     output_file.write(json.dumps({'category' : entry[0],
    #                                  'misalignment_over_category' : entry[1],
    #                                  'number_of_instances' : misalignment_category_count[entry[0]],
    #                                  'instances' : misalignment_category_entity[entry[0]]
    #                                  }) + "\n")

          


main()

