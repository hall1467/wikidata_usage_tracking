\copy (SELECT * FROM (SELECT entity_id, SUM(page_views) AS total_entity_page_views FROM (SELECT DISTINCT project, entity_id, page_id, page_views FROM proj_aspect_entity_page_views) AS entity_project_page_views GROUP BY entity_id HAVING SUM(page_views) = 0 ORDER BY RANDOM() limit 50) AS entity_page_views INNER JOIN proj_aspect_entity_page_views ON entity_page_views.entity_id = proj_aspect_entity_page_views.entity_id ) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/proj_aspect_entity_page_views/outliers/50_random_least_viewed_entities.tsv';