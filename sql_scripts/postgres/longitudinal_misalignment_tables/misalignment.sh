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

# Filter out revisions without parent and keep only edits that aren't from a client, merging, or to sitelinks
# psql wikidata_entities < $base/revisions_final_table/revisions_final_table_creation.sql

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

# Combine male and female item datasets
# psql wikidata_entities < $base/interesting_subset_tables/items_with_male_or_female_gender_12_29_18_table_creation.sql


# Import coordinate location data into Postgres
# psql wikidata_entities < $base/interesting_subset_tables/coordinate_location_items_12_29_18_table_creation.sql
# psql wikidata_entities < $base/interesting_subset_tables/coordinate_location_items_12_29_18_table_import.sql

# Items with only one location point
# psql wikidata_entities < $base/interesting_subset_tables/items_with_one_coordinate_location_12_29_18_table_creation.sql

# Create tsvs from filtered tables
# psql wikidata_entities < $base/interesting_subset_tables/items_with_male_or_female_gender_12_29_18.sql
# psql wikidata_entities < $base/interesting_subset_tables/items_with_one_coordinate_location_12_29_18.sql



# Obtain country code for all periods
# python $base/obtain_country_code.py \
# 	$results/items_with_one_coordinate_location_12_29_18.tsv \
# 	$results/items_with_one_coordinate_location_12_29_18_with_country_code.tsv \
# 	--verbose > & \
# 	$results/obtain_country_code_error_log.txt


# Obtain county information
# python $base/obtain_county_from_latlon.py \
# 	$results/items_with_one_coordinate_location_12_29_18_with_country_code.tsv \
# 	$results/US_States_from_counties.geojson \
# 	$results/USCounties_bare.geojson \
# 	$results/items_with_one_coordinate_location_12_29_18_with_country_and_county_codes.tsv \
# 	--verbose > & \
# 	$results/obtain_county_from_latlon_error_log.txt

# tail -n +2 $results/items_with_one_coordinate_location_12_29_18_with_country_and_county_codes.tsv > $results/items_with_one_coordinate_location_12_29_18_with_country_and_county_codes_without_header.tsv


# Import US items data into Postgres
# psql wikidata_entities < $base/interesting_subset_tables/items_with_one_coordinate_location_processed_12_29_18_table_creation.sql
# psql wikidata_entities < $base/interesting_subset_tables/items_with_one_coordinate_location_processed_12_29_18_table_import.sql


# Join location data and male and female item data with revision data
# Filters out item locations that have more than one location
# psql wikidata_entities < $base/interesting_subset_revisions_tables/items_with_male_or_female_gender_revisions_table_creation.sql
# psql wikidata_entities < $base/interesting_subset_revisions_tables/items_with_one_coordinate_location_revisions_table_creation.sql
# psql wikidata_entities < $base/interesting_subset_revisions_tables/us_items_12_29_18_revisions_table_creation.sql


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

foreach input_RMSE_file ($input_for_rmse_split_directory/2012/input_for_RMSE_sub*)
	Rscript $base/expected_quality_versus_actual_quality_RMSE.r $input_RMSE_file $results/2012_error_metrics.tsv
end

foreach input_RMSE_file ($input_for_rmse_split_directory/2013/input_for_RMSE_sub*)
	Rscript $base/expected_quality_versus_actual_quality_RMSE.r $input_RMSE_file $results/2013_error_metrics.tsv
end

foreach input_RMSE_file ($input_for_rmse_split_directory/2014/input_for_RMSE_sub*)
	Rscript $base/expected_quality_versus_actual_quality_RMSE.r $input_RMSE_file $results/2014_error_metrics.tsv
end

foreach input_RMSE_file ($input_for_rmse_split_directory/2015/input_for_RMSE_sub*)
	Rscript $base/expected_quality_versus_actual_quality_RMSE.r $input_RMSE_file $results/2015_error_metrics.tsv
end

foreach input_RMSE_file ($input_for_rmse_split_directory/2016/input_for_RMSE_sub*)
	Rscript $base/expected_quality_versus_actual_quality_RMSE.r $input_RMSE_file $results/2016_error_metrics.tsv
end

foreach input_RMSE_file ($input_for_rmse_split_directory/2017/input_for_RMSE_sub*)
	Rscript $base/expected_quality_versus_actual_quality_RMSE.r $input_RMSE_file $results/2017_error_metrics.tsv
end


