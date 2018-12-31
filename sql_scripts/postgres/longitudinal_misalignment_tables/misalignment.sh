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

# tail -n +2 $results/extracted_revisions_escaped.tsv > $results/extracted_revisions_escaped_no_header.tsv

# Import basic revision data into Postgres
# psql wikidata_entities < $base/revisions_table/revisions_table_creation.sql
# psql wikidata_entities < $base/revisions_table/revisions_table_import.sql	

# Merge with various automation flags
# psql wikidata_entities < $base/revisions_initial_automation_flags_table/revisions_initial_automation_flags_table_creation.sql

# Perform additional checks for different types of edits
# psql wikidata_entities < $base/revisions_all_automation_flags_and_usages_table/revisions_all_automation_flags_and_usages_table_creation.sql

# Interesting subset tables

# First need to import male and female item data into a table 
# so that we can then join with the revision data. 

# tail -n +2 $results/human_male_items_12_29_18.tsv | sed s'/http:\/\/www\.wikidata\.org\/entity\///' > $results/human_male_items_12_29_18_url_removed.tsv
# tail -n +2 $results/human_female_items_12_29_18.tsv | sed s'/http:\/\/www\.wikidata\.org\/entity\///' > $results/human_female_items_12_29_18_url_removed.tsv
# tail -n +2 $results/coordinate_location_items_12_29_18.tsv | sed s'/http:\/\/www\.wikidata\.org\/entity\///' > $results/coordinate_location_items_12_29_18_url_removed.tsv


# Import male data into Postgres
# psql wikidata_entities < $base/interesting_subset_tables/human_male_items_12_29_18_table_creation.sql
# psql wikidata_entities < $base/interesting_subset_tables/human_male_items_12_29_18_table_import.sql

# Import female data into Postgres
# psql wikidata_entities < $base/interesting_subset_tables/human_female_items_12_29_18_table_creation.sql
# psql wikidata_entities < $base/interesting_subset_tables/human_female_items_12_29_18_table_import.sql

# Import coordinate location data into Postgres
# psql wikidata_entities < $base/interesting_subset_tables/coordinate_location_items_12_29_18_table_creation.sql
# psql wikidata_entities < $base/interesting_subset_tables/coordinate_location_items_12_29_18_table_import.sql

# Join location data and male and female item data with revision data
# Filters out item locations that have more than one location
psql wikidata_entities < $base/interesting_subset_revisions_tables/items_with_male_or_female_gender_revisions_table_creation.sql
psql wikidata_entities < $base/interesting_subset_revisions_tables/items_with_one_coordinate_location_revisions_table_creation.sql

# psql wikidata_entities < $base/used_item_page_views.sql


# psql wikidata_entities < $base/monthly_item_quality_sorted_by_month.sql


# python $base/misalignment_preprocessor.py \
# 		$results/used_item_page_views.tsv \
# 		$results/monthly_item_quality_sorted_by_month.tsv \
# 		$input_for_rmse_split_directory/input_for_RMSE.tsv \
# 		--verbose > & \
# 		$results/misalignment_preprocessor_error_log.txt


# input_for_rmse_split_directory

# tail -n +2 $input_for_rmse_split_directory/input_for_RMSE.tsv > $input_for_rmse_split_directory/input_for_RMSE_no_header.tsv


# length of May 2017 Wikidata entity "universe"
# split -d  -l 22149770 $input_for_rmse_split_directory/input_for_RMSE_no_header.tsv $input_for_rmse_split_directory/input_for_RMSE_sub_

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


psql wikidata_entities < $base/yearly_revision_samples.sql


