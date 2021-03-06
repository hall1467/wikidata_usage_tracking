# Have been running python scripts in the virtual environment on flagon here: /export/scratch2/wmf/scripts/

set entity_edit_types_sparse_and_usage_table_directory = /export/scratch2/wmf/scripts/wikidata_usage_tracking/sql_scripts/postgres/wikidata_page_revisions_with_timestamp_table/wikidata_page_revisions_bot_info_table/wikidata_page_revisions_with_timestamp_bot_and_tool_change_tags_table/wikidata_page_revisions_with_timestamp_edit_types_and_usage_table/entity_edit_types_sparse_and_usage_table
set used_entity_previous_month_edits_table_directory = $entity_edit_types_sparse_and_usage_table_directory/used_entity_previous_month_edits_table
set misalignment_and_edits_table_directory = $entity_edit_types_sparse_and_usage_table_directory/misalignment_and_edits_table

set entity_edit_types_sparse_and_usage_sql_results_directory = /export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/entity_edit_types_sparse_and_usage
set entity_edit_types_sparse_and_usage_processing_results_directory = /export/scratch2/wmf/wbc_entity_usage/usage_results/entity_edit_types_sparse_and_usage

echo "Running 'entity_edit_types_sparse_and_usage' table queries"
source $entity_edit_types_sparse_and_usage_table_directory/queries/all_queries.sh

rm -f $entity_edit_types_sparse_and_usage_processing_results_directory/used_entity_edits_aggregated_by_month_error_log.tsv
python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/longitudinal_misalignment/entity_edit_preprocessor.py \
    $entity_edit_types_sparse_and_usage_sql_results_directory/used_entity_monthly_edit_breakdowns.tsv \
    $entity_edit_types_sparse_and_usage_processing_results_directory/used_entity_edits_aggregated_by_month.tsv \
    --verbose \
    > & $entity_edit_types_sparse_and_usage_processing_results_directory/used_entity_edits_aggregated_by_month_error_log.tsv

# Create (drop old tables if need be) directly dependent tables
echo "Dropping old version of 'used_entity_previous_month_edits' table (if it exists. Otherwise, will return error.)"
psql wikidata_entities -c "drop table used_entity_previous_month_edits;"
echo "Creating 'used_entity_previous_month_edits' table"
psql wikidata_entities < $used_entity_previous_month_edits_table_directory/table_creation.sql
psql wikidata_entities < $used_entity_previous_month_edits_table_directory/table_import.sql

echo "Dropping old version of 'misalignment_and_edits' table (if it exists. Otherwise, will return error.)"
psql wikidata_entities -c "drop table misalignment_and_edits;"
echo "Creating 'misalignment_and_edits' table"
psql wikidata_entities < $misalignment_and_edits_table_directory/table_creation.sql

# Run dependencies

source $used_entity_previous_month_edits_table_directory/all_dependencies.sh

source $misalignment_and_edits_table_directory/all_dependencies.sh