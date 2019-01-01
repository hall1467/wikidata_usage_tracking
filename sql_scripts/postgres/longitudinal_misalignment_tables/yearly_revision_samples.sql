-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '1' as period, NULL as gender, NULL as coordinate_location FROM revisions_all_automation_flags_and_usages where revision_timestamp >= 20130500000000 and revision_timestamp < 20140500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'bot_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_bot_edits_may_2013_to_2014.tsv';
-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '2' as period, NULL as gender, NULL as coordinate_location FROM revisions_all_automation_flags_and_usages where revision_timestamp >= 20140500000000 and revision_timestamp < 20150500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'bot_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_bot_edits_may_2014_to_2015.tsv';
-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '3' as period, NULL as gender, NULL as coordinate_location FROM revisions_all_automation_flags_and_usages where revision_timestamp >= 20150500000000 and revision_timestamp < 20160500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'bot_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_bot_edits_may_2015_to_2016.tsv';
-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '4' as period, NULL as gender, NULL as coordinate_location FROM revisions_all_automation_flags_and_usages where revision_timestamp >= 20160500000000 and revision_timestamp < 20170500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'bot_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_bot_edits_may_2016_to_2017.tsv';

-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '1' as period, NULL as gender, NULL as coordinate_location FROM revisions_all_automation_flags_and_usages where revision_timestamp >= 20130500000000 and revision_timestamp < 20140500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'human_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_human_edits_may_2013_to_2014.tsv';
-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '2' as period, NULL as gender, NULL as coordinate_location FROM revisions_all_automation_flags_and_usages where revision_timestamp >= 20140500000000 and revision_timestamp < 20150500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'human_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_human_edits_may_2014_to_2015.tsv';
-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '3' as period, NULL as gender, NULL as coordinate_location FROM revisions_all_automation_flags_and_usages where revision_timestamp >= 20150500000000 and revision_timestamp < 20160500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'human_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_human_edits_may_2015_to_2016.tsv';
-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '4' as period, NULL as gender, NULL as coordinate_location FROM revisions_all_automation_flags_and_usages where revision_timestamp >= 20160500000000 and revision_timestamp < 20170500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'human_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_human_edits_may_2016_to_2017.tsv';

-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '1' as period, NULL as gender, NULL as coordinate_location FROM revisions_all_automation_flags_and_usages where revision_timestamp >= 20130500000000 and revision_timestamp < 20140500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'anon_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_anon_edits_may_2013_to_2014.tsv';
-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '2' as period, NULL as gender, NULL as coordinate_location FROM revisions_all_automation_flags_and_usages where revision_timestamp >= 20140500000000 and revision_timestamp < 20150500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'anon_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_anon_edits_may_2014_to_2015.tsv';
-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '3' as period, NULL as gender, NULL as coordinate_location FROM revisions_all_automation_flags_and_usages where revision_timestamp >= 20150500000000 and revision_timestamp < 20160500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'anon_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_anon_edits_may_2015_to_2016.tsv';
-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '4' as period, NULL as gender, NULL as coordinate_location FROM revisions_all_automation_flags_and_usages where revision_timestamp >= 20160500000000 and revision_timestamp < 20170500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'anon_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_anon_edits_may_2016_to_2017.tsv';

-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '1' as period, NULL as gender, NULL as coordinate_location FROM revisions_all_automation_flags_and_usages where revision_timestamp >= 20130500000000 and revision_timestamp < 20140500000000 AND page_views IS NOT NULL AND namespace = 0 AND (edit_type != 'bot_edit' AND edit_type != 'human_edit' AND edit_type != 'anon_edit' AND edit_type != 'identity_blocked_edit')) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_tool_edits_may_2013_to_2014.tsv';
-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '2' as period, NULL as gender, NULL as coordinate_location FROM revisions_all_automation_flags_and_usages where revision_timestamp >= 20140500000000 and revision_timestamp < 20150500000000 AND page_views IS NOT NULL AND namespace = 0 AND (edit_type != 'bot_edit' AND edit_type != 'human_edit' AND edit_type != 'anon_edit' AND edit_type != 'identity_blocked_edit')) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_tool_edits_may_2014_to_2015.tsv';
-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '3' as period, NULL as gender, NULL as coordinate_location FROM revisions_all_automation_flags_and_usages where revision_timestamp >= 20150500000000 and revision_timestamp < 20160500000000 AND page_views IS NOT NULL AND namespace = 0 AND (edit_type != 'bot_edit' AND edit_type != 'human_edit' AND edit_type != 'anon_edit' AND edit_type != 'identity_blocked_edit')) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_tool_edits_may_2015_to_2016.tsv';
-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '4' as period, NULL as gender, NULL as coordinate_location FROM revisions_all_automation_flags_and_usages where revision_timestamp >= 20160500000000 and revision_timestamp < 20170500000000 AND page_views IS NOT NULL AND namespace = 0 AND (edit_type != 'bot_edit' AND edit_type != 'human_edit' AND edit_type != 'anon_edit' AND edit_type != 'identity_blocked_edit')) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_tool_edits_may_2016_to_2017.tsv';




\copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '1' as period, (CASE WHEN female_item IS NOT NULL THEN 'female_item' ELSE 'male_item' END) as gender, NULL as coordinate_location FROM items_with_male_or_female_gender_revisions where revision_timestamp >= 20130500000000 and revision_timestamp < 20140500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'bot_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_gender_bot_edits_may_2013_to_2014.tsv';
\copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '2' as period, (CASE WHEN female_item IS NOT NULL THEN 'female_item' ELSE 'male_item' END) as gender, NULL as coordinate_location FROM items_with_male_or_female_gender_revisions where revision_timestamp >= 20140500000000 and revision_timestamp < 20150500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'bot_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_gender_bot_edits_may_2014_to_2015.tsv';
\copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '3' as period, (CASE WHEN female_item IS NOT NULL THEN 'female_item' ELSE 'male_item' END) as gender, NULL as coordinate_location FROM items_with_male_or_female_gender_revisions where revision_timestamp >= 20150500000000 and revision_timestamp < 20160500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'bot_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_gender_bot_edits_may_2015_to_2016.tsv';
\copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '4' as period, (CASE WHEN female_item IS NOT NULL THEN 'female_item' ELSE 'male_item' END) as gender, NULL as coordinate_location FROM items_with_male_or_female_gender_revisions where revision_timestamp >= 20160500000000 and revision_timestamp < 20170500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'bot_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_gender_bot_edits_may_2016_to_2017.tsv';

\copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '1' as period, (CASE WHEN female_item IS NOT NULL THEN 'female_item' ELSE 'male_item' END) as gender, NULL as coordinate_location FROM items_with_male_or_female_gender_revisions where revision_timestamp >= 20130500000000 and revision_timestamp < 20140500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'human_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_gender_human_edits_may_2013_to_2014.tsv';
\copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '2' as period, (CASE WHEN female_item IS NOT NULL THEN 'female_item' ELSE 'male_item' END) as gender, NULL as coordinate_location FROM items_with_male_or_female_gender_revisions where revision_timestamp >= 20140500000000 and revision_timestamp < 20150500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'human_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_gender_human_edits_may_2014_to_2015.tsv';
\copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '3' as period, (CASE WHEN female_item IS NOT NULL THEN 'female_item' ELSE 'male_item' END) as gender, NULL as coordinate_location FROM items_with_male_or_female_gender_revisions where revision_timestamp >= 20150500000000 and revision_timestamp < 20160500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'human_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_gender_human_edits_may_2015_to_2016.tsv';
\copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '4' as period, (CASE WHEN female_item IS NOT NULL THEN 'female_item' ELSE 'male_item' END) as gender, NULL as coordinate_location FROM items_with_male_or_female_gender_revisions where revision_timestamp >= 20160500000000 and revision_timestamp < 20170500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'human_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_gender_human_edits_may_2016_to_2017.tsv';

\copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '1' as period, (CASE WHEN female_item IS NOT NULL THEN 'female_item' ELSE 'male_item' END) as gender, NULL as coordinate_location FROM items_with_male_or_female_gender_revisions where revision_timestamp >= 20130500000000 and revision_timestamp < 20140500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'anon_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_gender_anon_edits_may_2013_to_2014.tsv';
\copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '2' as period, (CASE WHEN female_item IS NOT NULL THEN 'female_item' ELSE 'male_item' END) as gender, NULL as coordinate_location FROM items_with_male_or_female_gender_revisions where revision_timestamp >= 20140500000000 and revision_timestamp < 20150500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'anon_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_gender_anon_edits_may_2014_to_2015.tsv';
\copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '3' as period, (CASE WHEN female_item IS NOT NULL THEN 'female_item' ELSE 'male_item' END) as gender, NULL as coordinate_location FROM items_with_male_or_female_gender_revisions where revision_timestamp >= 20150500000000 and revision_timestamp < 20160500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'anon_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_gender_anon_edits_may_2015_to_2016.tsv';
\copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '4' as period, (CASE WHEN female_item IS NOT NULL THEN 'female_item' ELSE 'male_item' END) as gender, NULL as coordinate_location FROM items_with_male_or_female_gender_revisions where revision_timestamp >= 20160500000000 and revision_timestamp < 20170500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'anon_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_gender_anon_edits_may_2016_to_2017.tsv';

\copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '1' as period, (CASE WHEN female_item IS NOT NULL THEN 'female_item' ELSE 'male_item' END) as gender, NULL as coordinate_location FROM items_with_male_or_female_gender_revisions where revision_timestamp >= 20130500000000 and revision_timestamp < 20140500000000 AND page_views IS NOT NULL AND namespace = 0 AND (edit_type != 'bot_edit' AND edit_type != 'human_edit' AND edit_type != 'anon_edit' AND edit_type != 'identity_blocked_edit')) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_gender_tool_edits_may_2013_to_2014.tsv';
\copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '2' as period, (CASE WHEN female_item IS NOT NULL THEN 'female_item' ELSE 'male_item' END) as gender, NULL as coordinate_location FROM items_with_male_or_female_gender_revisions where revision_timestamp >= 20140500000000 and revision_timestamp < 20150500000000 AND page_views IS NOT NULL AND namespace = 0 AND (edit_type != 'bot_edit' AND edit_type != 'human_edit' AND edit_type != 'anon_edit' AND edit_type != 'identity_blocked_edit')) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_gender_tool_edits_may_2014_to_2015.tsv';
\copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '3' as period, (CASE WHEN female_item IS NOT NULL THEN 'female_item' ELSE 'male_item' END) as gender, NULL as coordinate_location FROM items_with_male_or_female_gender_revisions where revision_timestamp >= 20150500000000 and revision_timestamp < 20160500000000 AND page_views IS NOT NULL AND namespace = 0 AND (edit_type != 'bot_edit' AND edit_type != 'human_edit' AND edit_type != 'anon_edit' AND edit_type != 'identity_blocked_edit')) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_gender_tool_edits_may_2015_to_2016.tsv';
\copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '4' as period, (CASE WHEN female_item IS NOT NULL THEN 'female_item' ELSE 'male_item' END) as gender, NULL as coordinate_location FROM items_with_male_or_female_gender_revisions where revision_timestamp >= 20160500000000 and revision_timestamp < 20170500000000 AND page_views IS NOT NULL AND namespace = 0 AND (edit_type != 'bot_edit' AND edit_type != 'human_edit' AND edit_type != 'anon_edit' AND edit_type != 'identity_blocked_edit')) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_gender_tool_edits_may_2016_to_2017.tsv';




-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '1' as period, NULL as gender, coordinate_location FROM items_with_one_coordinate_location_revisions where revision_timestamp >= 20130500000000 and revision_timestamp < 20140500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'bot_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_coordinate_location_bot_edits_may_2013_to_2014.tsv';
-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '2' as period, NULL as gender, coordinate_location FROM items_with_one_coordinate_location_revisions where revision_timestamp >= 20140500000000 and revision_timestamp < 20150500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'bot_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_coordinate_location_bot_edits_may_2014_to_2015.tsv';
-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '3' as period, NULL as gender, coordinate_location FROM items_with_one_coordinate_location_revisions where revision_timestamp >= 20150500000000 and revision_timestamp < 20160500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'bot_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_coordinate_location_bot_edits_may_2015_to_2016.tsv';
-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '4' as period, NULL as gender, coordinate_location FROM items_with_one_coordinate_location_revisions where revision_timestamp >= 20160500000000 and revision_timestamp < 20170500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'bot_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_coordinate_location_bot_edits_may_2016_to_2017.tsv';