# shuf -n 400000 $results/used_bot_edits_may_2013_to_2014.tsv > $results/used_bot_edits_may_2013_to_2014_sampled.tsv
# shuf -n 400000 $results/used_bot_edits_may_2014_to_2015.tsv > $results/used_bot_edits_may_2014_to_2015_sampled.tsv
# shuf -n 400000 $results/used_bot_edits_may_2015_to_2016.tsv > $results/used_bot_edits_may_2015_to_2016_sampled.tsv
# shuf -n 400000 $results/used_bot_edits_may_2016_to_2017.tsv > $results/used_bot_edits_may_2016_to_2017_sampled.tsv

# shuf -n 400000 $results/used_human_edits_may_2013_to_2014.tsv > $results/used_human_edits_may_2013_to_2014_sampled.tsv
# shuf -n 400000 $results/used_human_edits_may_2014_to_2015.tsv > $results/used_human_edits_may_2014_to_2015_sampled.tsv
# shuf -n 400000 $results/used_human_edits_may_2015_to_2016.tsv > $results/used_human_edits_may_2015_to_2016_sampled.tsv
# shuf -n 400000 $results/used_human_edits_may_2016_to_2017.tsv > $results/used_human_edits_may_2016_to_2017_sampled.tsv

# shuf -n 400000 $results/used_anon_edits_may_2013_to_2014.tsv > $results/used_anon_edits_may_2013_to_2014_sampled.tsv
# shuf -n 400000 $results/used_anon_edits_may_2014_to_2015.tsv > $results/used_anon_edits_may_2014_to_2015_sampled.tsv
# shuf -n 400000 $results/used_anon_edits_may_2015_to_2016.tsv > $results/used_anon_edits_may_2015_to_2016_sampled.tsv
# shuf -n 400000 $results/used_anon_edits_may_2016_to_2017.tsv > $results/used_anon_edits_may_2016_to_2017_sampled.tsv

# shuf -n 400000 $results/used_tool_edits_may_2013_to_2014.tsv > $results/used_tool_edits_may_2013_to_2014_sampled.tsv
# shuf -n 400000 $results/used_tool_edits_may_2014_to_2015.tsv > $results/used_tool_edits_may_2014_to_2015_sampled.tsv
# shuf -n 400000 $results/used_tool_edits_may_2015_to_2016.tsv > $results/used_tool_edits_may_2015_to_2016_sampled.tsv
# shuf -n 400000 $results/used_tool_edits_may_2016_to_2017.tsv > $results/used_tool_edits_may_2016_to_2017_sampled.tsv

# Order is important for interpretation.
# wc -l $results/used_bot_edits_may_2013_to_2014.tsv > $results/edit_type_counts.tsv
# wc -l $results/used_human_edits_may_2013_to_2014.tsv >> $results/edit_type_counts.tsv
# wc -l $results/used_anon_edits_may_2013_to_2014.tsv >> $results/edit_type_counts.tsv
# wc -l $results/used_tool_edits_may_2013_to_2014.tsv >> $results/edit_type_counts.tsv

# wc -l $results/used_bot_edits_may_2014_to_2015.tsv >> $results/edit_type_counts.tsv
# wc -l $results/used_human_edits_may_2014_to_2015.tsv >> $results/edit_type_counts.tsv
# wc -l $results/used_anon_edits_may_2014_to_2015.tsv >> $results/edit_type_counts.tsv
# wc -l $results/used_tool_edits_may_2014_to_2015.tsv >> $results/edit_type_counts.tsv


# wc -l $results/used_bot_edits_may_2015_to_2016.tsv >> $results/edit_type_counts.tsv
# wc -l $results/used_human_edits_may_2015_to_2016.tsv >> $results/edit_type_counts.tsv
# wc -l $results/used_anon_edits_may_2015_to_2016.tsv >> $results/edit_type_counts.tsv
# wc -l $results/used_tool_edits_may_2015_to_2016.tsv >> $results/edit_type_counts.tsv

