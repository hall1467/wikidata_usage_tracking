CREATE TABLE wikidata_page_revision_with_timestamp_editors AS(
	SELECT semi_automated_and_all.page_title, bot_edits, semi_automated_edits, non_bot_edits, anon_edits, all_edits
	FROM 
	(
		SELECT (case when page_title IS NOT NULL THEN page_title else anon_edit_page_title end) as page_title, bot_edits, non_bot_edits, anon_edits
		FROM 
		(
			SELECT (case when bot_edit_page_title IS NOT NULL THEN bot_edit_page_title else non_bot_edit_page_title end) as page_title, bot_edits, non_bot_edits
			FROM 
			(
				SELECT page_title AS bot_edit_page_title, count(*) as bot_edits
				FROM wikidata_page_revisions_with_timestamp_bot_and_tool_change_tags
				WHERE bot_user_id IS NOT NULL
				GROUP BY page_title
			) AS bot_edits_query
			FULL OUTER JOIN
			(
				SELECT page_title AS non_bot_edit_page_title, count(*) as non_bot_edits
				FROM wikidata_page_revisions_with_timestamp_bot_and_tool_change_tags
				WHERE (bot_user_id IS NULL AND revision_user NOT LIKE '%.%' AND NOT (lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%quickstatements%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%petscan%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%autolist2%' OR
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%talkgadgetautoeditjs|autoedit]]%' OR
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%nameguzzler%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%labellister%' OR
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#itemcreator%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#dragrefjs%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[useryms/lc|lcjs]]%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#wikidatagame%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[wikidataprimary%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%mix''n''match%' OR
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#distributedgame%' OR  
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[userjitrixis/nameguzzlerjs|nameguzzler]]%' OR
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[mediawikigadgetmergejs|mergejs]]%'))
				AND change_tag_revision_id IS NULL
				GROUP BY page_title
			) AS non_bot_edits_query
			ON bot_edit_page_title = non_bot_edit_page_title
		) AS bots_and_non_bots
		FULL OUTER JOIN
		(
			SELECT page_title AS anon_edit_page_title, count(*) as anon_edits
			FROM wikidata_page_revisions_with_timestamp_bot_and_tool_change_tags
			WHERE (bot_user_id IS NULL AND revision_user LIKE '%.%' AND NOT (lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%quickstatements%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%petscan%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%autolist2%' OR
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%talkgadgetautoeditjs|autoedit]]%' OR
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%nameguzzler%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%labellister%' OR
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#itemcreator%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#dragrefjs%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[useryms/lc|lcjs]]%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#wikidatagame%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[wikidataprimary%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%mix''n''match%' OR
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#distributedgame%' OR  
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[userjitrixis/nameguzzlerjs|nameguzzler]]%' OR
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[mediawikigadgetmergejs|mergejs]]%'))
			AND change_tag_revision_id IS NULL
			GROUP BY page_title
		) AS anons
		ON bots_and_non_bots.page_title = anon_edit_page_title
	) AS bots_and_non_bots_and_anons
	FULL OUTER JOIN
	(
		SELECT *
		FROM
		(
			SELECT page_title AS semi_automated_edit_page_title, count(*) as semi_automated_edits
			FROM wikidata_page_revisions_with_timestamp_bot_and_tool_change_tags
			WHERE (bot_user_id IS NULL AND (lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%quickstatements%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%petscan%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%autolist2%' OR
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%talkgadgetautoeditjs|autoedit]]%' OR
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%nameguzzler%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%labellister%' OR
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#itemcreator%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#dragrefjs%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[useryms/lc|lcjs]]%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#wikidatagame%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[wikidataprimary%' OR 
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%mix''n''match%' OR
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#distributedgame%' OR  
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[userjitrixis/nameguzzlerjs|nameguzzler]]%' OR
																					lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[mediawikigadgetmergejs|mergejs]]%'))
			OR change_tag_revision_id IS NOT NULL
			GROUP BY page_title
		) AS semi_automated_revisions
		FULL OUTER JOIN
		(
			SELECT page_title, count(*) as all_edits
			FROM wikidata_page_revisions_with_timestamp_bot_and_tool_change_tags
			GROUP BY page_title
		) AS all_revisions
		ON page_title = semi_automated_edit_page_title
	) AS semi_automated_and_all
	ON semi_automated_and_all.page_title = bots_and_non_bots_and_anons.page_title
);
