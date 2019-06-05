"""
Takes coordinate location item data and determines country code in new column.
Filters out locations without proper point.


Usage:
    obtain_country_code (-h|--help)
    obtain_country_code <input> <output>
                        [--debug]
                        [--verbose]

Options:
    -h, --help        This help message is printed
    <input>           Path to edit file to process.
    <output>          Where output will be written
    --debug           Print debug logging to stderr
    --verbose         Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
import mysqltsv
import sys
import reverse_geocoder
import re


logger = logging.getLogger(__name__)

def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_file = mysqltsv.Reader(open(args['<input>'],
        'rt', encoding='utf-8', errors='replace'), headers=False,
        types=[str, str])

    input_file_second_iteration = mysqltsv.Reader(open(args['<input>'],
        'rt', encoding='utf-8', errors='replace'), headers=False,
        types=[str, str])

    output_file = mysqltsv.Writer(
        open(args['<output>'], "w"), 
        headers=[
                 'page_title',
                 'coordinate_location',
                 'latitude',
                 'longitude',
                 'iso_country_code'])

    verbose = args['--verbose']

    run(input_file, input_file_second_iteration, output_file, verbose)


def run(input_file, input_file_second_iteration, output_file, verbose):


    lat_lon_input_list = []
    list_of_non_proper_points = {}
    lat_lon_data_store = []

    for i, line in enumerate(input_file):

        proper_pt = re.match("Point\((.+) (.+)\)", line[1])

        if proper_pt:

            parsed_longitude = proper_pt.group(1)
            parsed_latitude = proper_pt.group(2)

            lat_lon_input_list.append((parsed_latitude, parsed_longitude))

            lat_lon_data_store.append({'latitude' : parsed_latitude,
                                       'longitude' : parsed_longitude})

        else:
            # Adding point as 0, 0 in list since we want this list to be same
            # size as input file.
            lat_lon_input_list.append((0, 0))
            list_of_non_proper_points[i] = 1

            lat_lon_data_store.append({'latitude' : 'NA',
                                       'longitude' : 'NA'})


        if verbose and i % 100000 == 0 and i != 0:
            sys.stderr.write("Iteration 1 Processing items: {0}\n".format(i))  
            sys.stderr.flush()


    lat_lon_results = reverse_geocoder.search(lat_lon_input_list)

    for i, line in enumerate(input_file_second_iteration):
        
        if i not in list_of_non_proper_points:
            output_file.write([
                line[0],
                line[1],
                lat_lon_data_store[i]['latitude'],
                lat_lon_data_store[i]['longitude'],
                lat_lon_results[i]['cc']])


        if verbose and i % 100000 == 0 and i != 0:
            sys.stderr.write("Iteration 2 Processing items: {0}\n".format(i))  
            sys.stderr.flush()


main()

