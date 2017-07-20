CREATE TABLE wikidata_page_revision_editors AS(
	SELECT page_title, bot_edits, non_bot_edits, anon_edits
	FROM
	(
		SELECT *
		FROM 
		(
			SELECT page_title AS bot_edit_title, count(*) as bot_edits
			FROM wikidata_page_revisions_bot_info
			WHERE bot_user_id IS NOT NULL
			GROUP BY page_title
		) AS bot_edits_query
		FULL OUTER JOIN
		(
			SELECT page_title AS non_bot_edit_title, count(*) as non_bot_edits
			FROM wikidata_page_revisions_bot_info
			WHERE bot_user_id IS NULL AND revision_user NOT LIKE '%.%'
			GROUP BY page_title
		) AS non_bot_edits_query
		ON bot_edit_title = non_bot_edit_title
	) AS bots_and_non_bots
	FULL OUTER JOIN
	(
		SELECT *
		FROM
		(
			SELECT page_title AS anon_edit_title, count(*) as anon_edits
			FROM wikidata_page_revisions_bot_info
			WHERE bot_user_id IS NULL AND revision_user LIKE '%.%'
			GROUP BY page_title
		) AS anons
		FULL OUTER JOIN
		(
			SELECT page_title, count(*) as all_edits
			FROM wikidata_page_revisions_bot_info
			GROUP BY page_title
		) AS all_revisions
		ON page_title = anon_edit_title
	) AS all_and_anons
	ON page_title = bot_edit_title
);
