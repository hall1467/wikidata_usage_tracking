entity_weighted_sums_and_page_views <- read.table(commandArgs(trailingOnly = TRUE)[1], header=FALSE, sep="\t");
output_file <- commandArgs(trailingOnly = TRUE)[2];


colnames(entity_weighted_sums_and_page_views) <- c('page_title','yyyy','mm', 'weighted_sum', 'page_views');
entity_weighted_sums_and_page_views = entity_weighted_sums_and_page_views[entity_weighted_sums_and_page_views$weighted_sum >= 1,];
entity_weighted_sums_and_page_views$expected_quality_quantile = ecdf(entity_weighted_sums_and_page_views$page_views)(entity_weighted_sums_and_page_views$page_views);
weighted_sum_distribution = ecdf(entity_weighted_sums_and_page_views$weighted_sum);
entity_weighted_sums_and_page_views$expected_quality = quantile(weighted_sum_distribution, probs=entity_weighted_sums_and_page_views$expected_quality_quantile);
entity_weighted_sums_and_page_views$quality_difference = entity_weighted_sums_and_page_views$weighted_sum - entity_weighted_sums_and_page_views$expected_quality;

entity_weighted_sums_and_page_views$quality_quantile = ecdf(entity_weighted_sums_and_page_views$weighted_sum)(entity_weighted_sums_and_page_views$weighted_sum)

mae_quantile = mean(abs(entity_weighted_sums_and_page_views$quality_quantile - entity_weighted_sums_and_page_views$expected_quality_quantile))
mae = mean(abs(entity_weighted_sums_and_page_views$quality_difference))
se_of_mean = sd(abs(entity_weighted_sums_and_page_views$quality_difference))/sqrt(nrow(entity_weighted_sums_and_page_views))



output = data.frame()
output = rbind(output, c(entity_weighted_sums_and_page_views[1,2], 
                         entity_weighted_sums_and_page_views[1,3], 
                         mae_quantile,
                         mae,
                         se_of_mean))

write.table(output[1,], output_file, row.names=FALSE, col.names=FALSE, quote=FALSE, sep='\t', append = TRUE);




