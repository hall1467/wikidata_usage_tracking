"""
Add bot prediction to entity revisions and types and usages table data. Both
datasets are sorted by username and timestamp. Specifically, the revision
timestamp for the 'entity_revisions_and_types_and_usages' table and 
'session_start' for the data coming from the 
'anonymous_user_session_gradient_boosting_bot_pred_thresholds' table.



Usage:
    add_bot_prediction_threshold_to_entity_revisions_and_types_and_usages_data (-h|--help)
    add_bot_prediction_threshold_to_entity_revisions_and_types_and_usages_data <entity_revisions_input> <anonymous_session_predictions_input> <output>
                                                                     [--debug]
                                                                     [--verbose]

Options:
    -h, --help                                  This help message is printed
    <entity_revisions_input>                    Path to input entity revisions
                                                data file to process.
    <anonymous_session_predictions_input>       Path to input anonymous session 
                                                predictions data file to 
                                                process.
    <output>                                    Where output will be written.                    
    --debug                                     Print debug logging to stderr
    --verbose                                   Print dots and stuff to stderr  
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

    anonymous_session_predictions_input_file = mysqltsv.Reader(
        open(args['<anonymous_session_predictions_input>'],'rt'),
        headers=False, types=[str, int, int, float])

    output_file = mysqltsv.Writer(open(args['<output>'], "w"))

    verbose = args['--verbose']

    run(entity_revisions_input_file, anonymous_session_predictions_input_file,
        output_file, verbose)


def run(entity_revisions_input_file, anonymous_session_predictions_input_file,
    output_file, verbose):

    anonymous_predictions = defaultdict(list)

    for i, line in enumerate(anonymous_session_predictions_input_file):
        anonymous_predictions[line[0]].append(line)


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Anon preds put in dictionary: {0}\n".format(i))  
            sys.stderr.flush()

    number_of_sessions = 0
    for username in anonymous_predictions:
        number_of_sessions += len(anonymous_predictions[username])


    for i, line in enumerate(entity_revisions_input_file):
            
        

        bot_prediction_threshold = "\\N"

        if line[2] in anonymous_predictions:


            

            unconsidered_sessions = []
            potential_session = anonymous_predictions[line[2]][0]

            if len(anonymous_predictions[line[2]]) > 1:
                next_session = anonymous_predictions[line[2]][1]
            else:
                next_session = None

            print(line[2], line[5], potential_session[1],potential_session[2], potential_session[3], anonymous_predictions[line[2]])

            if line[5] >= potential_session[1] and \
                line[5] <= potential_session[2]:

                bot_prediction_threshold = potential_session[3]

            elif line[5] > potential_session[2]:
                if next_session and line[5] >= next_session[1] and \
                    line[5] <= next_session[2]:
                    
                    bot_prediction_threshold = next_session[3]

                if len(anonymous_predictions[line[2]]) > 1:
                    # In situation where one remains, leave it in place.
                    anonymous_predictions[line[2]].pop(0)




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
             bot_prediction_threshold])

        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Revisions finished updating: {0}\n".format(i))  
            sys.stderr.flush()



main()


