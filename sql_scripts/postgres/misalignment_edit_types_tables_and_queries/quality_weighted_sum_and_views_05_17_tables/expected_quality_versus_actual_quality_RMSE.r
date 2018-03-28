entity_weighted_sums_and_page_views <- read.table(commandArgs()[1], header=TRUE, sep="\t");

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
    
output = data.frame(head(entity_weighted_sums_and_page_views, n=1)$year,
                    head(entity_weighted_sums_and_page_views, n=1)$month,
                    RMSE_with_sign);

write.table(output,'/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/rmse_with_sign.tsv', row.names=FALSE, col.names=FALSE, quote=FALSE, sep='\t', append = TRUE);




