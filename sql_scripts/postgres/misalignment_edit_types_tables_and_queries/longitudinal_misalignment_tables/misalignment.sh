# Have been running python scripts in the virtual environment on flagon here: /export/scratch2/wmf/scripts/

set base = /export/scratch2/wmf/scripts/wikidata_usage_tracking/sql_scripts/postgres/misalignment_edit_types_tables_and_queries
set results = /export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment
set input_for_rmse_split_directory = $results/input_for_rmse_split_directory
set monthly_revisions_directory = $results/monthly_revisions_directory


## It appears the quality_weighted_sum_and_views table was already created and manually so maybe could recreate


# psql wikidata_entities < $base/longitudinal_misalignment_tables/used_entity_page_views.sql


# psql wikidata_entities < $base/longitudinal_misalignment_tables/monthly_item_quality_sorted_by_month.sql


# python $base/longitudinal_misalignment_tables/misalignment_preprocessor.py \
# 		$results/used_entity_page_views.tsv \
# 		$results/monthly_item_quality_sorted_by_month.tsv \
# 		$input_for_rmse_split_directory/input_for_RMSE.tsv \
# 		--verbose > & \
# 		$results/misalignment_preprocessor_error_log.txt


# input_for_rmse_split_directory


# tail -n +2 input_for_RMSE.tsv > input_for_RMSE_no_header.tsv


# length of May 2017 Wikidata entity "universe"
# split -d  -l 22149770 input_for_RMSE_no_header.tsv input_for_RMSE_sub_

# Should delete output file before for loop

# More recently have been moving into directories by year and manually running each to speed up this process. 
# Otherwise takes 18 hours for the below loop

# foreach input_RMSE_file ($input_for_rmse_split_directory/2012/input_for_RMSE_sub*)
# 	Rscript $base/longitudinal_misalignment_tables/expected_quality_versus_actual_quality_RMSE.r $input_RMSE_file $results/2012_error_metrics.tsv
# end

# foreach input_RMSE_file ($input_for_rmse_split_directory/2013/input_for_RMSE_sub*)
# 	Rscript $base/longitudinal_misalignment_tables/expected_quality_versus_actual_quality_RMSE.r $input_RMSE_file $results/2013_error_metrics.tsv
# end

# foreach input_RMSE_file ($input_for_rmse_split_directory/2014/input_for_RMSE_sub*)
# 	Rscript $base/longitudinal_misalignment_tables/expected_quality_versus_actual_quality_RMSE.r $input_RMSE_file $results/2014_error_metrics.tsv
# end

# foreach input_RMSE_file ($input_for_rmse_split_directory/2015/input_for_RMSE_sub*)
# 	Rscript $base/longitudinal_misalignment_tables/expected_quality_versus_actual_quality_RMSE.r $input_RMSE_file $results/2015_error_metrics.tsv
# end

# foreach input_RMSE_file ($input_for_rmse_split_directory/2016/input_for_RMSE_sub*)
# 	Rscript $base/longitudinal_misalignment_tables/expected_quality_versus_actual_quality_RMSE.r $input_RMSE_file $results/2016_error_metrics.tsv
# end

# foreach input_RMSE_file ($input_for_rmse_split_directory/2017/input_for_RMSE_sub*)
# 	Rscript $base/longitudinal_misalignment_tables/expected_quality_versus_actual_quality_RMSE.r $input_RMSE_file $results/2017_error_metrics.tsv
# end


