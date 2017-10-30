\copy (SELECT quality_class, SUM(cast(total_bot_edits as float))/SUM(cast((total_bot_edits + total_semi_automated_edits + total_non_bot_edits + total_anon_edits) as float)) as bot_edits_proportion, SUM(cast(total_semi_automated_edits as float))/SUM(cast((total_bot_edits + total_semi_automated_edits + total_non_bot_edits + total_anon_edits) as float)) as semi_automated_edits_proportion, SUM(cast(total_non_bot_edits as float))/SUM(cast((total_bot_edits + total_semi_automated_edits + total_non_bot_edits + total_anon_edits) as float)) as non_bot_edits_proportion, SUM(cast(total_anon_edits as float))/SUM(cast((total_bot_edits + total_semi_automated_edits + total_non_bot_edits + total_anon_edits) as float)) as anon_edits_proportion FROM misalignment_and_edits WHERE year = 2017 and month = 5 GROUP BY quality_class ORDER BY quality_class) TO '../../../../../../../wbc_entity_usage/usage_results/sql_queries/misalignment_and_edits/edit_proportions_by_quality_class_5_17.tsv';