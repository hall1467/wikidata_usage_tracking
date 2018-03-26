"""
Apply previously generated model to anonymous user data.



Usage:
    model_applied_to_anonymous_users (-h|--help)
    model_applied_to_anonymous_users <input_training> <input_testing> <input_anonymous_data> <r_forest_predictions_output> <gradient_b_predictions_output> <gradient_b_predictions_i2_output> <gradient_b_threshold_scores_output> <gradient_b_threshold_scores_i2_output> <testing_output> <pr_output> <roc_output>
                                     [--debug]
                                     [--verbose]

Options:
    -h, --help                               This help message is printed
    <input_training>                         Path to input training file to 
                                             process.
    <input_testing>                          Path to input anonymous user data
                                             file to process.
    <input_anonymous_data>                   Path to input anonymous user data 
                                             file to process.
    <r_forest_predictions_output>            Where random forest predictions 
                                             will be written
    <gradient_b_predictions_output>          Where gradient boosting predictions 
                                             will be written
    <gradient_b_predictions_i2_output>       Where iteration 2 gradient boosting 
                                             predictions will be written
    <gradient_b_threshold_scores_output>     Where gradient boosting thresold 
                                             scores will be written
    <gradient_b_threshold_scores_i2_output>  Where iteration 2 gradient boosting
                                             thresold scores will be written
    <testing_output>                         Where testing predictions and 
                                             original predictors and labelled 
                                             data will be written     
    <pr_output>                              Where precision versus recall 
                                             output data for gradient boosting 
                                             iteration 2 will be written 
    <roc_output>                             Where roc output data for gradient 
                                             boosting iteration 2 will be 
                                             written                      
    --debug                                  Print debug logging to stderr
    --verbose                                Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
import sys
import mysqltsv
import sklearn
import sklearn.ensemble
import sklearn.model_selection
import sklearn.metrics
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
        types=[str, str, str, float, float, int, int, int, int, int, int, int, 
            int, int, str, str, float, int, int, int, int, int, int, int, 
            int, int, int, int, int, int, int, int, int, int]) 

    input_testing_file = mysqltsv.Reader(
        open(args['<input_testing>'],'rt'), headers=True, 
        types=[str, str, str, float, float, int, int, int, int, int, int, int, 
            int, int, str, str, float, int, int, int, int, int, int, int, 
            int, int, int, int, int, int, int, int, int, int])

    input_anonymous_data_file = mysqltsv.Reader(
        open(args['<input_anonymous_data>'],'rt'), headers=True, 
        types=[str, str, float, float, int, int, int, int, int, int, int, int, 
            int, float, int, int, int, int, int, int, int, int, int, int, int, 
            int, int, int, int, int, int])


    r_forest_predictions_output_file = mysqltsv.Writer(
        open(args['<r_forest_predictions_output>'], "w"), headers=[
            'username', 'session_start', 'mean_in_seconds', 'std_in_seconds', 
            'namespace_0_edits', 'namespace_1_edits', 'namespace_2_edits', 
            'namespace_3_edits', 'namespace_4_edits', 'namespace_5_edits', 
            'namespace_120_edits', 'namespace_121_edits', 'edits', 
            'session_length_in_seconds', 'inter_edits_less_than_5_seconds', 
            'inter_edits_between_5_and_20_seconds', 
            'inter_edits_greater_than_20_seconds', 'bot_prediction'])


    gradient_b_predictions_output_file = mysqltsv.Writer(
        open(args['<gradient_b_predictions_output>'], "w"), headers=[
            'username', 'session_start', 'mean_in_seconds', 'std_in_seconds', 
            'namespace_0_edits', 'namespace_1_edits', 'namespace_2_edits', 
            'namespace_3_edits', 'namespace_4_edits', 'namespace_5_edits', 
            'namespace_120_edits', 'namespace_121_edits', 'edits', 
            'session_length_in_seconds', 'inter_edits_less_than_5_seconds', 
            'inter_edits_between_5_and_20_seconds', 
            'inter_edits_greater_than_20_seconds', 'bot_prediction'])

    gradient_b_predictions_i2_output_file = mysqltsv.Writer(
        open(args['<gradient_b_predictions_i2_output>'], "w"), headers=[
            'username', 'session_start', 'mean_in_seconds', 'std_in_seconds', 
            'namespace_0_edits', 'namespace_1_edits', 'namespace_2_edits', 
            'namespace_3_edits', 'namespace_4_edits', 'namespace_5_edits', 
            'namespace_120_edits', 'namespace_121_edits', 'edits', 
            'session_length_in_seconds', 'inter_edits_less_than_5_seconds', 
            'inter_edits_between_5_and_20_seconds', 
            'inter_edits_greater_than_20_seconds', 'claims', 'distinct_claims', 
            'distinct_pages', 'disinct_edit_kinds', 'generic_bot_comment', 
            'bot_revision_comment', 'sitelink_changes', 'alias_changed', 
            'label_changed', 'description_changed', 'edit_war', 
            'inter_edits_less_than_2_seconds', 'things_removed', 
            'things_modified', 'bot_prediction'])


    gradient_b_threshold_scores_output_file = mysqltsv.Writer(
        open(args['<gradient_b_threshold_scores_output>'], "w"), headers=[
            'username', 'session_start', 'mean_in_seconds', 'std_in_seconds', 
            'namespace_0_edits', 'namespace_1_edits', 'namespace_2_edits', 
            'namespace_3_edits', 'namespace_4_edits', 'namespace_5_edits', 
            'namespace_120_edits', 'namespace_121_edits', 'edits', 
            'session_length_in_seconds', 'inter_edits_less_than_5_seconds', 
            'inter_edits_between_5_and_20_seconds', 
            'inter_edits_greater_than_20_seconds', 'threshold_score'])


    gradient_b_threshold_scores_i2_output_file = mysqltsv.Writer(
        open(args['<gradient_b_threshold_scores_i2_output>'], "w"), headers=[
            'username', 'session_start', 'mean_in_seconds', 'std_in_seconds', 
            'namespace_0_edits', 'namespace_1_edits', 'namespace_2_edits', 
            'namespace_3_edits', 'namespace_4_edits', 'namespace_5_edits', 
            'namespace_120_edits', 'namespace_121_edits', 'edits', 
            'session_length_in_seconds', 'inter_edits_less_than_5_seconds', 
            'inter_edits_between_5_and_20_seconds', 
            'inter_edits_greater_than_20_seconds', 'claims', 'distinct_claims', 
            'distinct_pages', 'disinct_edit_kinds', 'generic_bot_comment', 
            'bot_revision_comment', 'sitelink_changes', 'alias_changed', 
            'label_changed', 'description_changed', 'edit_war', 
            'inter_edits_less_than_2_seconds', 'things_removed', 
            'things_modified', 'threshold_score'])


    testing_output_file = mysqltsv.Writer(
        open(args['<testing_output>'], "w"), headers=[
            'user', 'username', 'session_start', 'mean_in_seconds', 
            'std_in_seconds', 'namespace_0_edits', 'namespace_1_edits', 
            'namespace_2_edits', 'namespace_3_edits', 'namespace_4_edits', 
            'namespace_5_edits', 'namespace_120_edits', 'namespace_121_edits', 
            'edits', 'session_length_in_seconds', 
            'inter_edits_less_than_5_seconds', 
            'inter_edits_between_5_and_20_seconds', 
            'inter_edits_greater_than_20_seconds', 'bot', 'human', 
            'bot_prediction'])


    pr_output_file = mysqltsv.Writer(
        open(args['<pr_output>'], "w"), headers=[
            'precision', 'recall'])


    roc_output_file = mysqltsv.Writer(
        open(args['<roc_output>'], "w"), headers=[
            'false_positives', 'true_positives'])


    verbose = args['--verbose']

    run(input_training_file, input_testing_file, input_anonymous_data_file, 
        r_forest_predictions_output_file, gradient_b_predictions_output_file,
        gradient_b_predictions_i2_output_file,
        gradient_b_threshold_scores_output_file, 
        gradient_b_threshold_scores_i2_output_file, testing_output_file, 
        pr_output_file, roc_output_file, verbose)


def run(input_training_file, input_testing_file, input_anonymous_data_file, 
    r_forest_predictions_output_file, 
    gradient_b_predictions_output_file, gradient_b_predictions_i2_output_file,
    gradient_b_threshold_scores_output_file, 
    gradient_b_threshold_scores_i2_output_file, testing_output_file, 
    pr_output_file, roc_output_file, verbose):
    
    training_predictors = []
    training_predictors_i2 = []
    training_responses = []
    training_responses_i2 = []
    testing_predictors = []
    testing_predictors_i2 = []
    testing_responses = []
    testing_responses_i2 = []
    anonymous_predictors = []
    anonymous_predictors_i2 = []
    anonymous_user_and_session_start = []
    testing_user_non_predictors = []

    for i, line in enumerate(input_training_file):


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

        training_predictors_i2\
            .append([line['mean_in_seconds'],
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
                    line['disinct_edit_kinds'], 
                    line['generic_bot_comment'], 
                    line['bot_revision_comment'], 
                    line['sitelink_changes'], 
                    line['alias_changed'], 
                    line['label_changed'], 
                    line['description_changed'], 
                    line['edit_war'], 
                    line['inter_edits_less_than_2_seconds'], 
                    line['things_removed'], 
                    line['things_modified']])


        if line['bot'] == 'TRUE':
            bot = 1
            human = 0
        else:
            bot = 0
            human = 1

        training_responses.append(bot)
        training_responses_i2.append(bot)


    for i, line in enumerate(input_testing_file):
        testing_user_non_predictors.append({'user' : line['user'], 
                                            'session_start' : 
                                                line['session_start'], 
                                            'bot' : line['bot'], 
                                            'human' : line['human'],
                                            'username' : line['username']})

        testing_predictors.append([line['mean_in_seconds'],
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


        testing_predictors_i2\
            .append([line['mean_in_seconds'],
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
                    line['disinct_edit_kinds'], 
                    line['generic_bot_comment'], 
                    line['bot_revision_comment'], 
                    line['sitelink_changes'], 
                    line['alias_changed'], 
                    line['label_changed'], 
                    line['description_changed'], 
                    line['edit_war'], 
                    line['inter_edits_less_than_2_seconds'], 
                    line['things_removed'], 
                    line['things_modified']])



        if line['bot'] == 'TRUE':
            bot = 1
            human = 0
        else:
            bot = 0
            human = 1

        testing_responses.append(bot)
        testing_responses_i2.append(bot)


    for i, line in enumerate(input_anonymous_data_file):
        anonymous_user_and_session_start.append({'username' : line['username'], 
                                                 'session_start' : 
                                                    line['session_start']})


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


        anonymous_predictors_i2\
            .append([line['mean_in_seconds'],
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
                    line['disinct_edit_kinds'], 
                    line['generic_bot_comment'], 
                    line['bot_revision_comment'], 
                    line['sitelink_changes'], 
                    line['alias_changed'], 
                    line['label_changed'], 
                    line['description_changed'], 
                    line['edit_war'], 
                    line['inter_edits_less_than_2_seconds'], 
                    line['things_removed'], 
                    line['things_modified']])



    r_forest_fitted_model = sklearn.ensemble.RandomForestClassifier(
                                n_estimators=320, min_samples_leaf=3, 
                                criterion='gini', max_features='log2')\
        .fit(training_predictors, training_responses)

    r_forest_predictions = r_forest_fitted_model\
                               .predict(anonymous_predictors)

    sys.stderr.write("Random forest default predictor weightings: {0}\n"
      .format(r_forest_fitted_model.feature_importances_))  
    sys.stderr.write("Random forest default precision: {0}\n"
      .format(sklearn.metrics.precision_score(testing_responses,
              r_forest_fitted_model.predict(testing_predictors))))
    sys.stderr.write("Random forest recall: {0}\n"
      .format(sklearn.metrics.recall_score(testing_responses,
              r_forest_fitted_model.predict(testing_predictors))))
    sys.stderr.flush()


    gradient_b_fitted_model = sklearn.ensemble.GradientBoostingClassifier(
                                  n_estimators=1700, max_depth=5, 
                                  learning_rate=.01, max_features='log2')\
        .fit(training_predictors, training_responses)

    gradient_b_predictions_i1 = gradient_b_fitted_model\
                                 .predict(anonymous_predictors)

    sys.stderr.write("Gradient boosting predictor weightings: {0}\n"
        .format(gradient_b_fitted_model.feature_importances_))
    sys.stderr.write("Gradient default boosting precision: {0}\n"
        .format(sklearn.metrics.precision_score(testing_responses,
                gradient_b_fitted_model.predict(testing_predictors))))
    sys.stderr.write("Gradient default boosting recall: {0}\n"
        .format(sklearn.metrics.recall_score(testing_responses,
                gradient_b_fitted_model.predict(testing_predictors))))
    sys.stderr.write("Gradient boosting precision recall curve: {0}\n"
        .format(sklearn.metrics.precision_recall_curve(testing_responses,
                gradient_b_fitted_model.decision_function(testing_predictors))))
    sys.stderr.flush()


    gradient_b_i2_fitted_model = sklearn.ensemble.GradientBoostingClassifier(
                                  n_estimators=1100, max_depth=3, 
                                  learning_rate=.1, max_features='log2')\
        .fit(training_predictors_i2, training_responses_i2)

    gradient_b_predictions_i2 = gradient_b_i2_fitted_model\
                                 .predict(anonymous_predictors_i2)

    sys.stderr.write("Gradient boosting predictor weightings I2: {0}\n"
        .format(gradient_b_i2_fitted_model.feature_importances_))
    sys.stderr.write("Gradient default boosting precision I2: {0}\n"
        .format(sklearn.metrics.precision_score(testing_responses_i2,
                gradient_b_i2_fitted_model.predict(testing_predictors_i2))))
    sys.stderr.write("Gradient default boosting recall I2: {0}\n"
        .format(sklearn.metrics.recall_score(testing_responses_i2,
                gradient_b_i2_fitted_model.predict(testing_predictors_i2))))
    sys.stderr.write("Gradient boosting precision recall curve I2: {0}\n"
        .format(sklearn.metrics.precision_recall_curve(testing_responses_i2,
                gradient_b_i2_fitted_model.
                    decision_function(testing_predictors_i2))))
    sys.stderr.flush()

    p, r, t = sklearn.metrics.precision_recall_curve(testing_responses_i2, 
        gradient_b_i2_fitted_model.decision_function(testing_predictors_i2))

    for i, line in enumerate(p):
        pr_output_file.write([p[i], r[i]])

    false_value, true_value, t = sklearn.metrics.roc_curve(testing_responses_i2, 
        gradient_b_i2_fitted_model.decision_function(testing_predictors_i2))

    for i, line in enumerate(false_value):
        roc_output_file.write([false_value[i], true_value[i]])
        
    threshold_scores_i1 =\
        gradient_b_fitted_model.decision_function(anonymous_predictors)

    threshold_scores_i2 =\
        gradient_b_i2_fitted_model.decision_function(anonymous_predictors_i2)

    testing_predictions =\
        gradient_b_fitted_model.predict(testing_predictors)

    for i, line in enumerate(testing_predictors):
        
        testing_output_file.write(
            [testing_user_non_predictors[i]['user'],
             testing_user_non_predictors[i]['username'],
             testing_user_non_predictors[i]['session_start'],
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
             testing_user_non_predictors[i]['bot'],
             testing_user_non_predictors[i]['human'],
             testing_predictions[i]])


    for i, line in enumerate(anonymous_predictors_i2):

        r_forest_predictions_output_file.write(
            [anonymous_user_and_session_start[i]['username'],
             anonymous_user_and_session_start[i]['session_start'],
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
            [anonymous_user_and_session_start[i]['username'],
             anonymous_user_and_session_start[i]['session_start'],
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
             gradient_b_predictions_i1[i]])


        gradient_b_predictions_i2_output_file.write(
            [anonymous_user_and_session_start[i]['username'],
             anonymous_user_and_session_start[i]['session_start'],
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
             line[15],
             line[16],
             line[17],
             line[18],
             line[19],
             line[20],
             line[21],
             line[22],
             line[23],
             line[24],
             line[25],
             line[26],
             line[27],
             line[28],
             gradient_b_predictions_i2[i]])


        gradient_b_threshold_scores_output_file.write(
            [anonymous_user_and_session_start[i]['username'],
             anonymous_user_and_session_start[i]['session_start'],
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
             threshold_scores_i1[i]])


        gradient_b_threshold_scores_i2_output_file.write(
            [anonymous_user_and_session_start[i]['username'],
             anonymous_user_and_session_start[i]['session_start'],
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
             line[15],
             line[16],
             line[17],
             line[18],
             line[19],
             line[20],
             line[21],
             line[22],
             line[23],
             line[24],
             line[25],
             line[26],
             line[27],
             line[28],
             threshold_scores_i2[i]])


main()

