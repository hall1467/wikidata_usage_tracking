"""
Aggregates entity_aspect_project_page_views returned from "entity_page_views". 
Aggregates down to either entity_project_page_views or entity_page_views or both
. One must be specified.

Usage:
    entity_page_view_aggregator (-h|--help)
    entity_page_view_aggregator 
                                [<un-aggregated-file>]
                                [--entity-proj-view-file=<location>]
                                [--entity-view-file=<location>]
                                [--debug] 
                                [--verbose]


Options:
    -h, --help                          This help message is printed
    <un-aggregated-file>                Path to entity aspect project 
                                        page views json file. If no file 
                                        is provided, uses stdin
    --entity-proj-view-file=<location>  Where entity project page view 
                                        results will be writen.
    --entity-view-file=<location>       Where entity page view results 
                                        will be writen.
    --debug                             Print debug logging to stderr
    --verbose                           Print dots and stuff to stderr  
"""
import logging
import sys
import json
from collections import defaultdict

import docopt

logger = logging.getLogger(__name__)

def main(argv=None):
    args = docopt.docopt(__doc__, argv=argv)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    if args['<un-aggregated-file>']:
        un_aggregated_file = args['<un-aggregated-file>']
    else:
        logger.info("Reading from <stdin>")
        un_aggregated_file = sys.stdin

    if args['--entity-proj-view-file']:
        entity_proj_view_file = open(args['--entity-proj-view-file'], "w")
    else:
        entity_proj_view_file = None

    if args['--entity-view-file']:
        entity_view_file = open(args['--entity-view-file'], "w")
    else:
        entity_view_file = None

    if not args['--entity-proj-view-file'] and\
       not args['--entity-view-file']:
           raise RuntimeError("Please specify at least one aggregation file.")

    verbose = args['--verbose']

    run(un_aggregated_file, entity_proj_view_file, entity_view_file, verbose)


def run(un_aggregated_file, entity_proj_view_file, entity_view_file, verbose):

    entity_proj_view_dict = defaultdict(lambda: defaultdict(dict))
    entity_view_dict = defaultdict(int)
    entity_view_counted_dict = defaultdict(dict)

    for i, line in enumerate(un_aggregated_file):
        json_line = json.loads(line)

        entity_id = json_line['entity_id']
        proj = json_line['project']
        views = json_line['page_views']

        if verbose and i % 1000000 == 0:
            sys.stderr.write(".")
            sys.stderr.flush()

        if entity_proj_view_file:
            entity_proj_view_dict[entity_id][proj] = views

        if entity_view_file and proj not in entity_view_counted_dict[entity_id]:
            entity_view_counted_dict[entity_id][proj] = True
            entity_view_dict[entity_id] += views


    if entity_proj_view_file:
        for entity_id in entity_proj_view_dict:
            for proj in entity_proj_view_dict[entity_id]:

                entity_proj_view_file.write(json.dumps({
                    'project' : proj,
                    'entity_id': entity_id,
                    'page_views': entity_proj_view_dict[entity_id][proj]
                }) + "\n")



    if entity_view_file:
       for entity_id in entity_view_dict:

           entity_view_file.write(json.dumps({
               'entity_id': entity_id,
               'page_views': entity_view_dict[entity_id]
           }) + "\n")


































































    # view_dict = defaultdict(lambda: defaultdict(dict))
    # wikidb_dict = {}
    # entity_values = {}

    # f = bz2.open(page_view_file)


    # if verbose:
    #     sys.stderr.write("Inserting page views into Python dictionary")
    #     sys.stderr.flush()


    # for i, entry in enumerate(f):

    #     if i == 0:
    #         continue

    #     entry_list = entry.decode().strip().split("\t")
    #     if len(entry_list) != 3:
    #         logger.warn(" Page view entry \"{0}\" improperly formatted"
    #         .format(entry.decode().strip()))
    #         continue

    #     project, page, views = entry_list
    #     view_dict[project][page] = int(views)


    #     if verbose and i % 1000000 == 0:
    #         sys.stderr.write(".")
    #         sys.stderr.flush()


    # if verbose:
    #     sys.stderr.write("inserting complete\n")
    #     sys.stderr.flush()


    # for line in dbname_file:
    #     json_line = json.loads(line)
    #     wikidb_dict[json_line['dbname']] =\
    #         re.findall(r"https://(www\.)?(.*)\.org",json_line['wikiurl'])[0][1]

    # if verbose:
    #     sys.stderr.write("Checking each line in aggregated entity usage file " +
    #         "against page views")
    #     sys.stderr.flush()


    # for i, line in enumerate(aggregated_entity_usage_file):
    #     json_line = json.loads(line)
    #     entity_page_view_count = 0


    #     if verbose and i % 1000000 == 0:
    #         sys.stderr.write(".")
    #         sys.stderr.flush()


    #     for page_id in json_line['unique_page_list']:
    #         page_id = str(page_id)

    #         if wikidb_dict[json_line["wikidb"]] not in view_dict:
    #             logger.warn("Project \"{0}\" does not have a page view entry"
    #             .format(wikidb_dict[json_line["wikidb"]]))
    #             break
    #         elif page_id not in view_dict[wikidb_dict[json_line["wikidb"]]]:
    #             logger.warn("Page id \"{0}\" for project \"{1}\" does not have"
    #             .format(page_id, wikidb_dict[json_line["wikidb"]]) 
    #             + " a page view entry")
    #         else:
    #             entity_page_view_count +=\
    #                 view_dict[wikidb_dict[json_line["wikidb"]]][page_id]

    #     output.write(json.dumps({
    #         'project' : json_line["wikidb"],
    #         'entity_id': json_line["entity_id"],
    #         'page_views': entity_page_view_count,
    #         'aspect': json_line["aspect"]
    #     }) + "\n")


    # if verbose:
    #     sys.stderr.write("checking complete\n")
    #     sys.stderr.flush()

