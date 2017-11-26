#python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/edit_analyses/wikidata_revision_extraction.py /export/scratch2/wmf/wbc_entity_usage/wikidata_page_revisions/wikidatawiki-20170501-stub-meta-history* --revisions-output=/export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501.tsv --verbose --debug > & /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_error_log.txt

#python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/revisions_postgres_post_process.py /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501.tsv --revisions-output=/export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes.tsv --verbose --debug > & /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes_error_log.txt

#sort -k 7,7 -t '	' -n -T /export/scratch2/temp /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes.tsv -o /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes_ordered_by_timestamp.tsv

echo "title\trev_id\tuser_id\tusername\tcomment\tnamespace\ttimestamp" > /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes_ordered_by_timestamp_with_header.tsv

cat /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes_ordered_by_timestamp.tsv >> /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes_ordered_by_timestamp_with_header.tsv

rm -f /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes_ordered_by_timestamp.tsv

mwsessions sessionize /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes_ordered_by_timestamp_with_header.tsv --events=/export/scratch2/wmf/edit_analyses/revision_session_data.tsv --verbose > /export/scratch2/wmf/edit_analyses/session_data.tsv

# Need a script that will go back and remove sessions that do not contain one of the original 100000 item or property edits
# Script can take in the tsv return from sql query sessions
