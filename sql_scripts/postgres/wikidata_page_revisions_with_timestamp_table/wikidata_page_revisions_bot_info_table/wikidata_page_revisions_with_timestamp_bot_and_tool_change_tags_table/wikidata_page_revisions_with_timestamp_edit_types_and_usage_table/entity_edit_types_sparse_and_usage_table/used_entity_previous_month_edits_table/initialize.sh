set used_entity_previous_month_edits_table_directory = /export/scratch2/wmf/scripts/wikidata_usage_tracking/sql_scripts/postgres/wikidata_page_revisions_with_timestamp_table/wikidata_page_revisions_bot_info_table/wikidata_page_revisions_with_timestamp_bot_and_tool_change_tags_table/wikidata_page_revisions_with_timestamp_edit_types_and_usage_table/entity_edit_types_sparse_and_usage_table/used_entity_previous_month_edits_table

psql wikidata_entities < $used_entity_previous_month_edits_table_directory/table_creation.sql
psql wikidata_entities < $used_entity_previous_month_edits_table_directory/table_import.sql