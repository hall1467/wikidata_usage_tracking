"""

Code to extract Wikidata "object" (item or statement) usages.
Also provides functionality for handling storage of these usages.

"""

import ast
import csv
import gzip
import operator
import re
import sys
from collections import OrderedDict, defaultdict

import requests

INSERT_LINE_RE = re.compile(r"INSERT INTO `wbc_entity_usage` VALUES ")
RECORD_RE = re.compile(r"\([^)]*\)")
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
    def from_record_string(cls, record, wikidb=None):
        converted = ast.literal_eval(record)
        return cls(wikidb, converted[1], converted[2], converted[3])


class WikibaseClientUsage:

    def __init__(self, dbname, usages):
        self.dbname = dbname
        self.usages = usages

    @classmethod
    def from_sql_file(cls, f):
        dbname = None
        for line in sql_file_obj:
            if DB_LINE_RE.match(line):
                dbname = re.sub(".*Database: ", "", line).rstrip()
                break

        usages = extract_usages(sql_file_obj, dbname)

        return cls(dbname, usages)


def extract_usages(sql_file_obj, dbname):
    """ Extract Wikidata object usages in wiki for given SQL entry"""
    for line in sql_file_obj:
        if INSERT_LINE_RE.match(line):

            # Remove "INSERT INTO `wbc_entity_usage` VALUES " and
            # trailing semi-colon/space
            input_sql_entry = line.strip(
                "INSERT INTO `wbc_entity_usage` VALUES ").rstrip().rstrip(";")

            # Split tuples
            records = RECORD_RE.findall(input_sql_entry)
            for record in records:
                yield WikibaseClientUsage.from_record_string(
                    record, dbname=dbname)


class WikidataObjectUsage:

    def __init__(self):
        # Global dictionaries to store aspect and page usage
        self.aspect_usage = defaultdict(dict)
        self.page_usage = defaultdict(dict)
        self.page_usage_count = defaultdict(int)
        self.aggregated_aspect_usages = defaultdict(dict)
        self.aggregated_page_usage_counts = defaultdict(int)




                # Update object usage storage dictionaries
                self.aspect_usage[wikidata_object][wikidata_aspect] += 1
                if wiki_page not in wikidata_object_page_usage[wikidata_object]:
                    self.page_usage_count[wikidata_object] += 1
                    self.page_usage[wikidata_object][wiki_page] = True


    # Return wikidata object page usages in descending order of usages, with aspect
    # usage information
    def getSortedObjectUsagesFromDump(self, wiki, date):

        dump = requests.get("https://dumps.wikimedia.org/" + wiki + "/" + str(date)
               + "/" + wiki + "-" + str(date) + "-wbc_entity_usage.sql.gz",
               stream=True)
        dump_file = gzip.open(dump.raw)

        for entry in dump_file:
            self.extractObjectUsages(entry.decode())

        return self.sortUsages()


    # Returns object usage in descending order of page count, includes aspects
    def sortUsages(self):
        sorted_object_page_usage_count = sorted(self.page_usage_count.items(),
                                                key=operator.itemgetter(1),
                                                reverse=True)
        wikidata_usages = []
        for wikidata_object in sorted_object_page_usage_count:
            wikidata_usages.append({'wikidata_object' : wikidata_object[0],
                                    'wiki_pages_used_by' : wikidata_object[1],
                                    'aspects_used_by_pages' : self.aspect_usage[wikidata_object[0]]})

        return wikidata_usages


    def addToWikidataUsageAggregation(self, wikidata_usages):
        '''Adds Wikidata usages to aggregate usages across Wikis'''
        for object_dictionary in wikidata_usages:
            if object_dictionary['wikidata_object'] not in self.aggregated_aspect_usages:
                self.aggregated_aspect_usages[object_dictionary['wikidata_object']] = {}

            for aspect_usage in object_dictionary['aspects_used_by_pages']:
                if aspect_usage not in aggregated_aspect_usages[object_dictionary['wikidata_object']]:
                    aggregated_aspect_usages[object_dictionary['wikidata_object']][aspect_usage] = 0
                aggregated_aspect_usages[object_dictionary['wikidata_object']][aspect_usage] += object_dictionary['aspects_used_by_pages'][aspect_usage]

            if object_dictionary['wikidata_object'] not in aggregated_page_usage_counts:
                aggregated_page_usage_counts[object_dictionary['wikidata_object']] = 0
            aggregated_page_usage_counts[object_dictionary['wikidata_object']] += object_dictionary['wiki_pages_used_by']

# Writes Wikidata usage statistics to a file
def writeWikidataUsagesToFile(directory, object_type, wiki, wikidata_usages, date):
    wiki_file = open(directory + "/" + wiki + "_" + object_type +
                     "_wikidata_usages_" + date + ".csv", "w")
    csv_object = csv.writer(wiki_file)
    csv_object.writerow(["Object ID", "Wiki Pages Used By", "Aspects Used by Pages"])
    for object_dictionary in wikidata_usages:
        csv_object.writerow([object_dictionary['wikidata_object'],
                            object_dictionary['wiki_pages_used_by'],
                            object_dictionary['aspects_used_by_pages']])
    wiki_file.close()



# Reset Wikidata usage aggregation
def resetWikidataUsageAggregation():
    aggregated_aspect_usages = {}
    aggregated_page_usage_counts = {}


# Return aggregated Wikidata usages
def returnWikidataUsageAggregation():
    return sortUsages(aggregated_page_usage_counts, aggregated_aspect_usages)


# print(getSortedObjectUsagesFromDump("plwiki", 20170420))
