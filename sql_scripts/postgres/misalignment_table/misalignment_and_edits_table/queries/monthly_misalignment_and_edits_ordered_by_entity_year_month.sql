\copy (SELECT entity_id, year, month, quality_class, views_class, bot_edits, semi_automated_edits, non_bot_edits, anon_edits, all_edits FROM misalignment_and_edits ORDER BY entity_id, year, month) TO '../../../../../../../wbc_entity_usage/usage_results/sql_queries/misalignment_and_edits/monthly_misalignment_and_edits_ordered_by_entity_year_month.tsv'; 
