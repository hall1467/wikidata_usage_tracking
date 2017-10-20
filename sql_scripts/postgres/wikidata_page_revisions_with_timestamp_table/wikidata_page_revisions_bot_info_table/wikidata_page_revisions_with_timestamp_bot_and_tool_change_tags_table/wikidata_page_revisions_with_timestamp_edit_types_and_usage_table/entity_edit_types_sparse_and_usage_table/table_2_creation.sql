CREATE TABLE entity_edit_types_sparse_and_usage_sub_table_2 AS (
	SELECT * 
	FROM crosstab(
		          'SELECT year_month_page_title, page_views, number_of_revisions, page_title, year, month, namespace, edit_type, count(*) 
		           FROM wikidata_page_revisions_with_timestamp_edit_types_and_usage
		           WHERE page_title >= "Q3" AND page_title < "Q6"
		           GROUP BY year_month_page_title, page_views, number_of_revisions, page_title, year, month, namespace, edit_type 
		           ORDER BY year_month_page_title',
		           'SELECT DISTINCT edit_type 
		           FROM wikidata_page_revisions_with_timestamp_edit_types_and_usage 
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