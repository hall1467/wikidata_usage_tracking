\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#quickstatements%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_1';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#petscan%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_2';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#autolist2%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_3';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%autoedit%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_4';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%nameguzzler%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_5';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%labellister%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_6';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#itemcreator%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_7';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#dragrefjs%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_8';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[useryms/lc|lcjs]]%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_9';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#wikidatagame%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_10';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[wikidataprimary%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_11';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#mix''n''match%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_12';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%mix''n''match%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_13';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#distributedgame%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_14';

\copy (select comment from wikidata_page_revisions where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[userjitrixis/nameguzzlerjs|nameguzzler]]%' order by random() limit 100) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revision_with_timestamp_editors/random_revisions_15';