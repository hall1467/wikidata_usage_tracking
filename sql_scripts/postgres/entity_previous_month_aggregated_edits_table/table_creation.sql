CREATE TABLE entity_previous_month_aggregated_edits(
	entity_id VARCHAR(265),
	year BIGINT,
	month BIGINT,
	bot_edits BIGINT,
	semi_automated_edits BIGINT,
	non_bot_edits BIGINT,
	anon_edits BIGINT,
	all_edits BIGINT
);