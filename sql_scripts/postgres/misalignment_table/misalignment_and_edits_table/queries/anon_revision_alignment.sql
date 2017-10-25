\copy (SELECT entity_id, revision_id, revision_user, quality_class, views_class FROM misalignment_and_edits INNER JOIN wikidata_page_revisions_with_timestamp_edit_types_and_usage ON misalignment_and_edits.entity_id = wikidata_page_revisions_with_timestamp_edit_types_and_usage.page_title WHERE misalignment_and_edits.year = '2017' AND misalignment_and_edits.month = '5' AND wikidata_page_revisions_with_timestamp_edit_types_and_usage.edit_type = 'anon_edit') TO '../../../../../../../wbc_entity_usage/usage_results/sql_queries/misalignment_and_edits/anon_revision_alignment.tsv';

