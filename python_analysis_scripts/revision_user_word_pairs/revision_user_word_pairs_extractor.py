"""
Returns tsv of word frequencies in revision comments by edit type.

Takes in user id, edit_type, revision_comment.

An R script is used for processing after this.

Usage:
    revision_user_word_pairs_extractor (-h|--help)
    revision_user_word_pairs_extractor <input> <output>
                                       [--debug]
                                       [--verbose]

Options:
    -h, --help  This help message is printed
    <input>     Path to file to process.
    <output>    Where results will be written
    --debug     Print debug logging to stderr
    --verbose   Print dots and stuff to stderr  
"""


import docopt
import sys
import logging
import operator
from collections import defaultdict
import re
import mysqltsv

STRUCTURED_COMMENT_RE = re.compile(r'^\/\*.*.\*\/')
PUNCTUATION_RE = re.compile(r'\:|\(|\)|\.|\,|\-')

logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_file = mysqltsv.Reader(open(args['<input>'], "r"), headers=False,
        types=[str, str, str])

    output_file = mysqltsv.Writer(open(args['<output>'], "w"))

    verbose = args['--verbose']

    run(input_file, output_file, verbose)


def run(input_file, output_file, verbose):

    word_count = defaultdict(lambda: defaultdict(int))

    for i, line in enumerate(input_file):
        comment = line[2]
        if comment != None:
            comment_match = re.match(STRUCTURED_COMMENT_RE, comment)
            if comment_match != None:
                for word in comment_match.group(0).split():
                    word_count[line[1]][str(line[0])+word.lower()] += 1


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Revisions processed: {0}\n".format(i))  
            sys.stderr.flush()


    for edit_type in word_count:
        for word in word_count[edit_type]:
            output_file.write([edit_type, word, word_count[edit_type][word]])

    
    if verbose:
        sys.stderr.write("Completed writing out result file\n")
        sys.stderr.flush()


main()

