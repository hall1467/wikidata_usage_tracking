CREATE TABLE entity_edit_types_sparse_and_usage AS (
	SELECT year_month_page_title, page_views, number_of_revisions, page_title, year, month, namespace, anon_edits, bot_edits, human_edits, semi_automated_edits
	FROM entity_edit_types_sparse_and_usage_sub_table_1
	UNION ALL
	SELECT year_month_page_title, page_views, number_of_revisions, page_title, year, month, namespace, anon_edits, bot_edits, human_edits, semi_automated_edits
	FROM entity_edit_types_sparse_and_usage_sub_table_2
	UNION ALL
	SELECT year_month_page_title, page_views, number_of_revisions, page_title, year, month, namespace, anon_edits, bot_edits, human_edits, semi_automated_edits
	FROM entity_edit_types_sparse_and_usage_sub_table_3
	UNION ALL
	SELECT year_month_page_title, page_views, number_of_revisions, page_title, year, month, namespace, anon_edits, bot_edits, human_edits, semi_automated_edits
	FROM entity_edit_types_sparse_and_usage_sub_table_4
	UNION ALL
	SELECT year_month_page_title, page_views, number_of_revisions, page_title, year, month, namespace, anon_edits, bot_edits, human_edits, semi_automated_edits
	FROM entity_edit_types_sparse_and_usage_sub_table_5
);