CREATE TABLE entity_views_and_aggregated_revisions AS(
	SELECT entity_id, rev_id, number_of_revisions, page_views
	FROM 
	( 
		SELECT page_title, MAX(revision_id) AS rev_id, COUNT(revision_id) AS number_of_revisions
		FROM wikidata_page_revisions 
  	  	GROUP BY page_title
  	) 	AS aggregated_revisions
	INNER JOIN
	(
		SELECT entity_id, SUM(page_views) as page_views
	    FROM
	    (
			SELECT DISTINCT project, entity_id, page_id, page_views 
		    FROM proj_aspect_entity_page_views
		)   AS entity_project_page_views 
	  	GROUP BY entity_id
	)	AS entity_page_views
	ON page_title = entity_id
);