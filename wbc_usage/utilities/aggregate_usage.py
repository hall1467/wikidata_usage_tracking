"""
Aggregates usage information from json file.

Usage:
    aggregate_usage (-h|--help)
    aggregate_usage [<json-file>]...
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
        print(path)
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

    for i, entity_entry in enumerate(entity_counts.items()):
        sys.stdout.write(json.dumps(str(entity_entry)) + "\n")

        if verbose and i % 1000 == 0:
            sys.stderr.write(".")
            sys.stderr.flush()

