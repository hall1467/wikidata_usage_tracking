all_revisions = data.frame()
options(scipen=999)


for (monthly_distribution_and_edits in list(
                    
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/2014/input_for_RMSE_sub_19', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_june_2014.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/2014/input_for_RMSE_sub_20', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_july_2014.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/2014/input_for_RMSE_sub_21', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_august_2014.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/2014/input_for_RMSE_sub_22', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_september_2014.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/2014/input_for_RMSE_sub_23', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_october_2014.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/2014/input_for_RMSE_sub_24', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_november_2014.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/2014/input_for_RMSE_sub_25', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_december_2014.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/2015/input_for_RMSE_sub_26', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_january_2015.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/2015/input_for_RMSE_sub_27', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_february_2015.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/2015/input_for_RMSE_sub_28', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_march_2015.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/2015/input_for_RMSE_sub_29', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_april_2015.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/input_for_rmse_split_directory/2015/input_for_RMSE_sub_30', revisions = '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/monthly_revisions_directory/monthly_sampled_revisions_may_2015.tsv')
)){
  

     distribution_file = monthly_distribution_and_edits$distribution
     revisions_file = monthly_distribution_and_edits$revision

     revisions <- read.table(revisions_file, header=TRUE, sep="\t")
     quality_and_page_views <- read.table(distribution_file, header=FALSE, sep="\t")
     colnames(quality_and_page_views) <- c('page_title','yyyy','mm', 'weighted_sum', 'page_views')

    print(head(quality_and_page_views))
    print(nrow(quality_and_page_views))
    print(head(revisions))
    print(nrow(revisions))


    quality_and_page_views$expected_quality_quantile = ecdf(quality_and_page_views$page_views)(quality_and_page_views$page_view)
    weighted_sum_distribution = ecdf(quality_and_page_views$weighted_sum)
    quality_and_page_views$expected_quality = quantile(weighted_sum_distribution, probs=quality_and_page_views$expected_quality_quantile)


    quality_and_page_views = quality_and_page_views[quality_and_page_views$weighted_sum >= 1,];
    revisions = merge(revisions, quality_and_page_views, by = "page_title")
    revisions = revisions[c("page_title", "namespace", "period", "edit_type", "rev_id", "weighted_sum.x","expected_quality","expected_quality_quantile","page_views.y","yyyy","mm","parent_weighted_sum")]
    colnames(revisions) <- c("page_title", "namespace", "period", "edit_type", "rev_id", "weighted_sum","expected_quality","expected_quality_quantile","page_views","yyyy","mm","parent_weighted_sum")
    revisions$quality_difference = revisions$weighted_sum - revisions$expected_quality


    all_revisions = rbind(all_revisions, revisions)
    
    quality_and_page_views = NULL

}

write.table(all_revisions, '/export/scratch2/wmf/wbc_entity_usage/usage_results/wikidata_longitudinal_misalignment/all_revisions_quality_differences_2014_2015.tsv', row.names=FALSE, col.names=FALSE, quote=FALSE, sep='\t');

