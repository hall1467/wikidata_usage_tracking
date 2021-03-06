"""
Given json containing wiki(s), downloads corresponding page_props 
dump sql files.

Usage:
    download_page_props (-h|--help)
    download_page_props <date> <download-directory> [<db-name-file>]
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
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.WARNING if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    if args['<db-name-file>']:
        db_name_file = args['<db-name-file>']
    else:
        logger.info("Reading from <stdin>")
        db_name_file = sys.stdin

    
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

    run(db_name_file, download_directory, date, dump_host, 
        gzip_compression_extension, verbose)


def run(db_name_file, download_directory, date, dump_host,
    gzip_compression_extension, verbose):

    if isinstance(db_name_file, str):
        logger.debug("Opening {0}".format(db_name_file))
        f = open(db_name_file, 'rt')
    else:
        logger.debug("Reading from {0}".format(db_name_file))
        f = db_name_file

    for line in f:

        wikidb_dictionary = json.loads(line)
        
        sql_file_name = wikidb_dictionary['dbname'] + "-" + date + \
            "-page_props.sql"

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

        output_f = open(download_directory + "/" + sql_file_name + ".gz", "wb")
        for entry in dump.iter_content(1000):
            output_f.write(entry)
        output_f.close()


main()

