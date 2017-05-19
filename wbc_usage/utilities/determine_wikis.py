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
# Code credit: https://github.com/WikiEducationFoundation/academic_classification/blob/master/pageclassifier/revgather.py

import mwapi
import sys
import logging
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
def run(verbose):

    def pull_text_from_query_results(results):
        wiki_names_list = []
        results = results['sitematrix']
        for entry in results:
            if entry == 'count':
                continue
            if entry == 'specials':
                for special_entry in results[entry]:
                    wiki_names_list.append({"dbname" : special_entry['dbname']})
                continue
            for wiki in results[entry]['site']:
                wiki_names_list.append({"dbname" : wiki['dbname']})

        return wiki_names_list

    session = mwapi.Session(
        'https://en.wikipedia.org',
        user_agent='hall1467'
    )
    results = session.get(
        action='sitematrix',
        smsiteprop='dbname'
    )

    for database_dictionary in pull_text_from_query_results(results):

        if verbose:
            sys.stderr.write("Printing json for the database: " + database_dictionary['dbname'] + "\n")
            sys.stderr.flush()

        sys.stdout.write(json.dumps(database_dictionary) + "\n")