-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '1' as period, NULL as gender, coordinate_location FROM items_with_one_coordinate_location_revisions where revision_timestamp >= 20130500000000 and revision_timestamp < 20140500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'human_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_coordinate_location_human_edits_may_2013_to_2014.tsv';
-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '2' as period, NULL as gender, coordinate_location FROM items_with_one_coordinate_location_revisions where revision_timestamp >= 20140500000000 and revision_timestamp < 20150500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'human_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_coordinate_location_human_edits_may_2014_to_2015.tsv';
-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '3' as period, NULL as gender, coordinate_location FROM items_with_one_coordinate_location_revisions where revision_timestamp >= 20150500000000 and revision_timestamp < 20160500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'human_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_coordinate_location_human_edits_may_2015_to_2016.tsv';
-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '4' as period, NULL as gender, coordinate_location FROM items_with_one_coordinate_location_revisions where revision_timestamp >= 20160500000000 and revision_timestamp < 20170500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'human_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_coordinate_location_human_edits_may_2016_to_2017.tsv';

-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '1' as period, NULL as gender, coordinate_location FROM items_with_one_coordinate_location_revisions where revision_timestamp >= 20130500000000 and revision_timestamp < 20140500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'anon_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_coordinate_location_anon_edits_may_2013_to_2014.tsv';
-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '2' as period, NULL as gender, coordinate_location FROM items_with_one_coordinate_location_revisions where revision_timestamp >= 20140500000000 and revision_timestamp < 20150500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'anon_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_coordinate_location_anon_edits_may_2014_to_2015.tsv';
-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '3' as period, NULL as gender, coordinate_location FROM items_with_one_coordinate_location_revisions where revision_timestamp >= 20150500000000 and revision_timestamp < 20160500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'anon_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_coordinate_location_anon_edits_may_2015_to_2016.tsv';
-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '4' as period, NULL as gender, coordinate_location FROM items_with_one_coordinate_location_revisions where revision_timestamp >= 20160500000000 and revision_timestamp < 20170500000000 AND page_views IS NOT NULL AND namespace = 0 AND edit_type = 'anon_edit') TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_coordinate_location_anon_edits_may_2016_to_2017.tsv';

-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '1' as period, NULL as gender, coordinate_location FROM items_with_one_coordinate_location_revisions where revision_timestamp >= 20130500000000 and revision_timestamp < 20140500000000 AND page_views IS NOT NULL AND namespace = 0 AND (edit_type != 'bot_edit' AND edit_type != 'human_edit' AND edit_type != 'anon_edit' AND edit_type != 'identity_blocked_edit')) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_coordinate_location_tool_edits_may_2013_to_2014.tsv';
-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '2' as period, NULL as gender, coordinate_location FROM items_with_one_coordinate_location_revisions where revision_timestamp >= 20140500000000 and revision_timestamp < 20150500000000 AND page_views IS NOT NULL AND namespace = 0 AND (edit_type != 'bot_edit' AND edit_type != 'human_edit' AND edit_type != 'anon_edit' AND edit_type != 'identity_blocked_edit')) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_coordinate_location_tool_edits_may_2014_to_2015.tsv';
-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '3' as period, NULL as gender, coordinate_location FROM items_with_one_coordinate_location_revisions where revision_timestamp >= 20150500000000 and revision_timestamp < 20160500000000 AND page_views IS NOT NULL AND namespace = 0 AND (edit_type != 'bot_edit' AND edit_type != 'human_edit' AND edit_type != 'anon_edit' AND edit_type != 'identity_blocked_edit')) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_coordinate_location_tool_edits_may_2015_to_2016.tsv';
-- \copy (SELECT misalignment_matching_year, misalignment_matching_month, namespace, page_title, edit_type, page_views, revision_id, comment, revision_parent_id, '4' as period, NULL as gender, coordinate_location FROM items_with_one_coordinate_location_revisions where revision_timestamp >= 20160500000000 and revision_timestamp < 20170500000000 AND page_views IS NOT NULL AND namespace = 0 AND (edit_type != 'bot_edit' AND edit_type != 'human_edit' AND edit_type != 'anon_edit' AND edit_type != 'identity_blocked_edit')) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/used_items_with_coordinate_location_tool_edits_may_2016_to_2017.tsv';
