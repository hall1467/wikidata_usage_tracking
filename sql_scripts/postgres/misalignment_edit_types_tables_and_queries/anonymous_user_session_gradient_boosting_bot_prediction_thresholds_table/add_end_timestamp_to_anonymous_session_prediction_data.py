"""
Add end timestamp to anonymous session bot prediction data.



Usage:
    add_end_timestamp_to_anonymous_session_prediction_data (-h|--help)
    add_end_timestamp_to_anonymous_session_prediction_data <input> <output>
                                                           [--debug]
                                                           [--verbose]

Options:
    -h, --help       This help message is printed
    <input_testing>  Path to input data file to process.
    <output>         Where output will be written.                    
    --debug          Print debug logging to stderr
    --verbose        Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
import sys
import mysqltsv
import datetime
from collections import defaultdict
import random


logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_file = mysqltsv.Reader(
        open(args['<input>'],'rt'),
        headers=True, types=[str, str, float, float, int, int, int, int, int, 
        int, int, int, int, float, int, int, int, int, int, int, int, int, int, 
        int, int, int, int, int, int, int, int, float])


    output_file = mysqltsv.Writer(
        open(args['<output>'], "w"), headers=[
            'username', 'session_start', 'session_end', 'mean_in_seconds', 
            'std_in_seconds', 'namespace_0_edits', 'namespace_1_edits', 
            'namespace_2_edits', 'namespace_3_edits', 'namespace_4_edits', 
            'namespace_5_edits', 'namespace_120_edits', 'namespace_121_edits', 
            'edits', 'session_length_in_seconds', 
            'inter_edits_less_than_5_seconds', 
            'inter_edits_between_5_and_20_seconds', 
            'inter_edits_greater_than_20_seconds', 'claims', 'distinct_claims', 
            'distinct_pages', 'distinct_edit_kinds', 'generic_bot_comment', 
            'bot_revision_comment', 'sitelink_changes', 'alias_changed', 
            'label_changed', 'description_changed', 'edit_war', 
            'inter_edits_less_than_2_seconds', 'things_removed', 
            'things_modified', 'threshold_score'])


    verbose = args['--verbose']

    run(input_file, output_file, verbose)


def run(input_file, output_file, verbose):

    for i, line in enumerate(input_file):

        converted_session_start_timestamp =\
            datetime.datetime(int(line['session_start'][0:4]),
                              int(line['session_start'][4:6]),
                              int(line['session_start'][6:8]),
                              int(line['session_start'][8:10]),
                              int(line['session_start'][10:12]),
                              int(line['session_start'][12:14]))



        session_completed = converted_session_start_timestamp +\
            datetime.timedelta(seconds=line['session_length_in_seconds'])

        session_completed_output_timestamp =\
            str(session_completed.year).zfill(4) +\
            str(session_completed.month).zfill(2) +\
            str(session_completed.day).zfill(2) +\
            str(session_completed.hour).zfill(2) +\
            str(session_completed.minute).zfill(2) +\
            str(session_completed.second).zfill(2)


        output_file.write(
            [line['username'],
             line['session_start'],
             session_completed_output_timestamp,
             line['mean_in_seconds'],
             line['std_in_seconds'],
             line['namespace_0_edits'],
             line['namespace_1_edits'],
             line['namespace_2_edits'],
             line['namespace_3_edits'],
             line['namespace_4_edits'],
             line['namespace_5_edits'],
             line['namespace_120_edits'],
             line['namespace_121_edits'],
             line['edits'],
             line['session_length_in_seconds'],
             line['inter_edits_less_than_5_seconds'],
             line['inter_edits_between_5_and_20_seconds'],
             line['inter_edits_greater_than_20_seconds'],
             line['claims'],
             line['distinct_claims'],
             line['distinct_pages'],
             line['distinct_edit_kinds'],
             line['generic_bot_comment'],
             line['bot_revision_comment'],
             line['sitelink_changes'],
             line['alias_changed'],
             line['label_changed'],
             line['description_changed'],
             line['edit_war'],
             line['inter_edits_less_than_2_seconds'],
             line['things_removed'],
             line['things_modified'],
             line['threshold_score']])


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Sessions finished updating: {0}\n".format(i))  
            sys.stderr.flush()



main()

