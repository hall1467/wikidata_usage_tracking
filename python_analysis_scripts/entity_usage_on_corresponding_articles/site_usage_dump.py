"""

Code to extract page sitelink usages.
Also provides functionality for handling storage of these usages.

"""

import ast
import re
from collections import OrderedDict

INSERT_LINE_RE = re.compile(r"INSERT INTO `wb_items_per_site` VALUES ")
# (305,'Q11686834','X',403,'\0\0\0\0\0\0\0\0\0\0\0\0\0\0')
RECORD_RE = re.compile(r"\(([0-9]+),([0-9]+),'([^']*)','([^']*)'\)")
DB_LINE_RE = re.compile(r"^-- Host:.*Database: ")


class SiteUsage:
    __slots__ = ('wikidb', 'entity_id', 'page_title')

    def __init__(self, wikidb, entity_id, page_title):
        self.wikidb = str(wikidb)
        self.entity_id = int(entity_id)
        self.page_title = str(page_title)

    def __hash__(self):
        return hash(self.wikidb, self.entity_id, self.page_title)

    def to_json(self):
        return OrderedDict(wikidb=self.wikidb,
                           entity_id=self.entity_id,
                           page_title=self.page_title)

    @classmethod
    def from_match(cls, match, dbname=None):
        return cls(match.group(3), match.group(2), match.group(4))


class SiteDump:

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
    """ Extract sitelink usages in wiki for given SQL entry"""
    for line in f:
        if INSERT_LINE_RE.match(line):
            # Remove "INSERT INTO `wb_items_per_site` VALUES " and
            # trailing semi-colon/space
            input_sql_entry = line.strip(
                "INSERT INTO `wb_items_per_site` VALUES ").rstrip().rstrip(";")
            # Split tuples
            for match in RECORD_RE.finditer(input_sql_entry):
                yield SiteUsage.from_match(
                    match, dbname=dbname)
