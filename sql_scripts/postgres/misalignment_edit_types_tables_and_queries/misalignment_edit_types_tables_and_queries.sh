# Have been running python scripts in the virtual environment on flagon here: /export/scratch2/wmf/scripts/

set base = /export/scratch2/wmf/scripts/wikidata_usage_tracking/sql_scripts/postgres/misalignment_edit_types_tables_and_queries
set results = /export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries
set input_for_rmse_split_directory = $results/input_for_rmse_split_directory


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

# python $base/user_session_gradient_boosting_bot_pred_thresholds_table/merge_bot_prediction_files.py \
# 	$results/gradient_boosting_threshold_scores_I2_for_anonymous_user_sessions.tsv \
# 	$results/gradient_boosting_threshold_scores_I2_for_registered_user_sessions.tsv \
# 	$results/gradient_boosting_threshold_scores_I2_for_user_sessions.tsv \
# 	--verbose > & \
# 	$results/merge_bot_prediction_files_error_log.txt \

# python $base/user_session_gradient_boosting_bot_pred_thresholds_table/add_end_timestamp_to_user_session_prediction_data.py \
# 	$results/gradient_boosting_threshold_scores_I2_for_user_sessions.tsv \
# 	$results/gradient_boosting_threshold_scores_I2_for_user_sessions_with_session_end.tsv \
# 	--verbose > & \
# 	$results/add_end_timestamp_to_user_session_prediction_data_error_log.txt

# psql wikidata_entities < $base/user_session_gradient_boosting_bot_pred_thresholds_table/user_session_gradient_boosting_bot_pred_thresholds_table_creation.sql

# tail -n +2 $results/gradient_boosting_threshold_scores_I2_for_user_sessions_with_session_end.tsv \
# 	> $results/gradient_boosting_threshold_scores_I2_for_user_sessions_with_session_end_no_header.tsv

# psql wikidata_entities < $base/user_session_gradient_boosting_bot_pred_thresholds_table/user_session_gradient_boosting_bot_pred_thresholds_table_import.sql
# psql wikidata_entities < $base/user_session_gradient_boosting_bot_pred_thresholds_table/user_session_gradient_boosting_bot_pred_thresholds_ordered_by_user_and_session_start_query.sql


##########################################################################################################
echo "'entity_revisions_and_types_and_usages_and_bot_pred_thresholds' table creation and querying section"
##########################################################################################################

echo "Dropping old version of 'entity_revisions_and_types_and_usages_and_bot_pred_thresholds' table (if it exists)."
# psql wikidata_entities -c "drop table entity_revisions_and_types_and_usages_and_bot_pred_thresholds;"

echo "Removing old version of '$results/entity_revisions_and_types_and_usages_with_bot_prediction_thresholds_error_log.txt' (if it exists)."
# rm -f $results/entity_revisions_and_types_and_usages_with_bot_prediction_thresholds_error_log.txt

echo "Removing old version of '$results/entity_revisions_and_types_and_usages_with_bot_prediction_thresholds_and_misalignment_month_error_log.txt' (if it exists)."
# rm -f $results/entity_revisions_and_types_and_usages_with_bot_prediction_thresholds_and_misalignment_month_error_log.txt

echo "Removing old version of '$results/entity_revisions_and_types_and_usages_with_bot_prediction_thresholds_and_misalignment_month_and_add_cols_error_log.txt' (if it exists)."
rm -f $results/entity_revisions_and_types_and_usages_with_bot_prediction_thresholds_and_misalignment_month_and_add_cols_error_log.txt

# python $base/entity_revisions_and_types_and_usages_and_bot_pred_thresholds_table/add_bot_prediction_threshold_to_entity_revisions_and_types_and_usages_data.py \
# 	$results/entity_revisions_and_types_and_usages_ordered_by_revision_user_and_timestamp.tsv \
# 	$results/user_session_gradient_boosting_bot_pred_thresholds_ordered_by_user_and_session_start.tsv \
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
# psql wikidata_entities < $base/misalignment_and_edits_table/misalignment_and_edits_query.sql

# python $base/misalignment_and_edits_table/attribute_aggregator.py \
# 	$results/misalignment_and_edits_ordered_by_year_and_month.tsv \
# 	$results/attribute_aggreations.tsv \
# 	$results/views_and_quality_class_edits.tsv \
# 	$results/views_class_edits.tsv \
# 	$results/quality_class_edits.tsv \
# 	--verbose > & \
# 	$results/attribute_aggregator_error_log.txt

# python $base/misalignment_and_edits_table/wasted_edit_analysis.py \
# 	$results/misalignment_and_edits_entity_edits_ordered_by_entity_year_month.tsv \
# 	$results/wasted_edits.tsv \
# 	--verbose > & \
# 	$results/wasted_edits_error_log.txt

## Note right now, output from attribute_aggregator.py is being manually merged with monthly misalignment data

###################################################################
echo "'quality_weighted_sum_and_views_05_17', 'sampled_quality_weighted_sum_and_views_05_17', and 'sampled_quality_weighted_sum_and_views_05_17_with_revisions' table creations and querying section"
###################################################################

# psql wikidata_entities < $base/quality_weighted_sum_and_views_05_17_tables/entity_weighted_sums_and_page_views_query.sql

