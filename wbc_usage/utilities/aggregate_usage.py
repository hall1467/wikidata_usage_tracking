"""
I AM DOCOPT
"""
import logging
from collections import defaultdict

import docopt

logger = logging.getLogger(__name__)


def main(argv=None):
    args = docopt.docopt(__doc__, argv=argv)
    logging.basicConfig(
        level=logging.WARNING if not args['--debug'] else logging.DEBUG,
        format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
    )


def run(usages):
    entity_counts = defaultdict(lambda: defaultdict(set))

    # usage looks like: {"page_id": 712, "aspect": "X",
    #                    "entity_id": "Q16533356", "wikidb": "plwiki"}
    for usage in usages:
        record = entity_counts[usage['entity_id']][usage['aspect']]
        record['pages'].add((usage['wikidb'], usage['page_id']))
        record['wikis'].add(usage['wikidb'])
