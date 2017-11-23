"""
Processes page revision dump data to return revisons for pages and the user who 
created the revision.

Usage:
    wikidata_revision_extraction (-h|--help)
    wikidata_revision_extraction <input>... --revisions-output=<location>
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
            
            if stub_file_page.namespace == 0 or stub_file_page.namespace == 120:

                for stub_file_page_revision in stub_file_page:

                    revision_comment = stub_file_page_revision.comment
                    revision_user_id = "NULL"
                    revision_user_text = "NULL"

                    if revision_comment is None:
                        revision_comment = "NULL"

                    if stub_file_page_revision.user is None:       
                        logger.warning(
                            "No user. Fields will be NULL. Revision: {0}"
                            .format(stub_file_page_revision))
                        revision_user_id = "NULL"
                        revision_user_text = "NULL"
                    elif stub_file_page_revision.user.id is None:
                        revision_user_id = "NULL"
                        revision_user_text = stub_file_page_revision.user.text
                    else:
                        revision_user_id = stub_file_page_revision.user.id
                        revision_user_text = stub_file_page_revision.user.text

                        
                    yield stub_file_page_revision.page.title,\
                          stub_file_page_revision.id,\
                          revision_user_id,\
                          revision_user_text,\
                          revision_comment,\
                          stub_file_page.namespace,\
                          stub_file_page_revision.timestamp

    i = 0
    revisions_output_file.write(["page_title", "revision_id", "user_id_or_ip", 
        "comment", "namespace", "timestamp"])
    for title, revision_id, user_id, user_text, comment, namespace, timestamp\
        in mwxml.map(process_pages, input_files):
        i += 1
        revisions_output_file.write([title, revision_id, user_id, user_text, 
            comment, namespace, timestamp])

        if verbose and i % 10000 == 0:
            sys.stderr.write("Revisions processed: {0}\n".format(i))  
            sys.stderr.flush()

    if verbose:
        sys.stderr.write("Completed writing out result file\n")
        sys.stderr.flush()


main()

