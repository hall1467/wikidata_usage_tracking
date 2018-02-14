\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types_and_usage where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#quickstatements%' AND page_views IS NOT NULL) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/semi_automated_revision_count_for_type_1.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types_and_usage where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#petscan%' AND page_views IS NOT NULL) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/semi_automated_revision_count_for_type_2.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types_and_usage where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#autolist2%' AND page_views IS NOT NULL) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/semi_automated_revision_count_for_type_3.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types_and_usage where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%talkgadgetautoeditjs|autoedit]]%' AND page_views IS NOT NULL) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/semi_automated_revision_count_for_type_4.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types_and_usage where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%labellister%' AND page_views IS NOT NULL) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/semi_automated_revision_count_for_type_5.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types_and_usage where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#itemcreator%' AND page_views IS NOT NULL) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/semi_automated_revision_count_for_type_6.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types_and_usage where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#dragrefjs%' AND page_views IS NOT NULL) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/semi_automated_revision_count_for_type_7.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types_and_usage where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[useryms/lc|lcjs]]%' AND page_views IS NOT NULL) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/semi_automated_revision_count_for_type_8.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types_and_usage where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#wikidatagame%' AND page_views IS NOT NULL) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/semi_automated_revision_count_for_type_9.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types_and_usage where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[wikidataprimary%' AND page_views IS NOT NULL) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/semi_automated_revision_count_for_type_10.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types_and_usage where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%mix''n''match%' AND page_views IS NOT NULL) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/semi_automated_revision_count_for_type_11.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types_and_usage where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%#distributedgame%' AND page_views IS NOT NULL) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/semi_automated_revision_count_for_type_12.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types_and_usage where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[userjitrixis/nameguzzlerjs|nameguzzler]]%' AND page_views IS NOT NULL) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/semi_automated_revision_count_for_type_13.tsv';

\copy (select count(*) from wikidata_page_revisions_with_timestamp_edit_types_and_usage where lower(regexp_replace(comment, '\.|,|\(|\)|-|:','','g')) LIKE '%[[mediawikigadgetmergejs|mergejs]]%' AND page_views IS NOT NULL) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/semi_automated_revision_count_for_type_14.tsv';
