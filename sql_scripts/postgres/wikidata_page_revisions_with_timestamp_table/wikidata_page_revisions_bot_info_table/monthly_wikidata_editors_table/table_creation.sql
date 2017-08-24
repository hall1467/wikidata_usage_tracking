CREATE TABLE monthly_wikidata_editors AS(
	SELECT year, month, bot_edits, semi_automated_edits, non_bot_edits, anon_edits, all_edits
	FROM 
	(
		SELECT *
		FROM 
		(
			SELECT *
			FROM 
			(
				SELECT year AS bot_edit_year, month AS bot_edit_month, count(*) as bot_edits
				FROM wikidata_page_revisions_with_timestamp_bot_info
				WHERE bot_user_id IS NOT NULL
				GROUP BY year, month
			) AS bot_edits_query
			FULL OUTER JOIN
			(
				SELECT year AS non_bot_edit_year, month AS non_bot_edit_month, count(*) as non_bot_edits
				FROM wikidata_page_revisions_with_timestamp_bot_info
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
				GROUP BY year, month
			) AS non_bot_edits_query
			ON bot_edit_year = non_bot_edit_year AND bot_edit_month = non_bot_edit_month
		) AS bots_and_non_bots
		FULL OUTER JOIN
		(
			SELECT year AS anon_edit_year, month AS anon_edit_month, count(*) as anon_edits
			FROM wikidata_page_revisions_with_timestamp_bot_info
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
			GROUP BY year, month
		) AS anons
		ON bot_edit_year = anon_edit_year AND bot_edit_month = anon_edit_month
	) AS bots_and_non_bots_and_anons
	FULL OUTER JOIN
	(
		SELECT *
		FROM
		(
			SELECT year AS semi_automated_edit_year, month AS semi_automated_edit_month, count(*) as semi_automated_edits
			FROM wikidata_page_revisions_with_timestamp_bot_info
			WHERE bot_user_id IS NULL AND (comment LIKE '%quickstatements%' OR 
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
			GROUP BY year, month
		) AS semi_automated_revisions
		FULL OUTER JOIN
		(
			SELECT year, month, count(*) as all_edits
			FROM wikidata_page_revisions_with_timestamp_bot_info
			GROUP BY year, month
		) AS all_revisions
		ON year = semi_automated_edit_year AND month = semi_automated_edit_month
	) AS semi_automated_and_all
	ON year = bot_edit_year AND month = bot_edit_month
);
