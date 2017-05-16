"""

Code to extract Wikidata "object" (item or statement) usages.
Also provides functionality for handling storage of these usages.

"""

import ast
import re
from collections import OrderedDict

INSERT_LINE_RE = re.compile(r"INSERT INTO `wbc_entity_usage` VALUES ")
# (305,'Q11686834','X',403,'\0\0\0\0\0\0\0\0\0\0\0\0\0\0')
RECORD_RE = re.compile(r"\(([0-9]+),'([^']*)','([^']*)',([0-9]+),'([^']*)'\)")
DB_LINE_RE = re.compile(r"^-- Host:.*Database: ")


class WikibaseClientUsage:
    __slots__ = ('wikidb', 'entity_id', 'aspect', 'page_id')

    def __init__(self, wikidb, entity_id, aspect, page_id):
        self.wikidb = str(wikidb)
        self.entity_id = str(entity_id)
        self.aspect = str(aspect)
        self.page_id = int(page_id)

    def __hash__(self):
        return hash((self.wikidb, self.entity_id, self.aspect, self.page_id))

    def to_json(self):
        return OrderedDict(wikidb=self.wikidb,
                           entity_id=self.entity_id,
                           aspect=self.aspect,
                           page_id=self.page_id)

    @classmethod
    def from_match(cls, match, dbname=None):
        return cls(dbname, match.group(2), match.group(3), match.group(4))


class WikibaseClientDump:

    def __init__(self, dbname, usages):
        self.dbname = dbname
        self.usages = usages

    @classmethod
    def from_sql_file(cls, f):
        dbname = None
        for line in f:
            if DB_LINE_RE.match(line):
                dbname = re.sub(".*Database: ", "", line).rstrip()
                break

        usages = extract_usages(f, dbname)

        return cls(dbname, usages)


def extract_usages(f, dbname):
    """ Extract Wikidata object usages in wiki for given SQL entry"""
    for line in f:
        if INSERT_LINE_RE.match(line):

            # Remove "INSERT INTO `wbc_entity_usage` VALUES " and
            # trailing semi-colon/space
            input_sql_entry = line.strip(
                "INSERT INTO `wbc_entity_usage` VALUES ").rstrip().rstrip(";")

            # Split tuples
            for match in RECORD_RE.finditer(input_sql_entry):
                yield WikibaseClientUsage.from_match(
                    match, dbname=dbname)