# psql wikidata_entities < $base/yearly_revision_samples.sql

# # Order is important for interpretation.
# # Counts for all revisions

python $base/get_edit_count.py $results/used_bot_edits_may_2013_to_2014.tsv > $results/edit_type_counts.tsv
python $base/get_edit_count.py $results/used_human_edits_may_2013_to_2014.tsv >> $results/edit_type_counts.tsv
python $base/get_edit_count.py $results/used_anon_edits_may_2013_to_2014.tsv >> $results/edit_type_counts.tsv
python $base/get_edit_count.py $results/used_tool_edits_may_2013_to_2014.tsv >> $results/edit_type_counts.tsv

python $base/get_edit_count.py $results/used_bot_edits_may_2014_to_2015.tsv >> $results/edit_type_counts.tsv
python $base/get_edit_count.py $results/used_human_edits_may_2014_to_2015.tsv >> $results/edit_type_counts.tsv
python $base/get_edit_count.py $results/used_anon_edits_may_2014_to_2015.tsv >> $results/edit_type_counts.tsv
python $base/get_edit_count.py $results/used_tool_edits_may_2014_to_2015.tsv >> $results/edit_type_counts.tsv

python $base/get_edit_count.py $results/used_bot_edits_may_2015_to_2016.tsv >> $results/edit_type_counts.tsv
python $base/get_edit_count.py $results/used_human_edits_may_2015_to_2016.tsv >> $results/edit_type_counts.tsv
python $base/get_edit_count.py $results/used_anon_edits_may_2015_to_2016.tsv >> $results/edit_type_counts.tsv
python $base/get_edit_count.py $results/used_tool_edits_may_2015_to_2016.tsv >> $results/edit_type_counts.tsv

python $base/get_edit_count.py $results/used_bot_edits_may_2016_to_2017.tsv  >> $results/edit_type_counts.tsv
python $base/get_edit_count.py $results/used_human_edits_may_2016_to_2017.tsv >> $results/edit_type_counts.tsv
python $base/get_edit_count.py $results/used_anon_edits_may_2016_to_2017.tsv >> $results/edit_type_counts.tsv
python $base/get_edit_count.py $results/used_tool_edits_may_2016_to_2017.tsv >> $results/edit_type_counts.tsv


# # Counts for gender revisions
python $base/get_edit_count.py $results/used_items_with_gender_bot_edits_may_2013_to_2014.tsv > $results/edit_type_counts_items_with_gender.tsv
python $base/get_edit_count.py $results/used_items_with_gender_human_edits_may_2013_to_2014.tsv >> $results/edit_type_counts_items_with_gender.tsv
python $base/get_edit_count.py $results/used_items_with_gender_anon_edits_may_2013_to_2014.tsv >> $results/edit_type_counts_items_with_gender.tsv
python $base/get_edit_count.py $results/used_items_with_gender_tool_edits_may_2013_to_2014.tsv >> $results/edit_type_counts_items_with_gender.tsv

python $base/get_edit_count.py $results/used_items_with_gender_bot_edits_may_2014_to_2015.tsv >> $results/edit_type_counts_items_with_gender.tsv
python $base/get_edit_count.py $results/used_items_with_gender_human_edits_may_2014_to_2015.tsv >> $results/edit_type_counts_items_with_gender.tsv
python $base/get_edit_count.py $results/used_items_with_gender_anon_edits_may_2014_to_2015.tsv >> $results/edit_type_counts_items_with_gender.tsv
python $base/get_edit_count.py $results/used_items_with_gender_tool_edits_may_2014_to_2015.tsv >> $results/edit_type_counts_items_with_gender.tsv

python $base/get_edit_count.py $results/used_items_with_gender_bot_edits_may_2015_to_2016.tsv >> $results/edit_type_counts_items_with_gender.tsv
python $base/get_edit_count.py $results/used_items_with_gender_human_edits_may_2015_to_2016.tsv >> $results/edit_type_counts_items_with_gender.tsv
python $base/get_edit_count.py $results/used_items_with_gender_anon_edits_may_2015_to_2016.tsv >> $results/edit_type_counts_items_with_gender.tsv
python $base/get_edit_count.py $results/used_items_with_gender_tool_edits_may_2015_to_2016.tsv >> $results/edit_type_counts_items_with_gender.tsv

