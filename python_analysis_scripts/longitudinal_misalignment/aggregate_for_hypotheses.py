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
        headers=['file_date', 'misaligned_automated_edits',
        'misaligned_human_edits', 'aligned_automated_edits', 
        'aligned_human_edits'])

    hypothesis_2_output_file = mysqltsv.Writer(
        open(args['<hypothesis_2_output>'], "w"), 
        headers=['file_date', 'lower_quality_automated_edits',
        'lower_quality_human_edits', 'higher_quality_automated_edits', 
        'higher_quality_human_edits'])

    hypothesis_3_output_file = mysqltsv.Writer(
        open(args['<hypothesis_3_output>'], "w"), 
        headers=['file_date', 'lower_quality_automated_edits',
        'lower_quality_human_edits', 'higher_quality_automated_edits', 
        'higher_quality_human_edits'])

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

            hypotheses["one"][date]["ma"]["automated_edits"] += bot_edits
            hypotheses["one"][date]["ma"]["automated_edits"]\
                += semi_automated_edits

            hypotheses["one"][date]["ma"]["human_edits"] += non_bot_edits
            hypotheses["one"][date]["ma"]["human_edits"] += anon_edits
    
        # Aligned
        if (qual == 'E' and views == 'E') or\
            (qual == 'D' and views == 'D'):

            hypotheses["one"][date]["a"]["automated_edits"] += bot_edits
            hypotheses["one"][date]["a"]["automated_edits"]\
                += semi_automated_edits

            hypotheses["one"][date]["a"]["human_edits"] += non_bot_edits
            hypotheses["one"][date]["a"]["human_edits"] += anon_edits

        # Hypothesis 2
        # Lower quality aligned
        if (qual == 'E' and views == 'E') or\
            (qual == 'D' and views == 'D') or\
            (qual == 'C' and views == 'C'):

            hypotheses["two"][date]["lq"]["automated_edits"] += bot_edits
            hypotheses["two"][date]["lq"]["automated_edits"]\
                += semi_automated_edits

            hypotheses["two"][date]["lq"]["human_edits"] += non_bot_edits
            hypotheses["two"][date]["lq"]["human_edits"] += anon_edits

        # Higher quality aligned
        if (qual == 'B' and views == 'B') or\
            (qual == 'A' and views == 'A'):

            hypotheses["two"][date]["hq"]["automated_edits"] += bot_edits
            hypotheses["two"][date]["hq"]["automated_edits"]\
                += semi_automated_edits
            
            hypotheses["two"][date]["hq"]["human_edits"] += non_bot_edits
            hypotheses["two"][date]["hq"]["human_edits"] += anon_edits

        # Hypothesis 3
        # Lower quality aligned
        if (qual == 'E' and views != 'E') or\
            (qual == 'D' and views != 'D') or\
            (qual == 'C' and views != 'C'):

            hypotheses["three"][date]["lq"]["automated_edits"] += bot_edits
            hypotheses["three"][date]["lq"]["automated_edits"]\
                += semi_automated_edits

            hypotheses["three"][date]["lq"]["human_edits"] += non_bot_edits
            hypotheses["three"][date]["lq"]["human_edits"] += anon_edits

        # Higher quality aligned
        if (qual == 'B' and views != 'B') or\
            (qual == 'A' and views != 'A'):

            hypotheses["three"][date]["hq"]["automated_edits"] += bot_edits
            hypotheses["three"][date]["hq"]["automated_edits"]\
                += semi_automated_edits

            hypotheses["three"][date]["hq"]["human_edits"] += non_bot_edits
            hypotheses["three"][date]["hq"]["human_edits"] += anon_edits


 
        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Entity-months processed: {0}\n".format(i))  
            sys.stderr.flush()


    for hypothesis in hypotheses:
        for date in hypotheses[hypothesis]:

            if hypothesis == "one":
                hypothesis_1_output_file.write([
                    date,
                    hypotheses[hypothesis][date]["ma"]["automated_edits"],
                    hypotheses[hypothesis][date]["ma"]["human_edits"],
                    hypotheses[hypothesis][date]["a"]["automated_edits"],
                    hypotheses[hypothesis][date]["a"]["human_edits"]])

            if hypothesis == "two":
                hypothesis_2_output_file.write([
                    date,
                    hypotheses[hypothesis][date]["lq"]["automated_edits"],
                    hypotheses[hypothesis][date]["lq"]["human_edits"],
                    hypotheses[hypothesis][date]["hq"]["automated_edits"],
                    hypotheses[hypothesis][date]["hq"]["human_edits"]])

            if hypothesis == "three":
                hypothesis_3_output_file.write([
                    date,
                    hypotheses[hypothesis][date]["lq"]["automated_edits"],
                    hypotheses[hypothesis][date]["lq"]["human_edits"],
                    hypotheses[hypothesis][date]["hq"]["automated_edits"],
                    hypotheses[hypothesis][date]["hq"]["human_edits"]])



main()

