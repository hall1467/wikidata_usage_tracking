\copy (SELECT user, session_start, session_end, threshold_score FROM user_session_gradient_boosting_bot_pred_thresholds ORDER BY username, session_start) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/user_session_gradient_boosting_bot_pred_thresholds_ordered_by_username_and_session_start.tsv';