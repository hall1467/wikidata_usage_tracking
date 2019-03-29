CREATE TABLE revisions_all_automation_flags_and_usages AS (
	SELECT revisions_initial_automation_flags.*, revisions_with_page_views.page_views,
	(CASE WHEN bot_user_id IS NOT NULL OR revision_user_text LIKE '10.68.%' THEN 'bot_edit'
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
		  WHEN lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[mediawikigadgetmergejs|mergejs]]%' THEN 'mergejs'
		  WHEN regexp_replace(comment, '\.|,|\(|\)|-|:','','g') LIKE '%#reasonator%' THEN 'reasonator'
		  WHEN regexp_replace(comment, '\.|,|\(|\)|-|:','','g') LIKE '%#duplicity%' THEN 'duplicity'
		  WHEN regexp_replace(comment, '\.|,|\(|\)|-|:','','g') LIKE '%#tabernacle%' THEN 'tabernacle'
		  WHEN regexp_replace(comment, '\.|,|\(|\)|-|:','','g') LIKE '%Widar%' THEN 'Widar'
		  WHEN regexp_replace(comment, '\.|,|\(|\)|-|:','','g') LIKE '%reCh%' THEN 'reCh'
		  WHEN regexp_replace(comment, '\.|,|\(|\)|-|:','','g') LIKE '%HHVM%' THEN 'HHVM'
		  WHEN regexp_replace(comment, '\.|,|\(|\)|-|:','','g') LIKE '%PAWS%' THEN 'PAWS'
		  WHEN regexp_replace(comment, '\.|,|\(|\)|-|:','','g') LIKE '%Kaspar%' THEN 'Kaspar'
		  WHEN regexp_replace(comment, '\.|,|\(|\)|-|:','','g') LIKE '%itemFinder%' THEN 'itemFinder'
		  WHEN regexp_replace(comment, '\.|,|\(|\)|-|:','','g') LIKE '%rgCh%' THEN 'rgCh'
		  WHEN revision_user_id = '2769139' THEN 'not_flagged_elsewhere_quickstatments_bot_account'
		  WHEN change_tag_revision_id IS NOT NULL THEN 'other_semi_automated_edit_since_change_tag'
		  WHEN revision_user_id = 'NULL' AND (revision_user_text LIKE '%.%' OR revision_user_text LIKE '%:%') THEN 'anon_edit'
		  WHEN (revision_user_id = 'NULL' AND revision_user_text = 'NULL') THEN 'identity_blocked_edit'
		  ELSE 'human_edit' END) AS edit_type,
	concat(year,'-',month,'-',page_title) AS year_month_page_title
	FROM revisions_initial_automation_flags
	LEFT JOIN
	(
		SELECT revision_id, page_views
		FROM
		(
			SELECT entity_id, SUM(page_views) as page_views
			FROM
	    	(
				SELECT DISTINCT project, entity_id, page_id, page_views 
			    FROM proj_aspect_entity_page_views
			)   AS entity_project_page_views 
			GROUP BY entity_id
		)	AS entity_page_views
		INNER JOIN
		revisions_initial_automation_flags
		ON entity_id = page_title
		WHERE revisions_initial_automation_flags.namespace = 0 OR revisions_initial_automation_flags.namespace = 120
	)	AS revisions_with_page_views
	ON revisions_initial_automation_flags.revision_id = revisions_with_page_views.revision_id
);
