# Code to extract highly used Wikidata "objects": items or statements
# 
# Author: Andrew Hall

import sqlparse
import sys
import re
import ast
import operator

# Read in SQL for client wiki.
wiki_sql = open(sys.argv[1])

# Global dictionaries to store aspect and page usage
wikidata_object_aspect_usage = {}
wikidata_object_page_usage = {}
wikidata_object_page_usage_count = {}


def extractObjectUsagesFromParsedSql(input_sql_entry):
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


# Print top n objects by page usages with aspect usage information
def printTopNObjectsByPageUsages(n):

	# Sort object page usage storage dictionary
	sorted_wikidata_object_page_usage_count = sorted(wikidata_object_page_usage_count.items(), key=operator.itemgetter(1), reverse=True)

	i = 0
	for wikidata_object in sorted_wikidata_object_page_usage_count:
		i += 1
		if i > n:
			break
		print (wikidata_object[0] + "\n\tWiki Pages Used: " + str(wikidata_object[1]) + "\n\tAspects Used: " + str(wikidata_object_aspect_usage[wikidata_object[0]]))
		# print (wikidata_object[0] + "\n\tWiki Pages Used: " + str(wikidata_object[1]) + "\n\tAspects Used: " + str(wikidata_object_aspect_usage[wikidata_object[0]])+ "\n\tPages Using: " + str(wikidata_object_page_usage[wikidata_object[0]].keys()))


for entry in wiki_sql:
	# Parse sql
	extractObjectUsagesFromParsedSql(entry)

# Print ten most used objects
printTopNObjectsByPageUsages(10)

