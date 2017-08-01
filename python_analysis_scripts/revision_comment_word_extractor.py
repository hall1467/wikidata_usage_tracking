"""
returns tsv of word frequencies in revision comments

Usage:
    revision_comment_word_extractor (-h|--help)
    revision_comment_word_extractor <input> <output>
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
import re
import mysqltsv

REMOVED_COMMENT_RE = re.compile(r'^\/\*.*.\*\/')
PUNCTUATION_RE = re.compile(r'\:|\(|\)|\.|\,|\-')

logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_file = mysqltsv.Reader(open(args['<input>'], "r"), headers=False,
        types=[str, int, str, str, int])

    output_file = mysqltsv.Writer(open(args['<output>'], "w"))

    verbose = args['--verbose']

    run(input_file, output_file, verbose)


def run(input_file, output_file, verbose):

    word_count = defaultdict(int)
    for i, line in enumerate(input_file):
        comment = line[3]
        if comment != None:
            comment = re.sub(REMOVED_COMMENT_RE, "", comment)
            for word in comment.split(" "):
                normalized_word = re.sub(PUNCTUATION_RE, "", word)
                word_count[normalized_word] += 1

        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Revisions processed: {0}\n".format(i))  
            sys.stderr.flush()

    sorted_word_count = sorted(word_count.items(), key=operator.itemgetter(1), 
        reverse=True)
    sum_of_word_counts = 0
    for i, entry in enumerate(sorted_word_count):
        output_file.write([entry[0], entry[1]])
        sum_of_word_counts += entry[1]

        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Words written: {0}\n".format(i))  
            sys.stderr.flush()


    print("Total word count: {0}".format(sum_of_word_counts))
    
    if verbose:
        sys.stderr.write("Completed writing out result file\n")
        sys.stderr.flush()


main()

