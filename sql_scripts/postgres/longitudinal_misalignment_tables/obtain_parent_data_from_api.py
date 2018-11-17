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
import time


logger = logging.getLogger(__name__)

def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_file = mysqltsv.Reader(open(args['<input>'],
        'rt', encoding='utf-8', errors='replace'), headers=False,
        types=[int, int, int, str, str, int, int, str, int])

    output_file = open(args['<output>'], "w")

    verbose = args['--verbose']

    run(input_file, output_file, verbose)


def run(input_file, output_file, verbose):


    # Create lists of 50 revisions (max allowed by API) for API call
    revision_id_lists = []
    for i, line in enumerate(input_file):

        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Adding revision to nested list: {0}\n".format(i))  
            sys.stderr.flush()

        if i % 50 == 0:
            inner_list = []
            inner_list.append(line[6])
        else:
            inner_list.append(line[6])
        if i % 50 == 49:
            revision_id_lists.append(inner_list)


    accessed_API_for_revisions_count = 0
    
    # Make API calls and process results
    for in_list in revision_id_lists:

        accessed_API_for_revisions_count += len(in_list)


        if verbose and accessed_API_for_revisions_count % 100 == 0 and \
            accessed_API_for_revisions_count != 0:
            sys.stderr.write("Getting API info for revision: {0}\n"
                    .format(accessed_API_for_revisions_count))  
            sys.stderr.flush()


        attempts = 30

        while attempts > 0:

            attempts -= 1

            try:
                api_revisions_result = set_up_conn_and_return_results(in_list)

            except mwapi.errors.ConnectionError:
                if attempts > 0:
                    sys.stderr.write("Can't connect. {0} attempt(s) left.\n"
                        .format(attempts))
                    sys.stderr.flush()
                    time.sleep(60)
                else:
                    sys.exit("Unable to connect. Exiting.")

            except Exception as e:
                if attempts > 0:
                    sys.stderr.write("{0} attempt(s) left. Exception: {1}. \n"
                        .format(attempts, e))
                    sys.stderr.flush()
                    time.sleep(60)
                else:
                    sys.exit("Exiting due to exception: {0}".format(e))



        for revision in api_revisions_result['query']['pages']:
            if len(api_revisions_result['query']['pages'][revision]
                ['revisions']) > 1:
                
                logger.warn("More entity revisions returned than expected: {0}"
                    .format(api_revisions_result['query']['pages'][revision]
                        ['revisions']))

            elif api_revisions_result['query']['pages']\
                        [revision]['revisions'][0]['parentid'] != 0:
                output_file.write(json.dumps({
                    'next_rev_id' : api_revisions_result['query']['pages']
                        [revision]['revisions'][0]['revid'],
                    'rev_id' : api_revisions_result['query']['pages']
                        [revision]['revisions'][0]['parentid']
                    }) + "\n")



def set_up_conn_and_return_results(in_list):
    wikidata_api_session = mwapi.Session(
        "https://www.wikidata.org", 
        user_agent="User-Agent")

    api_revisions_data = wikidata_api_session.get(
        action='query',
        prop='revisions',
        revids=in_list)

    return api_revisions_data



main()
