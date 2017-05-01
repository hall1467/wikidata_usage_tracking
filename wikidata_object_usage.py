# Code to extract highly used Wikidata "objects": items or statements
# 
# Author: Andrew Hall

import sys
import re
import ast
import operator
import subprocess
import requests
import gzip


# Global dictionaries to store aspect and page usage
wikidata_object_aspect_usage = {}
wikidata_object_page_usage = {}
wikidata_object_page_usage_count = {}


def extractObjectUsages(input_sql_entry):
		if re.match(r"INSERT INTO `wbc_entity_usage` VALUES ", input_sql_entry):

			# Remove "INSERT INTO `wbc_entity_usage` VALUES "
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


# Return wikidata object page usages with aspect usage information
def getSortedObjectUsages(wiki, date):

	global wikidata_object_aspect_usage
	wikidata_object_aspect_usage = {}

	global wikidata_object_page_usage
	wikidata_object_page_usage = {}

	global wikidata_object_page_usage_count
	wikidata_object_page_usage_count = {}
	
	dump = requests.get("https://dumps.wikimedia.org/" + wiki + "/" + str(date) + "/" + wiki + "-" + str(date) + "-wbc_entity_usage.sql.gz", stream=True)
	dump_file = gzip.open(dump.raw)

	for entry in dump_file:
		extractObjectUsages(entry.decode())


	# Sort object page usage storage dictionary
	sorted_wikidata_object_page_usage_count = sorted(wikidata_object_page_usage_count.items(), key=operator.itemgetter(1), reverse=True)

	wikidata_usages = []
	for wikidata_object in sorted_wikidata_object_page_usage_count:
		wikidata_usages.append({'wikidata_object' : wikidata_object[0], 'wiki_pages_used_by' : wikidata_object[1], 'aspects_used_by_pages' : wikidata_object_aspect_usage[wikidata_object[0]]})

	return wikidata_usages

# print(getSortedObjectUsages("plwiktionary", 20170420))

