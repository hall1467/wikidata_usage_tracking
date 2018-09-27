"""
Takes in revisions (and associated data) and returns the gender for 
entities (items or properties) that have one and null otherwise.

Usage:
    obtain_entity_gender_data (-h|--help)
    obtain_entity_gender_data <input> <output>
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


logger = logging.getLogger(__name__)

def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_file = mysqltsv.Reader(open(args['<input>'],
        'rt', encoding='utf-8', errors='replace'), headers=False,
        types=[str, int, str, str, str, str, float, float, float, str, str, str, 
        str])

    input_second_iteration_file = mysqltsv.Reader(open(args['<input>'],
        'rt', encoding='utf-8', errors='replace'), headers=False,
        types=[str, int, str, str, str, str, float, float, float, str, str, str, 
        str])


    output_file = mysqltsv.Writer(
        open(args['<output>'], "w"), 
        headers=['page_title',
                 'gender'])

    verbose = args['--verbose']

    run(input_file, input_second_iteration_file, output_file, verbose)


def run(input_file, input_second_iteration_file, output_file, verbose):


    unique_entities = defaultdict(int)

    # We don't want to query use the API to get the same entity info twice
    for i, line in enumerate(input_file):
        unique_entities[line[0]] = 1

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

        if i == 200000:
            break

    accessed_gender_for_revisions_count = 0
    gender_dict = defaultdict(str)
    
    # Make API calls and process results
    for in_list in entity_id_lists:

        accessed_gender_for_revisions_count += len(in_list)

        if verbose and accessed_gender_for_revisions_count % 100 == 0 and \
            accessed_gender_for_revisions_count != 0:
            sys.stderr.write("Getting gender for revision: {0}\n"
                    .format(accessed_gender_for_revisions_count))  
            sys.stderr.flush()


        wikidata_api_session = mwapi.Session(
            "https://www.wikidata.org", 
            user_agent="User-Agent")

        api_claims_result = wikidata_api_session.get(
            action='wbgetentities',
            ids=in_list)

        for entity in api_claims_result['entities']:
            if 'claims' in api_claims_result['entities'][entity] and \
                'P21' in api_claims_result['entities'][entity]['claims']:
                gender_claim = \
                    api_claims_result['entities'][entity]['claims']['P21'][0]\
                        ['mainsnak']['datavalue']['value']['id']

                gender_dict[entity] = gender_claim


    for i, line in enumerate(input_second_iteration_file):
        gender_value = None
        if line[0] in gender_dict:
            gender_value = gender_dict[line[0]]


        output_file.write([
            line[0],
            line[1],
            line[2],
            line[3],
            line[4],
            line[5],
            line[6],
            line[7],
            line[8],
            line[9],
            line[10],
            line[11],
            line[12],
            gender_value])


main()

