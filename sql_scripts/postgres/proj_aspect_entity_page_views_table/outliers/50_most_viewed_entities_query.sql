\copy (SELECT entity_id, aspect, project, page_id, total_entity_page_views from outliers.fifty_most_viewed_entities) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/proj_aspect_entity_page_views/outliers/50_most_viewed_entities.tsv'; 