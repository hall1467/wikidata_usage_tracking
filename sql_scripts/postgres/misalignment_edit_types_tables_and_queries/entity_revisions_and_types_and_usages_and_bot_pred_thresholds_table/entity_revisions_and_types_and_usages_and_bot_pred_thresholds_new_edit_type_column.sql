ALTER TABLE entity_revisions_and_types_and_usages_and_bot_pred_thresholds
ADD COLUMN edit_type_updated text;

UPDATE entity_revisions_and_types_and_usages_and_bot_pred_thresholds
SET edit_type_updated = (CASE WHEN edit_type = 'anon_edit' AND bot_prediction_threshold >= 5.46 THEN 'anon_ten_recall_bot_edit'
							  WHEN edit_type = 'anon_edit' AND bot_prediction_threshold >= 4.01 THEN 'anon_twenty_recall_bot_edit'
						      WHEN edit_type = 'anon_edit' AND bot_prediction_threshold >= 3.01 THEN 'anon_thirty_recall_bot_edit'
						      WHEN edit_type = 'anon_edit' AND bot_prediction_threshold >= 2.21 THEN 'anon_forty_recall_bot_edit'
						      WHEN edit_type = 'anon_edit' AND bot_prediction_threshold >= 1.41 THEN 'anon_fifty_recall_bot_edit'
						      WHEN edit_type = 'anon_edit' AND bot_prediction_threshold >= .66 THEN 'anon_sixty_recall_bot_edit'
						      WHEN edit_type = 'anon_edit' AND bot_prediction_threshold >= -.18 THEN 'anon_seventy_recall_bot_edit'
						      WHEN edit_type = 'anon_edit' AND bot_prediction_threshold >= -1.18 THEN 'anon_eighty_recall_bot_edit'
						      WHEN edit_type = 'anon_edit' AND bot_prediction_threshold >= -2.39 THEN 'anon_ninety_recall_bot_edit'
						      WHEN edit_type = 'anon_edit' AND bot_prediction_threshold >= -5.25 THEN 'anon_one_hundred_recall_bot_edit'
						      ELSE edit_type END);