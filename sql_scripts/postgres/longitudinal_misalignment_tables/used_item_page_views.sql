\copy (SELECT page_title, page_views FROM monthly_item_quality JOIN revisions_all_automation_flags_and_usages ON title = page_title WHERE monthly_timestamp = 20170501000000 and namespace = 0 and page_views IS NOT NULL) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_item_page_views.tsv';