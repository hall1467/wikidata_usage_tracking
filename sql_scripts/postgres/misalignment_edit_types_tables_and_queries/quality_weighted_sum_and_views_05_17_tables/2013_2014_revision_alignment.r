all_revisions = data.frame()


for (monthly_distribution_and_edits in list(
                    
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2013/input_for_RMSE_sub_07', revisions = 'monthly_sampled_revisions_june_2013.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2013/input_for_RMSE_sub_08', revisions = 'monthly_sampled_revisions_july_2013.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2013/input_for_RMSE_sub_09', revisions = 'monthly_sampled_revisions_august_2013.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2013/input_for_RMSE_sub_10', revisions = 'monthly_sampled_revisions_september_2013.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2013/input_for_RMSE_sub_11', revisions = 'monthly_sampled_revisions_october_2013.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2013/input_for_RMSE_sub_12', revisions = 'monthly_sampled_revisions_november_2013.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2013/input_for_RMSE_sub_13', revisions = 'monthly_sampled_revisions_december_2013.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2014/input_for_RMSE_sub_14', revisions = 'monthly_sampled_revisions_january_2013.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2014/input_for_RMSE_sub_15', revisions = 'monthly_sampled_revisions_february_2013.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2014/input_for_RMSE_sub_16', revisions = 'monthly_sampled_revisions_march_2013.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2014/input_for_RMSE_sub_17', revisions = 'monthly_sampled_revisions_april_2013.tsv'),
                    list(distribution = '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2014/input_for_RMSE_sub_18', revisions = 'monthly_sampled_revisions_may_2013.tsv')
)){
  

     distribution = monthly_distribution_and_edits$distribution
     revisions = monthly_distribution_and_edits$revision

     print(distribution)
     print(revisions)

     quality_and_page_views <- read.table(distribution, header=FALSE, sep="\t")
     colnames(quality_and_page_views) <- c('page_title','yyyy','mm', 'weighted_sum', 'page_views')

    


    quality_and_page_views$expected_quality_quantile = ecdf(quality_and_page_views$page_views)(quality_and_page_views$page_view)
    weighted_sum_distribution = ecdf(quality_and_page_views$weighted_sum)
    quality_and_page_views$expected_quality = quantile(weighted_sum_distribution, probs=quality_and_page_views$expected_quality_quantile)

    revisions = merge(revisions, quality_and_page_views, by = "page_title")
    revisions = revisions[c("page_title", "namespace", "edit_type", "agent_type", "rev_id", "weighted_sum.x","expected_quality","expected_quality_quantile","page_views.y","yyyy","mm")]
    colnames(revisions) <- c("page_title", "namespace", "edit_type", "agent_type", "rev_id", "weighted_sum","expected_quality","expected_quality_quantile","page_views","yyyy","mm")
    revisions$quality_difference = revisions$weighted_sum - revisions$expected_quality


    all_revisions = rbind(all_revisions, revisions)
    
    quality_and_page_views = NULL

}

write.table(all_revisions, '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/all_revisions_quality_differences_2013_2014.tsv', row.names=FALSE, col.names=FALSE, quote=FALSE, sep='\t', append = TRUE);

