\COPY 
	SELECT entity_id, page_id, avg(page_views)
	FROM entity_proj_aspect_page_views
	GROUP BY entity_id, page_id;
TO '../../../../../wbc_entity_usage/usage_results/sql_queries/entity_proj_aspect_views_no_header.tsv';


