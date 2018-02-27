"""
Add bot prediction to entity revisions and types and usages table data. Both
datasets are sorted by user and timestamp. Specifically, the revision
timestamp for the 'entity_revisions_and_types_and_usages' table and 
'session_start' for the data coming from the 
'user_session_gradient_boosting_bot_pred_thresholds' table.
Has been updated to include starting session timestamp as well.



Usage:
    add_bot_prediction_threshold_to_entity_revisions_and_types_and_usages_data (-h|--help)
    add_bot_prediction_threshold_to_entity_revisions_and_types_and_usages_data <entity_revisions_input> <session_predictions_input> <output>
                                                                               [--debug]
                                                                               [--verbose]

Options:
    -h, --help                   This help message is printed
    <entity_revisions_input>     Path to input entity revisions
                                 data file to process.
    <session_predictions_input>  Path to input session 
                                 predictions data file to 
                                 process.
    <output>                     Where output will be written.                    
    --debug                      Print debug logging to stderr
    --verbose                    Print dots and stuff to stderr  
"""


import docopt
import logging
import sys
import mysqltsv
import datetime
from collections import defaultdict


logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )


    entity_revisions_input_file = mysqltsv.Reader(
        open(args['<entity_revisions_input>'],'rt'),
        headers=False, types=[str, int, str, str, str, int, int, int, str, str, 
        str, str, str, str])

    session_predictions_input_file = mysqltsv.Reader(
        open(args['<session_predictions_input>'],'rt'),
        headers=False, types=[str, int, int, float])

    output_file = mysqltsv.Writer(open(args['<output>'], "w"))

    verbose = args['--verbose']

    run(entity_revisions_input_file, session_predictions_input_file,
        output_file, verbose)


def run(entity_revisions_input_file, session_predictions_input_file,
    output_file, verbose):

    predictions = defaultdict(list)

    for i, line in enumerate(session_predictions_input_file):
        predictions[line[0]].append(line)


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Preds put in dictionary: {0}\n".format(i))  
            sys.stderr.flush()


    for i, line in enumerate(entity_revisions_input_file):

        bot_prediction_threshold = "\\N"
        start_of_session = "\\N"

        if line[2] in predictions:

            unconsidered_sessions = []
            potential_session = predictions[line[2]][0]

            if len(predictions[line[2]]) > 1:
                next_session = predictions[line[2]][1]
            else:
                next_session = None


            if line[5] >= potential_session[1] and \
                line[5] <= potential_session[2]:

                bot_prediction_threshold = potential_session[3]
                start_of_session = potential_session[1]

            elif line[5] > potential_session[2]:
                if next_session and line[5] >= next_session[1] and \
                    line[5] <= next_session[2]:
                    
                    bot_prediction_threshold = next_session[3]
                    start_of_session = next_session[1]

                if len(predictions[line[2]]) > 1:
                    # In situation where one remains, leave it in place.
                    predictions[line[2]].pop(0)




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
             bot_prediction_threshold,
             start_of_session])

        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Revisions finished updating: {0}\n".format(i))  
            sys.stderr.flush()



main()


