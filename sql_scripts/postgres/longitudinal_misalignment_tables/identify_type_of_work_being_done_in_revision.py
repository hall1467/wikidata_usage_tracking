"""
Splits into months. Also checks that revisions are from
namespace 0. Note, already filtered upstream in recent changes.

Usage:
    identify_type_of_work_being_done_in_revision (-h|--help)
    identify_type_of_work_being_done_in_revision <input_original> <input_sample> <output>
                                                 [--debug]
                                                 [--verbose]

Options:
    -h, --help        This help message is printed
    <input_original>  Path to original editted file with comments
    <input_sample>    Path to sampled file
    <output>          Where month output will be written
    --debug           Print debug logging to stderr
    --verbose         Print dots and stuff to stderr  
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



    input_original_file = mysqltsv.Reader(open(args['<input_original>'],
        'rt', encoding='utf-8', errors='replace'), headers=False,
        types=[int, int, int, str, str, int, int, str, int, int, str, str, str])

    input_sample_file = mysqltsv.Reader(open(args['<input_sample>'],
        'rt', encoding='utf-8', errors='replace'), headers=True,
        types=[int, str, str, int, int, int, int, int, str, str, str, str, str, 
            str])

    output_file = mysqltsv.Writer(
        open(args['<output>'], "w"), 
        headers=[
                 'namespace',
                 'page_title',
                 'edit_type',
                 'page_views',
                 'rev_id',
                 'misalignment_year',
                 'misalignment_month',
                 'period',
                 'gender',
                 'coordinate_location',
                 'us_location',
                 'does_parent_exist',
                 'parent_weighted_sum',
                 'parent_id'])

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


        edit_month = line['misalignment_month']
        
        if line['namespace'] == 0:

            if edit_month == 6:
                output_first_month_file.write([
                    line['namespace'],
                    line['page_title'],
                    line['edit_type'],
                    line['page_views'],
                    line['rev_id'],
                    line['misalignment_year'],
                    line['misalignment_month'],
                    line['period'],
                    line['gender'],
                    line['coordinate_location'],
                    line['us_location'],
                    line['does_parent_exist'],
                    line['parent_weighted_sum'],
                    line['parent_id']])
            elif edit_month == 7:
                output_second_month_file.write([
                    line['namespace'],
                    line['page_title'],
                    line['edit_type'],
                    line['page_views'],
                    line['rev_id'],
                    line['misalignment_year'],
                    line['misalignment_month'],
                    line['period'],
                    line['gender'],
                    line['coordinate_location'],
                    line['us_location'],
                    line['does_parent_exist'],
                    line['parent_weighted_sum'],
                    line['parent_id']])
            elif edit_month == 8:
                output_third_month_file.write([
                    line['namespace'],
                    line['page_title'],
                    line['edit_type'],
                    line['page_views'],
                    line['rev_id'],
                    line['misalignment_year'],
                    line['misalignment_month'],
                    line['period'],
                    line['gender'],
                    line['coordinate_location'],
                    line['us_location'],
                    line['does_parent_exist'],
                    line['parent_weighted_sum'],
                    line['parent_id']])
            elif edit_month == 9:
                output_fourth_month_file.write([
                    line['namespace'],
                    line['page_title'],
                    line['edit_type'],
                    line['page_views'],
                    line['rev_id'],
                    line['misalignment_year'],
                    line['misalignment_month'],
                    line['period'],
                    line['gender'],
                    line['coordinate_location'],
                    line['us_location'],
                    line['does_parent_exist'],
                    line['parent_weighted_sum'],
                    line['parent_id']])
            elif edit_month == 10:
                output_fifth_month_file.write([
                    line['namespace'],
                    line['page_title'],
                    line['edit_type'],
                    line['page_views'],
                    line['rev_id'],
                    line['misalignment_year'],
                    line['misalignment_month'],
                    line['period'],
                    line['gender'],
                    line['coordinate_location'],
                    line['us_location'],
                    line['does_parent_exist'],
                    line['parent_weighted_sum'],
                    line['parent_id']])
            elif edit_month == 11:
                output_sixth_month_file.write([
                    line['namespace'],
                    line['page_title'],
                    line['edit_type'],
                    line['page_views'],
                    line['rev_id'],
                    line['misalignment_year'],
                    line['misalignment_month'],
                    line['period'],
                    line['gender'],
                    line['coordinate_location'],
                    line['us_location'],
                    line['does_parent_exist'],
                    line['parent_weighted_sum'],
                    line['parent_id']])
            elif edit_month == 12:
                output_seventh_month_file.write([
                    line['namespace'],
                    line['page_title'],
                    line['edit_type'],
                    line['page_views'],
                    line['rev_id'],
                    line['misalignment_year'],
                    line['misalignment_month'],
                    line['period'],
                    line['gender'],
                    line['coordinate_location'],
                    line['us_location'],
                    line['does_parent_exist'],
                    line['parent_weighted_sum'],
                    line['parent_id']])
            elif edit_month == 1:
                output_eighth_month_file.write([
                    line['namespace'],
                    line['page_title'],
                    line['edit_type'],
                    line['page_views'],
                    line['rev_id'],
                    line['misalignment_year'],
                    line['misalignment_month'],
                    line['period'],
                    line['gender'],
                    line['coordinate_location'],
                    line['us_location'],
                    line['does_parent_exist'],
                    line['parent_weighted_sum'],
                    line['parent_id']])
            elif edit_month == 2:
                output_ninth_month_file.write([
                    line['namespace'],
                    line['page_title'],
                    line['edit_type'],
                    line['page_views'],
                    line['rev_id'],
                    line['misalignment_year'],
                    line['misalignment_month'],
                    line['period'],
                    line['gender'],
                    line['coordinate_location'],
                    line['us_location'],
                    line['does_parent_exist'],
                    line['parent_weighted_sum'],
                    line['parent_id']])
            elif edit_month == 3:
                output_tenth_month_file.write([
                    line['namespace'],
                    line['page_title'],
                    line['edit_type'],
                    line['page_views'],
                    line['rev_id'],
                    line['misalignment_year'],
                    line['misalignment_month'],
                    line['period'],
                    line['gender'],
                    line['coordinate_location'],
                    line['us_location'],
                    line['does_parent_exist'],
                    line['parent_weighted_sum'],
                    line['parent_id']])
            elif edit_month == 4:
                output_eleventh_month_file.write([
                    line['namespace'],
                    line['page_title'],
                    line['edit_type'],
                    line['page_views'],
                    line['rev_id'],
                    line['misalignment_year'],
                    line['misalignment_month'],
                    line['period'],
                    line['gender'],
                    line['coordinate_location'],
                    line['us_location'],
                    line['does_parent_exist'],
                    line['parent_weighted_sum'],
                    line['parent_id']])
            elif edit_month == 5:
                output_twelfth_month_file.write([
                    line['namespace'],
                    line['page_title'],
                    line['edit_type'],
                    line['page_views'],
                    line['rev_id'],
                    line['misalignment_year'],
                    line['misalignment_month'],
                    line['period'],
                    line['gender'],
                    line['coordinate_location'],
                    line['us_location'],
                    line['does_parent_exist'],
                    line['parent_weighted_sum'],
                    line['parent_id']])


main()

