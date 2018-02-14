\copy (SELECT entity_id, year, month, quality_class, views_class, bot_edits, semi_automated_edits, non_bot_edits, anon_edits, anon_ten_recall_bot_edit, anon_twenty_recall_bot_edit, anon_thirty_recall_bot_edit, anon_forty_recall_bot_edit, anon_fifty_recall_bot_edit, anon_sixty_recall_bot_edit, anon_seventy_recall_bot_edit, anon_eighty_recall_bot_edit, anon_ninety_recall_bot_edit, anon_one_hundred_recall_bot_edit FROM misalignment_and_edits ORDER BY entity_id, year, month) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/monthly_misalignment_and_edits_ordered_by_entity_year_month.tsv'; 
