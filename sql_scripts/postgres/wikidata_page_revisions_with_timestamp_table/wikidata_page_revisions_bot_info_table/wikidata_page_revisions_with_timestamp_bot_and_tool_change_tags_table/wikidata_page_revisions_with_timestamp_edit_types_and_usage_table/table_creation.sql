CREATE TABLE wikidata_page_revisions_with_timestamp_edit_types AS (
	SELECT *,
	(CASE WHEN bot_user_id IS NOT NULL THEN 'bot_edit'
		 WHEN bot_user_id IS NULL AND ((lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%quickstatements%' OR 
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
																						lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[mediawikigadgetmergejs|mergejs]]%')
				OR change_tag_revision_id IS NOT NULL OR revision_user = '2769139') THEN 'semi_automated_edit'
		 WHEN revision_user LIKE '%.%' THEN 'anon_edit'
		 ELSE 'human_edit' END) AS edit_type,
	(CASE WHEN page_title IN (SELECT entity_id from entity_views_and_aggregated_revisions) THEN 'used' 
		  ELSE 'not_used' END) AS entity_usage
	FROM wikidata_page_revisions_with_timestamp_bot_and_tool_change_tags
);