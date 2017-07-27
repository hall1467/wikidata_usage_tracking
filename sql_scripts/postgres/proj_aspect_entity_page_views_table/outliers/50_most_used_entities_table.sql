CREATE TABLE outliers.fifty_most_used_entities AS (
	SELECT proj_aspect_entity.project, proj_aspect_entity.entity_id, proj_aspect_entity.aspect, proj_aspect_entity.page_id, total_entity_page_usages 
	FROM (
		SELECT entity_id, count(*) AS total_entity_page_usages
		FROM (
			  SELECT DISTINCT entity_id, project, page_id 
			  FROM proj_aspect_entity_page_views
			) AS distinct_entity_project_page
		GROUP BY entity_id
	)  AS entity_page_usages
	INNER JOIN (
		SELECT * 
		FROM (
			SELECT *, COUNT(*) OVER ( PARTITION BY project, entity_id 
			 					      ORDER BY random()
			 						) AS count 
			FROM proj_aspect_entity_page_views
		) AS inner_entities 
		WHERE count < 11
	) AS proj_aspect_entity
	ON entity_page_usages.entity_id = proj_aspect_entity.entity_id 
	ORDER BY total_entity_page_usages DESC
)