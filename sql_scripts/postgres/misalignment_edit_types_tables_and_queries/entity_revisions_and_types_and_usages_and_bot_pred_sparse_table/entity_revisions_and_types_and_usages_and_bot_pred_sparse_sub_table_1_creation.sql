CREATE TABLE entity_revisions_and_types_and_usages_and_bot_pred_sparse_sub_table_1 AS (
	SELECT * 
	FROM crosstab(
		          'SELECT year_month_page_title, page_views, number_of_revisions, page_title, year, month, namespace, edit_type_updated, count(*) 
		           FROM entity_revisions_and_types_and_usages_and_bot_pred_thresholds
		           WHERE cast(substring(page_title from 2) AS INT) < 4000000
		           GROUP BY year_month_page_title, page_views, number_of_revisions, page_title, year, month, namespace, edit_type_updated 
		           ORDER BY year_month_page_title',
		           'SELECT DISTINCT edit_type_updated 
		           FROM entity_revisions_and_types_and_usages_and_bot_pred_thresholds 
		           ORDER BY edit_type_updated'
		          ) AS (
		                year_month_page_title TEXT, 
		                page_views NUMERIC,
		                number_of_revisions BIGINT,
		                page_title VARCHAR(255),
		                year BIGINT,
		                month BIGINT,
		                namespace BIGINT,
		                anon_one_hundred_recall_bot_edit BIGINT,
		                anon_ten_recall_bot_edit BIGINT,
		                anon_twenty_recall_bot_edit BIGINT,
		                anon_thirty_recall_bot_edit BIGINT,
		                anon_forty_recall_bot_edit BIGINT,
		                anon_fifty_recall_bot_edit BIGINT,
		                anon_sixty_recall_bot_edit BIGINT,
		                anon_seventy_recall_bot_edit BIGINT,
		                anon_eighty_recall_bot_edit BIGINT,
		                anon_ninety_recall_bot_edit BIGINT,
		                anon_edits BIGINT, 
		                bot_edits BIGINT, 
		                human_edits BIGINT, 
		                semi_automated_edits BIGINT
		               )
);