#python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/edit_analyses/wikidata_revision_extraction.py /export/scratch2/wmf/wbc_entity_usage/wikidata_page_revisions/wikidatawiki-20170501-stub-meta-history* --revisions-output=/export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501.tsv --verbose --debug > & /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_error_log.txt

#python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/revisions_postgres_post_process.py /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501.tsv --revisions-output=/export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes.tsv --verbose --debug > & /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes_error_log.txt

#sort -k 7,7 -t '	' -n -T /export/scratch2/temp /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes.tsv -o /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes_ordered_by_timestamp.tsv

#echo "title\trev_id\tuser\tusername\tcomment\tnamespace\ttimestamp" > /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes_ordered_by_timestamp_with_header.tsv

#cat /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes_ordered_by_timestamp.tsv >> /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes_ordered_by_timestamp_with_header.tsv

#rm -f /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes_ordered_by_timestamp.tsv

#mwsessions sessionize /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes_ordered_by_timestamp_with_header.tsv --events=/export/scratch2/wmf/edit_analyses/revision_session_data.tsv --verbose > /export/scratch2/wmf/edit_analyses/session_data.tsv


#tail -n +2 /export/scratch2/wmf/edit_analyses/session_data.tsv | grep -v "^NULL" | shuf -n 100000 > /export/scratch2/wmf/edit_analyses/100000_random_registered_human_and_bot_sessions.tsv

python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/edit_analyses/select_actual_revisions_from_random_sessions.py /export/scratch2/wmf/edit_analyses/revision_session_data.tsv /export/scratch2/wmf/edit_analyses/100000_random_registered_human_and_bot_sessions.tsv /export/scratch2/wmf/edit_analyses/revisions_from_100000_random_registered_human_and_bot_sessions.tsv --verbose --debug > & /export/scratch2/wmf/edit_analyses/revisions_from_100000_random_registered_human_and_bot_sessions_error_log.txt

# Python script needs to go and get actual revisions for each of these 100000. Also will need to make sure there is at least one edit to either the property or item namespaces for these. 

# Script can also take a list of bots as input and label a given revision as bot or human. This will be our training/testing data.
