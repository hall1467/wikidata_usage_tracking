#python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/edit_analyses/wikidata_revision_extraction.py /export/scratch2/wmf/wbc_entity_usage/wikidata_page_revisions/wikidatawiki-20170501-stub-meta-history* --revisions-output=/export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501.tsv --verbose --debug > & /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_error_log.txt

#python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/revisions_postgres_post_process.py /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501.tsv --revisions-output=/export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes.tsv --verbose --debug > & /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes_error_log.txt

#sort -k 7,7 -t '	' -n -T /export/scratch2/temp /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes.tsv -o /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes_ordered_by_timestamp.tsv

#echo "title\trev_id\tuser\tusername\tcomment\tnamespace\ttimestamp" > /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes_ordered_by_timestamp_with_header.tsv

#cat /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes_ordered_by_timestamp.tsv >> /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes_ordered_by_timestamp_with_header.tsv

#rm -f /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes_ordered_by_timestamp.tsv

#mwsessions sessionize /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes_ordered_by_timestamp_with_header.tsv --events=/export/scratch2/wmf/edit_analyses/revision_session_data.tsv --verbose > /export/scratch2/wmf/edit_analyses/session_data.tsv


#tail -n +2 /export/scratch2/wmf/edit_analyses/session_data.tsv | grep -v "^NULL" | shuf -n 100000 > /export/scratch2/wmf/edit_analyses/100000_random_registered_human_and_bot_sessions.tsv

#python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/edit_analyses/select_actual_revisions_from_random_sessions.py /export/scratch2/wmf/edit_analyses/revision_session_data.tsv /export/scratch2/wmf/edit_analyses/100000_random_registered_human_and_bot_sessions.tsv /export/scratch2/wmf/edit_analyses/revisions_from_100000_random_registered_human_and_bot_sessions.tsv --verbose --debug > & /export/scratch2/wmf/edit_analyses/revisions_from_100000_random_registered_human_and_bot_sessions_error_log.txt

#python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/edit_analyses/select_revisions_containing_property_or_item_edits.py /export/scratch2/wmf/edit_analyses/revisions_from_100000_random_registered_human_and_bot_sessions.tsv /export/scratch2/wmf/edit_analyses/revisions_from_100000_random_registered_human_and_bot_sessions_containing_item_or_property_edits.tsv --verbose --debug > & /export/scratch2/wmf/edit_analyses/revisions_from_100000_random_registered_human_and_bot_sessions_containing_item_or_property_edits_error_log.txt

#psql wikidata_entities < /export/scratch2/wmf/scripts/wikidata_usage_tracking/sql_scripts/postgres/wikidata_bots_table/queries/bot_user_ids.sql

#python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/edit_analyses/label_edits_as_bot_or_human.py /export/scratch2/wmf/edit_analyses/revisions_from_100000_random_registered_human_and_bot_sessions_containing_item_or_property_edits.tsv /export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_bots/bot_user_ids.tsv /export/scratch2/wmf/edit_analyses/revisions_from_100000_random_registered_human_and_bot_sessions_containing_item_or_property_edits_labelled.tsv --verbose --debug > & /export/scratch2/wmf/edit_analyses/revisions_from_100000_random_registered_human_and_bot_sessions_containing_item_or_property_edits_labelled_error_log.txt

#python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/edit_analyses/session_stats.py /export/scratch2/wmf/edit_analyses/revisions_from_100000_random_registered_human_and_bot_sessions_containing_item_or_property_edits_labelled.tsv

python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/edit_analyses/predictor_construction.py /export/scratch2/wmf/edit_analyses/revisions_from_100000_random_registered_human_and_bot_sessions_containing_item_or_property_edits_labelled.tsv /export/scratch2/wmf/edit_analyses/predictors_and_labelled_data.tsv --verbose --debug > & /export/scratch2/wmf/edit_analyses/predictors_and_labelled_data_error_log.tsv