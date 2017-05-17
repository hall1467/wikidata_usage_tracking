"""
Given json containing wiki(s), downloads corresponding Wikibase entity usage 
dump sql files.

Usage:
    usage_downloader (-h|--help)
    usage_downloader [<json-file>] --download-directory=<file> --date=<yyyymmdd>
                     [--debug]
                     [--verbose]


Options:
    -h, --help                   This help message is printed
    <json-file>                  Path to json file to process. If no file is 
                                 provided, use stdin.
    --download-directory=<file>  Directory where downloads are placed.
    --date=<yyyymmdd>            When the sql files were produced.
    --debug                      Print debug logging to stderr
    --verbose                    Print dots and stuff to stderr      
"""

import logging
import json
import sys
import requests
import gzip

import docopt

logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__, argv=argv)
    logging.basicConfig(
        level=logging.WARNING if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    if args['<json-file>']:
        json_file = args['<json-file>']
    else:
        logger.info("Reading from <stdin>")
        json_file = sys.stdin

    download_directory = args['--download-directory']
    date = args['--date'] 
    verbose = args['--verbose']

    run(json_file, download_directory, date, verbose)


def run(json_file, download_directory, date, verbose):

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

        dump = requests.get("https://dumps.wikimedia.org/" + 
                            wikidb_dictionary['dbname'] + "/" + date + "/" +
                            sql_file_name + ".gz", stream=True)
        if dump.status_code != 200:
            logger.warn("Skipping (possibly non-existent) dump for {0}. {1}".format(wikidb_dictionary['dbname'], "HTTP code: " + str(dump.status_code)))
            continue
        output_f = open(download_directory + "/" + sql_file_name, "w")
        for entry in gzip.open(dump.raw):
            output_f.write(entry.decode())
        output_f.close()
