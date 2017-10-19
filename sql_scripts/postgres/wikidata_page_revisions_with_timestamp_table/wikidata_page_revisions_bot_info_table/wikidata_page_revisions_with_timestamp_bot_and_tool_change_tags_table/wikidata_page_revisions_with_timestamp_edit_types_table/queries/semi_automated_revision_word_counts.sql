\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#quickstatements%') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/revision_count_1.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#petscan%') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/revision_count_2.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#autolist2%') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/revision_count_3.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%talkgadgetautoeditjs|autoedit]]%') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/revision_count_4.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%labellister%') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/revision_count_5.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#itemcreator%') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/revision_count_6.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#dragrefjs%') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/revision_count_7.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[useryms/lc|lcjs]]%') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/revision_count_8.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#wikidatagame%') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/revision_count_9.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[wikidataprimary%') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/revision_count_10.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%mix''n''match%') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/revision_count_11.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#distributedgame%') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/revision_count_12.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[userjitrixis/nameguzzlerjs|nameguzzler]]%') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/revision_count_13.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[mediawikigadgetmergejs|mergejs]]%') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types/revision_count_14.tsv';
