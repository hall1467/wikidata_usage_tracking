CREATE TABLE entity_monthly_types_of_semi_automated_edits AS (
SELECT *, 
	   (CASE WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#quickstatements%' THEN 'quickstatements'
	         WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#petscan%' THEN 'petscan'
	         WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#autolist2%' THEN 'autolist2'
	         WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%talkgadgetautoeditjs|autoedit]]%' THEN 'autoedit'
	         WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%labellister%' THEN 'labellister'
	         WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#itemcreator%' THEN 'itemcreator'
	         WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#dragrefjs%' THEN 'dragrefjs'
	         WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[useryms/lc|lcjs]]%' THEN 'lcjs'
	         WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#wikidatagame%' THEN 'wikidatagame'
	         WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[wikidataprimary%' THEN 'wikidataprimary'
	         WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%mix''n''match%' THEN 'mixnmatch'
	         WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#distributedgame%' THEN 'distributedgame'
	         WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[userjitrixis/nameguzzlerjs|nameguzzler]]%' THEN 'nameguzzler'
	         WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[mediawikigadgetmergejs|mergejs]]%' THEN 'mergejs'
	   END) as type_of_semi_automated_edit
FROM wikidata_page_revisions_with_timestamp_bot_and_tool_change_tags
WHERE bot_user_id is NULL
);