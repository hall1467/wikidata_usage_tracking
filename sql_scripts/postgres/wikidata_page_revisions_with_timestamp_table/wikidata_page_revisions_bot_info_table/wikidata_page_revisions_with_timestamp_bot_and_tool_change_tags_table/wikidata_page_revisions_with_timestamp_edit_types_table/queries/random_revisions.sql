\copy (select comment from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#quickstatements%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/random_revisions_1.tsv';

\copy (select comment from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#petscan%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/random_revisions_2.tsv';

\copy (select comment from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#autolist2%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/random_revisions_3.tsv';

\copy (select comment from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%talkgadgetautoeditjs|autoedit]]%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/random_revisions_4.tsv';

\copy (select comment from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%labellister%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/random_revisions_5.tsv';

\copy (select comment from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#itemcreator%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/random_revisions_6.tsv';

\copy (select comment from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#dragrefjs%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/random_revisions_7.tsv';

\copy (select comment from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[useryms/lc|lcjs]]%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/random_revisions_8.tsv';

\copy (select comment from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#wikidatagame%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/random_revisions_9.tsv';

\copy (select comment from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[wikidataprimary%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/random_revisions_10.tsv';

\copy (select comment from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%mix''n''match%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/random_revisions_11.tsv';

\copy (select comment from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#distributedgame%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/random_revisions_12.tsv';

\copy (select comment from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[userjitrixis/nameguzzlerjs|nameguzzler]]%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/random_revisions_13.tsv';

\copy (select comment from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[mediawikigadgetmergejs|mergejs]]%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/random_revisions_14.tsv';
