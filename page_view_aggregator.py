"""
Script to aggregate page view dump data

Andrew Hall (hall@cs.umn.edu)

Code Credit:
    1. http://stackoverflow.com/questions/16963352/decompress-bz2-files
    2. http://stackoverflow.com/questions/613183/sort-a-python-dictionary-by-value
    3. http://stackoverflow.com/questions/5191830/best-way-to-log-a-python-exception

"""


import os
import sys
import re
import operator
import csv
import gzip
import collections
import logging
logging.basicConfig(filename='page_view_aggregator.log', level=logging.INFO)


all_files = []

base_path = sys.argv[1]  # Relative to script's directory
output_page_views = csv.writer(open(sys.argv[2], "w+"))


# Determine files to aggregate across
directories_to_search = ["2015/2015-08", "2015/2015-09", "2015/2015-10", "2015/2015-11", "2015/2015-12", "2016/2016-01", "2016/2016-02", "2016/2016-03", "2016/2016-04", "2016/2016-05", "2016/2016-06", "2016/2016-07"]
for directory_to_search in directories_to_search:
    for(directory_path, directory_name, file_names) in os.walk(os.path.join(base_path, directory_to_search)):
        for file_name in file_names:
            if re.match(r"^pageviews", file_name):
                all_files.append(os.path.join(directory_path, file_name))




num_files_processed = 0
articles = collections.Counter()
for file in all_files:
    logging.info("Working on {0}".format(file))
    file_reference = gzip.open(file)
    for line in file_reference:
        line = line.decode('UTF8')
        if re.match(r"^en([.][a-z]+)? ", line):
            line = line.rstrip()
            if len(line.split(" ")) != 4:
                old_line = line
                line += next(file_reference).decode('UTF8')
                line = line.rstrip()
                logging.info("Attempting to repair '{0}' to '{1}'".format(
                    old_line,
                    line
                ))
            try:
                language, article_name, hourly_count, size = line.split(" ")
            except ValueError as e:
                logging.error("Line: {0} \n could not be parsed from {1}".format(
                    line, file
                ))
                continue
            except KeyboardInterrupt:
                sys.exit("Keyboard Interupt")
            except Exception:
                logging.exception("Exception found and line skipped")
                continue
            if article_name == "" or re.match(r"^Special:", article_name) or re.match(r"^File:", article_name) \
                or re.match(r"^Template:", article_name) or re.match(r"^User:", article_name) \
                or re.match(r"^User_talk:", article_name) or re.match(r"^Talk:", article_name) \
                or re.match(r"^Category:", article_name) or re.match(r"^Wikipedia:", article_name) \
                or re.match(r"^Main_Page$", article_name):
                continue
            try:
                articles[article_name] += int(hourly_count)
            except KeyError:
                articles[article_name] = int(hourly_count)
    num_files_processed += 1
    print("Num files processed: ", num_files_processed)



    

sorted_articles = sorted(articles.items(),  key=operator.itemgetter(1), reverse=True)
print ("Number of articles analyzed: " + str(len(articles)))


output_page_view_list = []
output_page_view_list.append(["page", "views"])
for article_name_views_pair in sorted_articles:
    output_page_view_list.append([article_name_views_pair[0], article_name_views_pair[1]])
output_page_views.writerows(output_page_view_list)


