python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/edit_analyses/wikidata_revision_extraction.py /export/scratch2/wmf/edit_analyses/wbc_entity_usage/wikidata_page_revisions/wikidatawiki-20170501-stub-meta-history* --revisions-output=/export/scratch2/wmf/edit_analyses/wikidata_page_revisions_with_timestamp_20170501.tsv --verbose --debug > & /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_with_timestamp_20170501_error_log.txt

python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/revisions_postgres_post_process.py /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_with_timestamp_20170501.tsv --revisions-output=/export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes.tsv --verbose --debug > & /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_20170501_escaped_backslashes_error_log.txt

sort -k 7,7 -t $'\t' -n /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_with_timestamp_20170501.tsv -o /export/scratch2/wmf/edit_analyses/wikidata_page_revisions_with_timestamp_20170501_ordered_by_timestamp.tsv



#psql wikidata_entities -c "\copy (select revision_id, revision_user, revision_timestamp, edit_type from wikidata_page_revisions_with_timestamp_edit_types_and_usage where edit_type = 'bot_edit' or edit_type = 'human_edit' order by random() limit 100000) TO '/export/scratch2/wmf/edit_analyses/nearby_revisions/100000_random_item_or_property_revisions.tsv';"

#echo "revision_id\tuser_id\ttimestamp\tedit_type" > /export/scratch2/wmf/edit_analyses/nearby_revisions/100000_random_item_or_property_revisions_with_header.tsv

#cat /export/scratch2/wmf/edit_analyses/nearby_revisions/100000_random_item_or_property_revisions.tsv >> /export/scratch2/wmf/edit_analyses/nearby_revisions/100000_random_item_or_property_revisions_with_header.tsv

#python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/nearby_revisions/nearby_revisions.py /export/scratch2/wmf/edit_analyses/nearby_revisions/100000_random_item_or_property_revisions_with_header.tsv /export/scratch2/wmf/edit_analyses/nearby_revisions/nearby_revisions_for_100000_item_and_property_revisions.tsv --verbose > & /export/scratch2/wmf/edit_analyses/nearby_revisions/nearby_revisions_for_100000_item_and_property_revisions_error_log.tsv

#mwsessions sessionize /export/scratch2/wmf/edit_analyses/nearby_revisions/nearby_revisions_for_100000_item_and_property_revisions.tsv --events=/export/scratch2/wmf/edit_analyses/nearby_revisions/nearby_revisions_for_100000_item_and_property_revisions_session_data.tsv --verbose > /export/scratch2/wmf/edit_analyses/nearby_revisions/nearby_revisions_for_100000_item_and_property_revisions_session_data.tsv
# Need a script that will go back and remove sessions that do not contain one of the original 100000 item or property edits
# Script can take in the tsv return from sql query sessions





#psql wikidata_entities -c "\copy (select revision_id, revision_user, revision_timestamp, edit_type from wikidata_page_revisions_with_timestamp_edit_types_and_usage where edit_type = 'bot_edit' or edit_type = 'human_edit' order by random() limit 100000) TO '/export/scratch2/wmf/edit_analyses/nearby_revisions/100000_random_item_or_property_revisions.tsv';"

#echo "revision_id\tuser_id\ttimestamp\tedit_type" > /export/scratch2/wmf/edit_analyses/nearby_revisions/100000_random_item_or_property_revisions_with_header.tsv

#cat /export/scratch2/wmf/edit_analyses/nearby_revisions/100000_random_item_or_property_revisions.tsv >> /export/scratch2/wmf/edit_analyses/nearby_revisions/100000_random_item_or_property_revisions_with_header.tsv

#python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/nearby_revisions/nearby_revisions.py /export/scratch2/wmf/edit_analyses/nearby_revisions/100000_random_item_or_property_revisions_with_header.tsv /export/scratch2/wmf/edit_analyses/nearby_revisions/nearby_revisions_for_100000_item_and_property_revisions.tsv --verbose > & /export/scratch2/wmf/edit_analyses/nearby_revisions/nearby_revisions_for_100000_item_and_property_revisions_error_log.tsv

# # mwsessions sessionize /export/scratch2/wmf/edit_analyses/nearby_revisions/nearby_revisions_for_100000_item_and_property_revisions.tsv --events=/export/scratch2/wmf/edit_analyses/nearby_revisions/nearby_revisions_for_100000_item_and_property_revisions_session_data.tsv --verbose > /export/scratch2/wmf/edit_analyses/nearby_revisions/nearby_revisions_for_100000_item_and_property_revisions_session_data.tsv
# Need a script that will go back and remove sessions that do not contain one of the original 100000 item or property edits
# Script can take in the tsv return from sql query sessions
