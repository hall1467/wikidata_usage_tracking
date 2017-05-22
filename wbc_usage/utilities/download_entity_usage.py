"""
Given json containing wiki(s), downloads corresponding Wikibase entity usage 
dump sql files.

Usage:
    download_entity_usage (-h|--help)
    download_entity_usage <date> <download-directory> [<db-name-file>]
                          [--dump-host=<url>]
                          [--not-gzip-compressed]
                          [--debug]
                          [--verbose]



Options:
    -h, --help             This help message is printed
    <date>                 Date when the sql were files were produced. 
                           Format: yyyymmdd
    <download-directory>   Directory where downloads are placed
    <db-name-file>         Path to json file to process. If no file is 
                           provided, uses stdin
    --dump-host=<url>      If the host is different than the default 
                           Wikimedia host:
                           [default: https://dumps.wikimedia.org]
    --not-gzip-compressed  Set this flag if files at dump host are not 
                           compressed
    --debug                Print debug logging to stderr
    --verbose              Print dots and stuff to stderr      
"""

import logging
import json
import sys
import requests
import gzip
import re

import docopt

logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__, argv=argv)
    logging.basicConfig(
        level=logging.WARNING if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    if args['<db-name-file>']:
        json_file = args['<db-name-file>']
    else:
        logger.info("Reading from <stdin>")
        json_file = sys.stdin

    
    if re.match(r"^\d\d\d\d\d\d\d\d$",args['<date>']):
        date = args['<date>']
    else:
        raise RuntimeError("Please provide a data in the format: yyyymmdd")

    download_directory = args['<download-directory>']
    dump_host = args['--dump-host']

    if args['--not-gzip-compressed']:
        gzip_compression_extension = ""
    else:
        gzip_compression_extension = ".gz"

    verbose = args['--verbose']

    run(json_file, download_directory, date, dump_host, 
        gzip_compression_extension, verbose)


def run(json_file, download_directory, date, dump_host,
    gzip_compression_extension, verbose):

    if isinstance(json_file, str):
        logger.debug("Opening {0}".format(json_file))
        f = open(json_file, 'rt')
    else:
        logger.debug("Reading from {0}".format(json_file))
        f = json_file

    for line in f:

        wikidb_dictionary = json.loads(line)
        
        sql_file_name = wikidb_dictionary['dbname'] + "-" + date + \
            "-wbc_entity_usage.sql"

        dump_host_and_directory =\
            dump_host + "/" + wikidb_dictionary['dbname'] + "/" + date

        if verbose:
            sys.stderr.write("Downloading data for: " + 
                wikidb_dictionary['dbname'] + "\n")
            sys.stderr.flush()

        dump = requests.get(dump_host_and_directory + "/" + sql_file_name + 
            gzip_compression_extension, stream=True)

        if dump.status_code != 200:
            logger.warn("Skipping (possibly non-existent) dump for {0}. {1}"
                .format(wikidb_dictionary['dbname'], "HTTP code: " + 
                str(dump.status_code)))
            continue

        output_f = open(download_directory + "/" + sql_file_name, "w")
        for entry in gzip.open(dump.raw):
            output_f.write(entry.decode())
        output_f.close()