python $base/get_edit_count.py $results/used_items_with_gender_bot_edits_may_2016_to_2017.tsv  >> $results/edit_type_counts_items_with_gender.tsv
python $base/get_edit_count.py $results/used_items_with_gender_human_edits_may_2016_to_2017.tsv >> $results/edit_type_counts_items_with_gender.tsv
python $base/get_edit_count.py $results/used_items_with_gender_anon_edits_may_2016_to_2017.tsv >> $results/edit_type_counts_items_with_gender.tsv
python $base/get_edit_count.py $results/used_items_with_gender_tool_edits_may_2016_to_2017.tsv >> $results/edit_type_counts_items_with_gender.tsv


# # Counts for coordinate location revisions
python $base/get_edit_count.py $results/used_items_with_coordinate_location_bot_edits_may_2013_to_2014.tsv > $results/edit_type_counts_items_with_coordinate_location.tsv
python $base/get_edit_count.py $results/used_items_with_coordinate_location_human_edits_may_2013_to_2014.tsv >> $results/edit_type_counts_items_with_coordinate_location.tsv
python $base/get_edit_count.py $results/used_items_with_coordinate_location_anon_edits_may_2013_to_2014.tsv >> $results/edit_type_counts_items_with_coordinate_location.tsv
python $base/get_edit_count.py $results/used_items_with_coordinate_location_tool_edits_may_2013_to_2014.tsv >> $results/edit_type_counts_items_with_coordinate_location.tsv

python $base/get_edit_count.py $results/used_items_with_coordinate_location_bot_edits_may_2014_to_2015.tsv >> $results/edit_type_counts_items_with_coordinate_location.tsv
python $base/get_edit_count.py $results/used_items_with_coordinate_location_human_edits_may_2014_to_2015.tsv >> $results/edit_type_counts_items_with_coordinate_location.tsv
python $base/get_edit_count.py $results/used_items_with_coordinate_location_anon_edits_may_2014_to_2015.tsv >> $results/edit_type_counts_items_with_coordinate_location.tsv
python $base/get_edit_count.py $results/used_items_with_coordinate_location_tool_edits_may_2014_to_2015.tsv >> $results/edit_type_counts_items_with_coordinate_location.tsv

python $base/get_edit_count.py $results/used_items_with_coordinate_location_bot_edits_may_2015_to_2016.tsv >> $results/edit_type_counts_items_with_coordinate_location.tsv
python $base/get_edit_count.py $results/used_items_with_coordinate_location_human_edits_may_2015_to_2016.tsv >> $results/edit_type_counts_items_with_coordinate_location.tsv
python $base/get_edit_count.py $results/used_items_with_coordinate_location_anon_edits_may_2015_to_2016.tsv >> $results/edit_type_counts_items_with_coordinate_location.tsv
python $base/get_edit_count.py $results/used_items_with_coordinate_location_tool_edits_may_2015_to_2016.tsv >> $results/edit_type_counts_items_with_coordinate_location.tsv

python $base/get_edit_count.py $results/used_items_with_coordinate_location_bot_edits_may_2016_to_2017.tsv  >> $results/edit_type_counts_items_with_coordinate_location.tsv
python $base/get_edit_count.py $results/used_items_with_coordinate_location_human_edits_may_2016_to_2017.tsv >> $results/edit_type_counts_items_with_coordinate_location.tsv
python $base/get_edit_count.py $results/used_items_with_coordinate_location_anon_edits_may_2016_to_2017.tsv >> $results/edit_type_counts_items_with_coordinate_location.tsv
python $base/get_edit_count.py $results/used_items_with_coordinate_location_tool_edits_may_2016_to_2017.tsv >> $results/edit_type_counts_items_with_coordinate_location.tsv


# # Counts for US location revisions
python $base/get_edit_count.py $results/used_items_with_us_location_bot_edits_may_2013_to_2014.tsv > $results/edit_type_counts_items_with_us_location.tsv
python $base/get_edit_count.py $results/used_items_with_us_location_human_edits_may_2013_to_2014.tsv >> $results/edit_type_counts_items_with_us_location.tsv
python $base/get_edit_count.py $results/used_items_with_us_location_anon_edits_may_2013_to_2014.tsv >> $results/edit_type_counts_items_with_us_location.tsv
python $base/get_edit_count.py $results/used_items_with_us_location_tool_edits_may_2013_to_2014.tsv >> $results/edit_type_counts_items_with_us_location.tsv

