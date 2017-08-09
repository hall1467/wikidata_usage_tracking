"""
Creates a tsv of "instance of" and "subclass of" for each entity.

Usage:
    entity_categorization (-h|--help)
    entity_categorization <input> <output>
                          [--verbose]


Options:
    -h, --help  This help message is printed
    <input>     Path to json bz2 file to process.
    <output>    Where results will be writen.
    --verbose   Print dots and stuff to stderr  
"""


import docopt
import sys
import mysqltsv
from collections import defaultdict
import bz2
import json
import mwbase

def main(argv=None):
    args = docopt.docopt(__doc__)

    # input_file = gzip.open(args['<input>'])

    input_file = json.load(bz2.open(args['<input>'], 'rt', 
        encoding='utf-8', errors='replace'))

    verbose = args['--verbose']

    output_file = mysqltsv.Writer(open(args['<output>'], "w"))

    run(input_file, output_file, verbose)


def run(input_file, output_file, verbose):

    yymm_quality = defaultdict(dict)
    yymm_page_views = defaultdict(list)

    # print(input_file)
    # sys.exit()

    for i, entry in enumerate(input_file):
        mwbase_entry = mwbase.Entity.from_json(entry)
        if 'P31' in mwbase_entry.properties:
            for statement in mwbase_entry.properties['P31']:
                output_file.write([entry['id'], 'P31',
                    statement['claim']['datavalue']['id']])
        if 'P279' in mwbase_entry.properties:
            for statement in mwbase_entry.properties['P279']:
                output_file.write([entry['id'], 'P279',
                    statement['claim']['datavalue']['id']])

        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Revisions processed: {0}\n".format(i))  
            sys.stderr.flush()

    for entry in yymm_quality:
        correlation_and_p_value = scipy.stats.spearmanr(yymm_quality[entry], 
                                                        yymm_page_views[entry])
        output_file.write([entry, correlation_and_p_value[0], 
            correlation_and_p_value[1]])


main()

