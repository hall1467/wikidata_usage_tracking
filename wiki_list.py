# Queries MediaWiki API for wikis
#
# Code credit: https://github.com/WikiEducationFoundation/academic_classification/blob/master/pageclassifier/revgather.py
#
# Author Andrew Hall 

import mwapi
import time
import sys


# Contacts API to return list of wikis
def getWikiNamesList():
    wiki_names_lists = {}
    i = 0
    while True:
        try:
            wiki_names_list = tryGetWikiNames()
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
def tryGetWikiNames():
    session = mwapi.Session(
        'https://en.wikipedia.org',
        user_agent='hall1467'
    )
    results = session.get(
        action='sitematrix',
        smsiteprop='dbname'
    )

    return pullTextFromQueryResults(results)

# Formats results from API query
def pullTextFromQueryResults(results):
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

