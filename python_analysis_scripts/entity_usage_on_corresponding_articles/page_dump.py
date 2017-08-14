"""

Code to extract page sitelink usages.
Also provides functionality for handling storage of these usages.

"""

import ast
import re
from collections import OrderedDict

INSERT_LINE_RE = re.compile(r"INSERT INTO `page` VALUES ")
# (305,'Q11686834','X',403,'\0\0\0\0\0\0\0\0\0\0\0\0\0\0')
RECORD_RE = re.compile(r"\(([0-9]+),(0),'([^']*)'[^\)]*\)")
DB_LINE_RE = re.compile(r"^-- Host:.*Database: ")


class PageUsage:
    __slots__ = ('wikidb', 'page', 'page_title')

    def __init__(self, wikidb, page, page_title):
        self.wikidb = str(wikidb)
        self.page = int(page)
        self.page_title = str(page_title)

    def __hash__(self):
        return hash(self.wikidb, self.page, self.page_title)

    def to_json(self):
        return OrderedDict(wikidb=self.wikidb,
                           page=self.page,
                           page_title=self.page_title)

    @classmethod
    def from_match(cls, match, dbname=None):
        return cls(dbname, match.group(1), match.group(3))


class PageDump:

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
        print("here")
        if INSERT_LINE_RE.match(line):
            # Remove "INSERT INTO `page` VALUES " and
            # trailing semi-colon/space
            input_sql_entry = line.strip(
                "INSERT INTO `page` VALUES ").rstrip().rstrip(";")
            # Split tuples
            for match in RECORD_RE.finditer(input_sql_entry):
                yield PageUsage.from_match(
                    match, dbname=dbname)