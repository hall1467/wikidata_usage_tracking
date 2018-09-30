"""
Takes in revisions (and associated data) and returns gender, instance_of, and
subclass_of information for entities (items or properties) that have one and 
null otherwise.

Usage:
    obtain_entity_data_from_api (-h|--help)
    obtain_entity_data_from_api <input> <output>
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

    input_second_iteration_file = mysqltsv.Reader(open(args['<input>'],
        'rt', encoding='utf-8', errors='replace'), headers=False,
        types=[str, int, str, str, str, float, float, float, str, str, str, 
        str])

    output_file = open(args['<output>'], "w")

    verbose = args['--verbose']

    run(input_file, input_second_iteration_file, output_file, verbose)


def run(input_file, input_second_iteration_file, output_file, verbose):


    unique_entities = defaultdict(int)

    # We don't want to use the API to get the same entity info twice
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


    accessed_gender_for_revisions_count = 0
    gender_dict = defaultdict(str)
    instance_of_dict = defaultdict(list)
    subclass_of_dict = defaultdict(list)
    
    # Make API calls and process results
    for in_list in entity_id_lists:

        if accessed_gender_for_revisions_count > 3000:
            break
        accessed_gender_for_revisions_count += len(in_list)


        if verbose and accessed_gender_for_revisions_count % 100 == 0 and \
            accessed_gender_for_revisions_count != 0:
            sys.stderr.write("Getting API info for revision: {0}\n"
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
                'P21' in api_claims_result['entities'][entity]['claims'] and \
                'mainsnak' in api_claims_result['entities'][entity]['claims']\
                    ['P21'][0] and \
                'datavalue' in api_claims_result['entities'][entity]\
                    ['claims']['P21'][0]['mainsnak'] and \
                'value' in api_claims_result['entities'][entity]['claims']\
                    ['P21'][0]['mainsnak']['datavalue'] and \
                'id' in api_claims_result['entities'][entity]['claims']['P21']\
                    [0]['mainsnak']['datavalue']['value']:
                gender_claim = \
                    api_claims_result['entities'][entity]['claims']['P21'][0]\
                        ['mainsnak']['datavalue']['value']['id']

                gender_dict[entity] = gender_claim


            if 'claims' in api_claims_result['entities'][entity] and \
                'P31' in api_claims_result['entities'][entity]['claims'] and \
                'mainsnak' in api_claims_result['entities'][entity]['claims']\
                    ['P31'][0] and \
                'datavalue' in api_claims_result['entities'][entity]\
                    ['claims']['P31'][0]['mainsnak'] and \
                'value' in api_claims_result['entities'][entity]['claims']\
                    ['P31'][0]['mainsnak']['datavalue'] and \
                'id' in api_claims_result['entities'][entity]['claims']['P31']\
                    [0]['mainsnak']['datavalue']['value']:
                instance_of_dict_claim = \
                    api_claims_result['entities'][entity]['claims']['P31'][0]\
                        ['mainsnak']['datavalue']['value']['id']
                print(entity)
                instance_of_dict[entity].append(instance_of_dict_claim)


            if 'claims' in api_claims_result['entities'][entity] and \
                'P279' in api_claims_result['entities'][entity]['claims'] and \
                'mainsnak' in api_claims_result['entities'][entity]['claims']\
                    ['P279'][0] and \
                'datavalue' in api_claims_result['entities'][entity]\
                    ['claims']['P279'][0]['mainsnak'] and \
                'value' in api_claims_result['entities'][entity]['claims']\
                    ['P279'][0]['mainsnak']['datavalue'] and \
                'id' in api_claims_result['entities'][entity]['claims']['P279']\
                    [0]['mainsnak']['datavalue']['value']:
                subclass_of_dict_claim = \
                    api_claims_result['entities'][entity]['claims']['P279'][0]\
                        ['mainsnak']['datavalue']['value']['id']
                subclass_of_dict[entity].append(subclass_of_dict_claim)



    for i, line in enumerate(input_second_iteration_file):

        
        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Merging results: {0}\n".format(i))  
            sys.stderr.flush()

        gender_value = None
        instance_of_value = []
        subclass_of_value = []

        if line[0] in gender_dict:
            gender_value = gender_dict[line[0]]
        if line[0] in instance_of_dict:
            instance_of_value = instance_of_dict[line[0]]
        if line[0] in subclass_of_dict:
            subclass_of_value = subclass_of_dict[line[0]]
            

        output_file.write(json.dumps({
                    'page_title' : line[0],
                    'namespace' : line[1],
                    'edit_type': line[2],
                    'agent_type': line[3],
                    'rev_id': line[4],
                    'weighted_sum': line[5],
                    'expected_quality': line[6],
                    'expected_quality_quantile': line[7],
                    'page_views': line[8],
                    'yyyy': line[9],
                    'mm': line[10],
                    'quality_difference': line[11],
                    'gender': gender_value,
                    'instance_of': instance_of_value,
                    'subclass_of': subclass_of_value
                }) + "\n")


main()
