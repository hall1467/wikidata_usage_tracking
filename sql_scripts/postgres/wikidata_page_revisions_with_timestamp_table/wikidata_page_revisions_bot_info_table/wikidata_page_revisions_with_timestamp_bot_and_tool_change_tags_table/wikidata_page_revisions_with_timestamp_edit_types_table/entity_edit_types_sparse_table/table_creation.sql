CREATE TABLE entity_edit_types_sparse AS (
	SELECT * 
	FROM crosstab(
		          'SELECT page_title, edit_type, count(*) 
		           FROM wikidata_page_revisions_with_timestamp_edit_types 
		           GROUP BY page_title, edit_type 
		           ORDER BY page_title',
		           'SELECT DISTINCT edit_type 
		           FROM wikidata_page_revisions_with_timestamp_edit_types 
		           ORDER BY edit_type'
		          ) AS (
		                entity_id VARCHAR(255), 
		                anon_edits BIGINT, 
		                bot_edits BIGINT, 
		                human_edits BIGINT, 
		                semi_automated_edits BIGINT
		               )
);