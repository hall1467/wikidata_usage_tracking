"""
Downloads page view dump data for specified range of dates

Usage:
    page_view_dump_downloader (-h|--help)
    page_view_dump_downloader --start_year=<dddd> --start_month=<mm> --end_year=<dddd> --end_month=<mm> --results-directory=<directory_path>


Options:
    -h, --help                              This help message is printed
    --start_year=<dddd>                     Start year of range in form: yyyy
    --start_month=<mm>                      Start month of range in form: mm
    --end_year=<dddd>                       End year of range in form: yyyy
    --end_month=<mm>                        End month of range in form: mm
    --results-directory=<directory_path>    Directory where results will go         

"""

import docopt
import subprocess
import shlex
import sys

def main():
    args = docopt.docopt(__doc__)
    start_year = str(args['--start_year'])
    start_month = str(args['--start_month'])
    start_day = str(args['--start_day']) if '--start_day' in args else "0"
    start_hour = str(args['--start_hour']) if '--start_hour' in args else "0"
    end_year = str(args['--end_year'])
    end_month = str(args['--end_month'])
    end_day = str(args['--end_day']) if '--end_day' in args else "0"
    end_hour = str(args['--end_hour']) if '--end_hour' in args else "0"
    results_directory=args['--results-directory']

    if(int(start_year + start_month + start_day + start_hour) > 
       int(end_year + end_month + end_day + end_hour)):
        raise RuntimeError("Please specify a start date before the end date")

    

    subprocess.check_output(shlex.split("wget -r --no-parent --reject html -nd \
                                        -P " + results_directory +
                                        " https://dumps.wikimedia.org/other/pageviews/"
                                        + start_year + "/" + start_year + "-" +
                                        start_month + "/"))
    #want to only get project views
    #want to write to a log
    #do wget -r with --accept-regex > <

















main()











