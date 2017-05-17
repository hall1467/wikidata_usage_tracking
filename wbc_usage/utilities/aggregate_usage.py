"""
Aggregates usage information from json file and prints it to stdout. Aggregates
page_ids for a given entity_id, aspect, and wikidb. Additionally,
produces "entity_aspect_wikidb_page_count.json", 
"entity_aspect_page_count.json" and "entity_page_count.json" to 
provide page counts at varying levels of granularity.

Usage:
    aggregate_usage (-h|--help)
    aggregate_usage [<json-file>]...
                    [--s]
                    [--debug]
                    [--verbose]


Options:
    -h, --help             This help message is printed
    <json_file>            Path to json file to process. If no file is provided, 
                           use stdin.
    --debug                Print debug logging to stderr
    --verbose              Print dots and stuff to stderr      
"""
import logging
import json
import sys
from collections import defaultdict

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

    verbose = args['--verbose']

    run(json_files, verbose)


def run(json_files, verbose):

    def extract_from_json_file(path):
        if isinstance(path, str):
            logger.debug("Opening {0}".format(path))
            f = open(path, 'rt')
        else:
            logger.debug("Reading from {0}".format(path))
            f = path
        list_of_json = []
        for line in f:
            list_of_json.append(json.loads(line))
        return list_of_json

    usages = []
    for json_file in json_files:
        usages.extend(extract_from_json_file(json_file)) 
        
    entity_counts = defaultdict(lambda: defaultdict(lambda: defaultdict(set)))
    for usage in usages:
        record = entity_counts[usage['entity_id']][usage['aspect']]
        record[usage['wikidb']].add((usage['page_id']))

    entity_aspect_wikidb_page_count_f = open("entity_aspect_wikidb_page_count.json", "w")
    entity_aspect_page_count_f = open("entity_aspect_page_count.json", "w")
    entity_page_count_f = open("entity_page_count.json", "w")

    # Write out aggregations to files
    # Maybe write headers too?
    for i, entity_dictionary in enumerate(entity_counts.items()):
        entity_page_count = 0
        for aspect_dictionary in entity_dictionary[1].items():
            entity_aspect_page_count = 0
            for wikidb_dictionary in aspect_dictionary[1].items():

                entity_aspect_wikidb_pages_json = (entity_dictionary[0],
                                        aspect_dictionary[0], 
                                        wikidb_dictionary[0], 
                                        wikidb_dictionary[1])
                sys.stdout.write(json.dumps(str(entity_aspect_wikidb_pages_json)
                                 ) + "\n")

                entity_aspect_wikidb_count_json = (entity_dictionary[0],
                                              aspect_dictionary[0], 
                                              wikidb_dictionary[0], 
                                              len(wikidb_dictionary[1]))
                entity_aspect_wikidb_page_count_f.write(json.dumps(
                                    str(entity_aspect_wikidb_count_json)) 
                                    + "\n")

                # Update counters entity and entity_aspect page counters
                entity_page_count += len(wikidb_dictionary[1])
                entity_aspect_page_count += len(wikidb_dictionary[1])

            entity_aspect_count_json = (entity_dictionary[0],
                          aspect_dictionary[0], 
                          entity_aspect_page_count)
            entity_aspect_page_count_f.write(json.dumps(str(entity_aspect_count_json))
                                + "\n")

        entity_count_json = (entity_dictionary[0],
                         entity_page_count)
        entity_page_count_f.write(json.dumps(str(entity_count_json))
                            + "\n")

        if verbose and i % 1000 == 0:
            sys.stderr.write(".")
            sys.stderr.flush()

