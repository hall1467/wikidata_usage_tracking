CREATE TABLE number_of_revisions_per_title AS(
	SELECT page_title, COUNT(revision_id) 
	FROM wikidata_page_revisions
	GROUP BY page_title
);