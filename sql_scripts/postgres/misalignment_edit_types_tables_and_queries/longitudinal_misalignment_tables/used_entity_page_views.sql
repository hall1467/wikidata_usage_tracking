\copy (SELECT namespace, page_title, page_views FROM revisions_all_automation_flags_and_usages WHERE page_views IS NOT NULL GROUP BY namespace, page_title) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_entity_page_views.tsv';