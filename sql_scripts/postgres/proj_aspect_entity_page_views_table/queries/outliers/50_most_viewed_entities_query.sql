\copy () TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/proj_aspect_entity_page_views/outliers/50_most_viewed_entities.tsv'; 

CREATE TABLE 50_most_viewed_entities AS (
	SELECT proj_aspect_entity.project, proj_aspect_entity.entity_id, proj_aspect_entity.aspect, proj_aspect_entity.page_id, proj_aspect_entity.page_id, total_entity_page_views 
	FROM 
		(
		  SELECT entity_id, SUM(page_views) AS total_entity_page_views 
		  FROM (SELECT DISTINCT project, entity_id, page_id, page_views 
				FROM proj_aspect_entity_page_views) AS entity_project_page_views 
		  GROUP BY entity_id 
		  ORDER BY SUM(page_views) 
		  DESC limit 50
		 ) AS entity_page_views 
	INNER JOIN 
		(
		 SELECT * 
		 FROM 
			 (
			  SELECT *, COUNT(*) OVER ( PARTITION BY project, entity_id 
			 					        ORDER BY random()
			 						  ) AS count 
			  FROM proj_aspect_entity_page_views
		 ) AS inner_entities 
		 WHERE count < 11
		) AS proj_aspect_entity
	ON entity_page_views.entity_id = proj_aspect_entity.entity_id 
	ORDER BY total_entity_page_views DESC
);