# \copy (SELECT page_title, revision_id, revision_user, comment, namespace, revision_timestamp, year, month, bot_user_id, change_tag_revision_id, number_of_revisions, page_views, edit_type, year_month_page_title, bot_prediction_threshold, session_start, misalignment_matching_year, misalignment_matching_month, edit_type_updated, reference_manipulation, sitelink_manipulation, label_description_or_alias_manipulation, quality_class, views_class FROM misalignment_and_edits where revision_timestamp >= 20130500000000 and revision_timestamp < 20140500000000 AND page_views IS NOT NULL) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/used_misalignment_and_edits_may_2013_to_2014.tsv';
# \copy (SELECT page_title, revision_id, revision_user, comment, namespace, revision_timestamp, year, month, bot_user_id, change_tag_revision_id, number_of_revisions, page_views, edit_type, year_month_page_title, bot_prediction_threshold, session_start, misalignment_matching_year, misalignment_matching_month, edit_type_updated, reference_manipulation, sitelink_manipulation, label_description_or_alias_manipulation, quality_class, views_class FROM misalignment_and_edits where revision_timestamp >= 20140500000000 and revision_timestamp < 20150500000000 AND page_views IS NOT NULL) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/used_misalignment_and_edits_may_2014_to_2015.tsv';
# \copy (SELECT page_title, revision_id, revision_user, comment, namespace, revision_timestamp, year, month, bot_user_id, change_tag_revision_id, number_of_revisions, page_views, edit_type, year_month_page_title, bot_prediction_threshold, session_start, misalignment_matching_year, misalignment_matching_month, edit_type_updated, reference_manipulation, sitelink_manipulation, label_description_or_alias_manipulation, quality_class, views_class FROM misalignment_and_edits where revision_timestamp >= 20150500000000 and revision_timestamp < 20160500000000 AND page_views IS NOT NULL) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/used_misalignment_and_edits_may_2015_to_2016.tsv';
# \copy (SELECT page_title, revision_id, revision_user, comment, namespace, revision_timestamp, year, month, bot_user_id, change_tag_revision_id, number_of_revisions, page_views, edit_type, year_month_page_title, bot_prediction_threshold, session_start, misalignment_matching_year, misalignment_matching_month, edit_type_updated, reference_manipulation, sitelink_manipulation, label_description_or_alias_manipulation, quality_class, views_class FROM misalignment_and_edits where revision_timestamp >= 20160500000000 and revision_timestamp < 20170500000000 AND page_views IS NOT NULL) TO '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/used_misalignment_and_edits_may_2016_to_2017.tsv';


# shuf -n 1000000 $results/used_misalignment_and_edits_may_2013_to_2014.tsv > $results/used_misalignment_and_edits_may_2013_to_2014_million_sampled.tsv
# shuf -n 1000000 $results/used_misalignment_and_edits_may_2014_to_2015.tsv > $results/used_misalignment_and_edits_may_2014_to_2015_million_sampled.tsv
# shuf -n 1000000 $results/used_misalignment_and_edits_may_2015_to_2016.tsv > $results/used_misalignment_and_edits_may_2015_to_2016_million_sampled.tsv
# shuf -n 1000000 $results/used_misalignment_and_edits_may_2016_to_2017.tsv > $results/used_misalignment_and_edits_may_2016_to_2017_million_sampled.tsv


# python $base/longitudinal_misalignment_tables/extract_edit_type.py \
# 	$results/used_misalignment_and_edits_may_2013_to_2014_million_sampled.tsv \
# 	$results/revision_edit_and_agent_type_may_2013_to_2014_million_sampled.json \
# 	--verbose > & \
# 	$results/extract_edit_and_agent_type_may_2013_to_2014_error_log.txt


# python $base/longitudinal_misalignment_tables/extract_edit_type.py \
# 	$results/used_misalignment_and_edits_may_2014_to_2015_million_sampled.tsv \
# 	$results/revision_edit_and_agent_type_may_2014_to_2015_million_sampled.json \
# 	--verbose > & \
# 	$results/extract_edit_and_agent_type_may_2014_to_2015_error_log.txt


# python $base/longitudinal_misalignment_tables/extract_edit_type.py \
# 	$results/used_misalignment_and_edits_may_2015_to_2016_million_sampled.tsv \
# 	$results/revision_edit_and_agent_type_may_2015_to_2016_million_sampled.json \
# 	--verbose > & \
# 	$results/extract_edit_and_agent_type_may_2015_to_2016_error_log.txt


