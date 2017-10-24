\copy (SELECT year, month, SUM(bot_edits), SUM(semi_automated_edits), SUM(non_bot_edits), SUM(anon_edits) FROM misalignment_and_edits GROUP BY year, month ORDER BY year, month) TO '../../../../../../../wbc_entity_usage/usage_results/sql_queries/misalignment_and_edits/monthly_edit_types.tsv';

