\copy (
	SELECT views_class, 
	SUM(cast(bot_edits as float))/SUM(cast((bot_edits + semi_automated_edits + non_bot_edits + anon_edits) as float)) as bot_edits_proportion, 
	SUM(cast(semi_automated_edits as float))/SUM(cast((bot_edits + semi_automated_edits + non_bot_edits + anon_edits) as float)) as semi_automated_edits_proportion, 
	SUM(cast(non_bot_edits as float))/SUM(cast((bot_edits + semi_automated_edits + non_bot_edits + anon_edits) as float)) as non_bot_edits_proportion, 
	SUM(cast(anon_edits as float))/SUM(cast((bot_edits + semi_automated_edits + non_bot_edits + anon_edits) as float)) as anon_edits_proportion 
	FROM misalignment_and_edits 
	WHERE NOT ((misalignment_matching_year = 2017 and misalignment_matching_month = 7) OR (misalignment_matching_year = 2017 and misalignment_matching_month = 6)) 
		AND page_views IS NOT NULL 
	GROUP BY views_class 
	ORDER BY view_class) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/misalignment_and_edits/edit_proportions_by_view_class_5_17.tsv';





(CASE WHEN bot_user_id IS NOT NULL THEN 'bot_edit'
	ELSE END)