\copy (select revision_user, revision_timestamp, revision_id from wikidata_page_revisions_with_timestamp_edit_types_and_usage where edit_type = 'human_edit' order by revision_timestamp) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/sql_queries/wikidata_page_revisions_with_timestamp_edit_types_and_usage/human_edits.tsv';