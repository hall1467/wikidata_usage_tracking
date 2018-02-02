CREATE TABLE entity_revisions_and_types_and_usages_sparse AS (
	SELECT year_month_page_title, page_views, number_of_revisions, page_title, year, month, namespace, anon_edits, bot_edits, human_edits, semi_automated_edits
	FROM entity_revisions_and_types_and_usages_sparse_sub_table_1
	UNION ALL
	SELECT year_month_page_title, page_views, number_of_revisions, page_title, year, month, namespace, anon_edits, bot_edits, human_edits, semi_automated_edits
	FROM entity_revisions_and_types_and_usages_sparse_sub_table_2
	UNION ALL
	SELECT year_month_page_title, page_views, number_of_revisions, page_title, year, month, namespace, anon_edits, bot_edits, human_edits, semi_automated_edits
	FROM entity_revisions_and_types_and_usages_sparse_sub_table_3
	UNION ALL
	SELECT year_month_page_title, page_views, number_of_revisions, page_title, year, month, namespace, anon_edits, bot_edits, human_edits, semi_automated_edits
	FROM entity_revisions_and_types_and_usages_sparse_sub_table_4
	UNION ALL
	SELECT year_month_page_title, page_views, number_of_revisions, page_title, year, month, namespace, anon_edits, bot_edits, human_edits, semi_automated_edits
	FROM entity_revisions_and_types_and_usages_sparse_sub_table_5
);