# python $base/longitudinal_misalignment_tables/extract_edit_type.py \
# 	$results/used_misalignment_and_edits_may_2016_to_2017_million_sampled.tsv \
# 	$results/revision_edit_and_agent_type_may_2016_to_2017_million_sampled.json \
# 	--verbose > & \
# 	$results/extract_edit_and_agent_type_may_2016_to_2017_error_log.txt


# Run ores

# cat $results/revision_edit_and_agent_type_may_2013_to_2014_million_sampled.json | \
# 	ores score_revisions https://ores.wikimedia.org wikidatawiki itemquality --verbose \
# 	> $results/revision_edit_and_agent_type_may_2013_to_2014_million_sampled_with_quality.json

# cat $results/revision_edit_and_agent_type_may_2014_to_2015_million_sampled.json | \
# 	ores score_revisions https://ores.wikimedia.org wikidatawiki itemquality --verbose \
# 	> $results/revision_edit_and_agent_type_may_2014_to_2015_million_sampled_with_quality.json

# cat $results/revision_edit_and_agent_type_may_2015_to_2016_million_sampled.json | \
# 	ores score_revisions https://ores.wikimedia.org wikidatawiki itemquality --verbose \
# 	> $results/revision_edit_and_agent_type_may_2015_to_2016_million_sampled_with_quality.json

# cat $results/revision_edit_and_agent_type_may_2016_to_2017_million_sampled.json | \
# 	ores score_revisions https://ores.wikimedia.org wikidatawiki itemquality --verbose \
# 	> $results/revision_edit_and_agent_type_may_2016_to_2017_million_sampled_with_quality.json


# python $base/longitudinal_misalignment_tables/extract_weighted_score.py \
# 	$results/revision_edit_and_agent_type_may_2013_to_2014_million_sampled_with_quality.json \
# 	$monthly_revisions_directory/monthly_sampled_revisions_june_2013.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_july_2013.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_august_2013.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_september_2013.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_october_2013.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_november_2013.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_december_2013.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_january_2014.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_february_2014.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_march_2014.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_april_2014.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_may_2014.tsv \
# 	--verbose > & \
# 	$results/extract_weighted_score_2013_to_2014_error_log.txt


# python $base/longitudinal_misalignment_tables/extract_weighted_score.py \
# 	$results/revision_edit_and_agent_type_may_2014_to_2015_million_sampled_with_quality.json \
# 	$monthly_revisions_directory/monthly_sampled_revisions_june_2014.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_july_2014.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_august_2014.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_september_2014.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_october_2014.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_november_2014.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_december_2014.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_january_2015.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_february_2015.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_march_2015.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_april_2015.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_may_2015.tsv \
# 	--verbose > & \
# 	$results/extract_weighted_score_2014_to_2015_error_log.txt


# python $base/longitudinal_misalignment_tables/extract_weighted_score.py \
# 	$results/revision_edit_and_agent_type_may_2015_to_2016_million_sampled_with_quality.json \
# 	$monthly_revisions_directory/monthly_sampled_revisions_june_2015.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_july_2015.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_august_2015.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_september_2015.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_october_2015.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_november_2015.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_december_2015.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_january_2016.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_february_2016.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_march_2016.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_april_2016.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_may_2016.tsv \
# 	--verbose > & \
# 	$results/extract_weighted_score_2015_to_2016_error_log.txt


# python $base/longitudinal_misalignment_tables/extract_weighted_score.py \
# 	$results/revision_edit_and_agent_type_may_2016_to_2017_million_sampled_with_quality.json \
# 	$monthly_revisions_directory/monthly_sampled_revisions_june_2016.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_july_2016.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_august_2016.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_september_2016.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_october_2016.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_november_2016.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_december_2016.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_january_2017.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_february_2017.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_march_2017.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_april_2017.tsv \
# 	$monthly_revisions_directory/monthly_sampled_revisions_may_2017.tsv \
# 	--verbose > & \
# 	$results/extract_weighted_score_2016_to_2017_error_log.txt


