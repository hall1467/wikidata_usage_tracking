# Have been running python scripts in the virtual environment on flagon here: /export/scratch2/wmf/scripts/

set wikidata_page_revisions_with_timestamp_edit_types_and_usage_table_directory = /export/scratch2/wmf/scripts/wikidata_usage_tracking/sql_scripts/postgres/wikidata_page_revisions_with_timestamp_table/wikidata_page_revisions_bot_info_table/wikidata_page_revisions_with_timestamp_bot_and_tool_change_tags_table/wikidata_page_revisions_with_timestamp_edit_types_and_usage_table
set $entity_edit_types_sparse_and_usage_table_directory = $wikidata_page_revisions_with_timestamp_edit_types_and_usage_table_directory/entity_edit_types_sparse_and_usage_table

echo "Running 'wikidata_page_revisions_with_timestamp_edit_types_and_usage' table queries"
source $wikidata_page_revisions_with_timestamp_edit_types_and_usage_table_directory/queries/all_queries.sh

# Create (drop old tables if need be) directly dependent tables

echo "Dropping old version of 'entity_edit_types_sparse_and_usage' sub tables and table (if they exist). Otherwise, will return errors."
psql wikidata_entities -c "drop table entity_edit_types_sparse_and_usage_sub_table_1;"
psql wikidata_entities -c "drop table entity_edit_types_sparse_and_usage_sub_table_2;"
psql wikidata_entities -c "drop table entity_edit_types_sparse_and_usage_sub_table_3;"
psql wikidata_entities -c "drop table entity_edit_types_sparse_and_usage_sub_table_4;"
psql wikidata_entities -c "drop table entity_edit_types_sparse_and_usage_sub_table_5;"

psql wikidata_entities -c "drop table entity_edit_types_sparse_and_usage;"

echo "Creating 'entity_edit_types_sparse_and_usage' sub tables and table"
psql wikidata_entities < $entity_edit_types_sparse_and_usage_table_directory/table_1_creation.sql
psql wikidata_entities < $entity_edit_types_sparse_and_usage_table_directory/table_2_creation.sql
psql wikidata_entities < $entity_edit_types_sparse_and_usage_table_directory/table_3_creation.sql
psql wikidata_entities < $entity_edit_types_sparse_and_usage_table_directory/table_4_creation.sql
psql wikidata_entities < $entity_edit_types_sparse_and_usage_table_directory/table_5_creation.sql

psql wikidata_entities < $entity_edit_types_sparse_and_usage_table_directory/complete_table_creation.sql

# Run dependencies

source $entity_edit_types_sparse_and_usage_table_directory/all_dependencies.sh