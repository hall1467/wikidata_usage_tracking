"""
Post process revisions so that Postgres properly understands backslashes.

Usage:
    revisions_postgres_post_process (-h|--help)
    revisions_postgres_post_process <input> --revisions-output=<location>
                      [--debug]
                      [--verbose]

Options:
    -h, --help                     This help message is printed
    <input>                        Path to file to process.
    --revisions-output=<location>  Where revisions results
                                   will be written
    --debug                        Print debug logging to stderr
    --verbose                      Print dots and stuff to stderr  
"""


import docopt
import sys
import logging
import mwxml
import gzip
from collections import defaultdict
import re

logger = logging.getLogger(__name__)


BACKSLASH_RE = re.compile(r'.*(\\).*')

def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_file = open(args['<input>'], "r")

    revisions_output_file = open(args['--revisions-output'], "w")

    verbose = args['--verbose']

    run(input_file, revisions_output_file, verbose)


def run(input_file, revisions_output_file, verbose):

    for i, line in enumerate(input_file):

        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Revisions processed: {0}\n".format(i))  
            sys.stderr.flush()

        if BACKSLASH_RE.match(line):
            revisions_output_file.write(re.sub(r'\\', '\\\\\\\\', line))
        else:
            revisions_output_file.write(line)


    if verbose:
        sys.stderr.write("Completed writing out result file\n")
        sys.stderr.flush()


main()

