"""
Aggregates various attributes of misalignment and edit data by month.
Returns in json format in order to be processed by ORES next.

Usage:
    extract_edit_type (-h|--help)
    extract_edit_type <input> <output>
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


EDIT_KIND_RE = re.compile(r'(reverted edits|undid revision|restored revision|/\* (undo|restore|[^ ]+(sitelink|alias|label|description|reference|qualifier|claim|mergeitems|linktitles)))', re.I)


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

        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Processing revision: {0}\n".format(i))  
            sys.stderr.flush()


        page_title = line[0]
        revision_id = line[1]
        comment = line[3]
        namespace = line[4]
        misalignment_year = line[16]
        misalignment_month = line[17]
        page_views = line[11]
        agent_type = line[12]
        agent_bot_pred = line[18]

        
        if comment and EDIT_KIND_RE.match(comment):
            if EDIT_KIND_RE.match(comment).group(3) == 'sitelink':
                output_edit_type = 'sitelink'
            elif EDIT_KIND_RE.match(comment).group(3) == 'alias':
                output_edit_type = 'alias'
            elif EDIT_KIND_RE.match(comment).group(3) == 'label':
                output_edit_type = 'label'
            elif EDIT_KIND_RE.match(comment).group(3) == 'description':
                output_edit_type = 'description'
            elif EDIT_KIND_RE.match(comment).group(3) == 'reference':
                output_edit_type = 'reference'
            elif EDIT_KIND_RE.match(comment).group(3) == 'qualifier':
                output_edit_type = 'qualifier'
            elif EDIT_KIND_RE.match(comment).group(3) == 'claim':
                output_edit_type = 'claim'
            elif EDIT_KIND_RE.match(comment).group(3) == 'mergeitems':
                output_edit_type = 'mergeitems'
            elif EDIT_KIND_RE.match(comment).group(3) == 'linktitles':
                output_edit_type = 'linktitles'
            elif EDIT_KIND_RE.match(comment).group(1) == 'undid revision' or \
                EDIT_KIND_RE.match(comment).group(1) == 'reverted edits' or \
                EDIT_KIND_RE.match(comment).group(2) == 'undo':
                output_edit_type = 'undid or reverted revision'
            elif EDIT_KIND_RE.match(comment).group(1) == 'restored revision' or\
                EDIT_KIND_RE.match(comment).group(2) == 'restore':
                output_edit_type = 'restored revision'


        output_file.write(json.dumps({
                    'misalignment_year' : misalignment_year,
                    'misalignment_month' : misalignment_month,
                    'namespace' : namespace,
                    'page_title': page_title,
                    'edit_type': output_edit_type,
                    'agent_type': agent_type,
                    'page_views': page_views,
                    'rev_id': revision_id
                }) + "\n")


main()

