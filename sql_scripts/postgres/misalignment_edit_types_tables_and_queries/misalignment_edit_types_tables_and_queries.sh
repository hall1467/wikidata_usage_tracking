# Have been running python scripts in the virtual environment on flagon here: /export/scratch2/wmf/scripts/

set base = /export/scratch2/wmf/scripts/wikidata_usage_tracking/sql_scripts/postgres/misalignment_edit_types_tables_and_queries
set results = /export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries


#############################################################
echo "'entity_revisions' table creation and querying section"
#############################################################

echo "Dropping old version of 'entity_revisions' table (if it exists)."
# psql wikidata_entities -c "drop table entity_revisions;"

# psql wikidata_entities < $base/entity_revisions_table/entity_revisions_table_creation.sql
# psql wikidata_entities < $base/entity_revisions_table/entity_revisions_table_import.sql
# psql wikidata_entities < $base/entity_revisions_table/entity_revisions_table_index_creation.sql


################################################################################################
echo "'entity_revisions_and_bot_flags_and_tool_change_tags' table creation and querying section"
################################################################################################

echo "Dropping old version of 'entity_revisions_and_bot_flags_and_tool_change_tags' table (if it exists)."
# psql wikidata_entities -c "drop table entity_revisions_and_bot_flags_and_tool_change_tags;"

# psql wikidata_entities < $base/entity_revisions_and_bot_flags_and_tool_change_tags_table/entity_revisions_and_bot_flags_and_tool_change_tags_table_creation.sql
# psql wikidata_entities < $base/entity_revisions_and_bot_flags_and_tool_change_tags_table/entity_revisions_and_bot_flags_and_tool_change_tags_table_index_creation.sql

echo "Dropping table 'entity_revisions' since it isn't needed anymore."
# psql wikidata_entities -c "drop table entity_revisions;"


##################################################################################
echo "'entity_revisions_and_types_and_usages' table creation and querying section"
##################################################################################

echo "Dropping old version of 'entity_revisions_and_types_and_usages' table (if it exists)."
# psql wikidata_entities -c "drop table entity_revisions_and_types_and_usages;"

# psql wikidata_entities < $base/entity_revisions_and_types_and_usages_table/entity_revisions_and_types_and_usages_table_creation.sql
# psql wikidata_entities < $base/entity_revisions_and_types_and_usages_table/entity_revisions_and_types_and_usages_ordered_by_revision_user_and_timestamp_query.sql
# psql wikidata_entities < $base/entity_revisions_and_types_and_usages_table/entity_revisions_and_types_and_usages_ordered_by_revision_user_and_timestamp_semi_automated_100_random_revisions_per_type_query.sql
# psql wikidata_entities < $base/entity_revisions_and_types_and_usages_table/entity_revisions_and_types_and_usages_ordered_by_revision_user_and_timestamp_semi_automated_revision_word_counts_query.sql


echo "Dropping table 'entity_revisions_and_bot_flags_and_tool_change_tags' since it isn't needed anymore."
# psql wikidata_entities -c "drop table entity_revisions_and_bot_flags_and_tool_change_tags;"

echo "Dropping table 'entity_revisions_and_types_and_usages' since it isn't needed anymore."
# psql wikidata_entities -c "drop table entity_revisions_and_types_and_usages;"


#########################################################################################################
echo "'user_session_gradient_boosting_bot_pred_thresholds' table creation and querying section"
#########################################################################################################

echo "Dropping old version of 'user_session_gradient_boosting_bot_pred_thresholds' table (if it exists)."
# psql wikidata_entities -c "drop table anonymous_user_session_gradient_boosting_bot_pred_thresholds;"

echo "Removing old version of '$results/add_end_timestamp_to_anonymous_session_prediction_data_error_log.txt' (if it exists)."
# rm -f $results/add_end_timestamp_to_anonymous_session_prediction_data_error_log.txt

echo "Removing old version of '$results/gradient_boosting_threshold_scores_I2_for_anonymous_user_sessions_with_session_end_no_header.tsv' (if it exists)."
# rm -f $results/gradient_boosting_threshold_scores_I2_for_anonymous_user_sessions_with_session_end_no_header.tsv

echo "Removing old version of '$results/registered_human_and_bot_sessions.tsv' (if it exists)."
# rm -f $results/registered_human_and_bot_sessions.tsv

echo "Removing old version of '$results/revisions_registered_human_and_bot_sessions_error_log.txt' (if it exists)."
# rm -f $results/revisions_registered_human_and_bot_sessions_error_log.txt

echo "Removing old version of '$results/REGISTERED_USERS_revisions_from_sessions_containing_item_or_property_edits_error_log.txt' (if it exists)."
# rm -f $results/REGISTERED_USERS_revisions_from_sessions_containing_item_or_property_edits_error_log.txt

