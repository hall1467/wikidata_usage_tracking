\copy (SELECT aggregations.entity_id, aggregations.number_of_revisions, aggregations.page_views, predictions.prediction FROM entity_views_and_aggregated_revisions AS aggregations INNER JOIN (SELECT DISTINCT title, rev_id, prediction FROM monthly_item_quality WHERE monthly_timestamp = '20170601000000')   AS predictions ON predictions.title = aggregations.entity_id) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/entity_views_and_aggregated_revisions/entity_views_and_aggregated_revisions_and_quality_scoring_20170601.tsv';