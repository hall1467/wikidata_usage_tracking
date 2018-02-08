ALTER TABLE entity_revisions_and_types_and_usages_and_bot_pred_thresholds
ADD COLUMN "edit_type_updated" text;

UPDATE entity_revisions_and_types_and_usages_and_bot_pred_thresholds
SET edit_type_updated = (CASE WHEN edit_type = 'anon_edit' AND bot_prediction_threshold >= 5.46 THEN 'anon_.10_recall_bot_edit'
							  WHEN edit_type = 'anon_edit' AND bot_prediction_threshold >= 4.01 THEN 'anon_.20_recall_bot_edit'
						      WHEN edit_type = 'anon_edit' AND bot_prediction_threshold >= 3.01 THEN 'anon_.30_recall_bot_edit'
						      WHEN edit_type = 'anon_edit' AND bot_prediction_threshold >= 2.21 THEN 'anon_.40_recall_bot_edit'
						      WHEN edit_type = 'anon_edit' AND bot_prediction_threshold >= 1.41 THEN 'anon_.50_recall_bot_edit'
						      WHEN edit_type = 'anon_edit' AND bot_prediction_threshold >= .66 THEN 'anon_.60_recall_bot_edit'
						      WHEN edit_type = 'anon_edit' AND bot_prediction_threshold >= -.18 THEN 'anon_.70_recall_bot_edit'
						      WHEN edit_type = 'anon_edit' AND bot_prediction_threshold >= -1.18 THEN 'anon_.80_recall_bot_edit'
						      WHEN edit_type = 'anon_edit' AND bot_prediction_threshold >= -2.39 THEN 'anon_.90_recall_bot_edit'
						      WHEN edit_type = 'anon_edit' AND bot_prediction_threshold >= -5.25 THEN 'anon_1.00_recall_bot_edit'
						      ELSE edit_type END);