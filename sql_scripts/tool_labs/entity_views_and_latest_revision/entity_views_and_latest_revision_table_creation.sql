CREATE TABLE s53311__wikidata_usage_and_views_p.entity_views_and_latest_revision AS (
	SELECT entity_id, page_views, page_latest AS latest_revision, page_namespace
	FROM wikidatawiki_p.page
	INNER JOIN s53311__wikidata_usage_and_views_p.entity_views
	ON page_title = entity_id
);