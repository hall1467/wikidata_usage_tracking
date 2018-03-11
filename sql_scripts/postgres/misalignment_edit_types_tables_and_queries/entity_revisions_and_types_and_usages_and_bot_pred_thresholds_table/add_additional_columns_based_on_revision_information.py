"""
Match edits to following month so that they can be joined with
misalignment data for that month.

Usage:
    add_additional_columns_based_on_revision_information (-h|--help)
    add_additional_columns_based_on_revision_information <revisions_input> <output>
                                                         [--debug]
                                                         [--verbose]

Options:
    -h, --help         This help message is printed
    <revisions_input>  Path to revisions file to process.
    <output>           Where output will be written
    --debug            Print debug logging to stderr
    --verbose          Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
from collections import defaultdict
import mysqltsv
import re
import sys


logger = logging.getLogger(__name__)

REFERENCE_MANIPULATION_RE = re.compile(r'.*reference', re.I)
SITELINK_MANIPULATION_RE = re.compile(r'.*sitelink', re.I)
LABEL_DESCRIPTION_OR_ALIAS_MANIPULATION_RE = re.compile(r'.*((alias)|(label)|(description))', re.I)

def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    revisions_input_file = mysqltsv.Reader(
        open(args['<revisions_input>'],'rt'),
        headers=False, types=[str, int, str, str, str, int, int, int, str, str, 
        str, str, str, str, str, str, int, int])


    output_file = mysqltsv.Writer(open(args['<output>'], "w"))

    verbose = args['--verbose']


    run(revisions_input_file, output_file, verbose)


def run(revisions_input_file, output_file, verbose):


    for i, line in enumerate(revisions_input_file):

        comment = line[3]
        bot_prediction_threshold = line[14]

        if not bot_prediction_threshold:
            edit_type_updated = "\\N"
        elif bot_prediction_threshold >= 5.46:
            edit_type_updated = 'anon_ten_recall_bot_edit'
        elif bot_prediction_threshold >= 4.01:
            edit_type_updated = 'anon_twenty_recall_bot_edit'
        elif bot_prediction_threshold >= 3.01:
            edit_type_updated = 'anon_thirty_recall_bot_edit'
        elif bot_prediction_threshold >= 2.21:
            edit_type_updated = 'anon_forty_recall_bot_edit'
        elif bot_prediction_threshold >= 1.41:
            edit_type_updated = 'anon_fifty_recall_bot_edit'
        elif bot_prediction_threshold >= .66:
            edit_type_updated = 'anon_sixty_recall_bot_edit'
        elif bot_prediction_threshold >= -.18:
            edit_type_updated = 'anon_seventy_recall_bot_edit'
        elif bot_prediction_threshold >= -1.18:
            edit_type_updated = 'anon_eighty_recall_bot_edit'
        elif bot_prediction_threshold >= -2.39:
            edit_type_updated = 'anon_ninety_recall_bot_edit'
        elif bot_prediction_threshold >= -5.25:
            edit_type_updated = 'anon_one_hundred_recall_bot_edit'
        else:
            edit_type_updated = "\\N"


        if REFERENCE_RE.match(comment):
            reference_manipulation = True
        else:
            reference_manipulation = False

        if SITELINK_MANIPULATION_RE.match(comment):
            sitelink_manipulation = True
        else:
            sitelink_manipulation = False

        if LABEL_DESCRIPTION_OR_ALIAS_MANIPULATION_RE.match(comment):
            label_description_or_alias_manipulation = True
        else:
            label_description_or_alias_manipulation = False


        output_file.write(
            [line[0],
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
             line[13],
             line[14],
             line[15],
             line[16],
             line[17],
             edit_type_updated,
             reference_manipulation,
             sitelink_manipulation,
             label_description_or_alias_manipulation])


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Revisions processed: {0}\n".format(i))  
            sys.stderr.flush()



main()


