"""
Converts json returned from ORES command line utility to a format where the
predicted quality rating is not in a nested json object.

Usage:
    entity_page_views (-h|--help)
    entity_page_views --input=<location> --output=<location>


Options:
    -h, --help                      This help message is printed
    --input=<location>              Path to json file to process.
    --output=<location>             Where results will be writen.
                                    [default: <stdout>] 
"""


import docopt
import json
import sys

def main(argv=None):
    args = docopt.docopt(__doc__)
    #, argv=argv

    input_file = open(args['--input'])

    if args['--output'] == '<stdout>':
        output_file = sys.stdout
    else:
        output_file = open(args['--output'], "w")
    run(input_file, output_file)


def run(input_file, output_file):
    for line in input_file:
        
        json_line = json.loads(line)
        output_line = {}

        for entry_key in json_line:
            if entry_key == 'score':
                score =\
                    json_line[entry_key]['item_quality']['score']['prediction']
                output_line[entry_key] = score

                if score == 'A':
                    output_line['ordinal_score'] = 5
                elif score == 'B':
                    output_line['ordinal_score'] = 4
                elif score == 'C':
                    output_line['ordinal_score'] = 3
                elif score == 'D':
                    output_line['ordinal_score'] = 2
                elif score == 'E':
                    output_line['ordinal_score'] = 1
                else:
                    raise RuntimeError("Unknown score")

            else:
                output_line[entry_key] = json_line[entry_key]

        output_file.write(json.dumps(output_line) + "\n")


main()

