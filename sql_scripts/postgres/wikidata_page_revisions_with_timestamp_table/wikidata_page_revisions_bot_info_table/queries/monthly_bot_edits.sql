\copy (select year, month, cast(count(bot_user_id) as float)/cast(count(*) as float) as bot_edits_over_total from wikidata_page_revisions_with_timestamp_bot_info GROUP BY year, month UNION ALL select 2012, 10, cast(count(bot_user_id) as float)/cast(count(*) as float) as bot_edits_over_total from wikidata_page_revisions_with_timestamp_bot_info where revision_timestamp < 20121101000000;) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_bot_info/monthly_bot_edits.tsv'; 
