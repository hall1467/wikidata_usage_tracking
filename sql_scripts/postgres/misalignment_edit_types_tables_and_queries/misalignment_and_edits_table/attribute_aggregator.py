"""
Aggregates various attributes of misalignment and edit data by month.

Usage:
    attribute_aggregator (-h|--help)
    attribute_aggregator <input> <output_alignment_and_aggregations> <output_views_and_quality_class_edit_types> <output_views_class_edit_types> <output_quality_class_edit_types>
                         [--debug]
                         [--verbose]

Options:
    -h, --help                                   This help message is printed
    <input>                                      Path to misalignment/edit
                                                 breakdown file to process.
    <output_alignment_and_aggregations>          Where alignment and aggregation 
                                                 output will be written
    <output_views_and_quality_class_edit_types>  Where views and quality class
                                                 edit types will be written
    <output_views_class_edit_types>              Where views class edit types
                                                 will be written
    <output_quality_class_edit_types>            Where quality class edit types
                                                 will be written
    --debug                                      Print debug logging to stderr
    --verbose                                    Print dots and stuff to stderr  
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


    output_alignment_and_aggregations_file = mysqltsv.Writer(
        open(args['<output_alignment_and_aggregations>'], "w"), 
        headers=[
                 'year',
                 'month',
                 'alignment_percentage',
                 'bot_edit',
                 'semi_automated_edit',
                 'human_edit',
                 'anon_edit',
                 'semi_automated_bot_like_edit',
                 'human_bot_like_edit',
                 'anon_bot_like_edit'])


    output_views_and_quality_class_edit_types_file = mysqltsv.Writer(
        open(args['<output_views_and_quality_class_edit_types>'], "w"), 
        headers=[
                 'views_class',
                 'quality_class',
                 'bot_edit',
                 'semi_automated_edit',
                 'human_edit',
                 'anon_edit'])


    output_views_class_edit_types_file = mysqltsv.Writer(
        open(args['<output_views_class_edit_types>'], "w"), 
        headers=[
                 'views_class',
                 'bot_edit',
                 'semi_automated_edit',
                 'human_edit',
                 'anon_edit'])


    output_quality_class_edit_types_file = mysqltsv.Writer(
        open(args['<output_quality_class_edit_types>'], "w"), 
        headers=[
                 'quality_class',
                 'bot_edit',
                 'semi_automated_edit',
                 'human_edit',
                 'anon_edit'])


    verbose = args['--verbose']

    run(input_file, output_alignment_and_aggregations_file, 
        output_views_and_quality_class_edit_types_file,
        output_views_class_edit_types_file,
        output_quality_class_edit_types_file,
        verbose)


def run(input_file, output_alignment_and_aggregations_file, 
        output_views_and_quality_class_edit_types_file,
        output_views_class_edit_types_file,
        output_quality_class_edit_types_file, verbose):


    agg = \
        defaultdict(lambda: defaultdict(lambda: defaultdict(int)))
    align = \
        defaultdict(lambda: defaultdict(
            lambda: defaultdict(lambda: defaultdict(lambda: defaultdict(int)))))
    v_and_q_class_edits = \
        defaultdict(lambda: defaultdict(lambda: defaultdict(int)))
    v_class_edits = defaultdict(lambda: defaultdict(int))
    q_class_edits = defaultdict(lambda: defaultdict(int))


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

        # Also, filtering out sitelink edits
        if namespace == "0" and comment and \
            EDIT_KIND_RE.match(comment) and \
            EDIT_KIND_RE.match(comment).group(3) == 'sitelink':
            continue

        # Incrementing the agent type count
        if agent_type == 'bot_edit' or agent_type == 'human_edit' or \
            agent_type == 'anon_edit':

            agg[m_match_year][m_match_month][agent_type] += 1
        else:
            agg[m_match_year][m_match_month]['semi_automated_edit'] += 1


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



        # Calculating Alignment

        n_and_title = namespace + page_title
            
        if quality_class == views_class:
            align[m_match_year][m_match_month]['aligned'][n_and_title] = 1
        else:
            align[m_match_year][m_match_month]['misaligned'][n_and_title] = 1


        # Update views and quality class edit counts
        v_and_q_class_edits[views_class][quality_class][agent_type]\
            += 1
        v_class_edits[views_class][agent_type] += 1
        q_class_edits[quality_class][agent_type] += 1


    for year in agg:
        for month in agg[year]:
            output_alignment_and_aggregations_file.write([
                year,
                month,
                len(align[year][month]['aligned'])/
                    (len(align[year][month]['aligned']) + 
                    len(align[year][month]['misaligned'])),
                agg[year][month]['bot_edit'],
                agg[year][month]['semi_automated_edit'],
                agg[year][month]['human_edit'],
                agg[year][month]['anon_edit'],
                agg[year][month]['tool_bot_like_edit'],
                agg[year][month]['human_bot_like_edit'],
                agg[year][month]['anon_bot_like_edit']])


    for v_class in v_and_q_class_edits:
        for q_class in v_and_q_class_edits[v_class]:
            output_views_and_quality_class_edit_types_file.write([
                v_class,
                q_class,
                v_and_q_class_edits[v_class][q_class]['bot_edit'],
                v_and_q_class_edits[v_class][q_class]['semi_automated_edit'],
                v_and_q_class_edits[v_class][q_class]['human_edit'],
                v_and_q_class_edits[v_class][q_class]['anon_edit']])


    for v_class in v_class_edits:
        output_views_class_edit_types_file.write([
            v_class,
            v_class_edits[v_class]['bot_edit'],
            v_class_edits[v_class]['semi_automated_edit'],
            v_class_edits[v_class]['human_edit'],
            v_class_edits[v_class]['anon_edit']])


    for q_class in q_class_edits:
        output_quality_class_edit_types_file.write([
            q_class,
            q_class_edits[q_class]['bot_edit'],
            q_class_edits[q_class]['semi_automated_edit'],
            q_class_edits[q_class]['human_edit'],
            q_class_edits[q_class]['anon_edit']]) 


main()

