
# library(data.table)

# library(plyr)

# library(ggplot2)

# revisions_weighted_sums_and_page_views_june_2013 <- read.table("/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/revisions_with_weighted_score_extracted_june_2013.tsv", header=TRUE, sep="\t")
# revisions_weighted_sums_and_page_views_july_2013 <- read.table("/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/revisions_with_weighted_score_extracted_july_2013.tsv", header=TRUE, sep="\t")
# revisions_weighted_sums_and_page_views_august_2013 <- read.table("/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/revisions_with_weighted_score_extracted_august_2013.tsv", header=TRUE, sep="\t")
# revisions_weighted_sums_and_page_views_september_2013 <- read.table("/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/revisions_with_weighted_score_extracted_september_2013.tsv", header=TRUE, sep="\t")
# revisions_weighted_sums_and_page_views_october_2013 <- read.table("/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/revisions_with_weighted_score_extracted_october_2013.tsv", header=TRUE, sep="\t")
# revisions_weighted_sums_and_page_views_november_2013 <- read.table("/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/revisions_with_weighted_score_extracted_november_2013.tsv", header=TRUE, sep="\t")
# revisions_weighted_sums_and_page_views_december_2013 <- read.table("/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/revisions_with_weighted_score_extracted_december_2013.tsv", header=TRUE, sep="\t")
# revisions_weighted_sums_and_page_views_january_2014 <- read.table("/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/revisions_with_weighted_score_extracted_january_2014.tsv", header=TRUE, sep="\t")
# revisions_weighted_sums_and_page_views_february_2014 <- read.table("/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/revisions_with_weighted_score_extracted_february_2014.tsv", header=TRUE, sep="\t")
# revisions_weighted_sums_and_page_views_march_2014 <- read.table("/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/revisions_with_weighted_score_extracted_march_2014.tsv", header=TRUE, sep="\t")
# revisions_weighted_sums_and_page_views_april_2014 <- read.table("/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/revisions_with_weighted_score_extracted_april_2014.tsv", header=TRUE, sep="\t")
# revisions_weighted_sums_and_page_views_may_2014 <- read.table("/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/revisions_with_weighted_score_extracted_may_2014.tsv", header=TRUE, sep="\t")

# quality_and_page_views_june_2014 <- read.table("/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_RMSE_sub_07", header=FALSE, sep="\t")

# colnames(quality_and_page_views_june_2014) <- c('page_title','yyyy','mm', 'weighted_sum', 'page_views')
















for (monthly_distribution_and_edits in c(
                    
                    c('/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2013/input_for_RMSE_sub_07', 'test'),
                    c('/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2013/input_for_RMSE_sub_08', 'test'),
                    c('/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2013/input_for_RMSE_sub_09', 'test'),
                    c('/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2013/input_for_RMSE_sub_10', 'test'),
                    c('/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2013/input_for_RMSE_sub_11', 'test'),
                    c('/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2013/input_for_RMSE_sub_12', 'test'),
                    c('/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2013/input_for_RMSE_sub_13', 'test'),
                    c('/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2014/input_for_RMSE_sub_14', 'test'),
                    c('/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2014/input_for_RMSE_sub_15', 'test'),
                    c('/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2014/input_for_RMSE_sub_16', 'test'),
                    c('/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2014/input_for_RMSE_sub_17', 'test'),
                    c('/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2014/input_for_RMSE_sub_18', 'test'),
                    c('/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2014/input_for_RMSE_sub_19', 'test')
)){
  
     distribution = monthly_distribution_and_edits[[1]]
     revisions = monthly_distribution_and_edits[[2]]
     print(distribution)
     print(revisions)

#     quality_and_page_views <- read.table(rmse_file, header=FALSE, sep="\t")
#     colnames(quality_and_page_views) <- c('page_title','yyyy','mm', 'weighted_sum', 'page_views')
#     print(rmse_file)
#     print(nrow(quality_and_page_views))
    
#     if 

#     quality_and_page_views$expected_quality_quantile = ecdf(quality_and_page_views$page_views)(quality_and_page_views$page_view)
#     weighted_sum_distribution = ecdf(quality_and_page_views$weighted_sum)
#     quality_and_page_views$expected_quality = quantile(weighted_sum_distribution, probs=quality_and_page_views$expected_quality_quantile)

#     revisions_weighted_sums_and_page_views = merge(revisions_weighted_sums_and_page_views_2016_2017, quality_and_page_views, by = "page_title")
#     revisions_weighted_sums_and_page_views_2016_2017 = revisions_weighted_sums_and_page_views_2016_2017[c("page_title", "namespace", "edit_type", "agent_type", "rev_id", "weighted_sum.x","expected_quality","expected_quality_quantile","page_views.y","yyyy","mm")]
#     colnames(revisions_weighted_sums_and_page_views_2016_2017) <- c("page_title", "namespace", "edit_type", "agent_type", "rev_id", "weighted_sum","expected_quality","expected_quality_quantile","page_views","yyyy","mm")
#     revisions_weighted_sums_and_page_views$quality_difference = revisions_weighted_sums_and_page_views$weighted_sum.x - revisions_weighted_sums_and_page_views$expected_quality


    
#     quality_and_page_views = NULL
    
}