# shuf -n 1000000 $results/entity_weighted_sums_and_page_views.tsv > $results/entity_weighted_sums_and_page_views_sampled_1_million.tsv

# psql wikidata_entities < $base/quality_weighted_sum_and_views_05_17_tables/sampled_quality_weighted_sum_and_views_05_17_table_creation.sql
# psql wikidata_entities < $base/quality_weighted_sum_and_views_05_17_tables/sampled_quality_weighted_sum_and_views_05_17_table_import.sql

# psql wikidata_entities < $base/quality_weighted_sum_and_views_05_17_tables/sampled_quality_weighted_sum_and_views_05_17_with_revisions_table_creation.sql

# psql wikidata_entities < $base/quality_weighted_sum_and_views_05_17_tables/sampled_quality_weighted_sum_and_views_05_17_with_revisions_query.sql


# Ran: \copy (SELECT page_id, title, rev_id, monthly_timestamp, prediction, weighted_sum from monthly_item_quality order by monthly_timestamp) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/monthly_item_quality_sorted_by_month.tsv';

# Need a script here that takes in quality_weighted_sum_and_views_05_17 and output from above query

# python $base/quality_weighted_sum_and_views_05_17_tables/misalignment_preprocessor.py \
# 		$results/entity_weighted_sums_and_page_views.tsv \
# 		$results/monthly_item_quality_sorted_by_month.tsv \
# 		$results/input_for_RMSE.tsv \
# 		--verbose > & \
# 		$results/misalignment_preprocessor_error_log.txt

# update above python script to write to different directory
# input_for_rmse_split_directory


# tail -n +2 input_for_RMSE.tsv > input_for_RMSE_no_header.tsv

# length of May 2017 Wikidata entity "universe"
# split -d  -l 22149770 input_for_RMSE_no_header.tsv input_for_RMSE_sub_

# Should delete output file before for loop

# foreach input_RMSE_file ($input_for_rmse_split_directory/input_for_RMSE_sub*)
# 	Rscript $base/quality_weighted_sum_and_views_05_17_tables/expected_quality_versus_actual_quality_RMSE.r $input_RMSE_file
# end


# \copy (SELECT page_title, revision_id, revision_user, comment, namespace, revision_timestamp, year, month, bot_user_id, change_tag_revision_id, number_of_revisions, page_views, edit_type, year_month_page_title, bot_prediction_threshold, session_start, misalignment_matching_year, misalignment_matching_month, edit_type_updated, reference_manipulation, sitelink_manipulation, label_description_or_alias_manipulation, quality_class, views_class FROM misalignment_and_edits where revision_timestamp >= 20130500000000 and revision_timestamp < 20140500000000 AND page_views IS NOT NULL) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/used_misalignment_and_edits_may_2013_to_2014.tsv';
# \copy (SELECT page_title, revision_id, revision_user, comment, namespace, revision_timestamp, year, month, bot_user_id, change_tag_revision_id, number_of_revisions, page_views, edit_type, year_month_page_title, bot_prediction_threshold, session_start, misalignment_matching_year, misalignment_matching_month, edit_type_updated, reference_manipulation, sitelink_manipulation, label_description_or_alias_manipulation, quality_class, views_class FROM misalignment_and_edits where revision_timestamp >= 20140500000000 and revision_timestamp < 20150500000000 AND page_views IS NOT NULL) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/used_misalignment_and_edits_may_2014_to_2015.tsv';
# \copy (SELECT page_title, revision_id, revision_user, comment, namespace, revision_timestamp, year, month, bot_user_id, change_tag_revision_id, number_of_revisions, page_views, edit_type, year_month_page_title, bot_prediction_threshold, session_start, misalignment_matching_year, misalignment_matching_month, edit_type_updated, reference_manipulation, sitelink_manipulation, label_description_or_alias_manipulation, quality_class, views_class FROM misalignment_and_edits where revision_timestamp >= 20150500000000 and revision_timestamp < 20160500000000 AND page_views IS NOT NULL) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/used_misalignment_and_edits_may_2015_to_2016.tsv';
# \copy (SELECT page_title, revision_id, revision_user, comment, namespace, revision_timestamp, year, month, bot_user_id, change_tag_revision_id, number_of_revisions, page_views, edit_type, year_month_page_title, bot_prediction_threshold, session_start, misalignment_matching_year, misalignment_matching_month, edit_type_updated, reference_manipulation, sitelink_manipulation, label_description_or_alias_manipulation, quality_class, views_class FROM misalignment_and_edits where revision_timestamp >= 20160500000000 and revision_timestamp < 20170500000000 AND page_views IS NOT NULL) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/used_misalignment_and_edits_may_2016_to_2017.tsv';

# shuf -n 1000000 $results/used_misalignment_and_edits_may_2016_to_2017.tsv > $results/used_misalignment_and_edits_may_2016_to_2017_million_sampled.tsv

python $base/quality_weighted_sum_and_views_05_17_tables/convert_sample_tsv_to_json.py \
	$results/used_misalignment_and_edits_may_2016_to_2017_million_sampled.tsv \
	$results/revision_edit_and_agent_type_may_2016_to_2017_million_sampled.json \
	--verbose > & \
	$results/convert_sample_tsv_to_json_error_log.txt

