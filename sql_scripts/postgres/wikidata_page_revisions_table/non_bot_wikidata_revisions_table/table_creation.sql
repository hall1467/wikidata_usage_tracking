CREATE TABLE non_bot_wikidata_page_revisions AS(
	SELECT *
	FROM wikidata_page_revisions
	WHERE revision_user NOT IN 
		(
			SELECT user_id
			FROM wikidata_bots
		)
);