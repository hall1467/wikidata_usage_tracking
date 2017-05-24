"""
Prints all wikis to stdout.

Usage:
    determine_wikis (-h|--help)
    determine_wikis [--debug]
                    [--verbose]


Options:
    -h, --help                     This help message is printed
    --debug                        Print debug logging to stderr
    --verbose                      Print dots and stuff to stderr      
"""

import logging
import mwapi
import sys
import json


import docopt



logger = logging.getLogger(__name__)



def main(argv=None):
    args = docopt.docopt(__doc__, argv=argv)
    logging.basicConfig(
        level=logging.WARNING if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    verbose = args['--verbose']
    run(verbose)

# Contacts API to return list of wikis
# Code credit: https://github.com/WikiEducationFoundation/academic_classification/blob/master/pageclassifier/revgather.py
def run(verbose):

    session = mwapi.Session(
        'https://en.wikipedia.org',
        user_agent='hall1467'
    )
    results = session.get(
        action='sitematrix'
    )

    for database_dictionary in extract_query_results(results):

        if verbose:
            sys.stderr.write("Printing json for the database: " +
                database_dictionary['dbname'] + "\n")
            sys.stderr.flush()

        sys.stdout.write(json.dumps(database_dictionary) + "\n")


# Code credit: https://github.com/WikiEducationFoundation/academic_classification/blob/master/pageclassifier/revgather.py
def extract_query_results(results):
    results = results['sitematrix']
    for entry in results:
        if entry == 'count':
            continue
        if entry == 'specials':
            for special_entry in results[entry]:
                yield ({
                            "dbname" : special_entry['dbname'],
                            "wikiurl" : special_entry['url']
                       })
            continue
        for wiki in results[entry]['site']:
            yield {
                      "dbname" : wiki['dbname'],
                      "wikiurl" : wiki['url']
                  }

