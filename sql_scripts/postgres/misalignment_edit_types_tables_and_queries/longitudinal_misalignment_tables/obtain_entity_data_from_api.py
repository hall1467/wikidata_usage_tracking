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

    output_file = mysqltsv.Writer(
        open(args['<output>'], "w"), 
        headers=[
                 'page_title',
                 'namespace',
                 'edit_type',
                 'agent_type',
                 'rev_id',
                 'weighted_sum',
                 'expected_quality',
                 'expected_quality_quantile',
                 'page_views',
                 'yyyy',
                 'mm',
                 'quality_difference',
                 'gender',
                 'instance_of',
                 'subclass_of'
                 'continent',])

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
    inst_of_dict = defaultdict(list)
    subc_of_dict = defaultdict(list)
    continent_dict = defaultdict(list)
    
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
                'P31' in api_claims_result['entities'][entity]['claims']:
                p_31 = \
                    api_claims_result['entities'][entity]['claims']['P31']
                for p_31_cl in p_31:
                    if 'mainsnak' in p_31_cl and \
                        'datavalue' in p_31_cl['mainsnak'] and \
                        'value' in p_31_cl['mainsnak']['datavalue'] and \
                        'id' in p_31_cl['mainsnak']['datavalue']['value']:

                        inst_of_dict[entity].append(p_31_cl['mainsnak']\
                            ['datavalue']['value']['id'])


            if 'claims' in api_claims_result['entities'][entity] and \
                'P279' in api_claims_result['entities'][entity]['claims']:
                p_279 = \
                    api_claims_result['entities'][entity]['claims']['P279']

                for p_279_cl in p_279:
                    if 'mainsnak' in p_279_cl and \
                        'datavalue' in p_279_cl['mainsnak'] and \
                        'value' in p_279_cl['mainsnak']['datavalue'] and \
                        'id' in p_279_cl['mainsnak']['datavalue']['value']:

                        inst_of_dict[entity].append(p_279_cl['mainsnak']\
                            ['datavalue']['value']['id'])


            if 'claims' in api_claims_result['entities'][entity] and \
                'P30' in api_claims_result['entities'][entity]['claims']:
                p_30 = \
                    api_claims_result['entities'][entity]['claims']['P30']
                for p_30_cl in p_30:
                    if 'mainsnak' in p_30_cl and \
                        'datavalue' in p_30_cl['mainsnak'] and \
                        'value' in p_30_cl['mainsnak']['datavalue'] and \
                        'id' in p_30_cl['mainsnak']['datavalue']['value']:

                        continent_dict[entity].append(p_30_cl['mainsnak']\
                            ['datavalue']['value']['id'])


    for i, line in enumerate(input_second_iteration_file):

        
        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Merging results: {0}\n".format(i))  
            sys.stderr.flush()

        gender_value = None
        continent_value = []

        if line[0] in gender_dict:
            gender_value = gender_dict[line[0]]

        if line[0] in inst_of_dict:
            for instances in inst_of_dict[line[0]]:
                
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
                    gender_value,
                    instances,
                    None,
                    None])

        if line[0] in subc_of_dict:
            for subclasses in subc_of_dict[line[0]]:

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
                    gender_value,
                    None,
                    subclasses,
                    None])

        if line[0] in continent_dict:
            for continents in continent_dict[line[0]]:

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
                    gender_value,
                    None,
                    None,
                    continents])

main()

