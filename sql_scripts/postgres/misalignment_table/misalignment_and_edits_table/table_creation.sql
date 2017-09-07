CREATE TABLE misalignment_and_edits AS (
SELECT misalignment.entity_id, misalignment.year, misalignment.month, quality_class, views_class, bot_edits, semi_automated_edits, non_bot_edits, anon_edits, all_edits 
FROM entity_previous_month_aggregated_edits 
INNER JOIN misalignment 
ON misalignment.entity_id = entity_previous_month_aggregated_edits.entity_id 
	AND misalignment.year = entity_previous_month_aggregated_edits.year 
	AND misalignment.month = entity_previous_month_aggregated_edits.month
);