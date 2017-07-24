\copy () TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/entity_views_and_aggregated_revisions/entity_views_and_aggregated_revisions_and_quality_scoring.tsv';

SELECT aggregations.entity_id, aggregations.rev_id, aggregations.number_of_revisions, aggregations.page_views, predictions.prediction 
FROM entity_views_and_aggregated_revisions AS aggregations 
INNER JOIN 
(
	SELECT DISTINCT title, rev_id, prediction 
	FROM monthly_item_quality 
)   AS predictions 
ON predictions.rev_id = aggregations.rev_id