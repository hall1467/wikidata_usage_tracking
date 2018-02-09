CREATE TABLE entity_revisions_and_types_and_usages_and_bot_pred_thresholds_sparse AS (
	SELECT year_month_page_title, page_views, number_of_revisions, page_title, year, month, namespace, anon_edits, bot_edits, human_edits, semi_automated_edits, anon_.10_recall_bot_edit, anon_.20_recall_bot_edit, anon_.30_recall_bot_edit, anon_.40_recall_bot_edit, anon_.50_recall_bot_edit, anon_.60_recall_bot_edit, anon_.70_recall_bot_edit, anon_.80_recall_bot_edit, anon_.90_recall_bot_edit, anon_1.00_recall_bot_edit
	FROM entity_revisions_and_types_and_usages_and_bot_pred_thresholds_sparse_sub_table_1
	UNION ALL
	SELECT year_month_page_title, page_views, number_of_revisions, page_title, year, month, namespace, anon_edits, bot_edits, human_edits, semi_automated_edits, anon_.10_recall_bot_edit, anon_.20_recall_bot_edit, anon_.30_recall_bot_edit, anon_.40_recall_bot_edit, anon_.50_recall_bot_edit, anon_.60_recall_bot_edit, anon_.70_recall_bot_edit, anon_.80_recall_bot_edit, anon_.90_recall_bot_edit, anon_1.00_recall_bot_edit
	FROM entity_revisions_and_types_and_usages_and_bot_pred_thresholds_sparse_sub_table_2
	UNION ALL
	SELECT year_month_page_title, page_views, number_of_revisions, page_title, year, month, namespace, anon_edits, bot_edits, human_edits, semi_automated_edits, anon_.10_recall_bot_edit, anon_.20_recall_bot_edit, anon_.30_recall_bot_edit, anon_.40_recall_bot_edit, anon_.50_recall_bot_edit, anon_.60_recall_bot_edit, anon_.70_recall_bot_edit, anon_.80_recall_bot_edit, anon_.90_recall_bot_edit, anon_1.00_recall_bot_edit
	FROM entity_revisions_and_types_and_usages_and_bot_pred_thresholds_sparse_sub_table_3
	UNION ALL
	SELECT year_month_page_title, page_views, number_of_revisions, page_title, year, month, namespace, anon_edits, bot_edits, human_edits, semi_automated_edits, anon_.10_recall_bot_edit, anon_.20_recall_bot_edit, anon_.30_recall_bot_edit, anon_.40_recall_bot_edit, anon_.50_recall_bot_edit, anon_.60_recall_bot_edit, anon_.70_recall_bot_edit, anon_.80_recall_bot_edit, anon_.90_recall_bot_edit, anon_1.00_recall_bot_edit
	FROM entity_revisions_and_types_and_usages_and_bot_pred_thresholds_sparse_sub_table_4
	UNION ALL
	SELECT year_month_page_title, page_views, number_of_revisions, page_title, year, month, namespace, anon_edits, bot_edits, human_edits, semi_automated_edits, anon_.10_recall_bot_edit, anon_.20_recall_bot_edit, anon_.30_recall_bot_edit, anon_.40_recall_bot_edit, anon_.50_recall_bot_edit, anon_.60_recall_bot_edit, anon_.70_recall_bot_edit, anon_.80_recall_bot_edit, anon_.90_recall_bot_edit, anon_1.00_recall_bot_edit
	FROM entity_revisions_and_types_and_usages_and_bot_pred_thresholds_sparse_sub_table_5
);