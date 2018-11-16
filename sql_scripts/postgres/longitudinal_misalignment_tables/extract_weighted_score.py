"""
Extracts weighted_score from json returned from ores.
Returns in tsv format.

Usage:
    extract_weighted_score (-h|--help)
    extract_weighted_score <input> <output_first_month> <output_second_month> <output_third_month> <output_fourth_month> <output_fifth_month> <output_sixth_month> <output_seventh_month> <output_eighth_month> <output_ninth_month> <output_tenth_month> <output_eleventh_month> <output_twelfth_month>
                           [--debug]
                           [--verbose]

Options:
    -h, --help               This help message is printed
    <input>                  Path to edit file to process.
    <output_first_month>     Where month output will be written
    <output_second_month>    Where month output will be written
    <output_third_month>     Where month output will be written
    <output_fourth_month>    Where month output will be written
    <output_fifth_month>     Where month output will be written
    <output_sixth_month>     Where month output will be written
    <output_seventh_month>   Where month output will be written
    <output_eighth_month>    Where month output will be written
    <output_ninth_month>     Where month output will be written
    <output_tenth_month>     Where month output will be written
    <output_eleventh_month>  Where month output will be written
    <output_twelfth_month>   Where month output will be written
    --debug                  Print debug logging to stderr
    --verbose                Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
import mysqltsv
import sys
import re
import json


logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_file = open(args['<input>'])


    output_first_month_file = mysqltsv.Writer(
        open(args['<output_first_month>'], "w"), 
        headers=[
                 'namespace',
                 'page_title',
                 'edit_type',
                 'agent_type',
                 'page_views',
                 'rev_id',
                 'weighted_sum',
                 'misalignment_year',
                 'misalignment_month'])

    output_second_month_file = mysqltsv.Writer(
        open(args['<output_second_month>'], "w"), 
        headers=[
                 'namespace',
                 'page_title',
                 'edit_type',
                 'agent_type',
                 'page_views',
                 'rev_id',
                 'weighted_sum',
                 'misalignment_year',
                 'misalignment_month'])

    output_third_month_file = mysqltsv.Writer(
        open(args['<output_third_month>'], "w"), 
        headers=[
                 'namespace',
                 'page_title',
                 'edit_type',
                 'agent_type',
                 'page_views',
                 'rev_id',
                 'weighted_sum',
                 'misalignment_year',
                 'misalignment_month'])

    output_fourth_month_file = mysqltsv.Writer(
        open(args['<output_fourth_month>'], "w"), 
        headers=[
                 'namespace',
                 'page_title',
                 'edit_type',
                 'agent_type',
                 'page_views',
                 'rev_id',
                 'weighted_sum',
                 'misalignment_year',
                 'misalignment_month'])

    output_fifth_month_file = mysqltsv.Writer(
        open(args['<output_fifth_month>'], "w"), 
        headers=[
                 'namespace',
                 'page_title',
                 'edit_type',
                 'agent_type',
                 'page_views',
                 'rev_id',
                 'weighted_sum',
                 'misalignment_year',
                 'misalignment_month'])

    output_sixth_month_file = mysqltsv.Writer(
        open(args['<output_sixth_month>'], "w"), 
        headers=[
                 'namespace',
                 'page_title',
                 'edit_type',
                 'agent_type',
                 'page_views',
                 'rev_id',
                 'weighted_sum',
                 'misalignment_year',
                 'misalignment_month'])

    output_seventh_month_file = mysqltsv.Writer(
        open(args['<output_seventh_month>'], "w"), 
        headers=[
                 'namespace',
                 'page_title',
                 'edit_type',
                 'agent_type',
                 'page_views',
                 'rev_id',
                 'weighted_sum',
                 'misalignment_year',
                 'misalignment_month'])

    output_eighth_month_file = mysqltsv.Writer(
        open(args['<output_eighth_month>'], "w"), 
        headers=[
                 'namespace',
                 'page_title',
                 'edit_type',
                 'agent_type',
                 'page_views',
                 'rev_id',
                 'weighted_sum',
                 'misalignment_year',
                 'misalignment_month'])

    output_ninth_month_file = mysqltsv.Writer(
        open(args['<output_ninth_month>'], "w"), 
        headers=[
                 'namespace',
                 'page_title',
                 'edit_type',
                 'agent_type',
                 'page_views',
                 'rev_id',
                 'weighted_sum',
                 'misalignment_year',
                 'misalignment_month'])

    output_tenth_month_file = mysqltsv.Writer(
        open(args['<output_tenth_month>'], "w"), 
        headers=[
                 'namespace',
                 'page_title',
                 'edit_type',
                 'agent_type',
                 'page_views',
                 'rev_id',
                 'weighted_sum',
                 'misalignment_year',
                 'misalignment_month'])

    output_eleventh_month_file = mysqltsv.Writer(
        open(args['<output_eleventh_month>'], "w"), 
        headers=[
                 'namespace',
                 'page_title',
                 'edit_type',
                 'agent_type',
                 'page_views',
                 'rev_id',
                 'weighted_sum',
                 'misalignment_year',
                 'misalignment_month'])

    output_twelfth_month_file = mysqltsv.Writer(
        open(args['<output_twelfth_month>'], "w"), 
        headers=[
                 'namespace',
                 'page_title',
                 'edit_type',
                 'agent_type',
                 'page_views',
                 'rev_id',
                 'weighted_sum',
                 'misalignment_year',
                 'misalignment_month'])

    verbose = args['--verbose']

    run(input_file, output_first_month_file, output_second_month_file,
        output_third_month_file, output_fourth_month_file,
        output_fifth_month_file, output_sixth_month_file,
        output_seventh_month_file, output_eighth_month_file,
        output_ninth_month_file, output_tenth_month_file,
        output_eleventh_month_file, output_twelfth_month_file, verbose)


def run(input_file, output_first_month_file, output_second_month_file,
        output_third_month_file, output_fourth_month_file,
        output_fifth_month_file, output_sixth_month_file,
        output_seventh_month_file, output_eighth_month_file,
        output_ninth_month_file, output_tenth_month_file,
        output_eleventh_month_file, output_twelfth_month_file, verbose):


    for i, line in enumerate(input_file):


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Processing revision: {0}\n".format(i))  
            sys.stderr.flush()


        json_line = json.loads(line)
        if 'error' in json_line['score']['itemquality']:
            continue
        probabilities = \
            json_line['score']['itemquality']['score']['probability']
        weighted_sum = (probabilities['E'] * 0 + probabilities['D'] * 1 + \
            probabilities['C'] * 2 + probabilities['B'] * 3 + \
            probabilities['A'] * 4) + 1 
        output_edit_type = None
        output_agent_type = None

        if json_line['misalignment_month'] == 6:
            output_first_month_file.write([
                json_line['namespace'],
                json_line['page_title'],
                json_line['edit_type'],
                json_line['agent_type'],
                json_line['page_views'],
                json_line['rev_id'],
                weighted_sum,
                json_line['misalignment_year'],
                json_line['misalignment_month']])
        elif json_line['misalignment_month'] == 7:
            output_second_month_file.write([
                json_line['namespace'],
                json_line['page_title'],
                json_line['edit_type'],
                json_line['agent_type'],
                json_line['page_views'],
                json_line['rev_id'],
                weighted_sum,
                json_line['misalignment_year'],
                json_line['misalignment_month']])
        elif json_line['misalignment_month'] == 8:
            output_third_month_file.write([
                json_line['namespace'],
                json_line['page_title'],
                json_line['edit_type'],
                json_line['agent_type'],
                json_line['page_views'],
                json_line['rev_id'],
                weighted_sum,
                json_line['misalignment_year'],
                json_line['misalignment_month']])
        elif json_line['misalignment_month'] == 9:
            output_fourth_month_file.write([
                json_line['namespace'],
                json_line['page_title'],
                json_line['edit_type'],
                json_line['agent_type'],
                json_line['page_views'],
                json_line['rev_id'],
                weighted_sum,
                json_line['misalignment_year'],
                json_line['misalignment_month']])
        elif json_line['misalignment_month'] == 10:
            output_fifth_month_file.write([
                json_line['namespace'],
                json_line['page_title'],
                json_line['edit_type'],
                json_line['agent_type'],
                json_line['page_views'],
                json_line['rev_id'],
                weighted_sum,
                json_line['misalignment_year'],
                json_line['misalignment_month']])
        elif json_line['misalignment_month'] == 11:
            output_sixth_month_file.write([
                json_line['namespace'],
                json_line['page_title'],
                json_line['edit_type'],
                json_line['agent_type'],
                json_line['page_views'],
                json_line['rev_id'],
                weighted_sum,
                json_line['misalignment_year'],
                json_line['misalignment_month']])
        elif json_line['misalignment_month'] == 12:
            output_seventh_month_file.write([
                json_line['namespace'],
                json_line['page_title'],
                json_line['edit_type'],
                json_line['agent_type'],
                json_line['page_views'],
                json_line['rev_id'],
                weighted_sum,
                json_line['misalignment_year'],
                json_line['misalignment_month']])
        elif json_line['misalignment_month'] == 1:
            output_eighth_month_file.write([
                json_line['namespace'],
                json_line['page_title'],
                json_line['edit_type'],
                json_line['agent_type'],
                json_line['page_views'],
                json_line['rev_id'],
                weighted_sum,
                json_line['misalignment_year'],
                json_line['misalignment_month']])
        elif json_line['misalignment_month'] == 2:
            output_ninth_month_file.write([
                json_line['namespace'],
                json_line['page_title'],
                json_line['edit_type'],
                json_line['agent_type'],
                json_line['page_views'],
                json_line['rev_id'],
                weighted_sum,
                json_line['misalignment_year'],
                json_line['misalignment_month']])
        elif json_line['misalignment_month'] == 3:
            output_tenth_month_file.write([
                json_line['namespace'],
                json_line['page_title'],
                json_line['edit_type'],
                json_line['agent_type'],
                json_line['page_views'],
                json_line['rev_id'],
                weighted_sum,
                json_line['misalignment_year'],
                json_line['misalignment_month']])
        elif json_line['misalignment_month'] == 4:
            output_eleventh_month_file.write([
                json_line['namespace'],
                json_line['page_title'],
                json_line['edit_type'],
                json_line['agent_type'],
                json_line['page_views'],
                json_line['rev_id'],
                weighted_sum,
                json_line['misalignment_year'],
                json_line['misalignment_month']])
        elif json_line['misalignment_month'] == 5:
            output_twelfth_month_file.write([
                json_line['namespace'],
                json_line['page_title'],
                json_line['edit_type'],
                json_line['agent_type'],
                json_line['page_views'],
                json_line['rev_id'],
                weighted_sum,
                json_line['misalignment_year'],
                json_line['misalignment_month']])


main()

