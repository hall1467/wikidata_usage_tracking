\copy (select entity_id, year, month, quality_class, views_class, bot_edits, semi_automated_edits, non_bot_edits, anon_edits, all_edits from misalignment_and_edits order by year, month) TO '../../../../../../../wbc_entity_usage/usage_results/sql_queries/entity_monthly_wikidata_editors/monthly_misalignment_and_edits.tsv'; 