# wc -l $results/used_bot_edits_may_2016_to_2017.tsv  >> $results/edit_type_counts.tsv
# wc -l $results/used_human_edits_may_2016_to_2017.tsv >> $results/edit_type_counts.tsv
# wc -l $results/used_anon_edits_may_2016_to_2017.tsv >> $results/edit_type_counts.tsv
# wc -l $results/used_tool_edits_may_2016_to_2017.tsv >> $results/edit_type_counts.tsv


# Period 1: 2013 to 2014
# Setting sample size down here since we don't use all of original sample.

# set revision_sample_size = 400000
# echo $revision_sample_size > $results/sample_size_file.tsv

# head -n $revision_sample_size $results/used_bot_edits_may_2013_to_2014_sampled.tsv > $results/all_used_edits_sampled.tsv
# head -n $revision_sample_size $results/used_human_edits_may_2013_to_2014_sampled.tsv >> $results/all_used_edits_sampled.tsv
# head -n $revision_sample_size $results/used_anon_edits_may_2013_to_2014_sampled.tsv >> $results/all_used_edits_sampled.tsv
# head -n $revision_sample_size $results/used_tool_edits_may_2013_to_2014_sampled.tsv >> $results/all_used_edits_sampled.tsv

# Period 2: 2014 to 2015
# head -n $revision_sample_size $results/used_bot_edits_may_2014_to_2015_sampled.tsv >> $results/all_used_edits_sampled.tsv
# head -n $revision_sample_size $results/used_human_edits_may_2014_to_2015_sampled.tsv >> $results/all_used_edits_sampled.tsv
# head -n $revision_sample_size $results/used_anon_edits_may_2014_to_2015_sampled.tsv >> $results/all_used_edits_sampled.tsv
# head -n $revision_sample_size $results/used_tool_edits_may_2014_to_2015_sampled.tsv >> $results/all_used_edits_sampled.tsv

# Period 3: 2015 to 2016
# head -n $revision_sample_size $results/used_bot_edits_may_2015_to_2016_sampled.tsv >> $results/all_used_edits_sampled.tsv
# head -n $revision_sample_size $results/used_human_edits_may_2015_to_2016_sampled.tsv >> $results/all_used_edits_sampled.tsv
# head -n $revision_sample_size $results/used_anon_edits_may_2015_to_2016_sampled.tsv >> $results/all_used_edits_sampled.tsv
# head -n $revision_sample_size $results/used_tool_edits_may_2015_to_2016_sampled.tsv >> $results/all_used_edits_sampled.tsv

# Period 4: 2016 to 2017
# head -n $revision_sample_size $results/used_bot_edits_may_2016_to_2017_sampled.tsv >> $results/all_used_edits_sampled.tsv
# head -n $revision_sample_size $results/used_human_edits_may_2016_to_2017_sampled.tsv >> $results/all_used_edits_sampled.tsv
# head -n $revision_sample_size $results/used_anon_edits_may_2016_to_2017_sampled.tsv >> $results/all_used_edits_sampled.tsv
# head -n $revision_sample_size $results/used_tool_edits_may_2016_to_2017_sampled.tsv >> $results/all_used_edits_sampled.tsv


# Extract out parent rev ids. Convert to json so we can get ORES predictions for these edits
# python $base/extract_parent_rev_ids_and_convert_to_json.py \
# 	$results/all_used_edits_sampled.tsv \
# 	$results/all_used_edits_sampled.json \
# 	$results/all_used_edits_parent_rev_ids_sampled.json \
# 	--verbose > & \
# 	$results/all_used_edits_sampled_converted_error_log.txt


# Run ORES

# Temporary to speed things up

# split -d -l 3200000 $results/all_used_edits_sampled.json $results/all_used_edits_sampled_sub
# split -d -l 3200000 $results/all_used_edits_parent_rev_ids_sampled.json $results/all_used_edits_parent_rev_ids_sampled_sub

# $results/all_used_edits_sampled_sub00
# $results/all_used_edits_sampled_sub01

