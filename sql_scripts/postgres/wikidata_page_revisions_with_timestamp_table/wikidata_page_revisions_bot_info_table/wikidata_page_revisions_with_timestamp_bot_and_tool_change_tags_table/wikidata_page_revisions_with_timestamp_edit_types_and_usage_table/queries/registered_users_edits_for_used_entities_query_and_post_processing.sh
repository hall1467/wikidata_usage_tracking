set sql_results_directory = /export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types_and_usage
set post_processing_results_directory = /export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_page_revisions_with_timestamp_edit_types_and_usage

psql wikidata_entities < registered_user_edits_for_used_entities.sql

cp $sql_results_directory/registered_user_edits_for_used_entities.tsv $post_processing_results_directory

echo "user\ttimestamp\trevision_id" > $post_processing_results_directory/registered_user_edits_for_used_entities_with_header.tsv

cat $post_processing_results_directory/registered_user_edits_for_used_entities.tsv >> $post_processing_results_directory/registered_user_edits_for_used_entities_with_header.tsv

mwsessions sessionize $post_processing_results_directory/registered_user_edits_for_used_entities_with_header.tsv --events=$post_processing_results_directory/registered_user_revision_session_data.tsv > $post_processing_results_directory/registered_user_session_data.tsv --verbose

tail -n +2 $post_processing_results_directory/registered_user_revision_session_data.tsv | shuf -n 100000 > $post_processing_results_directory/100000_sample_registered_user_revision_session_data.tsv

head -n 1 $post_processing_results_directory/registered_user_revision_session_data.tsv > $post_processing_results_directory/100000_sample_registered_user_revision_session_data_with_header.tsv

cat $post_processing_results_directory/100000_sample_registered_user_revision_session_data.tsv >> $post_processing_results_directory/100000_sample_registered_user_revision_session_data_with_header.tsv