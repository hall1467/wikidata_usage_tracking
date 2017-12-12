"""
Label edits as bot or human based on bot user ids.



Usage:
    label_edits_as_bot_or_human (-h|--help)
    label_edits_as_bot_or_human <input_revisions> <input_bot_user_ids> <output>
                                [--debug]
                                [--verbose]

Options:
    -h, --help            This help message is printed
    <input_revisions>     Path to input revisions file to process. 
    <input_bot_user_ids>  Path to input bot user ids file to process.                             
    <output>              Where output will be written
    --debug               Print debug logging to stderr
    --verbose             Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
import sys
import mysqltsv
import re


logger = logging.getLogger(__name__)

BOT_NAME_RE = re.compile(r'.*bot$', re.I)

def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )


    input_revisions_file = mysqltsv.Reader(
        open(args['<input_revisions>'],'rt'), headers=True, 
        types=[str, str, int, str, str, int, str, str, str, str, str, str, str])


    input_bot_user_ids_file = mysqltsv.Reader(
        open(args['<input_bot_user_ids>'],'rt'), headers=False, 
        types=[int])


    output_file = mysqltsv.Writer(open(args['<output>'], "w"), headers=[
        'title', 'rev_id', 'user', 'username', 'comment', 'namespace', 
        'timestamp', 'prev_timestamp', 'session_start', 'session_end', 
        'session_index', 'session_events', 'event_index', 'edit_type'])


    verbose = args['--verbose']

    run(input_revisions_file, input_bot_user_ids_file, output_file, verbose)


def run(input_revisions_file, input_bot_user_ids_file, output_file, verbose):
    
    bot_user_ids = {}


    for i, line in enumerate(input_bot_user_ids_file):
        bot_user_ids[line[0]] = 1


    for i, line in enumerate(input_revisions_file):

        if line["user"] in bot_user_ids:
            edit_type = "bot"
        else:
            
            if BOT_NAME_RE.match(line["username"]):
                sys.stderr.write("Revision ends with bot: '{0}''. Skipping\n".
                    format(line["username"]))  
                sys.stderr.flush()
                continue

            edit_type = "human"


        output_file.write(
            [line["title"],
             line["rev_id"],
             line["user"],
             line["username"],
             line["comment"],
             line["namespace"],
             line["timestamp"],
             line["prev_timestamp"],
             line["session_start"],
             line["session_end"],
             line["session_index"],
             line["session_events"],
             line["event_index"],
             edit_type])


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Revisions labelled: {0}\n".format(i))  
            sys.stderr.flush()


main()

