CREATE TABLE outliers.fifty_random_least_used_entities AS (
	SELECT proj_aspect_entity_page_views.project, proj_aspect_entity_page_views.entity_id, proj_aspect_entity_page_views.aspect, proj_aspect_entity_page_views.page_id, total_entity_page_usages
	FROM (
		SELECT entity_id, count(*) AS total_entity_page_usages
		FROM (
			  SELECT DISTINCT entity_id, project, page_id 
			  FROM proj_aspect_entity_page_views
			) AS distinct_entity_project_page
		GROUP BY entity_id
		HAVING count(*) = 1 
		ORDER BY RANDOM() limit 50
		) AS entity_page_views 
	INNER JOIN proj_aspect_entity_page_views 
	ON entity_page_views.entity_id = proj_aspect_entity_page_views.entity_id
)