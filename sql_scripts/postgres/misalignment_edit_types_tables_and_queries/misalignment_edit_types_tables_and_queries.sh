# Have been running python scripts in the virtual environment on flagon here: /export/scratch2/wmf/scripts/

#NOTE: need to add in non-relative paths
# need to delete tables if created


# "entity_revisions" table creation
psql wikidata_entities < entity_revisions_table/entity_revisions_table_creation.sql
psql wikidata_entities < entity_revisions_table/entity_revisions_table_import.sql
psql wikidata_entities < entity_revisions_table/entity_revisions_table_index_creation.sql

# "entity_revisions_and_bot_flags_and_tool_change_tags" table creation
psql wikidata_entities < entity_revisions_and_bot_flags_and_tool_change_tags_table/entity_revisions_and_bot_flags_and_tool_change_tags_table_creation.sql
psql wikidata_entities < entity_revisions_and_bot_flags_and_tool_change_tags_table/entity_revisions_and_bot_flags_and_tool_change_tags_table_index_creation.sql

# "entity_revisions_and_types_and_usages" table creation
psql wikidata_entities < entity_revisions_and_types_and_usages_table/entity_revisions_and_types_and_usages_table_creation.sql

# "entity_revisions_and_types_and_usages_sparse" table creation
psql wikidata_entities < entity_revisions_and_types_and_usages_sparse_table/entity_revisions_and_types_and_usages_sparse_sub_table_1_table_creation.sql
psql wikidata_entities < entity_revisions_and_types_and_usages_sparse_table/entity_revisions_and_types_and_usages_sparse_sub_table_2_table_creation.sql
psql wikidata_entities < entity_revisions_and_types_and_usages_sparse_table/entity_revisions_and_types_and_usages_sparse_sub_table_3_table_creation.sql
psql wikidata_entities < entity_revisions_and_types_and_usages_sparse_table/entity_revisions_and_types_and_usages_sparse_sub_table_4_table_creation.sql
psql wikidata_entities < entity_revisions_and_types_and_usages_sparse_table/entity_revisions_and_types_and_usages_sparse_sub_table_5_table_creation.sql
psql wikidata_entities < entity_revisions_and_types_and_usages_sparse_table/entity_revisions_and_types_and_usages_sparse_table_creation.sql

