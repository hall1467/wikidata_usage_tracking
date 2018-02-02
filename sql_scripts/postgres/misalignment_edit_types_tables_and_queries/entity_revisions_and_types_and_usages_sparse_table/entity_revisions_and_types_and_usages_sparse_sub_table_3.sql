CREATE TABLE entity_revisions_and_types_and_usages_sparse_sub_table_3 AS (
	SELECT * 
	FROM crosstab(
		          'SELECT year_month_page_title, page_views, number_of_revisions, page_title, year, month, namespace, edit_type, count(*) 
		           FROM entity_revisions_and_types_and_usages
		           WHERE cast(substring(page_title from 2) AS INT) >= 8000000 AND cast(substring(page_title from 2) AS INT) < 12000000
		           GROUP BY year_month_page_title, page_views, number_of_revisions, page_title, year, month, namespace, edit_type 
		           ORDER BY year_month_page_title',
		           'SELECT DISTINCT edit_type 
		           FROM entity_revisions_and_types_and_usages 
		           ORDER BY edit_type'
		          ) AS (
		                year_month_page_title TEXT, 
		                page_views NUMERIC,
		                number_of_revisions BIGINT,
		                page_title VARCHAR(255),
		                year BIGINT,
		                month BIGINT,
		                namespace BIGINT,
		                anon_edits BIGINT, 
		                bot_edits BIGINT, 
		                human_edits BIGINT, 
		                semi_automated_edits BIGINT
		               )
);