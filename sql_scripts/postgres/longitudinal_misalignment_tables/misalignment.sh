# Have been running python scripts in the virtual environment on flagon here: /export/scratch2/wmf/scripts/

set base = /export/scratch2/wmf/scripts/wikidata_usage_tracking/sql_scripts/postgres/longitudinal_misalignment_tables
set results = /export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment
set input_for_rmse_split_directory = $results/input_for_rmse_split_directory
set monthly_revisions_directory = $results/monthly_revisions_directory


# python $base/extract_revisions_from_xml_dump.py \
# 	/export/scratch2/wmf/wbc_entity_usage/wikidata_page_revisions/wikidatawiki-20170501-stub-meta-history* \
# 	--revisions-output=$results/extracted_revisions.tsv \
# 	--verbose \
# 	--debug > & \
# 	$results/extract_revisions_from_xml_dump_error_log.txt


# python $base/revisions_postgres_post_process.py \
# 	$results/extracted_revisions.tsv \
# 	--revisions-output=$results/extracted_revisions_escaped.tsv \
# 	--verbose \
# 	--debug > & \
# 	$results/revisions_postgres_post_process_error_log.txt


# Import basic revision data into Postgres
psql wikidata_entities < $base/revisions_table/revisions_table_creation.sql
psql wikidata_entities < $base/revisions_table/revisions_table_import.sql	

# Merge with various automation flags
psql wikidata_entities < $base/revisions_initial_automation_flags_table/revision_intial_automation_flags_table_creation.sql
psql wikidata_entities < $base/revisions_initial_automation_flags_table/revision_intial_automation_flags_table_index_creation.sql

# Perform additional checks for different types of edits
# psql wikidata_entities < $base/revisions_all_automation_flags_table/psql wikidata_entities < $base/revisions_initial_automation_flags_table/revisions_all_automation_flags_and_usages_table_creation.sql


# psql wikidata_entities < $base/longitudinal_misalignment_tables/used_entity_page_views.sql


# psql wikidata_entities < $base/longitudinal_misalignment_tables/monthly_item_quality_sorted_by_month.sql


# python $base/misalignment_preprocessor.py \
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
# 	Rscript $base/expected_quality_versus_actual_quality_RMSE.r $input_RMSE_file $results/2012_error_metrics.tsv
# end

# foreach input_RMSE_file ($input_for_rmse_split_directory/2013/input_for_RMSE_sub*)
# 	Rscript $base/expected_quality_versus_actual_quality_RMSE.r $input_RMSE_file $results/2013_error_metrics.tsv
# end

# foreach input_RMSE_file ($input_for_rmse_split_directory/2014/input_for_RMSE_sub*)
# 	Rscript $base/expected_quality_versus_actual_quality_RMSE.r $input_RMSE_file $results/2014_error_metrics.tsv
# end

# foreach input_RMSE_file ($input_for_rmse_split_directory/2015/input_for_RMSE_sub*)
# 	Rscript $base/expected_quality_versus_actual_quality_RMSE.r $input_RMSE_file $results/2015_error_metrics.tsv
# end

# foreach input_RMSE_file ($input_for_rmse_split_directory/2016/input_for_RMSE_sub*)
# 	Rscript $base/expected_quality_versus_actual_quality_RMSE.r $input_RMSE_file $results/2016_error_metrics.tsv
# end

# foreach input_RMSE_file ($input_for_rmse_split_directory/2017/input_for_RMSE_sub*)
# 	Rscript $base/expected_quality_versus_actual_quality_RMSE.r $input_RMSE_file $results/2017_error_metrics.tsv
# end

# psql wikidata_entities < $base/yearly_revision_samples.sql

# shuf -n 250000 $results/used_bot_edits_may_2013_to_2014.tsv > $results/used_bot_edits_may_2013_to_2014_sampled.tsv
# shuf -n 250000 $results/used_bot_edits_may_2014_to_2015.tsv > $results/used_bot_edits_may_2014_to_2015_sampled.tsv
# shuf -n 250000 $results/used_bot_edits_may_2015_to_2016.tsv > $results/used_bot_edits_may_2015_to_2016_sampled.tsv
# shuf -n 250000 $results/used_bot_edits_may_2016_to_2017.tsv > $results/used_bot_edits_may_2016_to_2017_sampled.tsv

# shuf -n 250000 $results/used_human_edits_may_2013_to_2014.tsv > $results/used_human_edits_may_2013_to_2014_sampled.tsv
# shuf -n 250000 $results/used_human_edits_may_2014_to_2015.tsv > $results/used_human_edits_may_2014_to_2015_sampled.tsv
# shuf -n 250000 $results/used_human_edits_may_2015_to_2016.tsv > $results/used_human_edits_may_2015_to_2016_sampled.tsv
# shuf -n 250000 $results/used_human_edits_may_2016_to_2017.tsv > $results/used_human_edits_may_2016_to_2017_sampled.tsv

