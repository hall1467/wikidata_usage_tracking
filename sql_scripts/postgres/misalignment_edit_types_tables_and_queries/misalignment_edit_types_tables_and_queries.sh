# Have been running python scripts in the virtual environment on flagon here: /export/scratch2/wmf/scripts/

# Might want to fill in any additional queries. Including one for final jupyter notebook
set base = /export/scratch2/wmf/scripts/wikidata_usage_tracking/sql_scripts/postgres/misalignment_edit_types_tables_and_queries
set results = /export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries


#############################################################
echo "'entity_revisions' table creation and querying section"
#############################################################

psql wikidata_entities < $base/entity_revisions_table/entity_revisions_table_creation.sql
psql wikidata_entities < $base/entity_revisions_table/entity_revisions_table_import.sql
psql wikidata_entities < $base/entity_revisions_table/entity_revisions_table_index_creation.sql


################################################################################################
echo "'entity_revisions_and_bot_flags_and_tool_change_tags' table creation and querying section"
################################################################################################

psql wikidata_entities < $base/entity_revisions_and_bot_flags_and_tool_change_tags_table/entity_revisions_and_bot_flags_and_tool_change_tags_table_creation.sql
psql wikidata_entities < $base/entity_revisions_and_bot_flags_and_tool_change_tags_table/entity_revisions_and_bot_flags_and_tool_change_tags_table_index_creation.sql

echo "Dropping table 'entity_revisions' since it isn't needed anymore."
# psql wikidata_entities -c "drop table entity_revisions;"


##################################################################################
echo "'entity_revisions_and_types_and_usages' table creation and querying section"
##################################################################################

# psql wikidata_entities < $base/entity_revisions_and_types_and_usages_table/entity_revisions_and_types_and_usages_table_creation.sql
# psql wikidata_entities < $base/entity_revisions_and_types_and_usages_table/entity_revisions_and_types_and_usages_ordered_by_revision_user_and_timestamp_query.sql
# psql wikidata_entities < $base/entity_revisions_and_types_and_usages_table/entity_revisions_and_types_and_usages_ordered_by_revision_user_and_timestamp_semi_automated_100_random_revisions_per_type_query.sql
# psql wikidata_entities < $base/entity_revisions_and_types_and_usages_table/entity_revisions_and_types_and_usages_ordered_by_revision_user_and_timestamp_semi_automated_revision_word_counts_query.sql


echo "Dropping table 'entity_revisions_and_bot_flags_and_tool_change_tags' since it isn't needed anymore."
# psql wikidata_entities -c "drop table entity_revisions_and_bot_flags_and_tool_change_tags;"

echo "Dropping table 'entity_revisions_and_types_and_usages' since it isn't needed anymore."
# psql wikidata_entities -c "drop table entity_revisions_and_types_and_usages;"


#########################################################################################################
echo "'anonymous_user_session_gradient_boosting_bot_pred_thresholds' table creation and querying section"
#########################################################################################################

echo "Removing old version of '$results/gradient_boosting_threshold_scores_I2_for_anonymous_user_sessions_with_session_end_error_log.txt' (if it exists)."
# rm -f $results/gradient_boosting_threshold_scores_I2_for_anonymous_user_sessions_with_session_end_error_log.txt

echo "Removing old version of '$results/gradient_boosting_threshold_scores_I2_for_anonymous_user_sessions_with_session_end_no_header.tsv' (if it exists)."
# rm -f $results/gradient_boosting_threshold_scores_I2_for_anonymous_user_sessions_with_session_end_no_header.tsv

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


##########################################################################################################
echo "'entity_revisions_and_types_and_usages_and_bot_pred_thresholds' table creation and querying section"
##########################################################################################################

echo "Removing old version of '$results/entity_revisions_and_types_and_usages_with_bot_prediction_thresholds_error_log.txt' (if it exists)."
# rm -f $results/entity_revisions_and_types_and_usages_with_bot_prediction_thresholds_error_log.txt

# python $base/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table/add_bot_prediction_threshold_to_entity_revisions_and_types_and_usages_data.py \
# 	$results/entity_revisions_and_types_and_usages_ordered_by_revision_user_and_timestamp.tsv \
# 	$results/anonymous_user_session_gradient_boosting_bot_pred_thresholds_ordered_by_username_and_session_start.tsv \
# 	$results/entity_revisions_and_types_and_usages_with_bot_prediction_thresholds.tsv \
# 	--verbose > & \
# 	$results/entity_revisions_and_types_and_usages_with_bot_prediction_thresholds_error_log.txt

# psql wikidata_entities < $base/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table_creation.sql
# psql wikidata_entities < $base/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table_import.sql
# psql wikidata_entities < $base/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_new_edit_type_column.sql


######################################################################################################
echo "'entity_revisions_and_types_and_usages_and_bot_pred_sparse' table creation and querying section"
######################################################################################################

echo "Dropping old versions of 'entity_revisions_and_types_and_usages_and_bot_pred_sparse' table and sub tables (if they exist)."
# psql wikidata_entities -c "drop table entity_revisions_and_types_and_usages_and_bot_pred_sparse_sub_1;"
# psql wikidata_entities -c "drop table entity_revisions_and_types_and_usages_and_bot_pred_sparse_sub_2;"
# psql wikidata_entities -c "drop table entity_revisions_and_types_and_usages_and_bot_pred_sparse_sub_3;"
# psql wikidata_entities -c "drop table entity_revisions_and_types_and_usages_and_bot_pred_sparse_sub_4;"
# psql wikidata_entities -c "drop table entity_revisions_and_types_and_usages_and_bot_pred_sparse_sub_5;"
# psql wikidata_entities -c "drop table entity_revisions_and_types_and_usages_and_bot_pred_sparse;"

