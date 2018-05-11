"""
Processes article dump data to return namespace 0 articles.

Usage:
    wikipedia_main_namespace_article_extraction (-h|--help)
    wikipedia_main_namespace_article_extraction <input>... --revisions-output=<location>
                                                [--debug]
                                                [--verbose]

Options:
    -h, --help                     This help message is printed
    <input>                        Path to file(s) to process.
    --revisions-output=<location>  Where revisions results
                                   will be written
    --debug                        Print debug logging to stderr
    --verbose                      Print dots and stuff to stderr  
"""


import docopt
import sys
import logging
import mwxml
import mysqltsv
import datetime

logger = logging.getLogger(__name__)

def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_files = args['<input>']

    revisions_output_file =\
        mysqltsv.Writer(open(args['--revisions-output'], "w"))

    verbose = args['--verbose']

    run(input_files, revisions_output_file, verbose)


def run(input_files, revisions_output_file, verbose):

    def process_pages(stub_file_dump_object, file_url):
        for stub_file_page in stub_file_dump_object:
            for stub_file_page_revision in stub_file_page:
                if stub_file_page.namespace == 0:
                    yield stub_file_page.id


    i = 0
    for page_id in mwxml.map(process_pages, input_files):
        i += 1
        revisions_output_file.write([page_id])

        if verbose and i % 10000 == 0:
            sys.stderr.write("Revisions processed: {0}\n".format(i))  
            sys.stderr.flush()

    if verbose:
        sys.stderr.write("Completed writing out result file\n")
        sys.stderr.flush()


main()

