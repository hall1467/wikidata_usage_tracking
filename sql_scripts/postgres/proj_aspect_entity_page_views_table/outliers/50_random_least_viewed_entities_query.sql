\copy (SELECT entity_id, project, page_id, aspect, total_entity_page_views FROM outliers.fifty_random_least_viewed_entities) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/proj_aspect_entity_page_views/outliers/50_random_least_viewed_entities.tsv';