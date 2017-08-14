"""
Extract page information from an (gross, icky) SQL file.

Usage:
    extract_page_information (-h|--help)
    extract_page_information [<sql-file>]...
                             [--processes=<num>]
                             [--debug]
                             [--verbose]


Options:
    -h, --help         Print this help message
    <sql-file>         Path to SQL file to process.  If no file is provided,
                       read stdin.
    --processes=<num>  The number of parallel processes to run
                       [default: <cpu-count>]
    --debug            Print debug logging to stderr
    --verbose          Print dots and stuff to stderr
"""
import gzip
import json
import logging
import sys
from multiprocessing import cpu_count

import docopt
import para

from page_dump import PageDump

logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.WARNING if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    if len(args['<sql-file>']) == 0:
        logger.info("Reading from <stdin>")
        sql_files = [sys.stdin]
    else:
        sql_files = args['<sql-file>']

    if args['--processes'] == "<cpu-count>":
        processes = cpu_count()
    else:
        processes = int(args['--processes'])

    verbose = args['--verbose']

    run(sql_files, processes, verbose)


def run(sql_files, processes, verbose):

    def extract_from_sql_file(path):
        if isinstance(path, str):
            logger.debug("Opening {0}".format(path))
            f = gzip.open(path, 'rt', errors='replace')
        else:
            logger.debug("Reading from {0}".format(path))
            f = path
        dump = PageDump.from_sql_file(f)
        for sitelink_usage in dump.usages:
            yield sitelink_usage

    usages = para.map(extract_from_sql_file, sql_files, mappers=processes)
    for i, sitelink_usage in enumerate(usages):
        json.dump(sitelink_usage.to_json(), sys.stdout)
        sys.stdout.write("\n")

        if verbose and i % 1000 == 0:
            sys.stderr.write(".")
            sys.stderr.flush()

main()


