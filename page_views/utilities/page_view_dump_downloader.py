"""
Downloads page view dump data for specified range of dates.

Usage:
    page_view_dump_downloader (-h|--help)
    page_view_dump_downloader <download-directory> --start-year=<yyyy> --end-year=<yyyy>
                              [--start-month=<mm>]
                              [--start-day=<dd>]
                              [--start-hour=<hh>]
                              [--end-month=<mm>]
                              [--end-day=<dd>]
                              [--end-hour=<hh>]
                              [--dump-host=<url>]
                              [--debug]
                              [--verbose]



Options:
    -h, --help            This help message is printed
    <download-directory>  Directory where results will go.
    --start-year=<yyyy>   Start year of range in form: yyyy
    --start-month=<mm>    Start month of range in form: mm
    --start-day=<dd>      Start day of range in form: dd
    --start-hour=<hh>     Start hour of range in form: hh
    --end-year=<yyyy>     End year of range in form: yyyy
    --end-month=<mm>      End month of range in form: mm
    --end-day=<dd>        End day of range in form: dd
    --end-hour=<hh>       End hour of range in form: hh
    --dump-host=<url>     If the host is different than the default 
                          Wikimedia host [default: https://dumps.wikimedia.org]
    --debug               Print debug logging to stderr
    --verbose             Print dots and stuff to stderr  
"""



import logging
import sys
import requests
import re

import docopt

logger = logging.getLogger(__name__)

def main(argv=None):
    args = docopt.docopt(__doc__, argv=argv)
    logging.basicConfig(
        level=logging.WARNING if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )


    download_directory = str(args['<download-directory>'])
    start_year = int(args['--start-year'])
    start_month = int(args['--start-month']) if args['--start-month'] else 1
    start_day = int(args['--start-day']) if args['--start-day'] else 1
    start_hour = int(args['--start-hour']) if args['--start-hour'] else 0
    end_year = int(args['--end-year'])
    end_month = int(args['--end-month']) if args['--end-month'] else 12
    end_day = int(args['--end-day']) if args['--end-day'] else 31
    end_hour = int(args['--end-hour']) if args['--end-hour'] else 23
    dump_host = args['--dump-host']
    verbose=args['--verbose']

    start_time = int(str(start_year) + str(start_month).zfill(2) +
        str(start_day).zfill(2) + str(start_hour).zfill(2))
    end_time = int(str(end_year) + str(end_month).zfill(2) +
        str(end_day).zfill(2) + str(end_hour).zfill(2))  

    if start_time > end_time:
        raise RuntimeError("The start date should occur before the end date")

 
    run(download_directory, start_time, end_time, dump_host, verbose)

def run(download_directory, start_time, end_time, dump_host, verbose):

    current_year = int(str(start_time)[0:4])
    current_month = int(str(start_time)[4:6])
    list_of_file_url_information = []

    while int(str(current_year)+str(current_month).zfill(2)) <=\
        int(str(end_time)[0:4]+str(end_time)[4:6]):

        sub_directory = "/other/pageviews/" + str(current_year) + "/" +\
            str(current_year) + "-" + str(current_month).zfill(2) + "/"


        if verbose:
            sys.stderr.write("Downloading html for: " + dump_host + 
                sub_directory + " in order to determine available files\n")
            sys.stderr.flush()

        pageview_current_month_file = requests.get(dump_host + sub_directory)
        if pageview_current_month_file.status_code != 200:
            logger.warn("Couldn't find directory {0}. {1}"
                .format(dump_host + sub_directory, "HTTP code: " + 
                str(pageview_current_month_file.status_code)))
        else:
            file_names = re.findall(r"a href=\"pageviews[^>]+>(.*)</a>",
                pageview_current_month_file.text, re.MULTILINE)
            for file_name in file_names:
                file_year, file_month, file_day, file_hour =\
                    re.findall(
                        r"pageviews-(\d\d\d\d)(\d\d)(\d\d)-(\d\d)\d\d\d\d\.gz",
                        file_name)[0]
                
                file_time = int(str(file_year) + str(file_month).zfill(2) + 
                    str(file_day).zfill(2) + str(file_hour).zfill(2))  
                
                if file_time >= start_time and file_time <= end_time:
                    list_of_file_url_information.append(
                        {"file_name" : file_name,
                         "file_url" : dump_host + sub_directory + file_name}) 


        if current_month == 12:
            current_month = 1
            current_year += 1
        else:
            current_month += 1

    # Write files to directory specified
    for file_url_information in list_of_file_url_information:
        if verbose:
            sys.stderr.write("Downloading data for: " + 
                file_url_information['file_url'] + " into " + 
                download_directory + "\n")
            sys.stderr.flush()

        file_dump = requests.get(file_url_information['file_url'], stream=True)
        if file_dump.status_code != 200:
            logger.warn("Could not download dump at {0}. {1}"
                .format(file_url_information['file_url'], "HTTP code: " + 
                str(file_dump.status_code)))
            continue

        output_f = open(download_directory + "/" + 
            file_url_information['file_name'], "wb")
        for entry in file_dump.raw:
            output_f.write(entry)
        output_f.close()
        











