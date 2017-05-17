"""
Queries Mediawiki API for list of wikidbs.



"""
# Code credit: https://github.com/WikiEducationFoundation/academic_classification/blob/master/pageclassifier/revgather.py

import mwapi
import time
import sys
import logging

import docopt

logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__, argv=argv)
    logging.basicConfig(
        level=logging.WARNING if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    run(verbose)


def run(verbose):
    wiki_names_list = get_wiki_names_list()
    # dump = requests.get("https://dumps.wikimedia.org/" + wiki + "/" + str(date) 
    #        + "/" + wiki + "-" + str(date) + "-wbc_entity_usage.sql.gz", 
    #        stream=True)
    # dump_file = gzip.open(dump.raw)

    # for entry in dump_file:
    #     extractObjectUsages(entry.decode())    



# Contacts API to return list of wikis
def get_wiki_names_list():
    wiki_names_lists = {}
    i = 0
    while True:
        try:
            wiki_names_list = try_get_wiki_names()
            break
        except mwapi.errors.ConnectionError as e:
            if i > 5:
                raise e
            else:
                i += 1
                time.sleep(5*i)
                continue

    return wiki_names_list


# Creates API request
def try_get_wiki_names():
    session = mwapi.Session(
        'https://en.wikipedia.org',
        user_agent='hall1467'
    )
    results = session.get(
        action='sitematrix',
        smsiteprop='dbname'
    )

    return pull_text_from_query_results(results)

# Formats results from API query
def pull_text_from_query_results(results):
    wiki_names_list = []
    results = results['sitematrix']
    for entry in results:
        if entry == 'count':
            continue
        if entry == 'specials':
            for special_entry in results[entry]:
                wiki_names_list.append(special_entry['dbname'])
            continue
        for wiki in results[entry]['site']:
            wiki_names_list.append(wiki['dbname'])

    return wiki_names_list

