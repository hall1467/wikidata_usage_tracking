"""
Takes lat lon item data and obtain US county FIP if it's in the US.


Usage:
    obtain_county_from_latlon (-h|--help)
    obtain_county_from_latlon <input> <state> <county> <output>
                              [--debug]
                              [--verbose]

Options:
    -h, --help  This help message is printed
    <input>     Path to edit file to process.
    <state>     Path to state geojson file to process.
    <county>    Path to county geojson file to process.
    <output>    Where output will be written
    --debug     Print debug logging to stderr
    --verbose   Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
import mysqltsv
import sys
import json
import csv

from shapely.wkt import loads
from shapely.geometry import shape
from shapely.geometry import box


logger = logging.getLogger(__name__)

def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_file = mysqltsv.Reader(open(args['<input>'],
        'rt', encoding='utf-8', errors='replace'), headers=True,
        types=[str, str, str, str, str])


    states_gj = json.load(open(args['<state>'], 'r'))
    counties_gj = json.load(open(args['<county>'], 'r'))


    output_file = mysqltsv.Writer(
        open(args['<output>'], "w"), 
        headers=[
                 'page_title',
                 'coordinate_location',
                 'latitude',
                 'longitude',
                 'iso_country_code',
                 'fip'])

    verbose = args['--verbose']

    run(input_file, states_gj, counties_gj, output_file, verbose)


def run(input_file, states_gj, counties_gj, output_file, verbose):


    counties = {}
    for state in states_gj['features']:
        west, south, east, north = shape(state['geometry']).bounds
        counties[state['properties']['FIPS'][:2]] = {'bb':box(west, south, east, north), 'counties':{}}
    for region in counties_gj['features']:
        state_fips = region['properties']['FIPS'][:2]
        counties[state_fips]['counties'][region['properties']['FIPS']] = shape(region['geometry'])
    del(counties_gj)
    del(states_gj)


    eastUS = -66.885444
    westUS = -124.848974
    northUS = 49.384358
    southUS = 24.396308
    boundingboxUS = box(westUS, southUS, eastUS, northUS)

    total_points = 0
    points_in_US = 0
    count_lines = 0

    for i, line in enumerate(input_file):

        count_lines += 1
        lat = line['latitude']
        lon = line['longitude']
        county = None

        try:
            pt = loads('POINT ({0} {1})'.format(lon, lat))
            # print(pt)
            total_points += 1

            if boundingboxUS.contains(pt):
                for state in counties:
                    if counties[state]['bb'].contains(pt):
                        for fips in counties[state]['counties']:
                            if counties[state]['counties'][fips].contains(pt):
                                county = fips
                                points_in_US += 1
                                break

        except Exception as e:
            print(e)
            print(line['page_title'], lat, lon)

        output_file.write([
            line['page_title'],
            line['coordinate_location'],
            line['latitude'],
            line['longitude'],
            line['iso_country_code'],
            county])


        if total_points % 10000 == 0:
            print ("{0} of {1} points in US and {2} lines in.".format(points_in_US, total_points, count_lines))

    print("{0} of {1} in the US out of {2} total lines.".format(points_in_US, total_points, count_lines))    


main()

