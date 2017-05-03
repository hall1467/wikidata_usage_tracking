# For each wiki, calculates Wikidata usage and returns a csv containing its usage information. 
# Also returns csv with aggregated results across wikis.
#
# Takes three arguments:
# 	1. Directory to write results
# 	2. File name scheme for result files. Use this to specify the type of wikidata. For example: "item"
# 	3. Date of dumps in format: yyyymmdd
#
# Author Andrew Hall

import wiki_list
import wikidata_object_usage
import csv
import sys


# Used to write out which wikis had Wikidata usages
def writeToFileWhichWikisHadUsages(directory, wiki_list, name_of_file_to_create, description, date):
	wikis_file = open(directory + "/" + name_of_file_to_create + "_" + date + ".txt", "w")
	wikis_file.write(description + ":\n")
	for wiki in wiki_list:
		wikis_file.write(wiki + "\n")
	wikis_file.close()


# Calculates list of all wikis from MediaWiki API
def calculateListOfWikis():
	print("Getting list of wikis from MediaWiki API...", end="")
	list_of_wikis = wiki_list.getWikiNamesList()
	print("found " + str(len(list_of_wikis)) + " wikis")

	return list_of_wikis


# Iterate through list of all wikis and calculate individual and aggregate Wikidata usage
# Writes both individual and aggregate wiki usage to file
def calculateWikidataUsages(list_of_wikis):
	wikis_completed_count = 0
	wikis_not_processed = []
	wikis_successfully_processed = []

	wikidata_object_usage.resetWikidataUsageAggregation()

	for wiki in list_of_wikis:
		print("Getting object usages for " + wiki + "...", end="",flush=True)
		wikidata_usages = wikidata_object_usage.getSortedObjectUsagesFromDump(wiki, sys.argv[3])

		if len(wikidata_usages) == 0:
			print("\n\tNot Found...", end="", flush=True)
			wikis_not_processed.append(wiki)
		else:
			wikis_successfully_processed.append(wiki)
			wikidata_object_usage.addToWikidataUsageAggregation(wikidata_usages)
			wikidata_object_usage.writeWikidataUsagesToFile(sys.argv[1], sys.argv[2], wiki, wikidata_usages, sys.argv[3])

		wikis_completed_count += 1
		print(str(wikis_completed_count) + " wikis completed", flush=True)

	# Write aggregated Wikidata usages to file
	wikidata_object_usage.writeWikidataUsagesToFile(sys.argv[1], sys.argv[2], "all_wikis", wikidata_object_usage.returnWikidataUsageAggregation(), sys.argv[3])

	# Finish by writing to file which wikis successfully processed or not
	writeToFileWhichWikisHadUsages(sys.argv[1], wikis_not_processed, "wikis_not_processed", "Wikis not processed", sys.argv[3])
	writeToFileWhichWikisHadUsages(sys.argv[1], wikis_successfully_processed, "wikis_successfully_processed", "Wikis successfully processed", sys.argv[3])


def main():
	list_of_wikis = calculateListOfWikis()
	calculateWikidataUsages(list_of_wikis)


main()

