"""

For each wiki, calculates Wikidata usage and returns a csv containing its usage
information. Also returns csv with aggregated results across wikis.

Usage:
    multi_wiki_wikidata_usage (-h|--help)
    multi_wiki_wikidata_usage --results-directory=<directory_path> --naming-scheme=<scheme> --dump-date=<yyyymmdd>


Options:
    -h, --help                              Returns this help message
    --results-directory=<directory_path>    Directory where results will be 
                                            written                                        
    --naming-scheme=<scheme>                Naming scheme for files in results
                                            directory. Describes objects whose
                                            usage is being calculated E.g. 
                                            "item" or "statement". 
    --dump-date=<yyyymmdd>                  Date of wbc_entity_usage dump in 
                                            yyyymmdd format. E.g. 20170420

"""

import docopt
import wiki_list
import wikidata_object_usage
import csv


# Used to write out which wikis had Wikidata usages
def write_to_file_which_wikis_had_usages(directory, wiki_list, name_of_file_to_create,
                                         description, date):
    wikis_file = open(directory + "/" + name_of_file_to_create + "_" + date + 
                      ".txt", "w")
    wikis_file.write(description + ":\n")
    for wiki in wiki_list:
        wikis_file.write(wiki + "\n")
    wikis_file.close()


# Calculates list of all wikis from MediaWiki API
def calculate_list_of_wikis():
    print("Getting list of wikis from MediaWiki API...", end="")
    list_of_wikis = wiki_list.getWikiNamesList()
    print("found " + str(len(list_of_wikis)) + " wikis")

    return list_of_wikis


# Iterate through list of all wikis and calculate individual and aggregate
# Wikidata usage.
# Writes both individual and aggregate wiki usage to file
def calculate_wikidata_usages(list_of_wikis, results_directory, naming_scheme, dump_date):
    wikis_completed_count = 0
    wikis_not_processed = []
    wikis_successfully_processed = []

    wikidata_object_usage.resetWikidataUsageAggregation()

    for wiki in list_of_wikis:
        print("Getting object usages for " + wiki + "...", end="",flush=True)
        wikidata_usages = wikidata_object_usage.getSortedObjectUsagesFromDump(
                          wiki, dump_date)

        if len(wikidata_usages) == 0:
            print("\n\tNot Found...", end="", flush=True)
            wikis_not_processed.append(wiki)
        else:
            wikis_successfully_processed.append(wiki)
            wikidata_object_usage.addToWikidataUsageAggregation(wikidata_usages)
            wikidata_object_usage.writeWikidataUsagesToFile(results_directory, 
                                                            naming_scheme, 
                                                            wiki, 
                                                            wikidata_usages, 
                                                            dump_date)

        wikis_completed_count += 1
        print(str(wikis_completed_count) + " wikis completed", flush=True)

    # Write aggregated Wikidata usages to file
    wikidata_object_usage.writeWikidataUsagesToFile(results_directory,
                                                    naming_scheme,
                                                    "all_wikis",
                                                    wikidata_object_usage.returnWikidataUsageAggregation(),
                                                    dump_date)

    # Finish by writing to file which wikis successfully processed or not
    write_to_file_which_wikis_had_usages(results_directory,
                                   wikis_not_processed,
                                   "wikis_not_processed",
                                   "Wikis not processed",
                                   dump_date)
    write_to_file_which_wikis_had_usages(results_directory,
                                   wikis_successfully_processed,
                                   "wikis_successfully_processed",
                                   "Wikis successfully processed",
                                   dump_date)


def main():
    args = docopt.docopt(__doc__)
    results_directory = args['--results-directory']
    naming_scheme = args['--naming-scheme']
    dump_date = args['--dump-date']
    list_of_wikis = calculate_list_of_wikis()
    calculate_wikidata_usages(list_of_wikis, results_directory, naming_scheme, dump_date)


main()

