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
				FROM wikidata_page_revisions_with_timestamp_bot_info
				WHERE bot_user_id IS NULL AND revision_user NOT LIKE '%.%' AND NOT (lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%quickstatements%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%petscan%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%autolist2%' OR
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%autoedit%' OR
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%nameguzzler%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%labellister%' OR
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#itemcreator%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#dragrefjs%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[useryms/lc|lcjs]]%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#wikidatagame%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[wikidataprimary%' OR
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#mix''n''match%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%mix''n''match%' OR
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#distributedgame%' OR  
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[userjitrixis/nameguzzlerjs|nameguzzler]]%')
				GROUP BY page_title
			) AS non_bot_edits_query
			ON bot_edit_title = non_bot_edit_title
		) AS bots_and_non_bots
		FULL OUTER JOIN
		(
			SELECT page_title AS anon_edit_title, count(*) as anon_edits
			FROM wikidata_page_revisions_with_timestamp_bot_info
			WHERE bot_user_id IS NULL AND revision_user LIKE '%.%' AND NOT (lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%quickstatements%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%petscan%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%autolist2%' OR
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%autoedit%' OR
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%nameguzzler%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%labellister%' OR
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#itemcreator%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#dragrefjs%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[useryms/lc|lcjs]]%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#wikidatagame%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[wikidataprimary%' OR
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#mix''n''match%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%mix''n''match%' OR
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#distributedgame%' OR  
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[userjitrixis/nameguzzlerjs|nameguzzler]]%')
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
			FROM wikidata_page_revisions_with_timestamp_bot_info
			WHERE bot_user_id IS NULL AND (lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%quickstatements%' OR 
										   lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%petscan%' OR 
										   lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%autolist2%' OR
										   lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%autoedit%' OR
										   lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%nameguzzler%' OR 
										   lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%labellister%' OR
										   lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#itemcreator%' OR 
										   lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#dragrefjs%' OR 
										   lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[useryms/lc|lcjs]]%' OR 
										   lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#wikidatagame%' OR 
										   lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[wikidataprimary%' OR
										   lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#mix''n''match%' OR 
										   lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%mix''n''match%' OR
										   lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#distributedgame%' OR  
										   lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[userjitrixis/nameguzzlerjs|nameguzzler]]%')
			GROUP BY page_title
		) AS semi_automated_revisions
		FULL OUTER JOIN
		(
			SELECT page_title, count(*) as all_edits
			FROM wikidata_page_revisions_with_timestamp_bot_info
			GROUP BY page_title
		) AS all_revisions
		ON page_title = semi_automated_title
	) AS semi_automated_and_all
	ON page_title = bot_edit_title
);
