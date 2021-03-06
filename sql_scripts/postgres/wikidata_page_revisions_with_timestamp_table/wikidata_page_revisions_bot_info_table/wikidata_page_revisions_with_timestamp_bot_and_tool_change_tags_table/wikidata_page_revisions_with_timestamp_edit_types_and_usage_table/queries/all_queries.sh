# Have been running on the virtual environment on flagon here: /export/scratch2/wmf/scripts/

set wikidata_page_revisions_with_timestamp_edit_types_and_usage_table_queries_directory = /export/scratch2/wmf/scripts/wikidata_usage_tracking/sql_scripts/postgres/wikidata_page_revisions_with_timestamp_table/wikidata_page_revisions_bot_info_table/wikidata_page_revisions_with_timestamp_bot_and_tool_change_tags_table/wikidata_page_revisions_with_timestamp_edit_types_and_usage_table/queries

set sql_results_directory = /export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types_and_usage
set post_processing_results_directory = /export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_page_revisions_with_timestamp_edit_types_and_usage

set wikidata_page_revisions_with_timestamp_edit_types_and_usage_sql_results_directory = /export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types_and_usage
set wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory = /export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_page_revisions_with_timestamp_edit_types_and_usage




#create sessions for human property edits
psql wikidata_entities < $wikidata_page_revisions_with_timestamp_edit_types_and_usage_table_queries_directory/human_property_edits.sql

cp $wikidata_page_revisions_with_timestamp_edit_types_and_usage_sql_results_directory/human_property_edits.tsv $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory

rm -f $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/human_property_edits_with_header.tsv
rm -f $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/human_property_session_data.tsv
rm -f $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_human_property_revision_session_data.tsv
rm -f $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_human_property_revision_session_data_with_header.tsv

echo "user\ttimestamp\trevision_id" > $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/human_property_edits_with_header.tsv

cat $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/human_property_edits.tsv >> $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/human_property_edits_with_header.tsv

mwsessions sessionize $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/human_property_edits_with_header.tsv --events=$wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/human_property_revision_session_data.tsv --verbose > $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/human_property_session_data.tsv

python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/session_analysis/session_analyzer.py $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/human_property_revision_session_data.tsv $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/human_property_events_session_mean_frequency_edits.tsv --verbose

tail -n +2 $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/human_property_revision_session_data.tsv | shuf -n 100000 > $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_human_property_revision_session_data.tsv

head -n 1 $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/human_property_revision_session_data.tsv > $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_human_property_revision_session_data_with_header.tsv

cat $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_human_property_revision_session_data.tsv >> $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_human_property_revision_session_data_with_header.tsv


#create sessions for human edits
psql wikidata_entities < $wikidata_page_revisions_with_timestamp_edit_types_and_usage_table_queries_directory/human_edits.sql

cp $wikidata_page_revisions_with_timestamp_edit_types_and_usage_sql_results_directory/human_edits.tsv $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory

rm -f $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/human_edits_with_header.tsv
rm -f $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/human_session_data.tsv
rm -f $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_human_revision_session_data.tsv
rm -f $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_human_revision_session_data_with_header.tsv

echo "user\ttimestamp\trevision_id" > $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/human_edits_with_header.tsv

cat $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/human_edits.tsv >> $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/human_edits_with_header.tsv

mwsessions sessionize $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/human_edits_with_header.tsv --events=$wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/human_revision_session_data.tsv --verbose > $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/human_session_data.tsv

python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/session_analysis/session_analyzer.py $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/human_revision_session_data.tsv $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/human_events_session_mean_frequency_edits.tsv --verbose

tail -n +2 $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/human_revision_session_data.tsv | shuf -n 100000 > $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_human_revision_session_data.tsv

head -n 1 $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/human_revision_session_data.tsv > $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_human_revision_session_data_with_header.tsv

cat $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_human_revision_session_data.tsv >> $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_human_revision_session_data_with_header.tsv


#create sessions for all property edits
psql wikidata_entities < $wikidata_page_revisions_with_timestamp_edit_types_and_usage_table_queries_directory/all_property_edits.sql

cp $wikidata_page_revisions_with_timestamp_edit_types_and_usage_sql_results_directory/all_property_edits.tsv $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory

rm -f $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/all_property_edits_with_header.tsv
rm -f $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/all_property_session_data.tsv
rm -f $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_all_property_revision_session_data.tsv
rm -f $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_all_property_revision_session_data_with_header.tsv

echo "edit_type\tuser\ttimestamp\trevision_id" > $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/all_property_edits_with_header.tsv

cat $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/all_property_edits.tsv >> $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/all_property_edits_with_header.tsv

mwsessions sessionize $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/all_property_edits_with_header.tsv --events=$wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/all_property_revision_session_data.tsv --verbose > $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/all_property_session_data.tsv