# shuf -n 250000 $results/used_anon_edits_may_2013_to_2014.tsv > $results/used_anon_edits_may_2013_to_2014_sampled.tsv
# shuf -n 250000 $results/used_anon_edits_may_2014_to_2015.tsv > $results/used_anon_edits_may_2014_to_2015_sampled.tsv
# shuf -n 250000 $results/used_anon_edits_may_2015_to_2016.tsv > $results/used_anon_edits_may_2015_to_2016_sampled.tsv
# shuf -n 250000 $results/used_anon_edits_may_2016_to_2017.tsv > $results/used_anon_edits_may_2016_to_2017_sampled.tsv

# shuf -n 250000 $results/used_tool_edits_may_2013_to_2014.tsv > $results/used_tool_edits_may_2013_to_2014_sampled.tsv
# shuf -n 250000 $results/used_tool_edits_may_2014_to_2015.tsv > $results/used_tool_edits_may_2014_to_2015_sampled.tsv
# shuf -n 250000 $results/used_tool_edits_may_2015_to_2016.tsv > $results/used_tool_edits_may_2015_to_2016_sampled.tsv
# shuf -n 250000 $results/used_tool_edits_may_2016_to_2017.tsv > $results/used_tool_edits_may_2016_to_2017_sampled.tsv


# Period 1: 2013 to 2014
# cat $results/used_bot_edits_may_2013_to_2014_sampled.tsv > $results/all_used_edits_sampled.tsv
# cat $results/used_human_edits_may_2013_to_2014_sampled.tsv >> $results/all_used_edits_sampled.tsv
# cat $results/used_anon_edits_may_2013_to_2014_sampled.tsv >> $results/all_used_edits_sampled.tsv
# cat $results/used_tool_edits_may_2013_to_2014_sampled.tsv >> $results/all_used_edits_sampled.tsv

# Period 2: 2014 to 2015
# cat $results/used_bot_edits_may_2014_to_2015_sampled.tsv >> $results/all_used_edits_sampled.tsv
# cat $results/used_human_edits_may_2014_to_2015_sampled.tsv >> $results/all_used_edits_sampled.tsv
# cat $results/used_anon_edits_may_2014_to_2015_sampled.tsv >> $results/all_used_edits_sampled.tsv
# cat $results/used_tool_edits_may_2014_to_2015_sampled.tsv >> $results/all_used_edits_sampled.tsv

# Period 3: 2015 to 2016
# cat $results/used_bot_edits_may_2015_to_2016_sampled.tsv >> $results/all_used_edits_sampled.tsv
# cat $results/used_human_edits_may_2015_to_2016_sampled.tsv >> $results/all_used_edits_sampled.tsv
# cat $results/used_anon_edits_may_2015_to_2016_sampled.tsv >> $results/all_used_edits_sampled.tsv
# cat $results/used_tool_edits_may_2015_to_2016_sampled.tsv >> $results/all_used_edits_sampled.tsv

# Period 4: 2016 to 2017
# cat $results/used_bot_edits_may_2016_to_2017_sampled.tsv >> $results/all_used_edits_sampled.tsv
# cat $results/used_human_edits_may_2016_to_2017_sampled.tsv >> $results/all_used_edits_sampled.tsv
# cat $results/used_anon_edits_may_2016_to_2017_sampled.tsv >> $results/all_used_edits_sampled.tsv
# cat $results/used_tool_edits_may_2016_to_2017_sampled.tsv >> $results/all_used_edits_sampled.tsv




# Convert to json so we can get ORES predictions for these edits
# python $base/convert_to_json.py \
# 	$results/all_used_edits_sampled.tsv \
# 	$results/all_used_edits_sampled.json \
# 	--verbose > & \
# 	$results/all_used_edits_sampled_converted_error_log.txt

# Combine two json files so that we can run ORES once.

# Run ORES

# cat $results/revision_edit_and_agent_type_may_2013_to_2014_million_sampled.json | \
# 	ores score_revisions https://ores.wikimedia.org wikidatawiki itemquality --verbose \
# 	> $results/revision_edit_and_agent_type_may_2013_to_2014_million_sampled_with_quality.json


