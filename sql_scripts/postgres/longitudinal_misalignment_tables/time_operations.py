"""
Seperates out into year and month columns and determines next month.

Usage:
    time_operations (-h|--help)
    time_operations <input> --revisions-output=<location>
                    [--debug]
                    [--verbose]

Options:
    -h, --help                     This help message is printed
    <input>                        Path to file to process.
    --revisions-output=<location>  Where revisions results
                                   will be written
    --debug                        Print debug logging to stderr
    --verbose                      Print dots and stuff to stderr  
"""


import docopt
import sys
import logging
import mysqltsv

logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )


    input_file = mysqltsv.Reader(open(args['<input>'], "r"), headers=True,
        types=[str, str, str, str, str, str, str, str])

    revisions_output_file = mysqltsv.Writer(
        open(args['--revisions-output'], "w"))

    verbose = args['--verbose']

    run(input_file, revisions_output_file, verbose)


def run(input_file, revisions_output_file, verbose):

    for i, line in enumerate(input_file):

        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Revisions processed: {0}\n".format(i))  
            sys.stderr.flush()

        new_revision_timestamp = line['timestamp']

        year = new_revision_timestamp[0:4]
        month = new_revision_timestamp[4:6]


        if month == 12:
            incremented_date_year = year + 1
            incremented_date_month = 1
        else:
            incremented_date_year = year
            incremented_date_month = month + 1
            

        revisions_output_file.write([line['page_title'], 
                                     line['revision_id'], 
                                     line['user_id'],
                                     line['user_text'],
                                     line['comment'], 
                                     line['namespace'],
                                     line['timestamp'],
                                     line['parent_id'],
                                     year,
                                     month,
                                     incremented_date_year,
                                     incremented_date_month])


    if verbose:
        sys.stderr.write("Completed writing out result file\n")
        sys.stderr.flush()


main()

