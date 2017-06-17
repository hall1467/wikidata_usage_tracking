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

