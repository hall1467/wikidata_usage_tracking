"""
Writes to stderr number of revisions processed by wikidata_page_revisions.py to 
see if it is correct.

Usage:
    verify_number_of_revisions (-h|--help)
    verify_number_of_revisions <input>...
                      [--debug]

Options:
    -h, --help                     This help message is printed
    <input>                        Path to file(s) to process.
    --debug                        Print debug logging to stderr
"""


import docopt
import sys
import logging
import mwxml
import gzip

logger = logging.getLogger(__name__)

def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_files = args['<input>']

    run(input_files)


def run(input_files):

    def process_pages(stub_file_dump_object, file_url):
        for stub_file_page in stub_file_dump_object:
            for stub_file_page_revision in stub_file_page:     
                yield True

    i = 0
    for boolean_value in mwxml.map(process_pages, input_files):
        i += 1

        if i % 100000 == 0:
            sys.stderr.write("Revisions processed: {0}\n".format(i))  
            sys.stderr.flush()


    sys.stderr.write("Completed writing out result file\n")
    sys.stderr.write("Count: {0}\n".format(i))
    sys.stderr.flush()


main()