# Rscript $base/longitudinal_misalignment_tables/2013_2014_revision_alignment.r
# Rscript $base/longitudinal_misalignment_tables/2014_2015_revision_alignment.r
# Rscript $base/longitudinal_misalignment_tables/2015_2016_revision_alignment.r
# Rscript $base/longitudinal_misalignment_tables/2016_2017_revision_alignment.r


# python $base/longitudinal_misalignment_tables/obtain_parent_data_from_api.py \
# 	$results/all_revisions_quality_differences_2013_2014.tsv \
# 	$results/revision_parent_data_2013_2014.json \
# 	--verbose > & \
# 	$results/revision_parent_data_2013_2014_error_log.txt

# python $base/longitudinal_misalignment_tables/obtain_parent_data_from_api.py \
# 	$results/all_revisions_quality_differences_2014_2015.tsv \
# 	$results/revision_parent_data_2014_2015.json \
# 	--verbose > & \
# 	$results/revision_parent_data_2014_2015_error_log.txt

# python $base/longitudinal_misalignment_tables/obtain_parent_data_from_api.py \
# 	$results/all_revisions_quality_differences_2015_2016.tsv \
# 	$results/revision_parent_data_2015_2016.json \
# 	--verbose > & \
# 	$results/revision_parent_data_2015_2016_error_log.txt

# python $base/longitudinal_misalignment_tables/obtain_parent_data_from_api.py \
# 	$results/all_revisions_quality_differences_2016_2017.tsv \
# 	$results/revision_parent_data_2016_2017.json \
# 	--verbose > & \
# 	$results/revision_parent_data_2016_2017_error_log.txt


# Run ores

# cat $results/revision_parent_data_2013_2014.json | \
# 	ores score_revisions https://ores.wikimedia.org wikidatawiki itemquality --verbose \
# 	> $results/revision_parent_data_2013_2014_with_quality.json

# cat $results/revision_parent_data_2014_2015.json | \
# 	ores score_revisions https://ores.wikimedia.org wikidatawiki itemquality --verbose \
# 	> $results/revision_parent_data_2014_2015_with_quality.json

# cat $results/revision_parent_data_2015_2016.json | \
# 	ores score_revisions https://ores.wikimedia.org wikidatawiki itemquality --verbose \
# 	> $results/revision_parent_data_2015_2016_with_quality.json

# cat $results/revision_parent_data_2016_2017.json | \
# 	ores score_revisions https://ores.wikimedia.org wikidatawiki itemquality --verbose \
# 	> $results/revision_parent_data_2016_2017_with_quality.json


# python $base/longitudinal_misalignment_tables/extract_weighted_score_from_parent.py \
# 	$results/revision_parent_data_2013_2014_with_quality.json \
# 	$results/parent_data_with_extracted_weighted_score_2013_2014.tsv \
# 	--verbose > & \
# 	$results/parent_data_with_extracted_weighted_score_2013_2014_error_log.txt

# python $base/longitudinal_misalignment_tables/extract_weighted_score_from_parent.py \
# 	$results/revision_parent_data_2014_2015_with_quality.json \
# 	$results/parent_data_with_extracted_weighted_score_2014_2015.tsv \
# 	--verbose > & \
# 	$results/parent_data_with_extracted_weighted_score_2014_2015_error_log.txt

# python $base/longitudinal_misalignment_tables/extract_weighted_score_from_parent.py \
# 	$results/revision_parent_data_2015_2016_with_quality.json \
# 	$results/parent_data_with_extracted_weighted_score_2015_2016.tsv \
# 	--verbose > & \
# 	$results/parent_data_with_extracted_weighted_score_2015_2016_error_log.txt

