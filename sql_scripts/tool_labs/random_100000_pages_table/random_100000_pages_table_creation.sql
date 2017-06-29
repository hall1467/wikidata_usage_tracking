CREATE TABLE s53311__wikidata_usage_and_views_p.random_100000_pages AS (
	SELECT page_title, page_namespace
	FROM wikidatawiki_p.page 
	ORDER BY RAND()
	LIMIT 100000
);
