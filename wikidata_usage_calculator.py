# For each wiki, calculates Wikidata usage and returns a csv containing its usage information. Also returns csv with aggrgated results across wikis
#
# Takes three arguments:
# 	1. Directory to write results
# 	2. File name scheme for result files. Use this to specify the type of wikidata. For example: "item"
# 	3. Date of dumps in format: yyyymmdd
#
# Author Andrew Hall

import wiki_list
import wikidata_object_usage
import re
import subprocess
import csv
import sys
import operator




def write_wiki_stats_to_file(directory, object_type, wiki, wikidata_usages):
	wiki_file = open(directory + "/" + wiki + "_" + object_type + "_wikidata_usages.csv", "w")
	csv_object = csv.writer(wiki_file)
	csv_object.writerow(["Object ID", "Wiki Pages Used By", "Aspects Used by Pages"])
	for object_dictionary in wikidata_usages:
		# print(object_dictionary)
		csv_object.writerow([object_dictionary['wikidata_object'], object_dictionary['wiki_pages_used_by'], object_dictionary['aspects_used_by_pages']])
	wiki_file.close()

def add_to_aggregation(wikidata_usages):
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


# List of all wikis
print("Getting list of wikis from MediaWiki API...", end="")
list_of_wikis = wiki_list.get_wiki_information()
print("found " + str(len(list_of_wikis)) + " wikis")

wikis_completed_count = 0
wikis_not_processed = []
wikis_successfully_processed = []
aggregated_aspect_usages = {}
aggregated_page_usage_counts = {}

# 
# list_of_wikis = ["viwiki", "klwiki", "plwiki"]
#"azwiki", "viwiki", "klwiki", 
for wiki in list_of_wikis:
	print("Getting object usages for " + wiki + "...", end="",flush=True)
	wikidata_usages = wikidata_object_usage.getSortedObjectUsages(wiki, sys.argv[3])
	if len(wikidata_usages) == 0:
		print("\n\tNot Found...", end="", flush=True)
		wikis_not_processed.append(wiki)
	else:
		wikis_successfully_processed.append(wiki)
		add_to_aggregation(wikidata_usages)
		write_wiki_stats_to_file(sys.argv[1], sys.argv[2], wiki, wikidata_usages)
	wikis_completed_count += 1
	print(str(wikis_completed_count) + " wikis completed", flush=True)

sorted_aggregated_page_usage_counts = sorted(aggregated_page_usage_counts.items(), key=operator.itemgetter(1), reverse=True)
aggregated_wikidata_usages = []
for wikidata_object in sorted_aggregated_page_usage_counts:
	aggregated_wikidata_usages.append({'wikidata_object' : wikidata_object[0], 'wiki_pages_used_by' : wikidata_object[1], 'aspects_used_by_pages' : aggregated_aspect_usages[wikidata_object[0]]})

write_wiki_stats_to_file(sys.argv[1], sys.argv[2], "all_wikis", aggregated_wikidata_usages)

def wiki_success_failure_writing(wiki_list, name_of_file_to_create, description):
	wikis_file = open(sys.argv[1] + "/" + name_of_file_to_create + ".txt", "w")
	wikis_file.write(description + ":\n")
	for wiki in wiki_list:
		wikis_file.write(wiki + "\n")
	wikis_file.close()

wiki_success_failure_writing(wikis_not_processed, "wikis_not_processed", "Wikis not processed")
wiki_success_failure_writing(wikis_successfully_processed, "wikis_successfully_processed", "Wikis successfully processed")

