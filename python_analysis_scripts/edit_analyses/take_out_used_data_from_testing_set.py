"""
Takes random session data file used to build model and the one used for testing.
Returns only test data that is not also used to build the model.



Usage:
    take_out_used_data_from_testing_set (-h|--help)
    take_out_used_data_from_testing_set <input_building_data> <input_testing_data> <output>
                                        [--debug]
                                        [--verbose]

Options:
    -h, --help             This help message is printed
    <input_building_data>  Path to input model building data file to 
                           process.
    <input_testing_data>   Path to input testing data file to 
                           process.                             
    <output>               Where output will be written
    --debug                Print debug logging to stderr
    --verbose              Print dots and stuff to stderr  
"""


import docopt
import logging
import operator
import sys
from collections import defaultdict
import mysqltsv


logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__)
    logging.basicConfig(
        level=logging.INFO if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )

    input_building_data_file = mysqltsv.Reader(
        open(args['<input_building_data>'],'rt'), headers=False, 
        types=[str, str, str, str, str])

    input_testing_data_file = mysqltsv.Reader(
        open(args['<input_testing_data>'],'rt'), headers=False, 
        types=[str, str, str, str, str])


    output_file = mysqltsv.Writer(open(args['<output>'], "w"))

    verbose = args['--verbose']

    run(input_building_data_file, input_testing_data_file, 
        output_file, verbose)


def run(input_building_data_file, input_testing_data_file, 
    output_file, verbose):
    
    random_building_sessions = defaultdict(lambda: defaultdict(int))


    for i, line in enumerate(input_building_data_file):
        random_building_sessions[line[0]][line[1]] = 1


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Building sessions returned: {0}\n".format(i))  
            sys.stderr.flush()

    for i, line in enumerate(input_testing_data_file):
        if line[0] in random_building_sessions and\
            line[1] in random_building_sessions[line[0]]:
        
            random_testing_sessions[line[0]][line[1]] = 1


            output_file.write(
                [line[0],
                 line[1],
                 line[2],
                 line[3],
                 line[4]])


        if verbose and i % 10000 == 0 and i != 0:
            sys.stderr.write("Testing sessions compared: {0}\n".format(i))  
            sys.stderr.flush()



main()

