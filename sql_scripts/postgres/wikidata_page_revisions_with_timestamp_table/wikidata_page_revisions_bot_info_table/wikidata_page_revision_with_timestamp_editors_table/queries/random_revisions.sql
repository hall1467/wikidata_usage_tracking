\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#quickstatements%' and revision_user not in (select * from wikidata_bots) order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_1.tsv';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#petscan%' and revision_user not in (select * from wikidata_bots) order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_2.tsv';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#autolist2%' and revision_user not in (select * from wikidata_bots) order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_3.tsv';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%talkgadgetautoeditjs|autoedit]]%' and revision_user not in (select * from wikidata_bots) order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_4.tsv';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%labellister%' and revision_user not in (select * from wikidata_bots) order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_5.tsv';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#itemcreator%' and revision_user not in (select * from wikidata_bots) order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_6.tsv';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#dragrefjs%' and revision_user not in (select * from wikidata_bots) order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_7.tsv';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[useryms/lc|lcjs]]%' and revision_user not in (select * from wikidata_bots) order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_8.tsv';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#wikidatagame%' and revision_user not in (select * from wikidata_bots) order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_9.tsv';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[wikidataprimary%' and revision_user not in (select * from wikidata_bots) order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_10.tsv';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%mix''n''match%' and revision_user not in (select * from wikidata_bots) order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_11.tsv';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#distributedgame%' and revision_user not in (select * from wikidata_bots) order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_12.tsv';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[userjitrixis/nameguzzlerjs|nameguzzler]]%' and revision_user not in (select * from wikidata_bots) order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_13.tsv';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[mediawikigadgetmergejs|mergejs]]%' and revision_user not in (select * from wikidata_bots) order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_14.tsv';
