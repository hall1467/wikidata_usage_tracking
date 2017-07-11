"""
Processes page revision dump data to return revisons for pages and the user who 
created the revision.

Usage:
    entity_page_views (-h|--help)
    entity_page_views --input=<location> --revisions-output=<location>
                      [--debug]
                      [--verbose]

Options:
    -h, --help                             This help message is printed
    --input=<location>                     Path to json file to process.
    --revisions-output=<location>          Where revisions results
                                           will be written
    --debug                                Print debug logging to stderr
    --verbose                              Print dots and stuff to stderr  
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

    input_file = gzip.open(args['--input'],"rb")

    revisions_output_file =\
        csv.writer(open(args['--revisions-output'], "w"), delimiter="\t")

    verbose = args['--verbose']

    run(input_file, revisions_output_file, verbose)


def run(input_file, revisions_output_file, verbose):

    revisions_output = defaultdict(lambda: defaultdict(dict))
    stub_file_dump_object = mwxml.Dump.from_file(input_file)

    if verbose:
        sys.stderr.write("Processing dump file")  
        sys.stderr.flush()

    j =0 
    for i, stub_file_page in enumerate(stub_file_dump_object):

        if verbose and i % 1000:
            sys.stderr.write(".")  
            sys.stderr.flush()

        for stub_file_page_revision in stub_file_page:
            j +=1
            print(j)
            revisions_output[stub_file_page_revision.page.title]\
                            [stub_file_page_revision.id] =\
                                stub_file_page_revision.user.id

            
        if i == 350:
            break

    if verbose:
        sys.stderr.write("completed processing dump file\n")
        sys.stderr.write("Writing out result file")  
        sys.stderr.flush()


    revisions_output_file.writerow(["page_title", "revision_id", "user_id"])
    for title in revisions_output:
        for revision_id in revisions_output[title]:
           
            revisions_output_file.writerow([title, revision_id, 
                revisions_output[title][revision_id]])
            
            if verbose and i % 1000000:
                sys.stderr.write(".")  
                sys.stderr.flush()

    if verbose:
        sys.stderr.write("completed writing out result file\n")
        sys.stderr.flush()


main()

