"""
Takes user id and associated timestamp and gives back nearby 
revisions and timestamps (using Mediawiki API). User can specify how "near" (in 
minutes)

Usage:
    nearby_revisions (-h|--help)
    nearby_revisions <input> <output>
                     [--debug]
                     [--verbose]

Options:
    -h, --help  This help message is printed
    <input>     Path to misalignment/edit breakdown file to process.
    <output>    Where output will be written
    --debug     Print debug logging to stderr
    --verbose   Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
import mwapi
import sys
import datetime
import json
import iso8601
from collections import defaultdict
import re


WIKIDATA_ITEM_RE = re.compile(r'^Q\d+')
logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_file = open(args['<input>'], 'rt')


    output_file = open(args['<output>'], "w")

    verbose = args['--verbose']

    run(input_file, output_file, verbose)


def run(input_file, output_file, verbose):

    unique_revision_ids = defaultdict(lambda: defaultdict(dict))
    session_for_nearby_revisions = mwapi.Session("http://wikidata.org")

    for i, line in enumerate(input_file):
        json_line = json.loads(line)

        # Need to convert timestamp and then add and subtract from it
        timestamp_year = int(json_line['timestamp'][0:4])
        timestamp_month = int(json_line['timestamp'][4:6])
        timestamp_day = int(json_line['timestamp'][6:8])
        timestamp_hour = int(json_line['timestamp'][8:10])
        timestamp_minute = int(json_line['timestamp'][10:12])
        timestamp_second = int(json_line['timestamp'][12:14])


        cast_timestamp = datetime.datetime(timestamp_year,
                                           timestamp_month,
                                           timestamp_day,
                                           timestamp_hour,
                                           timestamp_minute,
                                           timestamp_second
                                          )
        
        incremented_cast_timestamp =\
            cast_timestamp + datetime.timedelta(minutes=50000)
        decremented_cast_timestamp =\
            cast_timestamp - datetime.timedelta(minutes=61)
     
        # Range after
        for revision_id, user_id, timestamp, namespace in request_function_and_timestamp_adjusting(cast_timestamp, incremented_cast_timestamp, "newer", json_line, session_for_nearby_revisions):
            unique_revision_ids[timestamp][revision_id]["user_id"] = user_id
            unique_revision_ids[timestamp][revision_id]["edit_type"] = json_line["edit_type"]
            unique_revision_ids[timestamp][revision_id]["namespace"] = namespace

        # Range before
        for revision_id, user_id, timestamp, namespace in request_function_and_timestamp_adjusting(cast_timestamp, incremented_cast_timestamp, "older", json_line, session_for_nearby_revisions):
            unique_revision_ids[timestamp][revision_id]["user_id"] = user_id
            unique_revision_ids[timestamp][revision_id]["edit_type"] = json_line["edit_type"]
            unique_revision_ids[timestamp][revision_id]["namespace"] = namespace


        if verbose:
            sys.stderr.write("Revisions returned: {0}\n".format(i+1))  
            sys.stderr.flush()


    for timestamp in sorted(unique_revision_ids.keys()):
        for revision_id in unique_revision_ids[timestamp]: 
            print(timestamp, revision_id, unique_revision_ids[timestamp][revision_id]["namespace"], unique_revision_ids[timestamp][revision_id]["edit_type"], unique_revision_ids[timestamp][revision_id]["user_id"])


def request_function_and_timestamp_adjusting(cast_timestamp, 
    adjusted_cast_timestamp, moving, json_line, session_for_nearby_revisions):
    for user_and_timestamp in session_for_nearby_revisions.get(action="query", format="json", list="usercontribs", uclimit="max", ucstart=cast_timestamp, 
        ucend=adjusted_cast_timestamp, ucdir=moving, ucprop=["timestamp","ids", "title"], ucuserids=[json_line["user_id"]], continuation=True):
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