python $base/get_edit_count.py $results/used_items_with_us_location_bot_edits_may_2014_to_2015.tsv >> $results/edit_type_counts_items_with_us_location.tsv
python $base/get_edit_count.py $results/used_items_with_us_location_human_edits_may_2014_to_2015.tsv >> $results/edit_type_counts_items_with_us_location.tsv
python $base/get_edit_count.py $results/used_items_with_us_location_anon_edits_may_2014_to_2015.tsv >> $results/edit_type_counts_items_with_us_location.tsv
python $base/get_edit_count.py $results/used_items_with_us_location_tool_edits_may_2014_to_2015.tsv >> $results/edit_type_counts_items_with_us_location.tsv

python $base/get_edit_count.py $results/used_items_with_us_location_bot_edits_may_2015_to_2016.tsv >> $results/edit_type_counts_items_with_us_location.tsv
python $base/get_edit_count.py $results/used_items_with_us_location_human_edits_may_2015_to_2016.tsv >> $results/edit_type_counts_items_with_us_location.tsv
python $base/get_edit_count.py $results/used_items_with_us_location_anon_edits_may_2015_to_2016.tsv >> $results/edit_type_counts_items_with_us_location.tsv
python $base/get_edit_count.py $results/used_items_with_us_location_tool_edits_may_2015_to_2016.tsv >> $results/edit_type_counts_items_with_us_location.tsv

python $base/get_edit_count.py $results/used_items_with_us_location_bot_edits_may_2016_to_2017.tsv  >> $results/edit_type_counts_items_with_us_location.tsv
python $base/get_edit_count.py $results/used_items_with_us_location_human_edits_may_2016_to_2017.tsv >> $results/edit_type_counts_items_with_us_location.tsv
python $base/get_edit_count.py $results/used_items_with_us_location_anon_edits_may_2016_to_2017.tsv >> $results/edit_type_counts_items_with_us_location.tsv
python $base/get_edit_count.py $results/used_items_with_us_location_tool_edits_may_2016_to_2017.tsv >> $results/edit_type_counts_items_with_us_location.tsv

# # All revisions

# # Sample size to strive for
# set revision_sample_size = 100000


# # Period 1: 2013 to 2014
# shuf -n $revision_sample_size $results/used_bot_edits_may_2013_to_2014.tsv > $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_human_edits_may_2013_to_2014.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_anon_edits_may_2013_to_2014.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_tool_edits_may_2013_to_2014.tsv >> $results/all_used_edits_sampled.tsv

# # Period 2: 2014 to 2015
# shuf -n $revision_sample_size $results/used_bot_edits_may_2014_to_2015.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_human_edits_may_2014_to_2015.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_anon_edits_may_2014_to_2015.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_tool_edits_may_2014_to_2015.tsv >> $results/all_used_edits_sampled.tsv

# # Period 3: 2015 to 2016
# shuf -n $revision_sample_size $results/used_bot_edits_may_2015_to_2016.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_human_edits_may_2015_to_2016.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_anon_edits_may_2015_to_2016.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_tool_edits_may_2015_to_2016.tsv >> $results/all_used_edits_sampled.tsv

# # Period 4: 2016 to 2017
# shuf -n $revision_sample_size $results/used_bot_edits_may_2016_to_2017.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_human_edits_may_2016_to_2017.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_anon_edits_may_2016_to_2017.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_tool_edits_may_2016_to_2017.tsv >> $results/all_used_edits_sampled.tsv


# # Gender Revisions


# # Period 1: 2013 to 2014
# shuf -n $revision_sample_size $results/used_items_with_gender_bot_edits_may_2013_to_2014.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_gender_human_edits_may_2013_to_2014.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_gender_anon_edits_may_2013_to_2014.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_gender_tool_edits_may_2013_to_2014.tsv >> $results/all_used_edits_sampled.tsv

# # Period 2: 2014 to 2015
# shuf -n $revision_sample_size $results/used_items_with_gender_bot_edits_may_2014_to_2015.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_gender_human_edits_may_2014_to_2015.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_gender_anon_edits_may_2014_to_2015.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_gender_tool_edits_may_2014_to_2015.tsv >> $results/all_used_edits_sampled.tsv

# # Period 3: 2015 to 2016
# shuf -n $revision_sample_size $results/used_items_with_gender_bot_edits_may_2015_to_2016.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_gender_human_edits_may_2015_to_2016.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_gender_anon_edits_may_2015_to_2016.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_gender_tool_edits_may_2015_to_2016.tsv >> $results/all_used_edits_sampled.tsv

