CREATE TABLE s53311__wikidata_usage_and_views_p.random_100000_items AS (
	SELECT entity_id, page_views, latest_revision, page_namespace
	FROM s53311__wikidata_usage_and_views_p.entity_views_and_latest_revision
	WHERE page_namespace = 0
	ORDER BY RAND()
	LIMIT 100000
);
