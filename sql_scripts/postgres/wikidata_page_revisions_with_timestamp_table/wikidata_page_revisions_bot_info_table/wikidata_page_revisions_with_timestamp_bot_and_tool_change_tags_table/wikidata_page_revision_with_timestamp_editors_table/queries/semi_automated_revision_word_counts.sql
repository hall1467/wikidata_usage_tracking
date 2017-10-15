\copy (select count(*) from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#quickstatements%' and revision_user not in (select * from wikidata_bots)) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/revision_count_1.tsv';

\copy (select count(*) from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#petscan%' and revision_user not in (select * from wikidata_bots)) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/revision_count_2.tsv';

\copy (select count(*) from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#autolist2%' and revision_user not in (select * from wikidata_bots)) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/revision_count_3.tsv';

\copy (select count(*) from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%talkgadgetautoeditjs|autoedit]]%' and revision_user not in (select * from wikidata_bots)) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/revision_count_4.tsv';

\copy (select count(*) from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%labellister%' and revision_user not in (select * from wikidata_bots)) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/revision_count_5.tsv';

\copy (select count(*) from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#itemcreator%' and revision_user not in (select * from wikidata_bots)) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/revision_count_6.tsv';

\copy (select count(*) from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#dragrefjs%' and revision_user not in (select * from wikidata_bots)) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/revision_count_7.tsv';

\copy (select count(*) from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[useryms/lc|lcjs]]%' and revision_user not in (select * from wikidata_bots)) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/revision_count_8.tsv';

\copy (select count(*) from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#wikidatagame%' and revision_user not in (select * from wikidata_bots)) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/revision_count_9.tsv';

\copy (select count(*) from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[wikidataprimary%' and revision_user not in (select * from wikidata_bots)) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/revision_count_10.tsv';

\copy (select count(*) from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%mix''n''match%' and revision_user not in (select * from wikidata_bots)) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/revision_count_11.tsv';

\copy (select count(*) from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#distributedgame%' and revision_user not in (select * from wikidata_bots)) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/revision_count_12.tsv';

\copy (select count(*) from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[userjitrixis/nameguzzlerjs|nameguzzler]]%' and revision_user not in (select * from wikidata_bots)) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/revision_count_13.tsv';

\copy (select count(*) from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[mediawikigadgetmergejs|mergejs]]%' and revision_user not in (select * from wikidata_bots)) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/revision_count_14.tsv';
