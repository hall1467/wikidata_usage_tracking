CREATE TABLE entity_revisions_and_types_and_usages AS (
	SELECT entity_revisions_and_bot_flags_and_tool_change_tags.*, entity_views_and_aggregated_revisions.number_of_revisions, entity_views_and_aggregated_revisions.page_views,
	(CASE WHEN bot_user_id IS NOT NULL OR revision_user LIKE '10.86.%' THEN 'bot_edit'
		  WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#quickstatements%' THEN 'quickstatements'
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
		  WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[mediawikigadgetmergejs|mergejs]]%') THEN 'mergejs'
		  WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#reasonator%') THEN 'reasonator'
		  WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#duplicity%') THEN 'duplicity'
		  WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#tabernacle%') THEN 'tabernacle'
		  WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%Widar%') THEN 'Widar'
		  WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%reCh%') THEN 'reCh'
		  WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%HHVM%') THEN 'HHVM'
		  WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%PAWS%') THEN 'PAWS'
		  WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%Kaspar%') THEN 'Kaspar'
		  WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%itemFinder%') THEN 'itemFinder'
		  WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%rgCh%') THEN 'rgCh'
		  WHEN revision_user = '2769139' THEN 'not_flagged_elsewhere_quickstatments_bot_account'
		  WHEN change_tag_revision_id IS NOT NULL THEN 'other_semi_automated_edit_since_change_tag'
		  WHEN revision_user LIKE '%.%' OR revision_user LIKE '%:%' THEN 'anon_edit'
		  ELSE 'human_edit' END) AS edit_type,
	concat(year,'-',month,'-',page_title) AS year_month_page_title
	FROM entity_revisions_and_bot_flags_and_tool_change_tags
	LEFT JOIN
	entity_views_and_aggregated_revisions
	ON entity_id = page_title
);