python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/session_analysis/session_analyzer.py $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/all_property_revision_session_data.tsv $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/all_property_events_session_mean_frequency_edits.tsv --verbose

tail -n +2 $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/all_property_revision_session_data.tsv | shuf -n 100000 > $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_all_property_revision_session_data.tsv

head -n 1 $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/all_property_revision_session_data.tsv > $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_all_property_revision_session_data_with_header.tsv

cat $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_all_property_revision_session_data.tsv >> $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_all_property_revision_session_data_with_header.tsv


#create sessions for all used edits
psql wikidata_entities < $wikidata_page_revisions_with_timestamp_edit_types_and_usage_table_queries_directory/all_edits_for_used_entities.sql

cp $wikidata_page_revisions_with_timestamp_edit_types_and_usage_sql_results_directory/all_edits_for_used_entities.tsv $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory

rm -f $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/all_edits_for_used_entities_with_header.tsv
rm -f $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/all_session_data.tsv

echo "edit_type\tuser\ttimestamp\trevision_id" > $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/all_edits_for_used_entities_with_header.tsv

cat $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/all_edits_for_used_entities.tsv >> $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/all_edits_for_used_entities_with_header.tsv

mwsessions sessionize $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/all_edits_for_used_entities_with_header.tsv --events=$wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/all_revision_session_data.tsv --verbose > $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/all_session_data.tsv

python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/session_analysis/session_analyzer.py $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/all_revision_session_data.tsv $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/all_events_session_mean_frequency_edits.tsv --verbose


#create sessions for anon used edits

psql wikidata_entities < $wikidata_page_revisions_with_timestamp_edit_types_and_usage_table_queries_directory/anon_edits_for_used_entities.sql

cp $wikidata_page_revisions_with_timestamp_edit_types_and_usage_sql_results_directory/anon_edits_for_used_entities.tsv $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory


rm -f $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/anon_edits_for_used_entities_with_header.tsv
rm -f $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/anon_session_data.tsv
rm -f $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_anon_revision_session_data.tsv
rm -f $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_anon_revision_session_data_with_header.tsv

echo "user\ttimestamp\trevision_id" > $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/anon_edits_for_used_entities_with_header.tsv

cat $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/anon_edits_for_used_entities.tsv >> $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/anon_edits_for_used_entities_with_header.tsv

mwsessions sessionize $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/anon_edits_for_used_entities_with_header.tsv --events=$wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/anon_revision_session_data.tsv > $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/anon_session_data.tsv --verbose

tail -n +2 $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/anon_revision_session_data.tsv | shuf -n 100000 > $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_anon_revision_session_data.tsv

head -n 1 $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/anon_revision_session_data.tsv > $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_anon_revision_session_data_with_header.tsv

cat $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_anon_revision_session_data.tsv >> $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_anon_revision_session_data_with_header.tsv



# Create sessions for registered user used edits

psql wikidata_entities < $wikidata_page_revisions_with_timestamp_edit_types_and_usage_table_queries_directory/registered_user_edits_for_used_entities.sql

cp wikidata_page_revisions_with_timestamp_edit_types_and_usage_sql_results_directory/registered_user_edits_for_used_entities.tsv $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory


rm -f $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/registered_user_edits_for_used_entities_with_header.tsv
rm -f $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/registered_user_session_data.tsv
rm -f $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_registered_user_revision_session_data.tsv
rm -f $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_registered_user_revision_session_data_with_header.tsv

echo "user\ttimestamp\trevision_id" > $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/registered_user_edits_for_used_entities_with_header.tsv

cat $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/registered_user_edits_for_used_entities.tsv >> $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/registered_user_edits_for_used_entities_with_header.tsv

mwsessions sessionize $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/registered_user_edits_for_used_entities_with_header.tsv --events=$wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/registered_user_revision_session_data.tsv > $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/registered_user_session_data.tsv --verbose

tail -n +2 $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/registered_user_revision_session_data.tsv | shuf -n 100000 > $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_registered_user_revision_session_data.tsv

head -n 1 $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/registered_user_revision_session_data.tsv > $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_registered_user_revision_session_data_with_header.tsv

cat $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_registered_user_revision_session_data.tsv >> $wikidata_page_revisions_with_timestamp_edit_types_and_usage_processing_results_directory/100000_sample_registered_user_revision_session_data_with_header.tsv



# Rest of queries
psql wikidata_entities < $wikidata_page_revisions_with_timestamp_edit_types_and_usage_table_queries_directory/edit_type_sums.sql
psql wikidata_entities < $wikidata_page_revisions_with_timestamp_edit_types_and_usage_table_queries_directory/random_revisions.sql
psql wikidata_entities < $wikidata_page_revisions_with_timestamp_edit_types_and_usage_table_queries_directory/semi_automated_revision_word_counts.sql

