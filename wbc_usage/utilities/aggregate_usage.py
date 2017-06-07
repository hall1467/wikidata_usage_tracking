"""
Aggregates usage information from json file and prints it to stdout. Aggregates
page_ids for a given entity_id, aspect, and wikidb. Additionally,
produces:

    1. "entity_aspect_wikidb_page_count.json" 
    2. "entity_aspect_page_count.json"
    3. "entity_page_count.json"

These 3 additional files provide page counts at varying levels of granularity. 
Can use the [file-output-prefix=<file>] for these three last files to specify a 
path and file prefix for them.

Usage:
    aggregate_usage (-h|--help)
    aggregate_usage [<json-file>]...
                    [--file-output-prefix=<file>]
                    [--output=<location>]
                    [--debug]
                    [--verbose]


Options:
    -h, --help                   This help message is printed
    <json-file>                  Path to json file to process. If no file is 
                                 provided, use stdin.
    --file-output-prefix=<file>  Prefix for page count output files. Can also
                                 be used to specify a directory for the files.
    --output=<location>          Where results will be written.
                                 [default: <stdout>]
    --debug                      Print debug logging to stderr
    --verbose                    Print dots and stuff to stderr      
"""

import logging
import json
import sys
from collections import defaultdict
from itertools import chain

import docopt

logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__, argv=argv)
    logging.basicConfig(
        level=logging.WARNING if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    if len(args['<json-file>']) == 0:
        logger.info("Reading from <stdin>")
        json_files = [sys.stdin]
    else:
        json_files = args['<json-file>']

    if args['--file-output-prefix']:
        file_output_prefix = args['--file-output-prefix'] 
    else:
        file_output_prefix = ""

    if args['--output'] == '<stdout>':
        output = sys.stdout
    else:
        output = open(args['--output'], "w")

    verbose = args['--verbose']

    run(json_files, file_output_prefix, output, verbose)


def run(json_files, file_output_prefix, output, verbose):

    usages = chain(extract_from_json_file(*json_files)) 
    
    # Aggregation occurs here
    entity_counts = defaultdict(lambda: defaultdict(lambda: defaultdict(set)))
    for usage in usages:
        record = entity_counts[usage['entity_id']][usage['aspect']]
        record[usage['wikidb']].add((usage['page_id']))

    # Page count files at varying levels of aggregation
    entity_aspect_wikidb_page_count_f = \
        open(file_output_prefix + "entity_aspect_wikidb_page_count.json", "w")
    entity_aspect_page_count_f = \
        open(file_output_prefix + "entity_aspect_page_count.json", "w")
    entity_page_count_f = \
        open(file_output_prefix + "entity_page_count.json", "w")

    # Write out aggregations to files
    for i, (entity_id, entity_dictionary) in enumerate(entity_counts.items()):
        entity_page_count = 0
        for (aspect, aspect_dictionary) in entity_dictionary.items():
            entity_aspect_page_count = 0
            for (wikidb, page_set) in aspect_dictionary.items():

                output.write(json.dumps(
                    {
                        'entity_id' : entity_id, 
                        'aspect' : aspect, 
                        'wikidb' : wikidb, 
                        'unique_page_list' : list(page_set)
                    }) + "\n")


                entity_aspect_wikidb_page_count_f.write(json.dumps(
                    {
                        'entity_id' : entity_id,
                        'aspect' : aspect,
                        'wikidb' : wikidb,
                        'unique_page_count' : len(page_set)
                    }) + "\n")

                # Update counters entity and entity_aspect page counters
                entity_page_count += len(page_set)
                entity_aspect_page_count += len(page_set)


            entity_aspect_page_count_f.write(json.dumps(
                {
                    'entity_id' : entity_id,
                    'aspect' : aspect,
                    'unique_page_count' : entity_aspect_page_count
                }) + "\n")


        entity_page_count_f.write(json.dumps(
            {
                'entity_id' : entity_id,
                'unique_page_count' : entity_page_count
            }) + "\n")


        if verbose and i % 1000 == 0:
            sys.stderr.write(".")
            sys.stderr.flush()


def extract_from_json_file(path):
    if isinstance(path, str):
        logger.debug("Opening {0}".format(path))
        f = open(path, 'rt')
    else:
        logger.debug("Reading from {0}".format(path))
        f = path
    for line in f:
        yield json.loads(line)

