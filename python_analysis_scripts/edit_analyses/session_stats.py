"""
Selects number of distinct revisions.



Usage:
    session_stats (-h|--help)
    session_stats <input>
                     [--debug]
                     [--verbose]

Options:
    -h, --help  This help message is printed
    <input>     Path to input file to process.                           
    --debug     Print debug logging to stderr
    --verbose   Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
import sys
import mysqltsv
from collections import defaultdict


logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_file = mysqltsv.Reader(
        open(args['<input>'],'rt'), headers=True, 
        types=[str, str, str, str, str, int, str, str, str, str, str, str, 
            str, str])


    verbose = args['--verbose']

    run(input_file, verbose)


def run(input_file, verbose):
    
    sessions = defaultdict(lambda: defaultdict(int))
    bot_sessions = defaultdict(lambda: defaultdict(int))
    human_sessions = defaultdict(lambda: defaultdict(int))
    revision_namespaces = defaultdict(int)

    bot_revisions_sum = 0
    human_revisions_sum = 0


    for i, line in enumerate(input_file):
        sessions[line["user"]][line["session_start"]] = 1
        revision_namespaces[line["namespace"]] += 1

        if line["edit_type"] == 'bot':
            bot_revisions_sum += 1
            bot_sessions[line["user"]][line["session_start"]] = 1
        else:
            human_revisions_sum += 1
            human_sessions[line["user"]][line["session_start"]] = 1


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Revisions analyzed: {0}\n".format(i))  
            sys.stderr.flush()


    session_sum = 0
    for user in sessions:
        for session_start in sessions[user]:
            session_sum += 1

    bot_session_sum = 0
    for user in bot_sessions:
        for session_start in bot_sessions[user]:
            bot_session_sum += 1

    human_session_sum = 0
    for user in human_sessions:
        for session_start in human_sessions[user]:
            human_session_sum += 1


    print("Sessions: {0}".format(session_sum))
    print("Bot sessions: {0}".format(bot_session_sum))
    print("Bot revisions: {0}".format(bot_revisions_sum))
    print("Human sessions: {0}".format(human_session_sum))
    print("Human revisions: {0}".format(human_revisions_sum))
    print("Revision namespaces: {0}".format(revision_namespaces))


main()

