CREATE TABLE most_recent_revision_per_title AS(
	SELECT page_title, MAX(revision_id) 
	FROM wikidata_page_revisions 
	GROUP BY page_title
);