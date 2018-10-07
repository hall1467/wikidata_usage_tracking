"""
Takes in revisions (and associated data) and returns parent id
information for entities (items or properties) that have one.

Usage:
    obtain_parent_data_from_api (-h|--help)
    obtain_parent_data_from_api <input> <output>
                                [--debug]
                                [--verbose]

Options:
    -h, --help  This help message is printed
    <input>     Path to edit file to process.
    <output>    Where output will be written
    --debug     Print debug logging to stderr
    --verbose   Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
from collections import defaultdict
import mysqltsv
import sys
import mwapi
import json


logger = logging.getLogger(__name__)

def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_file = mysqltsv.Reader(open(args['<input>'],
        'rt', encoding='utf-8', errors='replace'), headers=False,
        types=[str, int, str, str, str, float, float, float, str, str, str, 
        str])

    output_file = open(args['<output>'], "w")

    verbose = args['--verbose']

    run(input_file, output_file, verbose)


def run(input_file, output_file, verbose):


    unique_entities = defaultdict(int)

    # We don't want to use the API to get the same entity info twice
    for i, line in enumerate(input_file):
        unique_entities[line[4]] = 1

    # Create lists of 50 entities (max allowed by API) for API call
    entity_id_lists = []
    for i, entity in enumerate(unique_entities):

        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Adding revision to nested list: {0}\n".format(i))  
            sys.stderr.flush()

        if i % 50 == 0:
            inner_list = []
            inner_list.append(entity)
        else:
            inner_list.append(entity)
        if i % 50 == 49:
            entity_id_lists.append(inner_list)


    accessed_gender_for_revisions_count = 0
    gender_dict = defaultdict(str)
    inst_of_dict = defaultdict(list)
    subc_of_dict = defaultdict(list)
    
    # Make API calls and process results
    for in_list in entity_id_lists:

        accessed_gender_for_revisions_count += len(in_list)

        if verbose and accessed_gender_for_revisions_count % 100 == 0 and \
            accessed_gender_for_revisions_count != 0:
            sys.stderr.write("Getting API info for revision: {0}\n"
                    .format(accessed_gender_for_revisions_count))  
            sys.stderr.flush()


        wikidata_api_session = mwapi.Session(
            "https://www.wikidata.org", 
            user_agent="User-Agent")

        api_revisions_result = wikidata_api_session.get(
            action='query',
            prop='revisions',
            revids=in_list)

        for revision in api_revisions_result['query']['pages']:
            if len(api_revisions_result['query']['pages'][revision]
                ['revisions']) > 1:
                
                logger.warn("More revisions returned for entity than expected: {0}"
                    .format(api_revisions_result['query']['pages'][revision]
                        ['revisions']))
            

            output_file.write(json.dumps({
                'rev_id' : api_revisions_result['query']['pages'][revision]
                    ['revisions'][0]['revid'],
                'parent_id' : api_revisions_result['query']['pages'][revision]
                    ['revisions'][0]['parentid']
                }) + "\n")


main()

