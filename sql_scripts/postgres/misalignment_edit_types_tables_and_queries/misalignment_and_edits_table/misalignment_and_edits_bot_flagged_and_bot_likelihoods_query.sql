\copy (SELECT revision_id, 
	   CASE WHEN edit_type = 'bot_edit' THEN TRUE ELSE FALSE END, 
	   (CASE WHEN edit_type_updated = 'anon_ten_recall_bot_edit' THEN 'zero_to_ten_recall'
	   		 WHEN edit_type_updated = 'anon_twenty_recall_bot_edit' THEN 'ten_to_twenty_recall'
	   		 WHEN edit_type_updated = 'anon_thirty_recall_bot_edit' THEN 'twenty_to_thirty_recall'
	   		 WHEN edit_type_updated = 'anon_forty_recall_bot_edit' THEN 'thirty_to_forty_recall'
	   		 WHEN edit_type_updated = 'anon_fifty_recall_bot_edit' THEN 'forty_to_fifty_recall'
	   		 WHEN edit_type_updated = 'anon_sixty_recall_bot_edit' THEN 'fifty_to_sixty_recall'
	   		 WHEN edit_type_updated = 'anon_seventy_recall_bot_edit' THEN 'sixty_to_seventy_recall'
	   		 WHEN edit_type_updated = 'anon_eighty_recall_bot_edit' THEN 'seventy_to_eighty_recall'
	   		 WHEN edit_type_updated = 'anon_ninety_recall_bot_edit' THEN 'eighty_to_ninety_recall'
	   		 WHEN edit_type_updated = 'anon_one_hundred_recall_bot_edit' THEN 'ninety_to_one_hundred_recall'
	   	) as bot_likelihood FROM misalignment_and_edits) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/misalignment_and_edits_bot_flagged_and_bot_likelihoods_query.tsv';