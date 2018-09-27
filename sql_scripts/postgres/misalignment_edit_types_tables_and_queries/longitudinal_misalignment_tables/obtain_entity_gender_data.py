"""
Takes in revisions (and associated data) and returns the gender for 
entities (items or properties) that have one.

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
        types=[str, int, str, str, str, float, float, float, str, str, str, 
        str])


    output_file = mysqltsv.Writer(
        open(args['<output>'], "w"), 
        headers=['page_title',
                 'gender'])

    verbose = args['--verbose']

    run(input_file, output_file, verbose)


def run(input_file, output_file, verbose):

    entity_id_lists = []

    for i, line in enumerate(input_file):


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Adding revision to nested list: {0}\n".format(i))  
            sys.stderr.flush()

        if i % 50 == 0:
            inner_list = []
            inner_list.append(line[0])
        else:
            inner_list.append(line[0])
        if i % 50 == 49:
            entity_id_lists.append(inner_list)


    accessed_gender_for_revisions_count = 0
    
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

                output_file.write([entity, gender_claim])


main()