# # Period 4: 2016 to 2017
# shuf -n $revision_sample_size $results/used_items_with_gender_bot_edits_may_2016_to_2017.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_gender_human_edits_may_2016_to_2017.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_gender_anon_edits_may_2016_to_2017.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_gender_tool_edits_may_2016_to_2017.tsv >> $results/all_used_edits_sampled.tsv


# # Coordinate Location Revisions


# # Period 1: 2013 to 2014
# shuf -n $revision_sample_size $results/used_items_with_coordinate_location_bot_edits_may_2013_to_2014.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_coordinate_location_human_edits_may_2013_to_2014.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_coordinate_location_anon_edits_may_2013_to_2014.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_coordinate_location_tool_edits_may_2013_to_2014.tsv >> $results/all_used_edits_sampled.tsv

# # Period 2: 2014 to 2015
# shuf -n $revision_sample_size $results/used_items_with_coordinate_location_bot_edits_may_2014_to_2015.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_coordinate_location_human_edits_may_2014_to_2015.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_coordinate_location_anon_edits_may_2014_to_2015.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_coordinate_location_tool_edits_may_2014_to_2015.tsv >> $results/all_used_edits_sampled.tsv

# # Period 3: 2015 to 2016
# shuf -n $revision_sample_size $results/used_items_with_coordinate_location_bot_edits_may_2015_to_2016.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_coordinate_location_human_edits_may_2015_to_2016.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_coordinate_location_anon_edits_may_2015_to_2016.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_coordinate_location_tool_edits_may_2015_to_2016.tsv >> $results/all_used_edits_sampled.tsv

# # Period 4: 2016 to 2017
# shuf -n $revision_sample_size $results/used_items_with_coordinate_location_bot_edits_may_2016_to_2017.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_coordinate_location_human_edits_may_2016_to_2017.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_coordinate_location_anon_edits_may_2016_to_2017.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_coordinate_location_tool_edits_may_2016_to_2017.tsv >> $results/all_used_edits_sampled.tsv


# Coordinate Location Revisions


# Period 1: 2013 to 2014
# shuf -n $revision_sample_size $results/used_items_with_us_location_bot_edits_may_2013_to_2014.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_us_location_human_edits_may_2013_to_2014.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_us_location_anon_edits_may_2013_to_2014.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_us_location_tool_edits_may_2013_to_2014.tsv >> $results/all_used_edits_sampled.tsv

# Period 2: 2014 to 2015
# shuf -n $revision_sample_size $results/used_items_with_us_location_bot_edits_may_2014_to_2015.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_us_location_human_edits_may_2014_to_2015.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_us_location_anon_edits_may_2014_to_2015.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_us_location_tool_edits_may_2014_to_2015.tsv >> $results/all_used_edits_sampled.tsv

# Period 3: 2015 to 2016
# shuf -n $revision_sample_size $results/used_items_with_us_location_bot_edits_may_2015_to_2016.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_us_location_human_edits_may_2015_to_2016.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_us_location_anon_edits_may_2015_to_2016.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_us_location_tool_edits_may_2015_to_2016.tsv >> $results/all_used_edits_sampled.tsv

# Period 4: 2016 to 2017
# shuf -n $revision_sample_size $results/used_items_with_us_location_bot_edits_may_2016_to_2017.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_us_location_human_edits_may_2016_to_2017.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_us_location_anon_edits_may_2016_to_2017.tsv >> $results/all_used_edits_sampled.tsv
# shuf -n $revision_sample_size $results/used_items_with_us_location_tool_edits_may_2016_to_2017.tsv >> $results/all_used_edits_sampled.tsv




# Extract out parent rev ids. Convert to json so we can get ORES predictions for these edits
# python $base/convert_to_json.py \
# 	$results/all_used_edits_sampled.tsv \
# 	$results/all_used_edits_sampled.json \
# 	--verbose > & \
# 	$results/convert_to_json_error_log.txt


# Run ORES

# Temporary to speed things up

# split -d -l 1500000 $results/all_used_edits_sampled.json $results/all_used_edits_sampled_sub

cat $results/all_used_edits_sampled_sub00_predictions.json > $results/all_used_edits_sampled_predictions.json
cat $results/all_used_edits_sampled_sub01_predictions.json >> $results/all_used_edits_sampled_predictions.json
cat $results/all_used_edits_sampled_sub02_predictions.json >> $results/all_used_edits_sampled_predictions.json
cat $results/all_used_edits_sampled_sub03_predictions.json >> $results/all_used_edits_sampled_predictions.json


