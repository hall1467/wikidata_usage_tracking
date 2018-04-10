"""
Aggregates various attributes of misalignment and edit data by month.
Returns in json format.

Usage:
    extract_edit_and_agent_type (-h|--help)
    extract_edit_and_agent_type <input> <output>
                                [--debug]
                                [--verbose]

Options:
    -h, --help  This help message is printed
    <input>     Path to misalignment/edit
                breakdown file to process.
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
import re
import json


logger = logging.getLogger(__name__)


EDIT_KIND_RE = re.compile(r'/\* (wb(set|create|edit|remove)([a-z]+)((-[a-z]+)*))', re.I)


def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_file = mysqltsv.Reader(open(args['<input>'],
        'rt', encoding='utf-8', errors='replace'), headers=False,
        types=[str, int, str, str, str, int, int, int, str, str, 
        str, str, str, str, str, str, int, int, str, str, str, str, str, 
        str])


    output_file = open(args['<output>'], "w")


    verbose = args['--verbose']

    run(input_file, output_file, verbose)


def run(input_file, output_file, verbose):


    for i, line in enumerate(input_file):

        output_edit_type = None
        output_agent_type = None

        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Processing revision: {0}\n".format(i))  
            sys.stderr.flush()


        page_title = line[0]
        revision_id = line[1]
        comment = line[3]
        namespace = line[4]
        year = line[6]
        month = line[7]
        page_views = line[11]
        agent_type = line[12]
        agent_bot_pred = line[18]


        # Also, filtering out sitelink edits
        if namespace == "0" and comment and EDIT_KIND_RE.match(comment):

            if EDIT_KIND_RE.match(comment).group(3) == 'sitelink':

                output_edit_type = "sitelink"

            elif EDIT_KIND_RE.match(comment).group(3) == 'aliases':

                output_edit_type = "aliases"

            elif EDIT_KIND_RE.match(comment).group(3) == 'label':

                output_edit_type = "label"

            elif EDIT_KIND_RE.match(comment).group(3) == 'description':

                output_edit_type = "description"

            elif EDIT_KIND_RE.match(comment).group(3) == 'reference' or \
                EDIT_KIND_RE.match(comment).group(3) == 'references':

                output_edit_type = "reference"

            elif EDIT_KIND_RE.match(comment).group(3) == 'qualifier':

                output_edit_type = "qualifier"

            elif EDIT_KIND_RE.match(comment).group(3) == 'claim' or \
                EDIT_KIND_RE.match(comment).group(3) == 'claims':

                output_edit_type = "claim"

        # Incrementing the agent type count
        if agent_type == 'bot_edit' or agent_type == 'human_edit' or \
            agent_type == 'anon_edit':

            if agent_type == 'human_edit' and \
                (agent_bot_pred == 'anon_ten_recall_bot_edit' or \
                agent_bot_pred == 'anon_twenty_recall_bot_edit' or 
                agent_bot_pred == 'anon_thirty_recall_bot_edit'):

                output_agent_type = 'human_bot_like_edit'

            elif agent_type == 'anon_edit' and \
                (agent_bot_pred == 'anon_ten_recall_bot_edit' or \
                agent_bot_pred == 'anon_twenty_recall_bot_edit' or 
                agent_bot_pred == 'anon_thirty_recall_bot_edit'):

                output_agent_type = 'anon_bot_like_edit'

            else:
                
                output_agent_type = agent_type
        else:

            output_agent_type = 'semi_automated_edit'



        output_file.write(json.dumps({
                    'year' : year,
                    'month' : month,
                    'namespace' : namespace,
                    'page_title': page_title,
                    'edit_type': output_edit_type,
                    'agent_type': output_agent_type,
                    'page_views': page_views,
                    'rev_id': revision_id
                }) + "\n")


main()

