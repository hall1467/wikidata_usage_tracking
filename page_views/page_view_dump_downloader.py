"""
Downloads page view dump data for specified range of dates

Usage:
    page_view_dump_downloader (-h|--help)
    page_view_dump_downloader --start_year=<dddd>
                              --start_month=<mm>
                              --end_year=<dddd>
                              --end_month=<mm>
                              --output=<output_directory>


Options

"""

import docopt
import subprocess
import shlex
import sys

def main():
    args = docopt.docopt(__doc__)
    start_year = args['--start_year']
    start_month = args['--start_month']
    start_day = args['--start_day'] if '--start_day' in args else None
    start_hour = args['--start_hour'] if '--start_hour' in args else None
    end_year = args['--end_year']
    end_month =args['--end_month']
    end_day = args['--end_day'] if '--end_day' in args else None
    end_hour = args['--end_hour'] if '--end_hour' in args else None
    output_directory=args['--output']

    if(int(start_year > int(end_year):
        raise RuntimeError("Please specify a start date before the end date")

    

    subprocess.check_output(shlex.split("wget -r --no-parent --reject html -nd \
                                        -P " + output_directory +
                                        " https://dumps.wikimedia.org/other/pageviews/"
                                        + start_year + "/" + start_year + "-" +
                                        start_month + "/"))

















main()