# cat $results/all_used_edits_parent_rev_ids_sampled_sub00_predictions.json > $results/all_used_edits_parent_rev_ids_sampled_predictions.json
# cat $results/all_used_edits_parent_rev_ids_sampled_sub01_predictions.json >> $results/all_used_edits_parent_rev_ids_sampled_predictions.json

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
# 	> $results/all_used_edits_sampled_predictions.json_test

# cat $results/all_used_edits_sampled.json | \
# 	ores score_revisions https://ores.wikimedia.org wikidata_alignment_research wikidatawiki itemquality --batch-size=30 --verbose \
# 	> $results/all_used_edits_sampled_predictions.json






# cat $results/all_used_edits_parent_rev_ids_sampled.json | \
# 	ores score_revisions https://ores.wikimedia.org wikidata_alignment_research wikidatawiki itemquality --batch-size=30 --verbose \
# 	> $results/all_used_edits_parent_rev_ids_sampled_predictions.json


python $base/extract_ores_predictions.py \
	$results/all_used_edits_sampled_predictions.json \
	$results/sampled_rev_ids_for_ores_all_predictions_period_1.tsv \
	$results/sampled_rev_ids_for_ores_all_predictions_period_2.tsv \
	$results/sampled_rev_ids_for_ores_all_predictions_period_3.tsv \
	$results/sampled_rev_ids_for_ores_all_predictions_period_4.tsv \
	--verbose > & \
	$results/extract_ores_predictions_error_log.txt


python $base/split_into_months.py \
	$results/sampled_rev_ids_for_ores_all_predictions_period_1.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_june_2013.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_july_2013.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_august_2013.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_september_2013.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_october_2013.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_november_2013.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_december_2013.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_january_2014.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_february_2014.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_march_2014.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_april_2014.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_may_2014.tsv \
	--verbose > & \
	$results/split_into_months_period_1_error_log.txt


python $base/split_into_months.py \
	$results/sampled_rev_ids_for_ores_all_predictions_period_2.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_june_2014.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_july_2014.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_august_2014.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_september_2014.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_october_2014.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_november_2014.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_december_2014.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_january_2015.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_february_2015.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_march_2015.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_april_2015.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_may_2015.tsv \
	--verbose > & \
	$results/split_into_months_period_2_error_log.txt


python $base/split_into_months.py \
	$results/sampled_rev_ids_for_ores_all_predictions_period_3.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_june_2015.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_july_2015.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_august_2015.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_september_2015.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_october_2015.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_november_2015.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_december_2015.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_january_2016.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_february_2016.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_march_2016.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_april_2016.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_may_2016.tsv \
	--verbose > & \
	$results/split_into_months_period_3_error_log.txt


python $base/split_into_months.py \
	$results/sampled_rev_ids_for_ores_all_predictions_period_4.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_june_2016.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_july_2016.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_august_2016.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_september_2016.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_october_2016.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_november_2016.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_december_2016.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_january_2017.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_february_2017.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_march_2017.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_april_2017.tsv \
	$monthly_revisions_directory/monthly_sampled_revisions_may_2017.tsv \
	--verbose > & \
	$results/split_into_months_period_4_error_log.txt


# Rscript $base/2013_2014_revision_alignment.r
# Rscript $base/2014_2015_revision_alignment.r
# Rscript $base/2015_2016_revision_alignment.r
# Rscript $base/2016_2017_revision_alignment.r


cat $results/all_revisions_quality_differences_2013_2014.tsv > $results/all_revisions_quality_differences.tsv
cat $results/all_revisions_quality_differences_2014_2015.tsv >> $results/all_revisions_quality_differences.tsv
cat $results/all_revisions_quality_differences_2015_2016.tsv >> $results/all_revisions_quality_differences.tsv
cat $results/all_revisions_quality_differences_2016_2017.tsv >> $results/all_revisions_quality_differences.tsv


python $base/identify_type_of_work_being_done_in_revision.py \
	$results/all_used_edits_sampled.tsv \
	$results/all_revisions_quality_differences.tsv \
	$results/processed_revisions.tsv \
	--verbose > & \
	$results/identify_type_of_work_being_done_in_revision_error_log.txt



