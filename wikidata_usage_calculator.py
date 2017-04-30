# For each wiki, calculates Wikidata usage. Also can aggregated across Wikis
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
wikis_processed = []
aggregated_aspect_usages = {}
aggregated_page_usage_counts = {}

# 
for wiki in list_of_wikis:
	print("Getting object usages for " + wiki + "...", end="")
	try:	
		wikidata_usages = wikidata_object_usage.getSortedObjectUsages(-1, wiki, "20170420")
		wikis_processed.append(wiki)
		add_to_aggregation(wikidata_usages)

		write_wiki_stats_to_file(sys.argv[1], sys.argv[2], wiki, wikidata_usages)
	except subprocess.CalledProcessError as dump_download_error:
		if re.match(r"zcat\: \(stdin\)\: unexpected end of file", dump_download_error.output.decode().rstrip()):
			wikis_not_processed.append(wiki)
			print("failed to download: " + wiki + ". File may not exist. ", end="")
		else:
			raise
	wikis_completed_count += 1
	print(str(wikis_completed_count) + " wikis completed")

sorted_aggregated_page_usage_counts = sorted(aggregated_page_usage_counts.items(), key=operator.itemgetter(1), reverse=True)
aggregated_wikidata_usages = []
for wikidata_object in sorted_aggregated_page_usage_counts:
	aggregated_wikidata_usages.append({'wikidata_object' : wikidata_object[0], 'wiki_pages_used_by' : wikidata_object[1], 'aspects_used_by_pages' : aggregated_aspect_usages[wikidata_object[0]]})

write_wiki_stats_to_file(sys.argv[1], sys.argv[2], "all_wikis", aggregated_wikidata_usages)

