"""
Prints page views for entities.

Usage:
    entity_page_views (-h|--help)
    entity_page_views <aggregated-entity-usage-file>
                      [<dbname-file>]
                      [--page-view-file=<location>]
                      [--dump-host=<url>]
                      [--output=<location>]
                      [--debug] 
                      [--verbose]


Options:
    -h, --help                      This help message is printed
    <aggregated-entity-usage-file>  Aggregated entity usage file.
    <dbname-file>                   Path to json file to process. If no file is 
                                    provided, uses stdin
    --page-view-file=<location>     Path to tsv file to process. If 
                                    no file is provided, uses stdin
                                    [default: /datasets/one-off/pageview_rate/20170607/pageview_rate.20170607.tsv.bz2]
    --dump-host=<url>               If the host is different than the
                                    default Wikimedia host:
                                    [default: https://analytics.wikimedia.org]
    --output=<location>             Where results will be writen.
                                    [default: <stdout>]
    --debug                         Print debug logging to stderr
    --verbose                       Print dots and stuff to stderr  
"""
import logging
import requests
import sys
import json
import bz2
import re
from collections import defaultdict

import docopt

logger = logging.getLogger(__name__)

def main(argv=None):
    args = docopt.docopt(__doc__, argv=argv)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )
    aggregated_entity_usage_file = open(args['<aggregated-entity-usage-file>'])
    if args['<dbname-file>']:
        dbname_file = args['<dbname-file>']
    else:
        logger.info("Reading from <stdin>")
        dbname_file = sys.stdin
    page_view_file = args['--page-view-file']

    if args['--output'] == '<stdout>':
        output = sys.stdout
    else:
        output = open(args['--output'], "w")

    dump_host = args['--dump-host']
    verbose = args['--verbose']

    run(aggregated_entity_usage_file, dbname_file, page_view_file, dump_host, 
        output, verbose)


def run(aggregated_entity_usage_file, dbname_file, page_view_file, dump_host, 
    output, verbose):
    view_dict = defaultdict(lambda: defaultdict(dict))
    wikidb_dict = {}
    entity_values = {}

    if verbose:
        sys.stderr.write("Downloading page views from: " + dump_host +  
            page_view_file + "\n")
        sys.stderr.flush()

    page_view_dump_file = requests.get(dump_host + page_view_file, 
        stream=True)
    if page_view_dump_file.status_code != 200:
        raise RuntimeError("Couldn't download: {0}. {1}"
            .format(dump_host + page_view_file, "HTTP code: " + 
            str(page_view_dump_file.status_code)))
    
    f = bz2.BZ2File(page_view_dump_file.raw)


    if verbose:
        sys.stderr.write("Inserting page views into Python dictionary")
        sys.stderr.flush()


    for i, entry in enumerate(f):
        project, page, views = entry.decode().strip().split("\t")
        if i == 0:
            continue
        view_dict[project][page] = int(views)


        if verbose and i % 1000000 == 0:
            sys.stderr.write(".")
            sys.stderr.flush()
        if i > 10000000:
            break


    if verbose:
        sys.stderr.write("inserting complete\n")
        sys.stderr.flush()


    for line in dbname_file:
        json_line = json.loads(line)
        wikidb_dict[json_line['dbname']] =\
            re.findall(r"https://(.*)\.org",json_line['wikiurl'])[0]


    if verbose:
        sys.stderr.write("Checking each line in aggregated entity usage file " +
            "against page views")
        sys.stderr.flush()


    for i, line in enumerate(aggregated_entity_usage_file):
        json_line = json.loads(line)
        entity_page_view_count = 0


        if verbose and i % 1000000 == 0:
            sys.stderr.write(".")
            sys.stderr.flush()


        for page_id in json_line['unique_page_list']:
            page_id = str(page_id)

            if wikidb_dict[json_line["wikidb"]] not in view_dict:
                logger.warn(" Project \"{0}\" does not have a page view entry"
                .format(wikidb_dict[json_line["wikidb"]]))
                break
            elif page_id not in view_dict[wikidb_dict[json_line["wikidb"]]]:
                logger.warn(" Page id \"{0}\" for project \"{1}\" does not have"
                .format(page_id, wikidb_dict[json_line["wikidb"]]) 
                + " a page view entry")
            else:
                entity_page_view_count +=\
                    view_dict[wikidb_dict[json_line["wikidb"]]][page_id]

        output.write(json.dumps({
            'project' : json_line["wikidb"],
            'entity_id': json_line["entity_id"],
            'page_views': entity_page_view_count,
            'aspect': json_line["aspect"]
        }) + "\n")


    if verbose:
        sys.stderr.write("checking complete\n")
        sys.stderr.flush()

