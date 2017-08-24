CREATE TABLE wikidata_page_revision_with_timestamp_editors AS(
	SELECT page_title, bot_edits, semi_automated_edits, non_bot_edits, anon_edits, all_edits
	FROM 
	(
		SELECT *
		FROM 
		(
			SELECT *
			FROM 
			(
				SELECT page_title AS bot_edit_title, count(*) as bot_edits
				FROM wikidata_page_revisions_with_timestamp_bot_info
				WHERE bot_user_id IS NOT NULL
				GROUP BY page_title
			) AS bot_edits_query
			FULL OUTER JOIN
			(
				SELECT page_title AS non_bot_edit_title, count(*) as non_bot_edits
				FROM ikidata_page_revisions_with_timestamp_bot_info
				WHERE bot_user_id IS NULL AND revision_user NOT LIKE '%.%' AND NOT (comment LIKE '%quickstatements%' OR 
																					comment LIKE '%petscan%' OR 
																					comment LIKE '%autolist2%' OR
																					comment LIKE '%autoedit%' OR
																					comment LIKE '%nameguzzler%' OR 
																					comment LIKE '%labellister%' OR
																					comment LIKE '%#itemcreator%' OR 
																					comment LIKE '%#dragrefjs%' OR 
																					comment LIKE '%[[useryms/lc|lcjs]]%' OR 
																					comment LIKE '%#wikidatagame%' OR 
																					comment LIKE '%[[wikidataprimary%' OR
																					comment LIKE '%#mix''n''match%' OR 
																					comment LIKE '%mix''n''match%' OR
																					comment LIKE '%#distributedgame%' OR  
																					comment LIKE '%[[userjitrixis/nameguzzlerjs|nameguzzler]]%')
				GROUP BY page_title
			) AS non_bot_edits_query
			ON bot_edit_title = non_bot_edit_title
		) AS bots_and_non_bots
		FULL OUTER JOIN
		(
			SELECT page_title AS anon_edit_title, count(*) as anon_edits
			FROM ikidata_page_revisions_with_timestamp_bot_info
			WHERE bot_user_id IS NULL AND revision_user LIKE '%.%' AND NOT (comment LIKE '%quickstatements%' OR 
																					comment LIKE '%petscan%' OR 
																					comment LIKE '%autolist2%' OR
																					comment LIKE '%autoedit%' OR
																					comment LIKE '%nameguzzler%' OR 
																					comment LIKE '%labellister%' OR
																					comment LIKE '%#itemcreator%' OR 
																					comment LIKE '%#dragrefjs%' OR 
																					comment LIKE '%[[useryms/lc|lcjs]]%' OR 
																					comment LIKE '%#wikidatagame%' OR 
																					comment LIKE '%[[wikidataprimary%' OR
																					comment LIKE '%#mix''n''match%' OR 
																					comment LIKE '%mix''n''match%' OR
																					comment LIKE '%#distributedgame%' OR  
																					comment LIKE '%[[userjitrixis/nameguzzlerjs|nameguzzler]]%')
			GROUP BY page_title
		) AS anons
		ON bot_edit_title = anon_edit_title
	) AS bots_and_non_bots_and_anons
	FULL OUTER JOIN
	(
		SELECT *
		FROM
		(
			SELECT page_title AS semi_automated_title, count(*) as semi_automated_edits
			FROM ikidata_page_revisions_with_timestamp_bot_info
			WHERE bot_user_id IS NULL AND (comment LIKE '%quickstatements%' OR comment LIKE '%petscan%' OR comment LIKE '%autolist2%')
			GROUP BY page_title
		) AS semi_automated_revisions
		FULL OUTER JOIN
		(
			SELECT page_title, count(*) as all_edits
			FROM ikidata_page_revisions_with_timestamp_bot_info
			GROUP BY page_title
		) AS all_revisions
		ON page_title = semi_automated_title
	) AS semi_automated_and_all
	ON page_title = bot_edit_title
);
