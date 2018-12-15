all_revisions = data.frame()
options(scipen=999)


for (monthly_distribution_and_edits in list(
                    
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/2013/input_for_RMSE_sub_07', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_june_2013.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/2013/input_for_RMSE_sub_08', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_july_2013.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/2013/input_for_RMSE_sub_09', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_august_2013.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/2013/input_for_RMSE_sub_10', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_september_2013.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/2013/input_for_RMSE_sub_11', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_october_2013.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/2013/input_for_RMSE_sub_12', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_november_2013.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/2013/input_for_RMSE_sub_13', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_december_2013.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/2014/input_for_RMSE_sub_14', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_january_2014.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/2014/input_for_RMSE_sub_15', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_february_2014.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/2014/input_for_RMSE_sub_16', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_march_2014.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/2014/input_for_RMSE_sub_17', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_april_2014.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/2014/input_for_RMSE_sub_18', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_may_2014.tsv')
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


    
    revisions = merge(revisions, quality_and_page_views, by = "page_title")
    revisions = revisions[c("page_title", "namespace", "period", "edit_type", "rev_id", "weighted_sum.x","expected_quality","expected_quality_quantile","page_views.y","yyyy","mm","parent_weighted_sum","parent_id")]
    colnames(revisions) <- c("page_title", "namespace", "period", "edit_type", "rev_id", "weighted_sum","expected_quality","expected_quality_quantile","page_views","yyyy","mm","parent_weighted_sum","parent_id")
    revisions$quality_difference = revisions$weighted_sum - revisions$expected_quality

    all_revisions = rbind(all_revisions, revisions)
    
    quality_and_page_views = NULL

}

write.table(all_revisions, '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/all_revisions_quality_differences_2013_2014.tsv', row.names=FALSE, col.names=FALSE, quote=FALSE, sep='\t');

