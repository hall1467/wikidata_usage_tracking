\copy (select page_title, year, month, case when bot_edits IS NULL then 0 else bot_edits end, case when semi_automated_edits IS NULL then 0 else semi_automated_edits end, case when non_bot_edits IS NULL then 0 else non_bot_edits end, case when anon_edits IS NULL then 0 else anon_edits end, all_edits from entity_monthly_wikidata_editors order by entity_id, year, month) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/entity_monthly_wikidata_editors/entity_monthly_edit_breakdowns.tsv'; 
