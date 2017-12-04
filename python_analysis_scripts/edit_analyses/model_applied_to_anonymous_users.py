"""
Apply previously generated model to anonymous user data.



Usage:
    model_applied_to_anonymous_users (-h|--help)
    model_applied_to_anonymous_users <input_training> <input_anonymous_data> <r_forest_predictions_output> <gradient_b_predictions_output>
                                     [--debug]
                                     [--verbose]

Options:
    -h, --help                       This help message is printed
    <input_training>                 Path to input training file to process.
    <input_anonymous_data>           Path to input anonymous user data file to process.
    <r_forest_predictions_output>    Where random forest predictions will be written
    <gradient_b_predictions_output>  Where gradient boosting predictions will be written                         
    --debug                          Print debug logging to stderr
    --verbose                        Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
import sys
import mysqltsv
import sklearn
import sklearn.ensemble
import sklearn.model_selection
import numpy
from collections import defaultdict


logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_training_file = mysqltsv.Reader(
        open(args['<input_training>'],'rt'), headers=True, 
        types=[float, float, int, int, int, int, int, int, int, int, int, str,
            str, float, int, int, int])

    input_anonymous_data_file = mysqltsv.Reader(
        open(args['<input_anonymous_data>'],'rt'), headers=True, 
        types=[str, str, float, float, int, int, int, int, int, int, int, int, 
        int, float, int, int, int])


    r_forest_predictions_output_file = mysqltsv.Writer(open(args['<r_forest_predictions_output>'], "w"), headers=[
        'username', 'session_start', 'mean_in_seconds', 'std_in_seconds', 
        'namespace_0_edits', 'namespace_1_edits', 'namespace_2_edits', 
        'namespace_3_edits', 'namespace_4_edits', 'namespace_5_edits', 
        'namespace_120_edits', 'namespace_121_edits', 'edits', 
        'session_length_in_seconds', 'inter_edits_less_than_5_seconds', 
        'inter_edits_between_5_and_20_seconds', 
        'inter_edits_greater_than_20_seconds', 'bot_prediction'])


    gradient_b_predictions_output_file = mysqltsv.Writer(open(args['<gradient_b_predictions_output>'], "w"), headers=[
        'username', 'session_start', 'mean_in_seconds', 'std_in_seconds', 
        'namespace_0_edits', 'namespace_1_edits', 'namespace_2_edits', 
        'namespace_3_edits', 'namespace_4_edits', 'namespace_5_edits', 
        'namespace_120_edits', 'namespace_121_edits', 'edits', 
        'session_length_in_seconds', 'inter_edits_less_than_5_seconds', 
        'inter_edits_between_5_and_20_seconds', 
        'inter_edits_greater_than_20_seconds', 'bot_prediction'])

    verbose = args['--verbose']

    run(input_training_file, input_anonymous_data_file, 
        r_forest_predictions_output_file, gradient_b_predictions_output_file, 
        verbose)


def run(input_training_file, input_anonymous_data_file, 
    r_forest_predictions_output_file, 
    gradient_b_predictions_output_file, verbose):
    
    training_predictors = []
    training_responses = []
    anonymous_predictors = []
    user_and_session_start = []

    for i, line in enumerate(input_training_file):
        # predictors.append([line['mean_in_seconds']])



        training_predictors.append([line['mean_in_seconds'],
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
                                   line['inter_edits_greater_than_20_seconds']])


        if line['bot'] == 'TRUE':
            bot = 1
            human = 0
        else:
            bot = 0
            human = 1

        training_responses.append(bot)


    for i, line in enumerate(input_anonymous_data_file):
        user_and_session_start.append({'username' : line['username'], 
                                'session_start' : line['session_start']})



        anonymous_predictors.append([line['mean_in_seconds'],
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
                                   line['inter_edits_greater_than_20_seconds']])




    r_forest_fitted_model = sklearn.ensemble.RandomForestClassifier(
                                n_estimators=160, min_samples_leaf=13, 
                                criterion='gini', max_features='log2')\
        .fit(training_predictors, training_responses)

    r_forest_predictions = r_forest_fitted_model\
                               .predict(anonymous_predictors)

    sys.stderr.write("Random forest predictor weightings: {0}\n"
      .format(r_forest_fitted_model.feature_importances_))  
    sys.stderr.flush()

    gradient_b_fitted_model = sklearn.ensemble.GradientBoostingClassifier(
                                  n_estimators=1300, max_depth=5, 
                                  learning_rate=.01, max_features='log2')\
        .fit(training_predictors, training_responses)

    gradient_b_predictions = gradient_b_fitted_model\
                                 .predict(anonymous_predictors)

    sys.stderr.write("Gradient boosting predictor weightings: {0}\n"
      .format(gradient_b_fitted_model.feature_importances_))  
    sys.stderr.flush()

    for i, line in enumerate(anonymous_predictors):

        r_forest_predictions_output_file.write(
            [user_and_session_start[i]['username'],
             user_and_session_start[i]['session_start'],
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
             line[12],
             line[13],
             line[14],
             r_forest_predictions[i]])

        gradient_b_predictions_output_file.write(
            [user_and_session_start[i]['username'],
             user_and_session_start[i]['session_start'],
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
             line[12],
             line[13],
             line[14],
             gradient_b_predictions[i]])



main()