echo "Removing old version of '$results/registered_users_predictor_and_inter_edit_construction_error_log.tsv' (if it exists)."
# rm -f $results/registered_users_predictor_and_inter_edit_construction_error_log.tsv

echo "Removing old version of '$results/model_applied_to_registered_users_error_log.txt' (if it exists)."
# rm -f $results/model_applied_to_registered_users_error_log.txt

# Removes retracted and anonymous user names
# tail -n +2 /export/scratch2/wmf/edit_analyses/old_12_12_17/session_data.tsv | grep -v "^NULL" > $results/registered_human_and_bot_sessions.tsv

# python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/edit_analyses/select_actual_revisions_from_random_sessions.py \
# 	/export/scratch2/wmf/edit_analyses/old_12_12_17/revision_session_data.tsv \
# 	$results/registered_human_and_bot_sessions.tsv \
# 	$results/revisions_registered_human_and_bot_sessions.tsv \
# 	--verbose \
# 	--debug > & \
# 	$results/revisions_registered_human_and_bot_sessions_error_log.txt

echo "Removing '$results/registered_human_and_bot_sessions.tsv' to save space."
# rm -f $results/registered_human_and_bot_sessions.tsv

# python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/edit_analyses/select_revisions_containing_property_or_item_edits.py \
# 	$results/revisions_registered_human_and_bot_sessions.tsv \
# 	$results/REGISTERED_USERS_revisions_from_sessions_containing_item_or_property_edits.tsv --verbose --debug > & \
# 	$results/REGISTERED_USERS_revisions_from_sessions_containing_item_or_property_edits_error_log.txt

echo "Removing '$results/revisions_registered_human_and_bot_sessions.tsv' to save space."
# rm -f $results/revisions_registered_human_and_bot_sessions.tsv

# python $base/user_session_gradient_boosting_bot_pred_thresholds_table/registered_users_predictor_and_inter_edit_construction.py \
# 	$results/REGISTERED_USERS_revisions_from_sessions_containing_item_or_property_edits.tsv \
# 	$results/REGISTERED_USERS_predictors_data.tsv \
# 	$results/REGISTERED_USERS_inter_edit.tsv --verbose --debug > & \
# 	$results/registered_users_predictor_and_inter_edit_construction_error_log.tsv

# python $base/user_session_gradient_boosting_bot_pred_thresholds_table/model_applied_to_registered_users.py \
# 	$results/predictors_and_labelled_data.tsv \
# 	$results/MODEL_TESTING_I2_FILTERED_predictors_and_labelled_data.tsv \
# 	$results/REGISTERED_USERS_predictors_data.tsv \
# 	$results/random_forest_predictions_for_registered_user_sessions.tsv \
# 	$results/gradient_boosting_predictions_for_registered_user_sessions.tsv \
# 	$results/gradient_boosting_threshold_scores_for_registered_user_sessions.tsv \
# 	$results/gradient_boosting_threshold_scores_I2_for_registered_user_sessions.tsv \
# 	$results/MODEL_TESTING_FILTERED_labelled_and_predicted_data.tsv \
# 	$results/gradient_boosting_PR_I2_for_registered_user_sessions.tsv \
# 	$results/gradient_boosting_ROC_I2_for_registered_user_sessions.tsv \
# 	--verbose > & \
# 	$results/model_applied_to_registered_users_error_log.txt

python $base/user_session_gradient_boosting_bot_pred_thresholds_table/merge_bot_prediction_files.py \
	$results/gradient_boosting_threshold_scores_I2_for_anonymous_user_sessions.tsv \
	$results/gradient_boosting_threshold_scores_I2_for_registered_user_sessions.tsv \
	$results/gradient_boosting_threshold_scores_I2_for_user_sessions.tsv \
	--verbose > & \
	$results/merge_bot_prediction_files_error_log.txt \

# python $base/user_session_gradient_boosting_bot_pred_thresholds_table/add_end_timestamp_to_user_session_prediction_data.py \
# 	$results/gradient_boosting_threshold_scores_I2_for_user_sessions.tsv \
# 	$results/gradient_boosting_threshold_scores_I2_for_user_sessions_with_session_end.tsv \
# 	--verbose > & \
# 	$results/add_end_timestamp_to_user_session_prediction_data_error_log.txt

# psql wikidata_entities < $base/user_session_gradient_boosting_bot_pred_thresholds_table/user_session_gradient_boosting_bot_pred_thresholds_table_creation.sql

# tail -n +2 $results/gradient_boosting_threshold_scores_I2_for_user_sessions_with_session_end.tsv \
# 	> $results/gradient_boosting_threshold_scores_I2_for_user_sessions_with_session_end_no_header.tsv

