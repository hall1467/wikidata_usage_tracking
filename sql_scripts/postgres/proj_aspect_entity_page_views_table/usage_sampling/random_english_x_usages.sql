\copy (SELECT entity_id, aspect, project, page_id, page_views from proj_aspect_entity_page_views where aspect = 'X' and project = 'enwiki' order by random() limit 50) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/proj_aspect_entity_page_views/usage_sampling/random_english_x_usages.tsv'; 