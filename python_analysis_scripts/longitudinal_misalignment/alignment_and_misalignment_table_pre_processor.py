"""
Preprocess alignment and misalignment data so that it can be imported into 
Postgres

Usage:
    alignment_and_misalignment_table_pre_processor (-h|--help)
    alignment_and_misalignment_table_pre_processor <output> <input_alignment_data>...
                                                   [--debug]
                                                   [--verbose]

Options:
    -h, --help              This help message is printed
    <input_alignment_data>  Path to file to process.
    <output>                Where output will be written
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


    input_alignment_data = args['<input_alignment_data>']

    output_file = mysqltsv.Writer(open(args['<output>'], "w"))

    verbose = args['--verbose']

    run(input_alignment_data, output_file, verbose)


def run(input_alignment_data, output_file, verbose):


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

          output_file.write([line[0], int(date[0:4]), int(date[4:6]), line[2], 
                line[1]])


          if verbose and i % 10000 == 0 and i != 0:
              sys.stderr.write("\tEntities processed: {0}\n".format(i))  
              sys.stderr.flush()


main()

