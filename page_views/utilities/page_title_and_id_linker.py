"""
Prints page_names with ids.

Usage:
    page_title_and_id_linker (-h|--help)
    page_title_and_id_linker <date> [<dbname-file>]
                            [--dump-host=<url>]
                            [--processes=<count>]
                            [--output=<location>]
                            [--debug] 
                            [--verbose]


Options:
    -h, --help           This help message is printed
    <dbname-file>        Path to json file to process. If no file is 
                         provided, uses stdin
    <date>               Date when the sql were files were produced. 
                         Format: yyyymmdd
    --dump-host=<url>    If the host is different than the default 
                         Wikimedia host:
                         [default: https://dumps.wikimedia.org]
    --processes=<count>  The number of parallel processes to run.
                         [default: <cpu_count>]
    --output=<location>  Where results will be writen.
                         [default: <stdout>]
    --debug              Print debug logging to stderr
    --verbose            Print dots and stuff to stderr  
"""
import logging
import requests
import sys
import re
import json
import mwxml
import gzip
from collections import defaultdict
from multiprocessing import cpu_count
import para

import docopt

logger = logging.getLogger(__name__)

def main(argv=None):
    args = docopt.docopt(__doc__, argv=argv)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    if args['<dbname-file>']:
        dbname_file = args['<dbname-file>']
    else:
        logger.info("Reading from <stdin>")
        dbname_file = sys.stdin

    if re.match(r"^\d{8}$",args['<date>']):
        date = args['<date>']
    else:
        raise RuntimeError("Please provide a date in the format: yyyymmdd")

    if args['--processes'] == '<cpu_count>':
        processes = cpu_count()
    else:
        processes = int(args['--processes'])

    if args['--output'] == '<stdout>':
        output = sys.stdout
    else:
        output = open(args['--output'], "w")

    dump_host = args['--dump-host']
    verbose = args['--verbose']

    run(dbname_file, date, dump_host, processes, output, verbose)


def run(dbname_file, date, dump_host, processes, output, verbose):

    stub_meta_current_file_urls = determine_file_urls(dbname_file, date, 
                                                      dump_host, verbose)
    parallel_process_groupings(stub_meta_current_file_urls, processes, output, 
                               verbose)


def determine_file_urls(dbname_file, date, dump_host, verbose):

    # Process largest wikis individually
    largest_wikis = ['enwiki', 'esbwiki', 'dewiki', 'frwiki', 'zhwiki',
                     'plwiki', 'ptwiki', 'itwiki', 'ruwiki', 'jawiki']

    stub_meta_current_file_urls = defaultdict(list)

    for line in dbname_file:

        wikidb_dictionary = json.loads(line)

        sub_directory = wikidb_dictionary['dbname'] + "/" + date

        if verbose:
            sys.stderr.write("Downloading html for: " + dump_host + "/" +  
                sub_directory + " in order to determine available files\n")
            sys.stderr.flush()
   
        wiki_dump_file = requests.get(dump_host + "/" + sub_directory)
        if wiki_dump_file.status_code != 200:
            logger.warn(" Couldn't find directory: {0}. {1}"
                .format(dump_host + "/" + sub_directory, "HTTP code: " + 
                str(wiki_dump_file.status_code)))
            continue

        file_names = re.findall(
            r"a href=\".*\"\>(.*stub-meta-current[\d]*\.xml\.gz)</a>",
            wiki_dump_file.text, re.MULTILINE)

        if len(file_names) > 1:
            file_names = re.findall(
                r"a href=\".*\"\>(.*stub-meta-current[\d]+\.xml\.gz)</a>",
                wiki_dump_file.text, re.MULTILINE)

        for file_name in file_names:
            if wikidb_dictionary['dbname'] in largest_wikis:
                stub_meta_current_file_urls[wikidb_dictionary['dbname']]\
                    .append(dump_host + "/" + sub_directory + "/" + file_name)
            else:
                stub_meta_current_file_urls["smaller_wikis"].append(dump_host +
                    "/" + sub_directory + "/" + file_name)
                
    return stub_meta_current_file_urls


