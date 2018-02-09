CREATE TABLE entity_revisions_and_types_and_usages_and_bot_pred_thresholds_sparse_sub_table_3 AS (
	SELECT * 
	FROM crosstab(
		          'SELECT year_month_page_title, page_views, number_of_revisions, page_title, year, month, namespace, edit_type_updated, count(*) 
		           FROM entity_revisions_and_types_and_usages_and_bot_pred_thresholds
		           WHERE cast(substring(page_title from 2) AS INT) >= 8000000 AND cast(substring(page_title from 2) AS INT) < 12000000
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
		                anon_1.00_recall_bot_edit BIGINT,
		                anon_.10_recall_bot_edit BIGINT,
		                anon_.20_recall_bot_edit BIGINT,
		                anon_.30_recall_bot_edit BIGINT,
		                anon_.40_recall_bot_edit BIGINT,
		                anon_.50_recall_bot_edit BIGINT,
		                anon_.60_recall_bot_edit BIGINT,
		                anon_.70_recall_bot_edit BIGINT,
		                anon_.80_recall_bot_edit BIGINT,
		                anon_.90_recall_bot_edit BIGINT,
		                anon_edits BIGINT, 
		                bot_edits BIGINT, 
		                human_edits BIGINT, 
		                semi_automated_edits BIGINT
		               )
);