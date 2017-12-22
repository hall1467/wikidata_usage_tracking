"""
Take labelled data and aggregates to create predictors for a model.



Usage:
    model_construction (-h|--help)
    model_construction <input_training> <input_testing>
                           [--debug]
                           [--verbose]

Options:
    -h, --help        This help message is printed
    <input_training>  Path to input training file to process.
    <input_testing>   Path to input training file to process.                          
    --debug           Print debug logging to stderr
    --verbose         Print dots and stuff to stderr  
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
            int, int, str, str, float, int, int, int, int, int, int, int, int, 
            int, int, int, int, int, int, int, int, int])

    input_testing_file = mysqltsv.Reader(
        open(args['<input_testing>'],'rt'), headers=True, 
        types=[str, str, str, float, float, int, int, int, int, int, int, int, 
            int, int, str, str, float, int, int, int, int, int, int, int, int, 
            int, int, int, int, int, int, int, int, int])


    verbose = args['--verbose']

    run(input_training_file, input_testing_file, verbose)


def run(input_training_file, input_testing_file, verbose):
    
    training_predictors = []
    training_responses = []
    testing_predictors = []
    testing_responses = []

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


    for i, line in enumerate(input_testing_file):



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



    roc_r_forest_fitted_model = sklearn.model_selection.GridSearchCV(
                       sklearn.ensemble.RandomForestClassifier(),
                       {'n_estimators' : [10, 20, 40, 80, 160, 320, 640, 960, 
                                          1280, 2560], 
                        'min_samples_leaf' : [1, 3, 5, 7, 13, 15, 17], 
                        'criterion' : ['gini', 'entropy'],
                        'max_features' : ['log2']}, 
                       scoring="roc_auc")\
        .fit(training_predictors, training_responses)

    print("ROC RANDOM FOREST")
    print("BEST SCORE")
    print((roc_r_forest_fitted_model.best_score_))
    print ("BEST ESTIMATOR")
    print((roc_r_forest_fitted_model.best_estimator_))
    print ("BEST PARAMS")
    print((roc_r_forest_fitted_model.best_params_))
    print ("SCORE WITH TESTING DATASET")
    print((roc_r_forest_fitted_model
               .score(testing_predictors, testing_responses)))
    print()



    average_prec_r_forest_fitted_model = sklearn.model_selection.GridSearchCV(
                       sklearn.ensemble.RandomForestClassifier(),
                       {'n_estimators' : [10, 20, 40, 80, 160, 320, 640, 960, 
                                          1280, 2560], 
                        'min_samples_leaf' : [1, 3, 5, 7, 13, 15, 17], 
                        'criterion' : ['gini', 'entropy'],
                        'max_features' : ['log2']}, 
                       scoring="average_precision")\
        .fit(training_predictors, training_responses)

    print("AVERAGE PRECISION RANDOM FOREST")
    print("BEST SCORE")
    print((average_prec_r_forest_fitted_model.best_score_))
    print ("BEST ESTIMATOR")
    print((average_prec_r_forest_fitted_model.best_estimator_))
    print ("BEST PARAMS")
    print((average_prec_r_forest_fitted_model.best_params_))
    print ("SCORE WITH TESTING DATASET")
    print((average_prec_r_forest_fitted_model
               .score(testing_predictors, testing_responses)))
    print()



    roc_gradient_b_fitted_model = sklearn.model_selection.GridSearchCV(
                       sklearn.ensemble.GradientBoostingClassifier(),
                       {'n_estimators' : [100, 300, 500, 700, 900, 1100, 1300, 
                                          1500, 1700], 
                        'max_depth' : [1, 3, 5, 7, 9], 
                        'learning_rate' : [.001, .01, .1, .5, 1],
                        'max_features' : ['log2']}, 
                       scoring="roc_auc")\
        .fit(training_predictors, training_responses)


    print("ROC GRADIENT BOOSTING")
    print("BEST SCORE")
    print((roc_gradient_b_fitted_model.best_score_))
    print ("BEST ESTIMATOR")
    print((roc_gradient_b_fitted_model.best_estimator_))
    print ("BEST PARAMS")
    print((roc_gradient_b_fitted_model.best_params_))
    print ("SCORE WITH TESTING DATASET")
    print((roc_gradient_b_fitted_model
               .score(testing_predictors, testing_responses)))
    print()



    average_prec_gradient_b_fitted_model = sklearn.model_selection.GridSearchCV(
                       sklearn.ensemble.GradientBoostingClassifier(),
                       {'n_estimators' : [100, 300, 500, 700, 900, 1100, 1300, 
                                          1500, 1700], 
                        'max_depth' : [1, 3, 5, 7, 9], 
                        'learning_rate' : [.001, .01, .1, .5, 1],
                        'max_features' : ['log2']}, 
                       scoring="average_precision")\
        .fit(training_predictors, training_responses)


    print("AVERAGE PRECISION GRADIENT BOOSTING")
    print("BEST SCORE")
    print((average_prec_gradient_b_fitted_model.best_score_))
    print ("BEST ESTIMATOR")
    print((average_prec_gradient_b_fitted_model.best_estimator_))
    print ("BEST PARAMS")
    print((average_prec_gradient_b_fitted_model.best_params_))
    print ("SCORE WITH TESTING DATASET")
    print((average_prec_gradient_b_fitted_model
               .score(testing_predictors, testing_responses)))
    print()


main()

