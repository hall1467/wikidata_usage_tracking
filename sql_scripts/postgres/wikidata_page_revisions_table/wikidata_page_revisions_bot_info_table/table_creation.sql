CREATE TABLE wikidata_page_revisions_bot_info_table AS(
	SELECT wikidata_page_revisions.*, user_id AS bot_user_id
	FROM wikidata_page_revisions
	LEFT JOIN
	wikidata_bots
);