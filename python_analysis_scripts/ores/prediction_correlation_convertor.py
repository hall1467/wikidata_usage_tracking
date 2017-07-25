"""
Converts TSV of predictions into format for analyses.

Usage:
    prediction_correlation_convertor (-h|--help)
    prediction_correlation_convertor --input=<location> --output=<location>


Options:
    -h, --help                      This help message is printed
    --input=<location>              Path to tsv file to process.
    --output=<location>             Where results will be writen.
"""


import docopt
import json
import sys
import mysqltsv

def main(argv=None):
    args = docopt.docopt(__doc__)

    input_file = mysqltsv.Reader(open(args['--input']), headers=False,
        types=[str, int, int, str])


    output_file = mysqltsv.Writer(open(args['--output'], "w"))
    run(input_file, output_file)


def run(input_file, output_file):
    for line in input_file:

        score = line[3]

        if score == 'A':
            ordinal_column = 5
        elif score == 'B':
            ordinal_column = 4
        elif score == 'C':
            ordinal_column = 3
        elif score == 'D':
            ordinal_column = 2
        elif score == 'E':
            ordinal_column = 1
        else:
            raise RuntimeError("Unknown score")


        output_file.write([line[0],line[1],line[2],line[3],ordinal_column])


main()

