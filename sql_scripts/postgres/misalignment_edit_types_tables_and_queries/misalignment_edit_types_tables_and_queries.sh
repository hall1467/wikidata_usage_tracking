# Have been running python scripts in the virtual environment on flagon here: /export/scratch2/wmf/scripts/

# need to delete tables if created
# Need to delete tables if they aren't needed anymore? They take up a ton of space probably.
set base = /export/scratch2/wmf/scripts/wikidata_usage_tracking/sql_scripts/postgres/misalignment_edit_types_tables_and_queries
set results = /export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries


# "entity_revisions" table creation
# psql wikidata_entities < $base/entity_revisions_table/entity_revisions_table_creation.sql
# psql wikidata_entities < $base/entity_revisions_table/entity_revisions_table_import.sql
# psql wikidata_entities < $base/entity_revisions_table/entity_revisions_table_index_creation.sql

# "entity_revisions_and_bot_flags_and_tool_change_tags" table creation
# psql wikidata_entities < $base/entity_revisions_and_bot_flags_and_tool_change_tags_table/entity_revisions_and_bot_flags_and_tool_change_tags_table_creation.sql
# psql wikidata_entities < $base/entity_revisions_and_bot_flags_and_tool_change_tags_table/entity_revisions_and_bot_flags_and_tool_change_tags_table_index_creation.sql

# "entity_revisions_and_types_and_usages" table creation
# psql wikidata_entities < $base/entity_revisions_and_types_and_usages_table/entity_revisions_and_types_and_usages_table_creation.sql
# psql wikidata_entities < $base/entity_revisions_and_types_and_usages_table/entity_revisions_and_types_and_usages_ordered_by_revision_user_and_timestamp_query.sql

# "anonymous_user_session_gradient_boosting_bot_pred_thresholds" table creation
# python $base/anonymous_user_session_gradient_boosting_bot_pred_thresholds_table/add_end_timestamp_to_anonymous_session_prediction_data.py \
# 	$results/gradient_boosting_threshold_scores_I2_for_anonymous_user_sessions.tsv \
# 	$results/gradient_boosting_threshold_scores_I2_for_anonymous_user_sessions_with_session_end.tsv \
# 	--verbose > & \
# 	$results/gradient_boosting_threshold_scores_I2_for_anonymous_user_sessions_with_session_end_error_log.txt

# psql wikidata_entities < $base/anonymous_user_session_gradient_boosting_bot_pred_thresholds_table/anonymous_user_session_gradient_boosting_bot_pred_thresholds_table_creation.sql

# tail -n +2 $results/gradient_boosting_threshold_scores_I2_for_anonymous_user_sessions_with_session_end.tsv \
# 	> $results/gradient_boosting_threshold_scores_I2_for_anonymous_user_sessions_with_session_end_no_header.tsv

# psql wikidata_entities < $base/anonymous_user_session_gradient_boosting_bot_pred_thresholds_table/anonymous_user_session_gradient_boosting_bot_pred_thresholds_table_import.sql
# psql wikidata_entities < $base/anonymous_user_session_gradient_boosting_bot_pred_thresholds_table/anonymous_user_session_gradient_boosting_bot_pred_thresholds_ordered_by_username_and_session_start_query.sql


# "entity_revisions_and_types_and_usages_and_bot_pred_thresholds" table creation
# python $base/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table/add_bot_prediction_threshold_to_entity_revisions_and_types_and_usages_data.py \
# 	$results/entity_revisions_and_types_and_usages_ordered_by_revision_user_and_timestamp.tsv \
# 	$results/anonymous_user_session_gradient_boosting_bot_pred_thresholds_ordered_by_username_and_session_start.tsv \
# 	$results/entity_revisions_and_types_and_usages_with_bot_prediction_thresholds.tsv \
# 	--verbose > & \
# 	$results/entity_revisions_and_types_and_usages_with_bot_prediction_thresholds_error_log.txt

# psql wikidata_entities < $base/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table_creation.sql
# psql wikidata_entities < $base/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table_import.sql
# psql wikidata_entities < $base/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_new_edit_type_column.sql

# "entity_revisions_and_types_and_usages_and_bot_pred_thresholds" table creation
psql wikidata_entities < $base/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_sub_table_1_table_creation.sql
psql wikidata_entities < $base/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_sub_table_2_table_creation.sql
psql wikidata_entities < $base/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_sub_table_3_table_creation.sql
psql wikidata_entities < $base/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_sub_table_4_table_creation.sql
psql wikidata_entities < $base/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_sub_table_5_table_creation.sql
psql wikidata_entities < $base/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table_creation.sql
