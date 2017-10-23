CREATE TABLE used_entity_previous_month_edits(
	entity_id VARCHAR(265),
	year BIGINT,
	month BIGINT,
	bot_edits BIGINT,
	semi_automated_edits BIGINT,
	non_bot_edits BIGINT,
	anon_edits BIGINT,
	total_bot_edits BIGINT,
	total_semi_automated_edits BIGINT,
	total_non_bot_edits BIGINT,
	total_anon_edits BIGINT
);