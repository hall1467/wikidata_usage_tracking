CREATE TABLE wikidata_page_revisions_bot_info AS (
	SELECT wikidata_page_revisions.*, user_id AS bot_user_id
	FROM wikidata_page_revisions
	LEFT JOIN
	wikidata_bots
	ON user_id = revision_user
);