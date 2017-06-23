SELECT entity_id, page_views
FROM (
	SELECT entity_id, page_id, cast(avg(page_views) AS BIGINT) AS page_views
	FROM proj_aspect_entity_page_views
	GROUP BY entity_id, page_id
) AS entity_pages;