# cat $results/all_used_edits_sampled_sub00_predictions.json > $results/all_used_edits_sampled_predictions.json
# cat $results/all_used_edits_sampled_sub01_predictions.json >> $results/all_used_edits_sampled_predictions.json


# cat $results/all_used_edits_parent_rev_ids_sampled_sub00_predictions.json > $results/all_used_edits_parent_rev_ids_sampled_predictions.json
# cat $results/all_used_edits_parent_rev_ids_sampled_sub01_predictions.json >> $results/all_used_edits_parent_rev_ids_sampled_predictions.json

# $results/all_used_edits_parent_rev_ids_sampled_sub00
# $results/all_used_edits_parent_rev_ids_sampled_sub01

# cat $results/all_used_edits_sampled_sub00 | \
# 	ores score_revisions https://ores.wikimedia.org wikidata_alignment_research wikidatawiki itemquality --batch-size=30 --verbose \
# 	> $results/all_used_edits_sampled_sub00_predictions.json

# cat $results/all_used_edits_sampled_sub01 | \
# 	ores score_revisions https://ores.wikimedia.org wikidata_alignment_research wikidatawiki itemquality --batch-size=30 --verbose \
# 	> $results/all_used_edits_sampled_sub01_predictions.json

# cat $results/all_used_edits_parent_rev_ids_sampled_sub00 | \
# 	ores score_revisions https://ores.wikimedia.org wikidata_alignment_research wikidatawiki itemquality --batch-size=30 --verbose \
# 	> $results/all_used_edits_parent_rev_ids_sampled_sub00_predictions.json

# cat $results/all_used_edits_parent_rev_ids_sampled_sub01 | \
# 	ores score_revisions https://ores.wikimedia.org wikidata_alignment_research wikidatawiki itemquality --batch-size=30 --verbose \
# 	> $results/all_used_edits_parent_rev_ids_sampled_sub01_predictions.json



# End temporary

# cat $results/all_used_edits_sampled.json | \
# 	ores score_revisions https://ores.wikimedia.org wikidata_alignment_research wikidatawiki itemquality --batch-size=30 --verbose \
# 	> $results/all_used_edits_sampled_predictions.json

# cat $results/all_used_edits_sampled.json | \
# 	ores score_revisions https://ores.wikimedia.org wikidata_alignment_research wikidatawiki itemquality --batch-size=30 --verbose \
# 	> $results/all_used_edits_sampled_predictions.json






# cat $results/all_used_edits_parent_rev_ids_sampled.json | \
# 	ores score_revisions https://ores.wikimedia.org wikidata_alignment_research wikidatawiki itemquality --batch-size=30 --verbose \
# 	> $results/all_used_edits_parent_rev_ids_sampled_predictions.json


# python $base/extract_and_merge_data.py \
# 	$results/all_used_edits_sampled_predictions.json \
# 	$results/all_used_edits_parent_rev_ids_sampled_predictions.json \
# 	$results/sampled_rev_ids_for_ores_all_predictions_period_1.tsv \
# 	$results/sampled_rev_ids_for_ores_all_predictions_period_2.tsv \
# 	$results/sampled_rev_ids_for_ores_all_predictions_period_3.tsv \
# 	$results/sampled_rev_ids_for_ores_all_predictions_period_4.tsv \
# 	--verbose > & \
# 	$results/sampled_rev_ids_for_ores_all_predictions_error_log.txt




# python $base/split_into_months.py \
# 	$results/sampled_rev_ids_for_ores_all_predictions_period_1.tsv \
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


# python $base/split_into_months.py \
# 	$results/sampled_rev_ids_for_ores_all_predictions_period_2.tsv \
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


# python $base/split_into_months.py \
# 	$results/sampled_rev_ids_for_ores_all_predictions_period_3.tsv \
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


# python $base/split_into_months.py \
# 	$results/sampled_rev_ids_for_ores_all_predictions_period_4.tsv \
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



