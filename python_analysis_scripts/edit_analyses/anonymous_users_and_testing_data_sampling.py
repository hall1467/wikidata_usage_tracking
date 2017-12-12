"""
Sample anonymous user sessions that have different bot threshold scores.
Also, samples testing data.



Usage:
    anonymous_users_and_testing_data_sampling (-h|--help)
    anonymous_users_and_testing_data_sampling <input_testing> <input_anonymous_user_threshold_scores> <anonymous_user_samples_output> <testing_samples_output>
                                              [--debug]
                                              [--verbose]

Options:
    -h, --help                               This help message is printed
    <input_testing>                          Path to input testing data file
                                             to process.
    <input_anonymous_user_threshold_scores>  Path to input anonymous user model 
                                             threshold scores file to sample.
    <anonymous_user_samples_output>          Where anonymous samples will be 
                                             written. HTML file.
    <testing_samples_output>                 Where testing samples will be 
                                             written. HTML file.                    
    --debug                                  Print debug logging to stderr
    --verbose                                Print dots and stuff to stderr  
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

    input_testing_file = mysqltsv.Reader(
        open(args['<input_testing>'],'rt'), headers=True, 
        types=[str, str, str, float, float, int, int, int, int, int, int, int, 
            int, int, float, int, int, int, str, str, int])

    input_anonymous_user_threshold_scores_file = mysqltsv.Reader(
        open(args['<input_anonymous_user_threshold_scores>'],'rt'),
        headers=True, types=[str, str, float, float, int, int, int, int, int, 
        int, int, int, int, float, int, int, int, float])


    anonymous_user_samples_output_file =\
        open(args['<anonymous_user_samples_output>'], "w")


    testing_samples_output_file = open(args['<testing_samples_output>'], "w")

    verbose = args['--verbose']

    run(input_testing_file, input_anonymous_user_threshold_scores_file, 
        anonymous_user_samples_output_file, testing_samples_output_file, 
        verbose)


def run(input_testing_file, input_anonymous_user_threshold_scores_file, 
    anonymous_user_samples_output_file, testing_samples_output_file,
    verbose):


    threshold_scores = defaultdict(list)
    false_negative_testing_sessions = []

    # Anonymous file sampling
    for i, line in enumerate(input_anonymous_user_threshold_scores_file):

        if line['threshold_score'] >= 1.78:
            recall_rounded = 'less_than_10_percent'
        elif line['threshold_score'] >= 1.11:
            recall_rounded = '10_to_20_percent'
        elif line['threshold_score'] >= .314:
            recall_rounded = '20_to_30_percent'
        elif line['threshold_score'] >= -.366:
            recall_rounded = '30_to_40_percent'
        elif line['threshold_score'] >= -1.21:
            recall_rounded = '40_to_50_percent'
        elif line['threshold_score'] >= -1.97:
            recall_rounded = '50_to_60_percent'
        elif line['threshold_score'] >= -2.78:
            recall_rounded = '60_to_70_percent'
        elif line['threshold_score'] >= -3.57:
            recall_rounded = '70_to_80_percent'
        elif line['threshold_score'] >= -4.23:
            recall_rounded = '80_to_90_percent'
        else:
            recall_rounded = 'greater_than_90_percent'

            

            
        threshold_scores[recall_rounded]\
            .append({'username' : line['username'], 
                     'session_start' : line['session_start'],
                     'threshold_score' : line['threshold_score'],
                     'session_length_in_seconds' : 
                          line['session_length_in_seconds']})


    recall_sample = defaultdict(list)
    for recall in threshold_scores:
        number_of_samples = 20
        length_of_recall = len(threshold_scores[recall])
        if length_of_recall < number_of_samples:
            number_of_samples = length_of_recall
        recall_sample[recall].append(random.sample(threshold_scores[recall],
                                                   number_of_samples))


    increasing_recall = ['less_than_10_percent', '10_to_20_percent', 
                         '20_to_30_percent', '30_to_40_percent', 
                         '40_to_50_percent', '50_to_60_percent', 
                         '60_to_70_percent', '70_to_80_percent', 
                         '80_to_90_percent', 'greater_than_90_percent']


    for recall in increasing_recall:
        anonymous_user_samples_output_file.write("<h1>Considered bot" + 
            " sessions when recall: {0}</h1>".format(recall))

        anonymous_user_samples_output_file.write("<ol>")

        for recall_session in recall_sample[recall]:
            for session in recall_session:
                url = create_url_item(session['username'], 
                                      session['session_start'], 
                                      session["session_length_in_seconds"])
                anonymous_user_samples_output_file.write(url)

        anonymous_user_samples_output_file.write("</ol>")


    # Testing file sampling
    for line in input_testing_file:
        if line['bot'] == 'TRUE' and line['bot_prediction'] == 0:
            false_negative_testing_sessions.append(line)

    testing_samples_output_file.write("<h1>False negatives from the test" +
        " set</h1>")
    testing_samples_output_file.write("<ol>")

    for line in random.sample(false_negative_testing_sessions, 100):
        url = create_url_item(line['username'], line['session_start'], 
                              line["session_length_in_seconds"])

        testing_samples_output_file.write(url)

    testing_samples_output_file.write("</ol>")


def create_url_item(username, starting_timestamp, session_length_in_seconds):
    url = ""
    converted_username = username.replace(":","%3A")
    converted_starting_timestamp =\
        datetime.datetime(int(starting_timestamp[0:4]),
                          int(starting_timestamp[4:6]),
                          int(starting_timestamp[6:8]),
                          int(starting_timestamp[8:10]),
                          int(starting_timestamp[10:12]),
                          int(starting_timestamp[12:14]))


    session_completed = converted_starting_timestamp +\
                        datetime.timedelta(seconds=session_length_in_seconds)

    session_completed_string = str(session_completed.year) +\
                               str(session_completed.month).zfill(2) +\
                               str(session_completed.day).zfill(2) +\
                               str(session_completed.hour).zfill(2) +\
                               str(session_completed.minute).zfill(2) +\
                               str(session_completed.second).zfill(2)


    starting_year_month_day =\
        str(converted_starting_timestamp.year).zfill(2) + "-" +\
        str(converted_starting_timestamp.month).zfill(2) + "-" +\
        str(converted_starting_timestamp.day).zfill(2)

    completed_year_month_day =\
        str(session_completed.year) + "-" +\
        str(session_completed.month).zfill(2) + "-" +\
        str(session_completed.day).zfill(2)


    url = "https://wikidata.org/w/index.php?limit=250&title=\
              Special%3AContributions&contribs=user&target=" +\
              converted_username +"&namespace=&tagfilter=&start=" +\
              starting_year_month_day + "&end=" + completed_year_month_day
              
    url_html = "<li><ul><li> Starting timestamp: " + starting_timestamp +\
               " <li> Session completed: " + session_completed_string +\
               " <li> Contributions page(s): <a href=\"" +\
               url + "\">" + url + "</a></p></ul></li>"

    return url_html

main()



