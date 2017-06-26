SELECT entity_id, page_views, revisions 
FROM (
	 SELECT page_title, COUNT(*) AS revisions
	 FROM wikidatawiki_p.revision 
	 INNER JOIN wikidatawiki_p.page 
	 ON page_id = rev_page 
	 WHERE page_namespace = 0
	 GROUP BY page_title
	 ) AS page_revisions
INNER JOIN s53311__wikidata_usage_and_views_p.entity_views
ON page_title = entity_id;