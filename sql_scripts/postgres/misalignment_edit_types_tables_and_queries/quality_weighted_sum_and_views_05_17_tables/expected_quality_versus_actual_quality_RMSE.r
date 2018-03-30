entity_weighted_sums_and_page_views <- read.table(commandArgs(trailingOnly = TRUE)[1], header=FALSE, sep="\t");

# summary(entity_weighted_sums_and_page_views)
colnames(entity_weighted_sums_and_page_views) <- c('page_title','yyyy','mm', 'weighted_sum', 'page_views')
entity_weighted_sums_and_page_views$expected_quality_quantile = ecdf(entity_weighted_sums_and_page_views$page_views)(entity_weighted_sums_and_page_views$page_views);
weighted_sum_distribution = ecdf(entity_weighted_sums_and_page_views$weighted_sum);
entity_weighted_sums_and_page_views$expected_quality = quantile(weighted_sum_distribution, probs=entity_weighted_sums_and_page_views$expected_quality_quantile);
entity_weighted_sums_and_page_views$quality_difference = entity_weighted_sums_and_page_views$weighted_sum - entity_weighted_sums_and_page_views$expected_quality;

entity_weighted_sums_and_page_views$quality_difference_sign = if (entity_weighted_sums_and_page_views$quality_difference < 0) -1 else 1;

mean_quality_difference = mean(entity_weighted_sums_and_page_views$quality_difference)
#Line below should be taking mean not sum. Won't effect results but should fix
mean_quality_differences_squared = sum((entity_weighted_sums_and_page_views$quality_difference^2)*entity_weighted_sums_and_page_views$quality_difference_sign)


if (mean_quality_difference < 0) {
    RMSE_with_sign = -sqrt(sum(entity_weighted_sums_and_page_views$quality_difference^2)/nrow(entity_weighted_sums_and_page_views))
} else {
    RMSE_with_sign = sqrt(sum(entity_weighted_sums_and_page_views$quality_difference^2)/nrow(entity_weighted_sums_and_page_views)) 
};


if (mean_quality_differences_squared < 0) {
    RMSE_with_sign_for_squared_sum = -sqrt(sum(entity_weighted_sums_and_page_views$quality_difference^2)/nrow(entity_weighted_sums_and_page_views))
} else {
    RMSE_with_sign_for_squared_sum = sqrt(sum(entity_weighted_sums_and_page_views$quality_difference^2)/nrow(entity_weighted_sums_and_page_views)) 
};


    
output = data.frame()
output = rbind(output, c(entity_weighted_sums_and_page_views[1,2], 
                         entity_weighted_sums_and_page_views[1,3], 
                         RMSE_with_sign,
                         RMSE_with_sign_for_squared_sum,
                         mean_quality_difference))

write.table(output[1,],'/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/rmse_with_sign.tsv', row.names=FALSE, col.names=FALSE, quote=FALSE, sep='\t', append = TRUE);




