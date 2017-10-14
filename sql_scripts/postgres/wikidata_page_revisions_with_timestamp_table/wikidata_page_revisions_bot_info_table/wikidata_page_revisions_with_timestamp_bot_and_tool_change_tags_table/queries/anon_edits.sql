\copy (SELECT * FROM wikidata_page_revisions_with_timestamp_bot_and_tool_change_tags WHERE (bot_user_id IS NULL AND revision_user LIKE '%.%' AND NOT (lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%quickstatements%' OR lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%petscan%' OR lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%autolist2%' OR lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%talkgadgetautoeditjs|autoedit]]%' OR lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%nameguzzler%' OR lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%labellister%' OR lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#itemcreator%' OR lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#dragrefjs%' OR lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[useryms/lc|lcjs]]%' OR lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#wikidatagame%' OR lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[wikidataprimary%' OR lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%mix''n''match%' OR lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#distributedgame%' OR lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[userjitrixis/nameguzzlerjs|nameguzzler]]%' OR lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[mediawikigadgetmergejs|mergejs]]%')) AND change_tag_revision_id IS NULL) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_bot_and_tool_change_tags/anon_edits.tsv'; 
