"""

Code to extract Wikidata "object" (item or statement) usages.
Also provides functionality for handling storage of these usages.

"""

import sys
import re
import ast
import operator
import requests
import gzip
import csv


# Global dictionaries to store aspect and page usage
wikidata_object_aspect_usage = {}
wikidata_object_page_usage = {}
wikidata_object_page_usage_count = {}
aggregated_aspect_usages = {}
aggregated_page_usage_counts = {}


# Extract Wikidata object usages in wiki for given SQL entry
def extractObjectUsages(input_sql_entry):
		dbname= None
		if re.match(r"^-- Host:.*Database: ", input_sql_entry):
			dbname = re.sub(".*Database: ","", input_sql_entry).rstrip()
			print(dbname)
		if re.match(r"INSERT INTO `wbc_entity_usage` VALUES ", input_sql_entry):

			# Remove "INSERT INTO `wbc_entity_usage` VALUES " and trailing semi-colon/space
			input_sql_entry = input_sql_entry.strip("INSERT INTO `wbc_entity_usage` VALUES ").rstrip().rstrip(";")

			# Split tuples
			records = re.findall("\([^)]*\)", input_sql_entry)
			for record in records:
				# Cast component to tuple
				converted = ast.literal_eval(record)

				# Extract object, wiki page, and usage information from tuple
				wikidata_object = converted[1]
				wikidata_aspect = converted[2]
				wiki_page = converted[3]

				# Initialize aspect usage storage dictionary for object if not already done
				if wikidata_object not in wikidata_object_aspect_usage:
					wikidata_object_aspect_usage[wikidata_object] = {}

				# Initialize nested aspect usage storage dictionary for object if not already done
				if wikidata_aspect not in wikidata_object_aspect_usage[wikidata_object]:
					wikidata_object_aspect_usage[wikidata_object][wikidata_aspect] = 0

				# Initialize page usage storage dictionary for object if not already done
				if wikidata_object not in wikidata_object_page_usage_count:
					wikidata_object_page_usage_count[wikidata_object] = 0
					wikidata_object_page_usage[wikidata_object] = {}

				# Update object usage storage dictionaries
				wikidata_object_aspect_usage[wikidata_object][wikidata_aspect] += 1
				if wiki_page not in wikidata_object_page_usage[wikidata_object]:
					wikidata_object_page_usage_count[wikidata_object] += 1
					wikidata_object_page_usage[wikidata_object][wiki_page] = True


# Return wikidata object page usages in descending order of usages, with aspect 
# usage information
def getSortedObjectUsagesFromDump(wiki, date):
	global wikidata_object_aspect_usage
	wikidata_object_aspect_usage = {}

	global wikidata_object_page_usage
	wikidata_object_page_usage = {}

	global wikidata_object_page_usage_count
	wikidata_object_page_usage_count = {}

	dump = requests.get("https://dumps.wikimedia.org/" + wiki + "/" + str(date) 
		   + "/" + wiki + "-" + str(date) + "-wbc_entity_usage.sql.gz", 
		   stream=True)
	dump_file = gzip.open(dump.raw)

	for entry in dump_file:
		extractObjectUsages(entry.decode())

	return sortUsages(wikidata_object_page_usage_count,
		   wikidata_object_aspect_usage)


# Returns object usage in descending order of page count, includes aspects
def sortUsages(object_page_usage_count, object_aspect_usage):
	sorted_object_page_usage_count = sorted(object_page_usage_count.items(),
	                                        key=operator.itemgetter(1),
	                                        reverse=True)
	wikidata_usages = []
	for wikidata_object in sorted_object_page_usage_count:
		wikidata_usages.append({'wikidata_object' : wikidata_object[0],
			                    'wiki_pages_used_by' : wikidata_object[1],
			                    'aspects_used_by_pages' : object_aspect_usage[wikidata_object[0]]})

	return wikidata_usages


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


# Adds Wikidata usages to aggregate usages across Wikis
def addToWikidataUsageAggregation(wikidata_usages):
	for object_dictionary in wikidata_usages:
		if object_dictionary['wikidata_object'] not in aggregated_aspect_usages:
			aggregated_aspect_usages[object_dictionary['wikidata_object']] = {}

		for aspect_usage in object_dictionary['aspects_used_by_pages']:
			if aspect_usage not in aggregated_aspect_usages[object_dictionary['wikidata_object']]:
				aggregated_aspect_usages[object_dictionary['wikidata_object']][aspect_usage] = 0
			aggregated_aspect_usages[object_dictionary['wikidata_object']][aspect_usage] += object_dictionary['aspects_used_by_pages'][aspect_usage]

		if object_dictionary['wikidata_object'] not in aggregated_page_usage_counts:
			aggregated_page_usage_counts[object_dictionary['wikidata_object']] = 0
		aggregated_page_usage_counts[object_dictionary['wikidata_object']] += object_dictionary['wiki_pages_used_by']


# Reset Wikidata usage aggregation
def resetWikidataUsageAggregation():
	aggregated_aspect_usages = {}
	aggregated_page_usage_counts = {}


# Return aggregated Wikidata usages
def returnWikidataUsageAggregation():
	return sortUsages(aggregated_page_usage_counts, aggregated_aspect_usages)


print(getSortedObjectUsagesFromDump("klwiki", 20170420))