# python $base/merge_parent_data.py \
# 	$results/all_revisions_with_api_entity_data_2013_2014.tsv \
# 	$results/parent_data_with_extracted_weighted_score_2013_2014.tsv \
# 	$results/all_revisions_with_api_and_parent_entity_data_2013_2014.tsv \
# 	--verbose > & \
# 	$results/all_revisions_with_api_and_parent_entity_data_2013_2014_error_log.tsv

# Split up files based on period.

# Extract weighted scores from both revision and parent



# python $base/extract_weighted_score.py \
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


# python $base/extract_weighted_score.py \
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


# python $base/extract_weighted_score.py \
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


# python $base/extract_weighted_score.py \
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


# Rscript $base/2013_2014_revision_alignment.r
# Rscript $base/2014_2015_revision_alignment.r
# Rscript $base/2015_2016_revision_alignment.r
# Rscript $base/2016_2017_revision_alignment.r



# Male alignment
# foreach input_RMSE_file ($input_for_rmse_split_directory/2012/input_for_RMSE_sub*)
# 	Rscript $base/expected_quality_versus_actual_quality_RMSE_humans.r $input_RMSE_file $results/human_male_items_10_11_18.tsv $results/2012_human_male_error_metrics.tsv
# end

# foreach input_RMSE_file ($input_for_rmse_split_directory/2013/input_for_RMSE_sub*)
# 	Rscript $base/expected_quality_versus_actual_quality_RMSE_humans.r $input_RMSE_file $results/human_male_items_10_11_18.tsv $results/2013_human_male_error_metrics.tsv
# end

# foreach input_RMSE_file ($input_for_rmse_split_directory/2014/input_for_RMSE_sub*)
# 	Rscript $base/expected_quality_versus_actual_quality_RMSE_humans.r $input_RMSE_file $results/human_male_items_10_11_18.tsv $results/2014_human_male_error_metrics.tsv
# end

# foreach input_RMSE_file ($input_for_rmse_split_directory/2015/input_for_RMSE_sub*)
# 	Rscript $base/expected_quality_versus_actual_quality_RMSE_humans.r $input_RMSE_file $results/human_male_items_10_11_18.tsv $results/2015_human_male_error_metrics.tsv
# end

# foreach input_RMSE_file ($input_for_rmse_split_directory/2016/input_for_RMSE_sub*)
# 	Rscript $base/expected_quality_versus_actual_quality_RMSE_humans.r $input_RMSE_file $results/human_male_items_10_11_18.tsv $results/2016_human_male_error_metrics.tsv
# end

# foreach input_RMSE_file ($input_for_rmse_split_directory/2017/input_for_RMSE_sub*)
# 	Rscript $base/expected_quality_versus_actual_quality_RMSE_humans.r $input_RMSE_file $results/human_male_items_10_11_18.tsv $results/2017_human_male_error_metrics.tsv
# end



# Female alignment
# foreach input_RMSE_file ($input_for_rmse_split_directory/2012/input_for_RMSE_sub*)
# 	Rscript $base/expected_quality_versus_actual_quality_RMSE_humans.r $input_RMSE_file $results/human_female_items_10_11_18.tsv $results/2012_human_female_error_metrics.tsv
# end

# foreach input_RMSE_file ($input_for_rmse_split_directory/2013/input_for_RMSE_sub*)
# 	Rscript $base/expected_quality_versus_actual_quality_RMSE_humans.r $input_RMSE_file $results/human_female_items_10_11_18.tsv $results/2013_human_female_error_metrics.tsv
# end

# foreach input_RMSE_file ($input_for_rmse_split_directory/2014/input_for_RMSE_sub*)
# 	Rscript $base/expected_quality_versus_actual_quality_RMSE_humans.r $input_RMSE_file $results/human_female_items_10_11_18.tsv $results/2014_human_female_error_metrics.tsv
# end

# foreach input_RMSE_file ($input_for_rmse_split_directory/2015/input_for_RMSE_sub*)
# 	Rscript $base/expected_quality_versus_actual_quality_RMSE_humans.r $input_RMSE_file $results/human_female_items_10_11_18.tsv $results/2015_human_female_error_metrics.tsv
# end

# foreach input_RMSE_file ($input_for_rmse_split_directory/2016/input_for_RMSE_sub*)
# 	Rscript $base/expected_quality_versus_actual_quality_RMSE_humans.r $input_RMSE_file $results/human_female_items_10_11_18.tsv $results/2016_human_female_error_metrics.tsv
# end

# foreach input_RMSE_file ($input_for_rmse_split_directory/2017/input_for_RMSE_sub*)
# 	Rscript $base/expected_quality_versus_actual_quality_RMSE_humans.r $input_RMSE_file $results/human_female_items_10_11_18.tsv $results/2017_human_female_error_metrics.tsv
# end