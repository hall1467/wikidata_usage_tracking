all_revisions = data.frame()
options(scipen=999)

# Shifted distributions in Feb 2019
for (monthly_distribution_and_edits in list(
                    
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/input_for_RMSE_sub_31', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_june_2015.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/input_for_RMSE_sub_32', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_july_2015.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/input_for_RMSE_sub_33', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_august_2015.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/input_for_RMSE_sub_34', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_september_2015.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/input_for_RMSE_sub_35', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_october_2015.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/input_for_RMSE_sub_36', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_november_2015.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/input_for_RMSE_sub_37', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_december_2015.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/input_for_RMSE_sub_38', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_january_2016.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/input_for_RMSE_sub_39', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_february_2016.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/input_for_RMSE_sub_40', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_march_2016.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/input_for_RMSE_sub_41', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_april_2016.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/input_for_RMSE_sub_42', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_may_2016.tsv')
)){
  

    distribution_file = monthly_distribution_and_edits$distribution
    revisions_file = monthly_distribution_and_edits$revision

    revisions <- read.table(revisions_file, header=TRUE, sep="\t")
    quality_and_page_views <- read.table(distribution_file, header=FALSE, sep="\t")
    colnames(quality_and_page_views) <- c('page_title','yyyy','mm', 'weighted_sum', 'page_views')
    quality_and_page_views = quality_and_page_views[quality_and_page_views$weighted_sum >= 1,];

    print(head(quality_and_page_views))
    print(nrow(quality_and_page_views))
    print(head(revisions))
    print(nrow(revisions))


    quality_and_page_views$expected_quality_quantile = ecdf(quality_and_page_views$page_views)(quality_and_page_views$page_views)
    weighted_sum_distribution = ecdf(quality_and_page_views$weighted_sum)
    quality_and_page_views$expected_quality = quantile(weighted_sum_distribution, probs=quality_and_page_views$expected_quality_quantile)
    quality_and_page_views$quality_quantile = ecdf(quality_and_page_views$weighted_sum)(quality_and_page_views$weighted_sum)

    
    revisions = merge(revisions, quality_and_page_views, by = "page_title")
    revisions = revisions[c("page_title", "namespace", "period", "gender", "coordinate_location", "us_location", "edit_type", "rev_id", "expected_quality","expected_quality_quantile","quality_quantile","page_views.y","yyyy","mm","does_parent_exist","parent_weighted_sum","parent_id")]
    colnames(revisions) <- c("page_title", "namespace", "period", "gender", "coordinate_location", "us_location", "edit_type", "rev_id", "expected_quality","expected_quality_quantile","quality_quantile","page_views","yyyy","mm","does_parent_exist","parent_weighted_sum","parent_id")

    all_revisions = rbind(all_revisions, revisions)
    
    quality_and_page_views = NULL

}

write.table(all_revisions, '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/all_revisions_quality_differences_2015_2016.tsv', row.names=FALSE, col.names=FALSE, quote=FALSE, sep='\t');

