#########################################################
######### Model test set generation for R and R #########
#########################################################

# Removes retracted and anonymous user names
# tail -n +2 /export/scratch2/wmf/edit_analyses/session_data.tsv | grep -v "^NULL" | shuf -n 100000 > \
# 	/export/scratch2/wmf/edit_analyses/MODEL_TESTING_R_100000_random_registered_human_and_bot_sessions.tsv

# python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/edit_analyses/take_out_used_data_from_testing_set_R.py \
# 	/export/scratch2/wmf/edit_analyses/100000_random_registered_human_and_bot_sessions.tsv \
# 	/export/scratch2/wmf/edit_analyses/MODEL_TESTING_100000_random_registered_human_and_bot_sessions.tsv \
# 	/export/scratch2/wmf/edit_analyses/MODEL_TESTING_I2_100000_random_registered_human_and_bot_sessions.tsv \
#     /export/scratch2/wmf/edit_analyses/MODEL_TESTING_R_100000_random_registered_human_and_bot_sessions.tsv \
# 	/export/scratch2/wmf/edit_analyses/MODEL_TESTING_R_FILTERED_100000_random_registered_human_and_bot_sessions.tsv \
# 	--verbose \
# 	--debug > & \
# 	/export/scratch2/wmf/edit_analyses/MODEL_TESTING_R_FILTERED_100000_random_registered_human_and_bot_sessions_error_log.txt

# python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/edit_analyses/select_actual_revisions_from_random_sessions.py \
# 	/export/scratch2/wmf/edit_analyses/revision_session_data.tsv \
# 	/export/scratch2/wmf/edit_analyses/MODEL_TESTING_R_FILTERED_100000_random_registered_human_and_bot_sessions.tsv \
# 	/export/scratch2/wmf/edit_analyses/MODEL_TESTING_R_FILTERED_revisions_from_100000_random_registered_human_and_bot_sessions.tsv \
# 	--verbose \
# 	--debug > & \
# 	/export/scratch2/wmf/edit_analyses/MODEL_TESTING_R_FILTERED_revisions_from_100000_random_registered_human_and_bot_sessions_error_log.txt

# python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/edit_analyses/select_revisions_containing_property_or_item_edits.py \
# 	/export/scratch2/wmf/edit_analyses/MODEL_TESTING_R_FILTERED_revisions_from_100000_random_registered_human_and_bot_sessions.tsv \
# 	/export/scratch2/wmf/edit_analyses/MODEL_TESTING_R_FILTERED_revisions_from_100000_random_registered_human_and_bot_sessions_containing_item_or_property_edits.tsv \
# 	--verbose \
# 	--debug > & \
# 	/export/scratch2/wmf/edit_analyses/MODEL_TESTING_R_FILTERED_revisions_from_100000_random_registered_human_and_bot_sessions_containing_item_or_property_edits_error_log.txt

# python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/edit_analyses/label_edits_as_bot_or_human.py \
# 	/export/scratch2/wmf/edit_analyses/MODEL_TESTING_R_FILTERED_revisions_from_100000_random_registered_human_and_bot_sessions_containing_item_or_property_edits.tsv \
# 	/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_bots/bot_user_ids.tsv \
# 	/export/scratch2/wmf/edit_analyses/MODEL_TESTING_R_FILTERED_revisions_from_100000_random_registered_human_and_bot_sessions_containing_item_or_property_edits_labelled.tsv \
# 	--verbose \
# 	--debug > & \
# 	/export/scratch2/wmf/edit_analyses/MODEL_TESTING_R_FILTERED_revisions_from_100000_random_registered_human_and_bot_sessions_containing_item_or_property_edits_labelled_error_log.txt

# python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/edit_analyses/session_stats.py \
# 	/export/scratch2/wmf/edit_analyses/MODEL_TESTING_R_FILTERED_revisions_from_100000_random_registered_human_and_bot_sessions_containing_item_or_property_edits_labelled.tsv \
# 	/export/scratch2/wmf/edit_analyses/MODEL_TESTING_R_FILTERED_session_stats.txt \
# 	--verbose \
# 	--debug > & \
# 	/export/scratch2/wmf/edit_analyses/MODEL_TESTING_R_FILTERED_session_stats_error_log.txt

# python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/edit_analyses/predictor_construction.py \
# 	/export/scratch2/wmf/edit_analyses/MODEL_TESTING_R_FILTERED_revisions_from_100000_random_registered_human_and_bot_sessions_containing_item_or_property_edits_labelled.tsv \
# 	/export/scratch2/wmf/edit_analyses/MODEL_TESTING_R_FILTERED_predictors_and_labelled_data.tsv \
# 	--verbose \
# 	--debug > & \
# 	/export/scratch2/wmf/edit_analyses/MODEL_TESTING_R_FILTERED_predictors_and_labelled_data_error_log.tsv


##############################################
######### Model training and testing #########
##############################################

python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/edit_analyses/model_construction_R.py \
	   /export/scratch2/wmf/edit_analyses/predictors_and_labelled_data.tsv \
	   /export/scratch2/wmf/edit_analyses/MODEL_TESTING_R_FILTERED_predictors_and_labelled_data.tsv > \
	   /export/scratch2/wmf/edit_analyses/model_building_results.txt