def parallel_process_groupings(stub_meta_current_file_urls, processes, output,
                               verbose):

    redirects = defaultdict(lambda: defaultdict(lambda: defaultdict(dict)))
    n_redirects = defaultdict(lambda: defaultdict(lambda: defaultdict(dict)))

    # Output is global in this scope

    def process_pages(file_url):
        # Should be handling 503 errors here eventually
        stub_file_dump = requests.get(file_url,
                                      headers={'user-agent': file_url}, 
                                      stream=True)

        if stub_file_dump.status_code != 200:
            logger.warn("{0} could not be downloaded. {1}"
                .format(file_url, "HTTP code: " + 
                str(stub_file_dump.status_code)))
            yield [], []
        else:
            f = gzip.open(stub_file_dump.raw,"rb")
            stub_file_dump_object = mwxml.Dump.from_file(f)

            namespaces = {}
            for namespace_entries in stub_file_dump_object.site_info.namespaces:
                namespaces[namespace_entries.name] = namespace_entries.id

            for stub_file_page in stub_file_dump_object:
                if stub_file_page.redirect == None:

                    print_linking(output, 
                                  stub_file_dump_object.site_info.dbname, 
                                  stub_file_page.namespace, 
                                  stub_file_page.title, 
                                  False, 
                                  stub_file_page.id)

                    yield [stub_file_dump_object.site_info.dbname, 
                           stub_file_page.namespace, 
                           stub_file_page.title, 
                           stub_file_page.id], []
                else:
                    split_redirect = stub_file_page.redirect.split(":", 1)
                    if len(split_redirect) > 1 and\
                        split_redirect[0] in namespaces:

                        yield [], [stub_file_dump_object.site_info.dbname, 
                                   stub_file_page.namespace, 
                                   stub_file_page.title, 
                                   namespaces[split_redirect[0]], 
                                   split_redirect[1]]
                    else:
                        yield [], [stub_file_dump_object.site_info.dbname, 
                                   stub_file_page.namespace, 
                                   stub_file_page.title, 
                                   0,
                                   stub_file_page.redirect]


    for file_url_grouping in stub_meta_current_file_urls:
        logger.info("Processing {0}. {1} file(s)."
            .format(file_url_grouping, 
                    len(stub_meta_current_file_urls[file_url_grouping])))

        for n_redirect, redirect in para.map(process_pages,
                stub_meta_current_file_urls[file_url_grouping], 
                mappers=processes):

            if n_redirect != []:
                n_redirects[n_redirect[0]][n_redirect[1]][n_redirect[2]] =\
                    n_redirect[3]
            if redirect != []:
                redirects[redirect[0]][redirect[1]][redirect[2]] = [redirect[3], 
                                                                    redirect[4]]

    link_redirects_to_actual_page(redirects, n_redirects, output, verbose)


def link_redirects_to_actual_page(redirects, non_redirects, output, verbose):
    for dbname in redirects:
        for namespace in redirects[dbname]:
            for title in redirects[dbname][namespace]:
                redir_n, redir_t = redirects[dbname][namespace][title]
                if dbname in non_redirects\
                        and redir_n in non_redirects[dbname]\
                        and redir_t in non_redirects[dbname][redir_n]:

                    print_linking(output, 
                                  dbname, 
                                  namespace, 
                                  title, 
                                  True, 
                                  non_redirects[dbname][redir_n][redir_t])
                else:
                    logger.warn("Wiki: {0}, Namespace: {1}, and Title: {2} "
                            .format(dbname, namespace, title)
                            + "redirects to namespace: {0} and title: {1}. "
                            .format(redirects[dbname][namespace][title][1],
                                redirects[dbname][namespace][title][0])
                            + "The redirect does not exist.")
                        
                                    
def print_linking(output, dbname, namespace, title, redirect, page_id):
    # print(output)
    output.write(json.dumps(
        {
            'dbname' : dbname,
            'namespace' : namespace,
            'title' : title,
            'redirect': redirect,
            'page_id': page_id
        }) + "\n")

