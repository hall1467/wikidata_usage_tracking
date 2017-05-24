"""
Prints page_names with ids.

Usage:
    page_title_and_id_linker (-h|--help)
    page_title_and_id_linker <date> [<dbname-file>]
                            [--dump-host=<url>]
                            [--debug] 
                            [--verbose]


Options:
    -h, --help         This help message is printed
    <dbname-file>      Path to json file to process. If no file is 
                       provided, uses stdin
    <date>             Date when the sql were files were produced. 
                       Format: yyyymmdd
    --dump-host=<url>  If the host is different than the default 
                       Wikimedia host:
                       [default: https://dumps.wikimedia.org]
    --debug            Print debug logging to stderr
    --verbose          Print dots and stuff to stderr  
"""



import logging
import requests
import sys
import re
import json
import mwxml
import gzip
from collections import defaultdict

import docopt

logger = logging.getLogger(__name__)

def main(argv=None):
    args = docopt.docopt(__doc__, argv=argv)
    logging.basicConfig(
        level=logging.WARNING if not args['--debug'] else logging.DEBUG,
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
        raise RuntimeError("Please provide a data in the format: yyyymmdd")

    dump_host = args['--dump-host']
    verbose=args['--verbose']

    run(dbname_file, date, dump_host, verbose)


def run(dbname_file, date, dump_host, verbose):
    for line in dbname_file:

        wikidb_dictionary = json.loads(line)

        redirects = defaultdict(dict)
        non_redirects = defaultdict(dict)
        namespace_names = {}

        sub_directory = wikidb_dictionary['dbname'] + "/" + date
        stub_file_name = wikidb_dictionary['dbname'] + "-" + date + "-" +\
            "stub-meta-current.xml.gz"

        stub_file_dump = requests.get(dump_host + "/" +
            sub_directory + "/" + stub_file_name, stream=True)
        if stub_file_dump.status_code != 200:
            logger.warn("{0} could not be downloaded. {1}"
                .format(stub_file_name, "HTTP code: " + 
                str(stub_file_dump.status_code)))
            continue

        #Now we process the stream, parsing xml using mwxml 

        f = gzip.open(stub_file_dump.raw,"rb")
        stub_file_dump_object = mwxml.Dump.from_file(f)

        # Extract namespace names
        for namespace in stub_file_dump_object.site_info.namespaces:
            namespace_names[namespace.id] = namespace.name


        for stub_file_page in stub_file_dump_object:
            # print("HERE")
            namespace_and_title_string =\
                create_namespace_and_title_string(namespace_names, 
                                                  stub_file_page.namespace, 
                                                  stub_file_page.title)
            if stub_file_page.redirect == None:
                non_redirects[namespace_and_title_string] = stub_file_page.id
                print_linking(wikidb_dictionary['dbname'], 
                              namespace_and_title_string, 
                              False, 
                              stub_file_page.id)
            else:
                redirects[namespace_and_title_string] = stub_file_page.redirect

        for namespace_and_title in redirects:
            if redirects[namespace_and_title] in non_redirects:
                print_linking(wikidb_dictionary['dbname'], 
                              namespace_and_title, 
                              True, 
                              non_redirects[redirects[namespace_and_title]])
            else:
                logger.warn("The redirect \"" + redirects[namespace_and_title] +
                    "\" for \"" + namespace_and_title +"\" does not appear to "
                    + "be a page.")


def print_linking(dbname, namespace_and_title, redirect, page_id):
    sys.stdout.write(json.dumps(
        {
            'dbname' : dbname,
            'namespace_and_title': namespace_and_title,
            'redirect': redirect,
            'page_id': page_id
        }) + "\n")


def create_namespace_and_title_string(namespace_names, namespace, title):
    if namespace == 0:
        return title
    else:
        return namespace_names[namespace] + ":" + title




















    # current_year = start_year
    # current_month = start_month
    # current_day = start_day
    # current_hour = start_hour
    # list_of_file_url_information = []

    # while int(str(current_year)+str(current_month).zfill(2)) <=\
    #     int(str(end_year)+str(end_month).zfill(2)):

    #     sub_directory = "/other/pageviews/" + str(current_year) + "/" +\
    #         str(current_year) + "-" + str(current_month).zfill(2) + "/"


    #     if verbose:
    #         sys.stderr.write("Downloading html for: " + dump_host + 
    #             sub_directory + " in order to determine available files\n")
    #         sys.stderr.flush()

    #     pageview_current_month_file = requests.get(dump_host + sub_directory)
    #     if pageview_current_month_file.status_code != 200:
    #         logger.warn("Couldn't find directory {0}. {1}"
    #             .format(dump_host + sub_directory, "HTTP code: " + 
    #             str(pageview_current_month_file.status_code)))
    #     else:
    #         file_names = re.findall(r"a href=\"pageviews[^>]+>(.*)</a>",
    #             pageview_current_month_file.text, re.MULTILINE)
    #         for file_name in file_names:
    #             file_year, file_month, file_day, file_hour =\
    #                 re.findall(
    #                     r"pageviews-(\d\d\d\d)(\d\d)(\d\d)-(\d\d)\d\d\d\d\.gz",
    #                     file_name)[0]
                
    #             if int(str(current_day)+str(current_hour).zfill(2)) <=\
    #                 int(str(end_day)+str(end_hour).zfill(2)):
    #                 list_of_file_url_information.append(
    #                     {"file_name" : file_name,
    #                      "file_url" : dump_host + sub_directory + file_name}) 


    #     if current_month == 12:
    #         current_month = 1
    #         current_year += 1
    #     else:
    #         current_month += 1

    # # Write files to directory specified
    # for file_url_information in list_of_file_url_information:
    #     if verbose:
    #         sys.stderr.write("Downloading data for: " + 
    #             file_url_information['file_url'] + " into " + 
    #             download_directory + "\n")
    #         sys.stderr.flush()

    #     file_dump = requests.get(file_url_information['file_url'], stream=True)
    #     if file_dump.status_code != 200:
    #         logger.warn("Could not download dump at {0}. {1}"
    #             .format(file_url_information['file_url'], "HTTP code: " + 
    #             str(file_dump.status_code)))
    #         continue

    #     output_f = open(download_directory + "/" + 
    #         file_url_information['file_name'], "wb")
    #     for entry in file_dump.raw:
    #         output_f.write(entry)
    #     output_f.close()
        





# """
# Given json containing wiki(s), downloads corresponding Wikibase entity usage 
# dump sql files.

# Usage:
#     download_entity_usage (-h|--help)
#     download_entity_usage <date> <download-directory> [<db-name-file>]
#                           [--dump-host=<url>]
#                           [--not-gzip-compressed]
#                           [--debug]
#                           [--verbose]



# Options:
#     -h, --help             This help message is printed
#     <date>                 Date when the sql were files were produced. 
#                            Format: yyyymmdd
#     <download-directory>   Directory where downloads are placed
#     <db-name-file>         Path to json file to process. If no file is 
#                            provided, uses stdin
#     --dump-host=<url>      If the host is different than the default 
#                            Wikimedia host:
#                            [default: https://dumps.wikimedia.org]
#     --not-gzip-compressed  Set this flag if files at dump host are not 
#                            compressed
#     --debug                Print debug logging to stderr
#     --verbose              Print dots and stuff to stderr      
# """

# import logging
# import json
# import sys
# import requests
# import gzip
# import re

# import docopt

# logger = logging.getLogger(__name__)


# def main(argv=None):
#     args = docopt.docopt(__doc__, argv=argv)
#     logging.basicConfig(
#         level=logging.WARNING if not args['--debug'] else logging.DEBUG,
#         format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
#     )

#     if args['<db-name-file>']:
#         json_file = args['<db-name-file>']
#     else:
#         logger.info("Reading from <stdin>")
#         json_file = sys.stdin

    
#     if re.match(r"^\d\d\d\d\d\d\d\d$",args['<date>']):
#         date = args['<date>']
#     else:
#         raise RuntimeError("Please provide a data in the format: yyyymmdd")

#     download_directory = args['<download-directory>']
#     dump_host = args['--dump-host']

#     if args['--not-gzip-compressed']:
#         gzip_compression_extension = ""
#     else:
#         gzip_compression_extension = ".gz"

#     verbose = args['--verbose']

#     run(json_file, download_directory, date, dump_host, 
#         gzip_compression_extension, verbose)


# def run(json_file, download_directory, date, dump_host,
#     gzip_compression_extension, verbose):

#     if isinstance(json_file, str):
#         logger.debug("Opening {0}".format(json_file))
#         f = open(json_file, 'rt')
#     else:
#         logger.debug("Reading from {0}".format(json_file))
#         f = json_file

#     for line in f:

#         wikidb_dictionary = json.loads(line)
        
#         sql_file_name = wikidb_dictionary['dbname'] + "-" + date + \
#             "-wbc_entity_usage.sql"

#         dump_host_and_directory =\
#             dump_host + "/" + wikidb_dictionary['dbname'] + "/" + date

#         if verbose:
#             sys.stderr.write("Downloading data for: " + 
#                 wikidb_dictionary['dbname'] + "\n")
#             sys.stderr.flush()

#         dump = requests.get(dump_host_and_directory + "/" + sql_file_name + 
#             gzip_compression_extension, stream=True)

#         if dump.status_code != 200:
#             logger.warn("Skipping (possibly non-existent) dump for {0}. {1}"
#                 .format(wikidb_dictionary['dbname'], "HTTP code: " + 
#                 str(dump.status_code)))
#             continue

#         output_f = open(download_directory + "/" + sql_file_name, "w")
#         for entry in gzip.open(dump.raw):
#             output_f.write(entry.decode())
#         output_f.close()








