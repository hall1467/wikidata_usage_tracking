"""
Merge misalignment data with edit breakdowns (e.g. bot, non-bot, anon,
  semi-automated) and aggregate for hypotheses.

Usage:
    merge_misalignment_data_with_edit_data (-h|--help)
    merge_misalignment_data_with_edit_data <hypothesis_1_output> <hypothesis_2_output> <hypothesis_3_output> <input_edit_data> <input_alignment_data>...
                                           [--debug]
                                           [--verbose]

Options:
    -h, --help              This help message is printed
    <input_edit_data>       Path to edit breakdown file to process.
    <input_alignment_data>  Path to misalignment and alignment files to 
                            process.
    <hypothesis_1_output>   Where hypothesis 1 counts will be written
    <hypothesis_2_output>   Where hypothesis 2 counts will be written
    <hypothesis_3_output>   Where hypothesis 3 counts will be written
    --debug                 Print debug logging to stderr
    --verbose               Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
from collections import defaultdict
import mysqltsv
import bz2
import re
from collections import defaultdict
import sys


logger = logging.getLogger(__name__)


MISALIGNMENT_FILE_RE =\
    re.compile(r'.*\/(\d\d\d\d\d\d)_misaligned\.tsv')
ALIGNMENT_FILE_RE =\
    re.compile(r'.*\/(\d\d\d\d\d\d)_aligned\.tsv')

def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_edit_data_file = mysqltsv.Reader(bz2.open(args['<input_edit_data>'],
        'rt', encoding='utf-8', errors='replace'), headers=False,
        types=[str, str, str, str, str, str, str, str])

    input_alignment_data = args['<input_alignment_data>']

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

    run(input_edit_data_file, input_alignment_data, hypothesis_1_output_file, 
        hypothesis_2_output_file, hypothesis_3_output_file, verbose)


def run(input_edit_data_file, input_alignment_data, hypothesis_1_output_file, 
    hypothesis_2_output_file, hypothesis_3_output_file, verbose):


    edits = defaultdict(lambda: defaultdict(lambda: defaultdict(
        lambda: defaultdict(int))))
    combined = defaultdict(lambda:
        defaultdict(lambda: defaultdict(lambda: defaultdict(int))))


    for i, line in enumerate(input_edit_data_file):

        edits[line[0]][line[1]+line[2].zfill(2)]['bot_edits'] = 0\
            if line[3] == "\\N" else int(line[3])
        edits[line[0]][line[1]+line[2].zfill(2)]['semi_aut_edits'] = 0\
            if line[4] == "\\N" else int(line[4])
        edits[line[0]][line[1]+line[2].zfill(2)]['non_bot_edits'] = 0\
            if line[5] == "\\N" else int(line[5])
        edits[line[0]][line[1]+line[2].zfill(2)]['anon_edits'] = 0\
            if line[6] == "\\N" else int(line[6])
        edits[line[0]][line[1]+line[2].zfill(2)]['all_edits'] = 0\
            if line[7] == "\\N" else int(line[7])


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Entity-months processed: {0}\n".format(i))  
            sys.stderr.flush()


    for f in input_alignment_data:

      if verbose:
          sys.stderr.write("Processing: {0}\n".format(f))  
          sys.stderr.flush()

      if MISALIGNMENT_FILE_RE.match(f):
          date = MISALIGNMENT_FILE_RE.match(f).group(1)
          file_type = "ma"
      elif ALIGNMENT_FILE_RE.match(f):
          date = ALIGNMENT_FILE_RE.match(f).group(1)
          file_type = "a"
      else:
          raise RuntimeError("Incorrect filename: {0}".format(f))

      for i, line in enumerate(mysqltsv.Reader(open(f, "r"), headers=False, 
          types=[str, str, str])):

          if line[0] in edits and date in edits[line[0]]:
              combined[line[2]][line[1]][date]['bot_edits']\
                  += edits[line[0]][date]['bot_edits']
              combined[line[2]][line[1]][date]['semi_aut_edits']\
                  += edits[line[0]][date]['semi_aut_edits']
              combined[line[2]][line[1]][date]['non_bot_edits']\
                  += edits[line[0]][date]['non_bot_edits']
              combined[line[2]][line[1]][date]['anon_edits']\
                  += edits[line[0]][date]['anon_edits']
              combined[line[2]][line[1]][date]['all_edits']\
                  += edits[line[0]][date]['all_edits']
          else:
              logger.warning("Couldn't find in the edit file: {0}"
                .format(line[0]))


          if verbose and i % 10000 == 0 and i != 0:
              sys.stderr.write("\tEntities processed: {0}\n".format(i))  
              sys.stderr.flush()


      # Aggregate aligned and misaligned edits by month for each analysis
     
      hypotheses = defaultdict(lambda: defaultdict(lambda: defaultdict(
          lambda: defaultdict(int))))



    for qual in combined:
        for views in combined[qual]:   
            for date in combined[qual][views]:
          


                # Hypothesis 1
                # Misaligned
                if (qual == 'D' and views == 'E') or\
                    (qual == 'C' and views == 'E') or\
                    (qual == 'C' and views == 'D'):

                    hypotheses["one"][date]["ma"]["automated_edits"]\
                        += combined[qual][views][date]['bot_edits']
                    hypotheses["one"][date]["ma"]["automated_edits"]\
                        += combined[qual][views][date]['semi_aut_edits']

                    hypotheses["one"][date]["ma"]["human_edits"]\
                        += combined[qual][views][date]['non_bot_edits']
                    hypotheses["one"][date]["ma"]["human_edits"]\
                        += combined[qual][views][date]['anon_edits']
            
                # Aligned
                if (qual == 'E' and views == 'E') or\
                    (qual == 'D' and views == 'D'):

                    hypotheses["one"][date]["a"]["automated_edits"]\
                        += combined[qual][views][date]['bot_edits']
                    hypotheses["one"][date]["a"]["automated_edits"]\
                        += combined[qual][views][date]['semi_aut_edits']

                    hypotheses["one"][date]["a"]["human_edits"]\
                        += combined[qual][views][date]['non_bot_edits']
                    hypotheses["one"][date]["a"]["human_edits"]\
                        += combined[qual][views][date]['anon_edits']

                # Hypothesis 2
                # Lower quality aligned
                if (qual == 'E' and views == 'E') or\
                    (qual == 'D' and views == 'D') or\
                    (qual == 'C' and views == 'C'):

                    hypotheses["two"][date]["lq"]["automated_edits"]\
                        += combined[qual][views][date]['bot_edits']
                    hypotheses["two"][date]["lq"]["automated_edits"]\
                        += combined[qual][views][date]['semi_aut_edits']

                    hypotheses["two"][date]["lq"]["human_edits"]\
                        += combined[qual][views][date]['non_bot_edits']
                    hypotheses["two"][date]["lq"]["human_edits"]\
                        += combined[qual][views][date]['anon_edits']

                # Higher quality aligned
                if (qual == 'B' and views == 'B') or\
                    (qual == 'A' and views == 'A'):

                    hypotheses["two"][date]["hq"]["automated_edits"]\
                        += combined[qual][views][date]['bot_edits']
                    hypotheses["two"][date]["hq"]["automated_edits"]\
                        += combined[qual][views][date]['semi_aut_edits']
                    
                    hypotheses["two"][date]["hq"]["human_edits"]\
                        += combined[qual][views][date]['non_bot_edits']
                    hypotheses["two"][date]["hq"]["human_edits"]\
                        += combined[qual][views][date]['anon_edits']

                # Hypothesis 3
                # Lower quality aligned
                if (qual == 'E' and views != 'E') or\
                    (qual == 'D' and views != 'D') or\
                    (qual == 'C' and views != 'C'):

                    hypotheses["three"][date]["lq"]["automated_edits"]\
                        += combined[qual][views][date]['bot_edits']
                    hypotheses["three"][date]["lq"]["automated_edits"]\
                        += combined[qual][views][date]['semi_aut_edits']

                    hypotheses["three"][date]["lq"]["human_edits"]\
                        += combined[qual][views][date]['non_bot_edits']
                    hypotheses["three"][date]["lq"]["human_edits"]\
                        += combined[qual][views][date]['anon_edits']

                # Higher quality aligned
                if (qual == 'B' and views != 'B') or\
                    (qual == 'A' and views != 'A'):

                    hypotheses["three"][date]["hq"]["automated_edits"]\
                        += combined[qual][views][date]['bot_edits']
                    hypotheses["three"][date]["hq"]["automated_edits"]\
                        += combined[qual][views][date]['semi_aut_edits']

                    hypotheses["three"][date]["hq"]["human_edits"]\
                        += combined[qual][views][date]['non_bot_edits']
                    hypotheses["three"][date]["hq"]["human_edits"]\
                        += combined[qual][views][date]['anon_edits']


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

