

revisions_weighted_sums_and_page_views_2013_2014 <- read.table("/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/revision_edit_and_agent_type_may_2013_to_2014_million_sampled_with_weighted_score_extracted.tsv", header=TRUE, sep="\t")

revisions_weighted_sums_and_page_views_2014_2015 <- read.table("/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/revision_edit_and_agent_type_may_2014_to_2015_million_sampled_with_weighted_score_extracted.tsv", header=TRUE, sep="\t")

revisions_weighted_sums_and_page_views_2015_2016 <- read.table("/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/revision_edit_and_agent_type_may_2015_to_2016_million_sampled_with_weighted_score_extracted.tsv", header=TRUE, sep="\t")

revisions_weighted_sums_and_page_views_2016_2017 <- read.table("/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/revision_edit_and_agent_type_may_2016_to_2017_million_sampled_with_weighted_score_extracted.tsv", header=TRUE, sep="\t")




for (rmse_file in c('/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2014/input_for_RMSE_sub_18',
                    '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2014/input_for_RMSE_sub_19',
                    '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2014/input_for_RMSE_sub_20',
                    '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2014/input_for_RMSE_sub_21',
                    '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2014/input_for_RMSE_sub_22',
                    '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2014/input_for_RMSE_sub_23',
                    '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2014/input_for_RMSE_sub_24',
                    '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2014/input_for_RMSE_sub_25',
                    '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2015/input_for_RMSE_sub_26',
                    '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2015/input_for_RMSE_sub_27',
                    '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2015/input_for_RMSE_sub_28',
                    '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2015/input_for_RMSE_sub_29',
                    '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2015/input_for_RMSE_sub_30'                     
)){
    quality_and_page_views <- read.table(rmse_file, header=FALSE, sep="\t")
    colnames(quality_and_page_views) <- c('page_title','yyyy','mm', 'weighted_sum', 'page_views')
    
    # 2013-2014

    quality_and_page_views$expected_quality_quantile = ecdf(quality_and_page_views$page_views)(quality_and_page_views$page_view)
    weighted_sum_distribution = ecdf(quality_and_page_views$weighted_sum)
    quality_and_page_views$expected_quality = quantile(weighted_sum_distribution, probs=quality_and_page_views$expected_quality_quantile)

    revisions_weighted_sums_and_page_views_2014_2015 = merge(revisions_weighted_sums_and_page_views_2014_2015, quality_and_page_views, by = "page_title")
    revisions_weighted_sums_and_page_views_2014_2015 = revisions_weighted_sums_and_page_views_2014_2015[c("page_title", "namespace", "edit_type", "agent_type", "rev_id", "weighted_sum.x","expected_quality","expected_quality_quantile","page_views.y","yyyy","mm")]
    colnames(revisions_weighted_sums_and_page_views_2014_2015) <- c("page_title", "namespace", "edit_type", "agent_type", "rev_id", "weighted_sum","expected_quality","expected_quality_quantile","page_views","yyyy","mm")
    revisions_weighted_sums_and_page_views_2014_2015$quality_difference = revisions_weighted_sums_and_page_views_2014_2015$weighted_sum - revisions_weighted_sums_and_page_views_2014_2015$expected_quality


    
    quality_and_page_views = NULL

    output = data.frame()
    output = rbind(output, c(
                             mean(revisions_weighted_sums_and_page_views_2014_2015[revisions_weighted_sums_and_page_views_2014_2015$agent_type == 'bot_edit',]$quality_difference),
                             median(revisions_weighted_sums_and_page_views_2014_2015[revisions_weighted_sums_and_page_views_2014_2015$agent_type == 'bot_edit',]$quality_difference),
                             mean(revisions_weighted_sums_and_page_views_2014_2015[revisions_weighted_sums_and_page_views_2014_2015$agent_type == 'human_bot_like_edit',]$quality_difference),
                             median(revisions_weighted_sums_and_page_views_2014_2015[revisions_weighted_sums_and_page_views_2014_2015$agent_type == 'human_bot_like_edit',]$quality_difference),
                             mean(revisions_weighted_sums_and_page_views_2014_2015[revisions_weighted_sums_and_page_views_2014_2015$agent_type == 'anon_bot_like_edit',]$quality_difference),
                             median(revisions_weighted_sums_and_page_views_2014_2015[revisions_weighted_sums_and_page_views_2014_2015$agent_type == 'anon_bot_like_edit',]$quality_difference),
                             mean(revisions_weighted_sums_and_page_views_2014_2015[revisions_weighted_sums_and_page_views_2014_2015$agent_type == 'semi_automated_edit',]$quality_difference),
                             median(revisions_weighted_sums_and_page_views_2014_2015[revisions_weighted_sums_and_page_views_2014_2015$agent_type == 'semi_automated_edit',]$quality_difference),
                             mean(revisions_weighted_sums_and_page_views_2014_2015[revisions_weighted_sums_and_page_views_2014_2015$agent_type == 'human_edit',]$quality_difference),
                             median(revisions_weighted_sums_and_page_views_2014_2015[revisions_weighted_sums_and_page_views_2014_2015$agent_type == 'human_edit',]$quality_difference),
                             mean(revisions_weighted_sums_and_page_views_2014_2015[revisions_weighted_sums_and_page_views_2014_2015$agent_type == 'anon_edit',]$quality_difference),
                             median(revisions_weighted_sums_and_page_views_2014_2015[revisions_weighted_sums_and_page_views_2014_2015$agent_type == 'anon_edit',]$quality_difference)))
    
    write.table(output[1,], '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/revision_expected_quality_versus_actual_quality_varying_distributions_output_2014_2015.tsv', row.names=FALSE, col.names=FALSE, quote=FALSE, sep='\t', append = TRUE);
    
}
