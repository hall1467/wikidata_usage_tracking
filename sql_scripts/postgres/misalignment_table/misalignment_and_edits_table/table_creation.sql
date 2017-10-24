CREATE TABLE misalignment_and_edits AS (
SELECT misalignment.entity_id, misalignment.year, misalignment.month, quality_class, views_class, bot_edits, semi_automated_edits, non_bot_edits, anon_edits, total_bot_edits, total_semi_automated_edits, total_non_bot_edits, total_anon_edits  
FROM used_entity_previous_month_edits 
INNER JOIN misalignment 
ON misalignment.entity_id = used_entity_previous_month_edits.entity_id 
	AND misalignment.year = used_entity_previous_month_edits.year 
	AND misalignment.month = used_entity_previous_month_edits.month
);