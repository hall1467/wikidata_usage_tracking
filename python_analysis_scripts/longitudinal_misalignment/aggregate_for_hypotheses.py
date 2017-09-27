"""
Aggregate misalignment and edit data for hypotheses. Data is sorted by
month

Usage:
    aggregate_for_hypotheses (-h|--help)
    aggregate_for_hypotheses <input> <hypothesis_1_output> <hypothesis_2_output> <hypothesis_3_output>
                             [--debug]
                             [--verbose]

Options:
    -h, --help             This help message is printed
    <input>                Path to misalignment/edit breakdown file to process.
    <hypothesis_1_output>  Where hypothesis 1 counts will be written
    <hypothesis_2_output>  Where hypothesis 2 counts will be written
    <hypothesis_3_output>  Where hypothesis 3 counts will be written
    --debug                Print debug logging to stderr
    --verbose              Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
from collections import defaultdict
import mysqltsv
import bz2
from collections import defaultdict
import sys


logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_file = mysqltsv.Reader(bz2.open(args['<input>'],
        'rt', encoding='utf-8', errors='replace'), headers=False,
        types=[str, int, int, str, str, int, int, int, int, int])


    hypothesis_1_output_file = mysqltsv.Writer(
        open(args['<hypothesis_1_output>'], "w"), 
        headers=[
                 'file_date', 
                 'misaligned_bot_edits',
                 'misaligned_semi_automated_edits',
                 'misaligned_non_bot_edits', 
                 'misaligned_anon_edits', 
                 'aligned_bot_edits',
                 'aligned_semi_automated_edits',
                 'aligned_non_bot_edits',
                 'aligned_anon_edits'])

    hypothesis_2_output_file = mysqltsv.Writer(
        open(args['<hypothesis_2_output>'], "w"), 
        headers=[
                 'file_date', 
                 'lower_quality_bot_edits',
                 'lower_quality_semi_automated_edits'
                 'lower_quality_non_bot_edits',
                 'lower_quality_anon_edits',
                 'higher_quality_bot_edits',
                 'higher_quality_semi_automated_edits',
                 'higher_quality_non_bot_edits',
                 'higher_quality_anon_edits'])

    hypothesis_3_output_file = mysqltsv.Writer(
        open(args['<hypothesis_3_output>'], "w"), 
        headers=[
                 'file_date', 
                 'lower_quality_bot_edits',
                 'lower_quality_semi_automated_edits',
                 'lower_quality_non_bot_edits',
                 'lower_quality_anon_edits',
                 'higher_quality_bot_edits',
                 'higher_quality_semi_automated_edits',  
                 'higher_quality_non_bot_edits',
                 'higher_quality_anon_edits'])

    verbose = args['--verbose']

    run(input_file, hypothesis_1_output_file, 
        hypothesis_2_output_file, hypothesis_3_output_file, verbose)


def run(input_file, hypothesis_1_output_file, 
    hypothesis_2_output_file, hypothesis_3_output_file, verbose):

    hypotheses = defaultdict(lambda: defaultdict(lambda: defaultdict(lambda: defaultdict(int))))

    for i, line in enumerate(input_file):


        date = str(line[1]) + str(line[2]).zfill(2)
        qual = line[3]
        views = line[4]
        bot_edits = line[5]
        semi_automated_edits = line[6]
        non_bot_edits = line[7]
        anon_edits = line[8]

        # Hypothesis 1
        # Misaligned
        if (qual == 'D' and views == 'E') or\
            (qual == 'C' and views == 'E') or\
            (qual == 'C' and views == 'D'):

            hypotheses["one"][date]["ma"]["bot_edits"] += bot_edits
            hypotheses["one"][date]["ma"]["semi_automated_edits"]\
                += semi_automated_edits

            hypotheses["one"][date]["ma"]["non_bot_edits"] += non_bot_edits
            hypotheses["one"][date]["ma"]["anon_edits"] += anon_edits
    
        # Aligned
        if (qual == 'E' and views == 'E') or\
            (qual == 'D' and views == 'D'):

            hypotheses["one"][date]["a"]["bot_edits"] += bot_edits
            hypotheses["one"][date]["a"]["semi_automated_edits"]\
                += semi_automated_edits

            hypotheses["one"][date]["a"]["non_bot_edits"] += non_bot_edits
            hypotheses["one"][date]["a"]["anon_edits"] += anon_edits

        # Hypothesis 2
        # Lower quality aligned
        if (qual == 'E' and views == 'E') or\
            (qual == 'D' and views == 'D') or\
            (qual == 'C' and views == 'C'):

            hypotheses["two"][date]["lq"]["bot_edits"] += bot_edits
            hypotheses["two"][date]["lq"]["semi_automated_edits"]\
                += semi_automated_edits

            hypotheses["two"][date]["lq"]["non_bot_edits"] += non_bot_edits
            hypotheses["two"][date]["lq"]["anon_edits"] += anon_edits

        # Higher quality aligned
        if (qual == 'B' and views == 'B') or\
            (qual == 'A' and views == 'A'):

            hypotheses["two"][date]["hq"]["bot_edits"] += bot_edits
            hypotheses["two"][date]["hq"]["semi_automated_edits"]\
                += semi_automated_edits
            
            hypotheses["two"][date]["hq"]["non_bot_edits"] += non_bot_edits
            hypotheses["two"][date]["hq"]["anon_edits"] += anon_edits

        # Hypothesis 3
        # Lower quality aligned
        if (qual == 'E' and views != 'E') or\
            (qual == 'D' and views != 'D') or\
            (qual == 'C' and views != 'C'):

            hypotheses["three"][date]["lq"]["bot_edits"] += bot_edits
            hypotheses["three"][date]["lq"]["semi_automated_edits"]\
                += semi_automated_edits

            hypotheses["three"][date]["lq"]["non_bot_edits"] += non_bot_edits
            hypotheses["three"][date]["lq"]["anon_edits"] += anon_edits

        # Higher quality aligned
        if (qual == 'B' and views != 'B') or\
            (qual == 'A' and views != 'A'):

            hypotheses["three"][date]["hq"]["bot_edits"] += bot_edits
            hypotheses["three"][date]["hq"]["semi_automated_edits"]\
                += semi_automated_edits

            hypotheses["three"][date]["hq"]["non_bot_edits"] += non_bot_edits
            hypotheses["three"][date]["hq"]["anon_edits"] += anon_edits


 
        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Entity-months processed: {0}\n".format(i))  
            sys.stderr.flush()


    for hypothesis in hypotheses:
        for date in hypotheses[hypothesis]:

            if hypothesis == "one":
                hypothesis_1_output_file.write([
                    date,
                    hypotheses[hypothesis][date]["ma"]["bot_edits"],
                    hypotheses[hypothesis][date]["ma"]["semi_automated_edits"],
                    hypotheses[hypothesis][date]["ma"]["non_bot_edits"],
                    hypotheses[hypothesis][date]["ma"]["anon_edits"],
                    hypotheses[hypothesis][date]["a"]["bot_edits"],
                    hypotheses[hypothesis][date]["a"]["semi_automated_edits"],
                    hypotheses[hypothesis][date]["a"]["non_bot_edits"],
                    hypotheses[hypothesis][date]["a"]["anon_edits"]])

            if hypothesis == "two":
                hypothesis_2_output_file.write([
                    date,
                    hypotheses[hypothesis][date]["lq"]["bot_edits"],
                    hypotheses[hypothesis][date]["lq"]["semi_automated_edits"],
                    hypotheses[hypothesis][date]["lq"]["non_bot_edits"],
                    hypotheses[hypothesis][date]["lq"]["anon_edits"],
                    hypotheses[hypothesis][date]["hq"]["bot_edits"],
                    hypotheses[hypothesis][date]["hq"]["semi_automated_edits"]
                    hypotheses[hypothesis][date]["hq"]["non_bot_edits"],
                    hypotheses[hypothesis][date]["hq"]["anon_edits"]])

            if hypothesis == "three":
                hypothesis_3_output_file.write([
                    date,
                    hypotheses[hypothesis][date]["lq"]["bot_edits"],
                    hypotheses[hypothesis][date]["lq"]["semi_automated_edits"],
                    hypotheses[hypothesis][date]["lq"]["non_bot_edits"],
                    hypotheses[hypothesis][date]["lq"]["anon_edits"],
                    hypotheses[hypothesis][date]["hq"]["bot_edits"],
                    hypotheses[hypothesis][date]["hq"]["semi_automated_edits"],
                    hypotheses[hypothesis][date]["hq"]["non_bot_edits"],
                    hypotheses[hypothesis][date]["hq"]["anon_edits"]])



main()

