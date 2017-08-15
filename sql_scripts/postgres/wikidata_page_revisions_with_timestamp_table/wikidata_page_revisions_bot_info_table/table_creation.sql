CREATE TABLE wikidata_page_revisions_with_timestamp_bot_info AS (
	SELECT wikidata_page_revisions_with_timestamp.*, user_id AS bot_user_id
	FROM wikidata_page_revisions_with_timestamp
	LEFT JOIN
	wikidata_bots
	ON user_id = revision_user
);