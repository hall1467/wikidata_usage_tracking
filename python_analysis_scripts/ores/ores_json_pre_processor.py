"""
Converts tsv file of latest revision information into a json file to be input 
into ORES to get a predicted quality rating. NOTE: filters out properties.

Usage:
    ores_json_pre_processor (-h|--help)
    ores_json_pre_processor <input-location> <output-location>


Options:
    -h, --help         This help message is printed
    <input-location>   Path to tsv file to process.
    <output-location>  Where results will be writen.
"""


import docopt
import json
import sys
import mysqltsv
import re

# ITEM_RE = re.compile(r'^Q\d+$')

def main(argv=None):
    args = docopt.docopt(__doc__)

    input_file = mysqltsv.Reader(open(args['<input-location>']), headers=False,
        types=[str, int, int, int])
    output_file = open(args['<output-location>'], "w")

    run(input_file, output_file)


def run(input_file, output_file):
    for i, line in enumerate(input_file):
        if i % 10000 == 0 and i != 0:
            print("Entities processed: {0}".format(i))

        # if ITEM_RE.match(line):
        output_line = {}
        output_line['entity_id'] = line[0]
        output_line['rev_id'] = line[1]
        output_line['page_views'] = line[3]
        output_file.write(json.dumps(output_line) + "\n")

    print("Done!")
    
main()

