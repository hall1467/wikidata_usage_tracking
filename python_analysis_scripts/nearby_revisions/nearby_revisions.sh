
psql wikidata_entities -c "\copy (select revision_id, user, revision_timestamp, edit_type from wikidata_page_revisions_with_timestamp_edit_types_and_usage order by random() limit 100000) TO '/export/scratch2/wmf/edit_analyses/nearby_revisions/100000_random_item_or_property_revisions';"

