\copy (SELECT sum(bot_edit_value) AS total_bot_edit_value, sum(semi_automated_edit_value) AS total_semi_automated_edit_value, sum(non_bot_edit_value) AS total_non_bot_edit_value, sum(anon_edit_value) AS total_anon_edit_value, sum(page_views) AS total_value FROM (SELECT entity_id, page_views, (case when bot_edits IS NOT NULL THEN cast(bot_edits as float)/cast(all_edits as float) else 0 end)*page_views as bot_edit_value, (case when semi_automated_edits IS NOT NULL THEN cast(semi_automated_edits as float)/cast(all_edits as float) else 0 end)*page_views as semi_automated_edit_value, (case when non_bot_edits IS NOT NULL THEN cast(non_bot_edits as float)/cast(all_edits as float) else 0 end)*page_views as non_bot_edit_value, (case when anon_edits IS NOT NULL THEN cast(anon_edits as float)/cast(all_edits as float) else 0 end)*page_views as anon_edit_value FROM entity_views_and_aggregated_revisions INNER JOIN wikidata_page_revision_with_timestamp_editors ON wikidata_page_revision_with_timestamp_editors.page_title = entity_views_and_aggregated_revisions.entity_id) as edit_type_value) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_editors/entity_value_by_edit_type.tsv';