\copy (SELECT edit_type, count(*) FROM entity_revisions_and_types_and_usages WHERE page_views IS NOT NULL GROUP BY edit_type) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/edit_type_counts.tsv';