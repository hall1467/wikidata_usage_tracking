"""
Aggregates agent type data by month for used entities.

Usage:
    attribute_aggregator (-h|--help)
    attribute_aggregator <input> <output_aggregations>
                         [--debug]
                         [--verbose]

Options:
    -h, --help             This help message is printed
    <input>                Path to misalignment/edit
                           breakdown file to process.
    <output_aggregations>  Where aggregation 
                           output will be written
    --debug                Print debug logging to stderr
    --verbose              Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
from collections import defaultdict
import mysqltsv
import sys
import re


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


    output_aggregations_file = mysqltsv.Writer(
        open(args['<output_aggregations>'], "w"), 
        headers=[
                 'year',
                 'month',
                 'bot_edit',
                 'quickstatements',
                 'petscan',
                 'autolist2',
                 'autoedit',
                 'labellister',
                 'itemcreator',
                 'dragrefjs',
                 'lcjs',
                 'wikidatagame',
                 'wikidataprimary',
                 'mixnmatch',
                 'distributedgame',
                 'nameguzzler',
                 'mergejs',
                 'reasonator',
                 'duplicity',
                 'tabernacle',
                 'Widar',
                 'reCh',
                 'HHVM',
                 'PAWS',
                 'Kaspar',
                 'itemFinder',
                 'rgCh',
                 'not_flagged_elsewhere_quickstatments_bot_account',
                 'other_semi_automated_edit_since_change_tag',
                 'anon_edit',
                 'human_edit',
                 'tool_bot_like_edit',
                 'human_bot_like_edit',
                 'anon_bot_like_edit'])




    verbose = args['--verbose']

    run(input_file, output_aggregations_file,
        verbose)


def run(input_file, output_aggregations_file,
        verbose):


    agg = \
        defaultdict(lambda: defaultdict(lambda: defaultdict(int)))


    for i, line in enumerate(input_file):


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Processing revision: {0}\n".format(i))  
            sys.stderr.flush()


        page_title = line[0]
        revision_id = line[1]
        revision_user = line[2]
        comment = line[3]
        namespace = line[4]
        revision_timestamp = line[5]
        year = line[6]
        month = line[7]
        bot_user_id = line[8]
        change_tag_revision_id = line[9]
        number_of_revisions = line[10]
        page_views = line[11]
        agent_type = line[12]
        year_month_page_title = line[13]
        bot_prediction_threshold = line[14]
        session_start = line[15]
        m_match_year = line[16]
        m_match_month = line[17]
        agent_anon_recall_level = line[18]
        reference_edit = line[19]
        sitelink_edit = line[20]
        l_d_or_a_edit = line[21]
        quality_class = line[22]
        views_class = line[23]


        # Filtering out unused entities
        if quality_class == '\\N':
            continue

        # Incrementing the agent type count
        agg[m_match_year][m_match_month][agent_type] += 1


        if not (agent_anon_recall_level == '\\N'):
            if agent_type == 'human_edit' and \
                (agent_anon_recall_level == 'anon_ten_recall_bot_edit' or \
                agent_anon_recall_level == 'anon_twenty_recall_bot_edit' or \
                agent_anon_recall_level == 'anon_thirty_recall_bot_edit'):

                agg[m_match_year][m_match_month]['human_bot_like_edit'] += 1

            elif agent_type == 'anon_edit' and \
                (agent_anon_recall_level == 'anon_ten_recall_bot_edit' or \
                agent_anon_recall_level == 'anon_twenty_recall_bot_edit' or \
                agent_anon_recall_level == 'anon_thirty_recall_bot_edit'):

                agg[m_match_year][m_match_month]['anon_bot_like_edit'] += 1

            elif agent_type != 'bot_edit' and \
                (agent_anon_recall_level == 'anon_ten_recall_bot_edit' or \
                agent_anon_recall_level == 'anon_twenty_recall_bot_edit' or \
                agent_anon_recall_level == 'anon_thirty_recall_bot_edit'):

                agg[m_match_year][m_match_month]['tool_bot_like_edit'] += 1


    for year in agg:
        for month in agg[year]:
            output_alignment_and_aggregations_file.write([
                year,
                month,
                agg[year][month]['bot_edit'],
                agg[year][month]['quickstatements'],
                agg[year][month]['petscan'],
                agg[year][month]['autolist2'],
                agg[year][month]['autoedit'],
                agg[year][month]['labellister'],
                agg[year][month]['itemcreator'],
                agg[year][month]['dragrefjs'],
                agg[year][month]['lcjs'],
                agg[year][month]['wikidatagame'],
                agg[year][month]['wikidataprimary'],
                agg[year][month]['mixnmatch'],
                agg[year][month]['distributedgame'],
                agg[year][month]['nameguzzler'],
                agg[year][month]['mergejs'],
                agg[year][month]['reasonator'],
                agg[year][month]['duplicity'],
                agg[year][month]['tabernacle'],
                agg[year][month]['Widar'],
                agg[year][month]['reCh'],
                agg[year][month]['HHVM'],
                agg[year][month]['PAWS'],
                agg[year][month]['Kaspar'],
                agg[year][month]['itemFinder'],
                agg[year][month]['rgCh'],
                agg[year][month]['not_flagged_elsewhere_quickstatments_bot_account'],
                agg[year][month]['other_semi_automated_edit_since_change_tag'],
                agg[year][month]['anon_edit'],
                agg[year][month]['human_edit'],
                agg[year][month]['tool_bot_like_edit'],
                agg[year][month]['human_bot_like_edit'],
                agg[year][month]['anon_bot_like_edit']])

 


main()