# psql wikidata_entities < $base/user_session_gradient_boosting_bot_pred_thresholds_table/user_session_gradient_boosting_bot_pred_thresholds_table_import.sql
# psql wikidata_entities < $base/user_session_gradient_boosting_bot_pred_thresholds_table/user_session_gradient_boosting_bot_pred_thresholds_ordered_by_username_and_session_start_query.sql


##########################################################################################################
echo "'entity_revisions_and_types_and_usages_and_bot_pred_thresholds' table creation and querying section"
##########################################################################################################

echo "Dropping old version of 'entity_revisions_and_types_and_usages_and_bot_pred_thresholds' table (if it exists)."
# psql wikidata_entities -c "drop table entity_revisions_and_types_and_usages_and_bot_pred_thresholds;"

# echo "Removing old version of '$results/entity_revisions_and_types_and_usages_with_bot_prediction_thresholds_error_log.txt' (if it exists)."
# rm -f $results/entity_revisions_and_types_and_usages_with_bot_prediction_thresholds_error_log.txt

echo "Removing old version of '$results/revision_misalignment_matcher_error_log.txt' (if it exists)."
# rm -f $results/revision_misalignment_matcher_error_log.txt

# python $base/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table/add_bot_prediction_threshold_to_entity_revisions_and_types_and_usages_data.py \
# 	$results/entity_revisions_and_types_and_usages_ordered_by_revision_user_and_timestamp.tsv \
# 	$results/user_session_gradient_boosting_bot_pred_thresholds_ordered_by_username_and_session_start.tsv \
# 	$results/entity_revisions_and_types_and_usages_with_bot_prediction_thresholds.tsv \
# 	--verbose > & \
# 	$results/entity_revisions_and_types_and_usages_with_bot_prediction_thresholds_error_log.txt

# python $base/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table/revision_misalignment_matcher.py \
# 	$results/entity_revisions_and_types_and_usages_with_bot_prediction_thresholds.tsv \
# 	$results/entity_revisions_and_types_and_usages_with_bot_prediction_thresholds_and_misalignment_month.tsv \
# 	--verbose > & \
# 	$results/entity_revisions_and_types_and_usages_with_bot_prediction_thresholds_and_misalignment_month_error_log.txt

# python $base/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table/add_additional_columns_based_on_revision_information.py \
# 	$results/entity_revisions_and_types_and_usages_with_bot_prediction_thresholds_and_misalignment_month.tsv \
# 	$results/entity_revisions_and_types_and_usages_with_bot_prediction_thresholds_and_misalignment_month_and_add_cols.tsv \
# 	--verbose > & \
# 	$results/entity_revisions_and_types_and_usages_with_bot_prediction_thresholds_and_misalignment_month_and_add_cols_error_log.txt

# psql wikidata_entities < $base/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table_creation.sql
# psql wikidata_entities < $base/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table_import.sql

echo "Removing '$results/entity_revisions_and_types_and_usages_ordered_by_revision_user_and_timestamp.tsv' to save space."
# rm -f $results/entity_revisions_and_types_and_usages_ordered_by_revision_user_and_timestamp.tsv

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

echo "Dropping old version of 'used_entity_previous_month_edits' table (if it exists)."
# psql wikidata_entities -c "drop table used_entity_previous_month_edits;"

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

echo "Dropping old version of 'misalignment_and_edits' table (if it exists)."
# psql wikidata_entities -c "drop table misalignment_and_edits;"

echo "Removing old version of '$results/wasted_edits_error_log.txt' (if it exists)."
# rm -f $results/wasted_edits_error_log.txt

# psql wikidata_entities < $base/misalignment_and_edits_table/misalignment_and_edits_table_creation.sql
# psql wikidata_entities < $base/misalignment_and_edits_table/misalignment_and_edits_entity_edits_ordered_by_entity_year_month_query.sql
# psql wikidata_entities < $base/misalignment_and_edits_table/misalignment_and_edits_entity_edits_grouped_and_ordered_by_year_month_query.sql
# psql wikidata_entities < $base/misalignment_and_edits_table/misalignment_and_edits_edit_proportions_by_entity_views_5_17_query.sql
# psql wikidata_entities < $base/misalignment_and_edits_table/misalignment_and_edits_edit_proportions_by_quality_and_view_class_5_17_query.sql
# psql wikidata_entities < $base/misalignment_and_edits_table/misalignment_and_edits_edit_proportions_by_quality_class_5_17_query.sql

# python $base/misalignment_and_edits_table/wasted_edit_analysis.py \
# 	$results/misalignment_and_edits_entity_edits_ordered_by_entity_year_month.tsv \
# 	$results/wasted_edits.tsv \
# 	--verbose > & \
# 	$results/wasted_edits_error_log.txt