# python $base/longitudinal_misalignment_tables/extract_weighted_score_from_parent.py \
# 	$results/revision_parent_data_2016_2017_with_quality.json \
# 	$results/parent_data_with_extracted_weighted_score_2016_2017.tsv \
# 	--verbose > & \
# 	$results/parent_data_with_extracted_weighted_score_2016_2017_error_log.txt


# python $base/longitudinal_misalignment_tables/obtain_entity_data_from_api.py \
# 	$results/all_revisions_quality_differences_2013_2014.tsv \
# 	$results/all_revisions_with_api_entity_data_2013_2014.tsv \
# 	--verbose > & \
# 	$results/all_revisions_with_api_entity_data_2013_2014_error_log.txt

# python $base/longitudinal_misalignment_tables/obtain_entity_data_from_api.py \
# 	$results/all_revisions_quality_differences_2014_2015.tsv \
# 	$results/all_revisions_with_api_entity_data_2014_2015.tsv \
# 	--verbose > & \
# 	$results/all_revisions_with_api_entity_data_2014_2015_error_log.txt

# python $base/longitudinal_misalignment_tables/obtain_entity_data_from_api.py \
# 	$results/all_revisions_quality_differences_2015_2016.tsv \
# 	$results/all_revisions_with_api_entity_data_2015_2016.tsv \
# 	--verbose > & \
# 	$results/all_revisions_with_api_entity_data_2015_2016_error_log.txt

# python $base/longitudinal_misalignment_tables/obtain_entity_data_from_api.py \
# 	$results/all_revisions_quality_differences_2016_2017.tsv \
# 	$results/all_revisions_with_api_entity_data_2016_2017.tsv \
# 	--verbose > & \
# 	$results/all_revisions_with_api_entity_data_2016_2017_error_log.txt


# python $base/longitudinal_misalignment_tables/merge_parent_data.py \
# 	$results/all_revisions_with_api_entity_data_2013_2014.tsv \
# 	$results/parent_data_with_extracted_weighted_score_2013_2014.tsv \
# 	$results/all_revisions_with_api_and_parent_entity_data_2013_2014.tsv \
# 	--verbose > & \
# 	$results/all_revisions_with_api_and_parent_entity_data_2013_2014_error_log.tsv

# python $base/longitudinal_misalignment_tables/merge_parent_data.py \
# 	$results/all_revisions_with_api_entity_data_2014_2015.tsv \
# 	$results/parent_data_with_extracted_weighted_score_2014_2015.tsv \
# 	$results/all_revisions_with_api_and_parent_entity_data_2014_2015.tsv \
# 	--verbose > & \
# 	$results/all_revisions_with_api_and_parent_entity_data_2014_2015_error_log.tsv

# python $base/longitudinal_misalignment_tables/merge_parent_data.py \
# 	$results/all_revisions_with_api_entity_data_2015_2016.tsv \
# 	$results/parent_data_with_extracted_weighted_score_2015_2016.tsv \
# 	$results/all_revisions_with_api_and_parent_entity_data_2015_2016.tsv \
# 	--verbose > & \
# 	$results/all_revisions_with_api_and_parent_entity_data_2015_2016_error_log.tsv

# python $base/longitudinal_misalignment_tables/merge_parent_data.py \
# 	$results/all_revisions_with_api_entity_data_2016_2017.tsv \
# 	$results/parent_data_with_extracted_weighted_score_2016_2017.tsv \
# 	$results/all_revisions_with_api_and_parent_entity_data_2016_2017.tsv \
# 	--verbose > & \
# 	$results/all_revisions_with_api_and_parent_entity_data_2016_2017_error_log.tsv



foreach input_RMSE_file ($input_for_rmse_split_directory/2012/input_for_RMSE_sub*)
	Rscript $base/longitudinal_misalignment_tables/expected_quality_versus_actual_quality_RMSE_humans.r $input_RMSE_file $results/human_male_items_10_11_18.tsv $results/2012_human_male_error_metrics.tsv
