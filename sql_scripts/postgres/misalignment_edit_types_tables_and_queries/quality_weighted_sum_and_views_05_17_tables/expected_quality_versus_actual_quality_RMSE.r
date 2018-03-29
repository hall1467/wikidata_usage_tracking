entity_weighted_sums_and_page_views <- read.table(commandArgs(trailingOnly = TRUE)[1], header=FALSE, sep="\t");

# summary(entity_weighted_sums_and_page_views)
colnames(entity_weighted_sums_and_page_views) <- c('page_title','yyyy','mm', 'weighted_sum', 'page_views')
entity_weighted_sums_and_page_views$expected_quality_quantile = ecdf(entity_weighted_sums_and_page_views$page_views)(entity_weighted_sums_and_page_views$page_views);
weighted_sum_distribution = ecdf(entity_weighted_sums_and_page_views$weighted_sum);
entity_weighted_sums_and_page_views$expected_quality = quantile(weighted_sum_distribution, probs=entity_weighted_sums_and_page_views$expected_quality_quantile);
entity_weighted_sums_and_page_views$quality_difference = entity_weighted_sums_and_page_views$expected_quality - entity_weighted_sums_and_page_views$weighted_sum;



quality_differences_added_up = sum(entity_weighted_sums_and_page_views$quality_difference);


if (quality_differences_added_up < 0) {
    RMSE_with_sign = -sqrt(quality_differences_added_up^2/nrow(entity_weighted_sums_and_page_views))
} else {
    RMSE_with_sign = sqrt(quality_differences_added_up^2/nrow(entity_weighted_sums_and_page_views)) 
};
    
output = data.frame()
output = rbind(output, c(entity_weighted_sums_and_page_views[1,2], 
                         entity_weighted_sums_and_page_views[1,3], 
                         RMSE_with_sign))

write.table(output[1,],'/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/rmse_with_sign.tsv', row.names=FALSE, col.names=FALSE, quote=FALSE, sep='\t', append = TRUE);




