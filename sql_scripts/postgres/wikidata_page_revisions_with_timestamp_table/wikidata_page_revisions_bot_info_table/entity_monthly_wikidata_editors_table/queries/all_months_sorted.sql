\copy (select page_title, year, month, bot_edits, semi_automated_edits, non_bot_edits, anon_edits, all_edits from entity_monthly_wikidata_editors) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/entity_monthly_wikidata_editors/entity_monthly_edit_breakdowns.csv'; 