end

foreach input_RMSE_file ($input_for_rmse_split_directory/2013/input_for_RMSE_sub*)
	Rscript $base/longitudinal_misalignment_tables/expected_quality_versus_actual_quality_RMSE_humans.r $input_RMSE_file $results/human_male_items_10_11_18.tsv $results/2013_human_male_error_metrics.tsv
end

foreach input_RMSE_file ($input_for_rmse_split_directory/2014/input_for_RMSE_sub*)
	Rscript $base/longitudinal_misalignment_tables/expected_quality_versus_actual_quality_RMSE_humans.r $input_RMSE_file $results/human_male_items_10_11_18.tsv $results/2014_human_male_error_metrics.tsv
end

foreach input_RMSE_file ($input_for_rmse_split_directory/2015/input_for_RMSE_sub*)
	Rscript $base/longitudinal_misalignment_tables/expected_quality_versus_actual_quality_RMSE_humans.r $input_RMSE_file $results/human_male_items_10_11_18.tsv $results/2015_human_male_error_metrics.tsv
end

foreach input_RMSE_file ($input_for_rmse_split_directory/2016/input_for_RMSE_sub*)
	Rscript $base/longitudinal_misalignment_tables/expected_quality_versus_actual_quality_RMSE_humans.r $input_RMSE_file $results/human_male_items_10_11_18.tsv $results/2016_human_male_error_metrics.tsv
end

foreach input_RMSE_file ($input_for_rmse_split_directory/2017/input_for_RMSE_sub*)
	Rscript $base/longitudinal_misalignment_tables/expected_quality_versus_actual_quality_RMSE_humans.r $input_RMSE_file $results/human_male_items_10_11_18.tsv $results/2017_human_male_error_metrics.tsv
end




foreach input_RMSE_file ($input_for_rmse_split_directory/2012/input_for_RMSE_sub*)
	Rscript $base/longitudinal_misalignment_tables/expected_quality_versus_actual_quality_RMSE_humans.r $input_RMSE_file $results/human_female_items_10_11_18.tsv $results/2012_human_female_error_metrics.tsv
end

foreach input_RMSE_file ($input_for_rmse_split_directory/2013/input_for_RMSE_sub*)
	Rscript $base/longitudinal_misalignment_tables/expected_quality_versus_actual_quality_RMSE_humans.r $input_RMSE_file $results/human_female_items_10_11_18.tsv $results/2013_human_female_error_metrics.tsv
end

foreach input_RMSE_file ($input_for_rmse_split_directory/2014/input_for_RMSE_sub*)
	Rscript $base/longitudinal_misalignment_tables/expected_quality_versus_actual_quality_RMSE_humans.r $input_RMSE_file $results/human_female_items_10_11_18.tsv $results/2014_human_female_error_metrics.tsv
end

foreach input_RMSE_file ($input_for_rmse_split_directory/2015/input_for_RMSE_sub*)
	Rscript $base/longitudinal_misalignment_tables/expected_quality_versus_actual_quality_RMSE_humans.r $input_RMSE_file $results/human_female_items_10_11_18.tsv $results/2015_human_female_error_metrics.tsv
end

foreach input_RMSE_file ($input_for_rmse_split_directory/2016/input_for_RMSE_sub*)
	Rscript $base/longitudinal_misalignment_tables/expected_quality_versus_actual_quality_RMSE_humans.r $input_RMSE_file $results/human_female_items_10_11_18.tsv $results/2016_human_female_error_metrics.tsv
end

foreach input_RMSE_file ($input_for_rmse_split_directory/2017/input_for_RMSE_sub*)
	Rscript $base/longitudinal_misalignment_tables/expected_quality_versus_actual_quality_RMSE_humans.r $input_RMSE_file $results/human_female_items_10_11_18.tsv $results/2017_human_female_error_metrics.tsv
end
