"""
Downloads page views zipped file.

Usage:
    download_page_views (-h|--help)
    download_page_views
                        [--dump-host=<url>]
                        [--page-view-directory=<location>]
                        [--page-view-file=<location>]
                        [--output-directory=<location>]
                        [--output-file=<name>]
                        [--debug] 
                        [--verbose]


Options:
    -h, --help                        This help message is printed
    --dump-host=<url>                 If the host is different than the
                                      default Wikimedia host.
                                      [default: https://analytics.wikimedia.org]
    --page-view-directory=<location>  Page view directory.
                                      [default: /datasets/one-off/pageview_rate/20170607/]
    --page-view-file=<name>           Page view tsv file to process in 
                                      directory.
                                      [default: pageview_rate.20170607.tsv.bz2]
    --output-directory=<location>     Where results will be writen.
                                      [default: ./]
    --output-file=<name>              File where results will be written (if 
                                      user would like a custom name)
    --debug                           Print debug logging to stderr
    --verbose                         Print dots and stuff to stderr  
"""
import logging
import requests
import sys
import bz2
import re
from collections import defaultdict

import docopt

logger = logging.getLogger(__name__)

def main(argv=None):
    args = docopt.docopt(__doc__, argv=argv)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )
    
    dump_host = args['--dump-host']
    page_view_directory = args['--page-view-directory']
    page_view_file = args['--page-view-file']

    output_directory = args['--output-directory']

    if args['--output-file']:
        output_file = open(output_directory + args['--output-file'], "wb")
    else:
        output_file = open(output_directory + page_view_file, "wb")

    verbose = args['--verbose']

    run(page_view_directory, page_view_file, dump_host, output_file, verbose)


def run(page_view_directory, page_view_file, dump_host, output_file, verbose):
    print(page_view_directory, page_view_file, dump_host, output_file, verbose)

    if verbose:
        sys.stderr.write("Downloading page views from: " + dump_host +   
            page_view_directory + page_view_file + "\n")
        sys.stderr.flush()

    page_view_dump_file = requests.get(dump_host + page_view_directory + 
        page_view_file, stream=True)
    if page_view_dump_file.status_code != 200:
        raise RuntimeError("Couldn't download: {0}. {1}"
            .format(dump_host + page_view_directory + page_view_file, 
            "HTTP code: " + str(page_view_dump_file.status_code)))
    
    for entry in page_view_dump_file.iter_content(1000):
        output_file.write(entry)
    output_file.close()

