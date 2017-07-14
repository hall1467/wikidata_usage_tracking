"""
Processes page revision dump data to return revisons for pages and the user who 
created the revision.

Usage:
    entity_page_views (-h|--help)
    entity_page_views <input>... --revisions-output=<location>
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
import gzip
from collections import defaultdict
import csv

logger = logging.getLogger(__name__)

def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_files = args['<input>']

    revisions_output_file =\
        csv.writer(open(args['--revisions-output'], "w"), delimiter="\t")

    verbose = args['--verbose']

    run(input_files, revisions_output_file, verbose)


def run(input_files, revisions_output_file, verbose):

    def process_pages(stub_file_dump_object, file_url):
        for stub_file_page in stub_file_dump_object:

            for stub_file_page_revision in stub_file_page:

                revision_comment = stub_file_page_revision.comment
                revision_user = stub_file_page_revision.user
                if revision_comment is None:
                    revision_comment = "NULL"

                if revision_user is None:       
                    logger.warning("No user id. id will be NULL. Revision: {0}"
                        .format(stub_file_page_revision))
                    revision_user = "NULL"
                    
                    
                yield stub_file_page_revision.page.title,\
                      stub_file_page_revision.id,\
                      revision_user,\
                      revision_comment

    i = 0
    revisions_output_file.writerow(["page_title", "revision_id", "user", "comment"])
    for title, revision_id, user, comment in mwxml.map(process_pages, 
        input_files):
        i += 1
        revisions_output_file.writerow([title, revision_id, user, comment])

        if verbose and i % 10000 == 0:
            sys.stderr.write("Revisions processed: {0}\n".format(i))  
            sys.stderr.flush()

    if verbose:
        sys.stderr.write("Completed writing out result file\n")
        sys.stderr.flush()


main()

