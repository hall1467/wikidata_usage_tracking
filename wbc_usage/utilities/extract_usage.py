"""
Extract Wikibase client usage information from an (gross, icky) SQL file.

Usage:
    extract_usage (-h|--help)
    extract_usage [<sql-file>]...
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

from ..wikibase_client_dump import WikibaseClientDump

logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__, argv=argv)
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
            f = gzip.open(path, 'rt')
        else:
            f = path
        dump = WikibaseClientDump.from_file(f)
        for wbcu in dump.usages:
            yield wbcu

    for wbcu in para.map(sql_files, sql_files, mappers=processes):
        json.dump(wbcu.to_json())
