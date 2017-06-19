"""
Converts json resulting from utilities to TSV.

Usage:
    convert_json_to_tsv (-h|--help)
    convert_json_to_tsv 
                        [<input-file>]
                        [--output-file=<location>]
                        [--debug] 
                        [--verbose]


Options:
    -h, --help                This help message is printed
    <input-file>              Path to json file. If no file 
                              is provided, uses stdin
    --output-file=<location>  Where results will be written.
                              [default: <stdout>]
    --debug                   Print debug logging to stderr
    --verbose                 Print dots and stuff to stderr  
"""
import logging
import sys
import json
import mysqltsv

import docopt

logger = logging.getLogger(__name__)

def main(argv=None):
    args = docopt.docopt(__doc__, argv=argv)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    if args['<input-file>']:
        input_file = open(args['<input-file>'], "r")
    else:
        logger.info("Reading from <stdin>")
        input_file = sys.stdin

    if args['--output-file'] == '<stdout>':
        output_file = sys.stdout
    else:
        output_file = open(args['--output-file'], "w")

    verbose = args['--verbose']

    run(input_file, output_file, verbose)


def run(input_file, output_file, verbose):

    tsv_object = mysqltsv.Writer(output_file, headers=['project', 'aspect', 
        'entity_id', 'page_views'])

    for i, line in enumerate(input_file):
        json_line = json.loads(line)
        tsv_object.write(json_line)

        if verbose and i % 1000000 == 0:
            sys.stderr.write(".")
            sys.stderr.flush()

