"""
Takes timestamp, revision id, user id, namespace, and edit type and gives back 
nearby revisions (using Mediawiki API). User can specify how "near" (in 
minutes).

Usage:
    filter_extra_sessions (-h|--help)
    filter_extra_sessions <input_sampled_revisions> <input_revisions_in_sessions> <output>
                          [--debug]
                          [--verbose]

Options:
    -h, --help                     This help message is printed
    <input_sampled_revisions>      Path to sampled revisions file to process.
    <input_revisions_in_sessions>  Path to input revisions in sessions file to 
                                   process.
    <output>                       Where output will be written
    --debug                        Print debug logging to stderr
    --verbose                      Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
import sys
from collections import defaultdict
import mysqltsv


logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_sampled_revisions_file = mysqltsv.Reader(open(args['<input_sampled_revisions>'],'rt'),
        headers=True, types=[int, int, str, str])

    input_revisions_in_sessions_file = mysqltsv.Reader(open(args['<input_revisions_in_sessions>'],'rt'),
        headers=True, types=[int, int, int, str, str])


    output_file = mysqltsv.Writer(open(args['<output>'], "w"), headers=[
    'timestamp', 'revision_id', 'user_id', 'namespace', 'edit_type'])

    verbose = args['--verbose']

    run(input_file, output_file, verbose)


def run(input_file, output_file, verbose):

    unique_revision_ids = defaultdict(lambda: defaultdict(dict))
    session_for_nearby_revisions = mwapi.Session("http://wikidata.org")

    for i, line in enumerate(input_file):

        # Need to convert timestamp and then add and subtract from it
        timestamp_year = int(line['timestamp'][0:4])
        timestamp_month = int(line['timestamp'][4:6])
        timestamp_day = int(line['timestamp'][6:8])
        timestamp_hour = int(line['timestamp'][8:10])
        timestamp_minute = int(line['timestamp'][10:12])
        timestamp_second = int(line['timestamp'][12:14])


        cast_timestamp = datetime.datetime(timestamp_year,
                                           timestamp_month,
                                           timestamp_day,
                                           timestamp_hour,
                                           timestamp_minute,
                                           timestamp_second
                                          )
        
        incremented_cast_timestamp =\
            cast_timestamp + datetime.timedelta(minutes=61)
        decremented_cast_timestamp =\
            cast_timestamp - datetime.timedelta(minutes=61)
     
        # Range after
        for revision_id, user_id, timestamp, namespace in request_function_and_timestamp_adjusting(cast_timestamp, incremented_cast_timestamp, "newer", line, session_for_nearby_revisions):
            unique_revision_ids[timestamp][revision_id]["user_id"] = user_id
            unique_revision_ids[timestamp][revision_id]["edit_type"] = line["edit_type"]
            unique_revision_ids[timestamp][revision_id]["namespace"] = namespace

        # Range before
        for revision_id, user_id, timestamp, namespace in request_function_and_timestamp_adjusting(cast_timestamp, incremented_cast_timestamp, "older", line, session_for_nearby_revisions):
            unique_revision_ids[timestamp][revision_id]["user_id"] = user_id
            unique_revision_ids[timestamp][revision_id]["edit_type"] = line["edit_type"]
            unique_revision_ids[timestamp][revision_id]["namespace"] = namespace


        if verbose:
            sys.stderr.write("Revisions returned: {0}\n".format(i+1))  
            sys.stderr.flush()


    for timestamp in sorted(unique_revision_ids.keys()):
        for revision_id in unique_revision_ids[timestamp]:
            output_file.write(
                [timestamp, 
                 revision_id,
                 unique_revision_ids[timestamp][revision_id]["user_id"],
                 unique_revision_ids[timestamp][revision_id]["namespace"], 
                 unique_revision_ids[timestamp][revision_id]["edit_type"]])







def request_function_and_timestamp_adjusting(cast_timestamp, 
    adjusted_cast_timestamp, moving, line, session_for_nearby_revisions):
    for user_and_timestamp in session_for_nearby_revisions.get(action="query", format="json", list="usercontribs", uclimit="max", ucstart=cast_timestamp, 
        ucend=adjusted_cast_timestamp, ucdir=moving, ucprop=["timestamp","ids", "title"], ucuserids=[line["user_id"]], continuation=True):
        for line in user_and_timestamp:
            for nearby_revision in user_and_timestamp["query"]["usercontribs"]:

                namespace = extract_revision_namespace(nearby_revision["title"])
                nearby_revision_timestamp = iso8601.parse_date(nearby_revision["timestamp"])
                
                cast_nearby_revision_timestamp = str(nearby_revision_timestamp.year).zfill(4) + str(nearby_revision_timestamp.month).zfill(2) + str(nearby_revision_timestamp.day).zfill(2) + str(nearby_revision_timestamp.hour).zfill(2) + str(nearby_revision_timestamp.minute).zfill(2) + str(nearby_revision_timestamp.second).zfill(2)

                yield nearby_revision["revid"], nearby_revision["userid"], cast_nearby_revision_timestamp, namespace


def extract_revision_namespace(revision_title):
    split_result = revision_title.split(":")
    if len(split_result) > 1:
        namespace = split_result[0]
    elif WIKIDATA_ITEM_RE.match(split_result[0]):
        namespace = "Main"
    else:
        raise RuntimeError("Title was not parsed correctly: {0}".format(revision_title))

    return namespace



main()

