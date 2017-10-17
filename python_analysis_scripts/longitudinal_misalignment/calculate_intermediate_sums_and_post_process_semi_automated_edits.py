"""
Post processing (subset of columns) to calculate intermediate sum edit counts 
and other variables. Date sorted input.

Usage:
    calculate_intermediate_sums (-h|--help)
    calculate_intermediate_sums <input> <output>
                                [--debug]
                                [--verbose]

Options:
    -h, --help  This help message is printed
    <input>     Path to file to process.
    <output>    Where revisions results
                will be written
    --debug     Print debug logging to stderr
    --verbose   Print dots and stuff to stderr  
"""


import docopt
import sys
import logging
import operator
from collections import defaultdict
import mysqltsv


logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_file = mysqltsv.Reader(open(args['<input>'], "r"), headers=True,
        types=[int, int, str, int])

    output_file = mysqltsv.Writer(open(args['<output>'], "w"), headers=[
        'yyyymm', 'quickstatements_edits', 'petscan_edits',
        'autolist2_edits', 'autoedit_edits', 'labellister_edits', 
        'itemcreator_edits',
        'dragrefjs_edits', 'lcjs_edits', 
        'wikidatagame_edits', 'wikidataprimary_edits',
        'mixnmatch_edits', 'distributedgame_edits', 'nameguzzler_edits', 
        'mergejs_edits'])

    verbose = args['--verbose']

    run(input_file, output_file, verbose)


def run(input_file, output_file, verbose):

    quickstatements_month_count = 0
    petscan_month_count = 0
    autolist2_month_count = 0
    autoedit_month_count = 0
    labellister_month_count = 0
    itemcreator_month_count = 0
    dragrefjs_month_count = 0
    lcjs_month_count = 0
    wikidatagame_month_count = 0
    wikidataprimary_month_count = 0
    mixnmatch_month_count = 0
    distributedgame_month_count = 0 
    nameguzzler_month_count = 0
    mergejs_month_count = 0


    previous_month = None
    previous_year = None

    for i, line in enumerate(input_file):

        
        year = line[0]
        month = line[1]
        year_month = str(year) + str(month).zfill(2)
        semi_automated_edit_type = line[2]
        semi_automated_edit_type_count = line[3]

        if month != previous_month and year != previous_year and previous_month != None:

            output_file.write([year_and_month,
                               quickstatements_month_count,
                               petscan_month_count,
                               autolist2_month_count, 
                               autoedit_month_count,
                               labellister_month_count,
                               itemcreator_month_count,
                               dragrefjs_month_count,
                               lcjs_month_count,
                               wikidatagame_month_count,
                               wikidataprimary_month_count,
                               mixnmatch_month_count,
                               distributedgame_month_count,
                               nameguzzler_month_count,
                               mergejs_month_count
                              ])




            quickstatements_month_count = 0
            petscan_month_count = 0
            autolist2_month_count = 0
            autoedit_month_count = 0
            labellister_month_count = 0
            itemcreator_month_count = 0
            dragrefjs_month_count = 0
            lcjs_month_count = 0
            wikidatagame_month_count = 0
            wikidataprimary_month_count = 0
            mixnmatch_month_count = 0
            distributedgame_month_count = 0 
            nameguzzler_month_count = 0
            mergejs_month_count = 0



        if semi_automated_edit_type == 'quickstatements':
            quickstatements_month_count = semi_automated_edit_type
        elif semi_automated_edit_type == 'petscan':
            petscan_month_count = semi_automated_edit_type
        elif semi_automated_edit_type == 'autolist2':
            autolist2_month_count = semi_automated_edit_type
        elif semi_automated_edit_type == 'autoedit':
            autoedit_month_count = semi_automated_edit_type
        elif semi_automated_edit_type == 'labellister':
            labellister_month_count = semi_automated_edit_type
        elif semi_automated_edit_type == 'itemcreator':
            itemcreator_month_count = semi_automated_edit_type
        elif semi_automated_edit_type == 'dragrefjs':
            dragrefjs_month_count = semi_automated_edit_type
        elif semi_automated_edit_type == 'lcjs':
            lcjs_month_count = semi_automated_edit_type
        elif semi_automated_edit_type == 'wikidatagame':
            wikidatagame_month_count = semi_automated_edit_type
        elif semi_automated_edit_type == 'wikidataprimary':
            wikidataprimary_month_count = semi_automated_edit_type
        elif semi_automated_edit_type == 'mixnmatch':
            mixnmatch_month_count = semi_automated_edit_type
        elif semi_automated_edit_type == 'distributedgame':
            distributedgame_month_count = semi_automated_edit_type
        elif semi_automated_edit_type == 'nameguzzler':
            nameguzzler_month_count = semi_automated_edit_type
        elif semi_automated_edit_type == 'mergejs':
            mergejs_month_count = semi_automated_edit_type
        else:
            raise RuntimeError("Semi automated edit type \'{0}\' not matched".format())



        previous_month = month


main()