echo "Creating 'entity_revisions_and_types_and_usages_and_bot_pred_sparse' table and sub tables (first)."
# psql wikidata_entities < $base/entity_revisions_and_types_and_usages_and_bot_pred_sparse_table/entity_revisions_and_types_and_usages_and_bot_pred_sparse_sub_1_table_creation.sql
# psql wikidata_entities < $base/entity_revisions_and_types_and_usages_and_bot_pred_sparse_table/entity_revisions_and_types_and_usages_and_bot_pred_sparse_sub_2_table_creation.sql
# psql wikidata_entities < $base/entity_revisions_and_types_and_usages_and_bot_pred_sparse_table/entity_revisions_and_types_and_usages_and_bot_pred_sparse_sub_3_table_creation.sql
# psql wikidata_entities < $base/entity_revisions_and_types_and_usages_and_bot_pred_sparse_table/entity_revisions_and_types_and_usages_and_bot_pred_sparse_sub_4_table_creation.sql
# psql wikidata_entities < $base/entity_revisions_and_types_and_usages_and_bot_pred_sparse_table/entity_revisions_and_types_and_usages_and_bot_pred_sparse_sub_5_table_creation.sql
# psql wikidata_entities < $base/entity_revisions_and_types_and_usages_and_bot_pred_sparse_table/entity_revisions_and_types_and_usages_and_bot_pred_sparse_table_creation.sql

echo "Dropping table 'entity_revisions_and_types_and_usages_and_bot_pred_thresholds' since it isn't needed anymore."
# psql wikidata_entities -c "drop table entity_revisions_and_types_and_usages_and_bot_pred_thresholds;"

echo "Dropping table and sub tables of 'entity_revisions_and_types_and_usages_and_bot_pred_sparse' since they aren't needed anymore."
# psql wikidata_entities -c "drop table entity_revisions_and_types_and_usages_and_bot_pred_sparse_sub_1;"
# psql wikidata_entities -c "drop table entity_revisions_and_types_and_usages_and_bot_pred_sparse_sub_2;"
# psql wikidata_entities -c "drop table entity_revisions_and_types_and_usages_and_bot_pred_sparse_sub_3;"
# psql wikidata_entities -c "drop table entity_revisions_and_types_and_usages_and_bot_pred_sparse_sub_4;"
# psql wikidata_entities -c "drop table entity_revisions_and_types_and_usages_and_bot_pred_sparse_sub_5;"
# psql wikidata_entities -c "drop table entity_revisions_and_types_and_usages_and_bot_pred_sparse;"

# psql wikidata_entities < $base/entity_revisions_and_types_and_usages_and_bot_pred_sparse_table/used_entity_monthly_edit_breakdowns_query.sql


#############################################################################
echo "'used_entity_previous_month_edits' table creation and querying section"
#############################################################################

# echo "Removing old version of '$results/used_entity_edits_aggregated_by_month_error_log.txt' (if it exists)."
# rm -f $results/used_entity_edits_aggregated_by_month_error_log.txt

# python $base/used_entity_previous_month_edits_table/entity_edit_preprocessor.py \
# 	$results/used_entity_monthly_edit_breakdowns.tsv \
# 	$results/used_entity_edits_aggregated_by_month.tsv \
# 	--verbose > & \
# 	$results/used_entity_edits_aggregated_by_month_error_log.txt

# psql wikidata_entities < $base/used_entity_previous_month_edits_table/used_entity_previous_month_edits_table_creation.sql
# psql wikidata_entities < $base/used_entity_previous_month_edits_table/used_entity_previous_month_edits_table_import.sql

# echo "Dropping file '$results/used_entity_edits_aggregated_by_month.tsv' since it isn't needed anymore."
# rm -f $results/used_entity_edits_aggregated_by_month.tsv


###################################################################
echo "'misalignment_and_edits' table creation and querying section"
###################################################################

echo "Removing old version of '$results/wasted_edits_error_log.txt' (if it exists)."
# rm -f $results/wasted_edits_error_log.txt

# psql wikidata_entities < $base/misalignment_and_edits_table/misalignment_and_edits_table_creation.sql
# psql wikidata_entities < $base/misalignment_and_edits_table/misalignment_and_edits_ordered_by_entity_year_month_query.sql
# psql wikidata_entities < $base/misalignment_and_edits_table/misalignment_and_edits_edit_proportions_by_entity_views_5_17.sql
# psql wikidata_entities < $base/misalignment_and_edits_table/misalignment_and_edits_edit_proportions_by_quality_and_view_class_5_17.sql
# psql wikidata_entities < $base/misalignment_and_edits_table/misalignment_and_edits_edit_proportions_by_quality_class_5_17.sql

# python $base/misalignment_and_edits_table/wasted_edit_analysis.py \
# 	$results/monthly_misalignment_and_edits_ordered_by_entity_year_month.tsv \
# 	$results/wasted_edits.tsv \
# 	--verbose > & \
# 	$results/wasted_edits_error_log.txt


