entity_weighted_sums_and_page_views <- read.table(commandArgs(trailingOnly = TRUE)[1], header=FALSE, sep="\t");
output_file <- commandArgs(trailingOnly = TRUE)[2];


colnames(entity_weighted_sums_and_page_views) <- c('page_title','yyyy','mm', 'weighted_sum', 'page_views');
entity_weighted_sums_and_page_views = entity_weighted_sums_and_page_views[entity_weighted_sums_and_page_views$weighted_sum >= 1,];
entity_weighted_sums_and_page_views$expected_quality_quantile = ecdf(entity_weighted_sums_and_page_views$page_views)(entity_weighted_sums_and_page_views$page_views);
weighted_sum_distribution = ecdf(entity_weighted_sums_and_page_views$weighted_sum);
entity_weighted_sums_and_page_views$expected_quality = quantile(weighted_sum_distribution, probs=entity_weighted_sums_and_page_views$expected_quality_quantile);
entity_weighted_sums_and_page_views$quality_difference = entity_weighted_sums_and_page_views$weighted_sum - entity_weighted_sums_and_page_views$expected_quality;

entity_weighted_sums_and_page_views$quality_difference_sign = sign(entity_weighted_sums_and_page_views$quality_difference);

me = sum(entity_weighted_sums_and_page_views$quality_difference)/nrow(entity_weighted_sums_and_page_views)
mae = sum(abs(entity_weighted_sums_and_page_views$quality_difference))/nrow(entity_weighted_sums_and_page_views)
median_error = median(entity_weighted_sums_and_page_views$quality_difference)
median_absolute_error = median(abs(entity_weighted_sums_and_page_views$quality_difference))
mad = median(abs(entity_weighted_sums_and_page_views$quality_difference - median(entity_weighted_sums_and_page_views$quality_difference)))
rmse = sqrt(sum(entity_weighted_sums_and_page_views$quality_difference^2)/nrow(entity_weighted_sums_and_page_views))

sum_quality_differences_squared = sum((entity_weighted_sums_and_page_views$quality_difference^2)*entity_weighted_sums_and_page_views$quality_difference_sign)
sum_quality_differences_squared_sign = sign(sum_quality_differences_squared)
rmse_with_sign = sqrt(abs(sum_quality_differences_squared)/nrow(entity_weighted_sums_and_page_views))*sum_quality_differences_squared_sign
    
output = data.frame()
output = rbind(output, c(entity_weighted_sums_and_page_views[1,2], 
                         entity_weighted_sums_and_page_views[1,3], 
                         me,
                         mae,
                         median_error,
                         median_absolute_error,
                         mad,
                         rmse,
                         rmse_with_sign))

write.table(output[1,], output_file, row.names=FALSE, col.names=FALSE, quote=FALSE, sep='\t', append = TRUE);




