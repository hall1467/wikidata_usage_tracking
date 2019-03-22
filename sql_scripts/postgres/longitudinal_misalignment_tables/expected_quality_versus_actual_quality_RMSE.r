entity_weighted_sums_and_page_views <- read.table(commandArgs(trailingOnly = TRUE)[1], header=FALSE, sep="\t");
output_file <- commandArgs(trailingOnly = TRUE)[2];


colnames(entity_weighted_sums_and_page_views) <- c('page_title','yyyy','mm', 'weighted_sum', 'page_views');
entity_weighted_sums_and_page_views = entity_weighted_sums_and_page_views[entity_weighted_sums_and_page_views$weighted_sum >= 1,];
entity_weighted_sums_and_page_views$expected_quality_quantile = ecdf(entity_weighted_sums_and_page_views$page_views)(entity_weighted_sums_and_page_views$page_views);
weighted_sum_distribution = ecdf(entity_weighted_sums_and_page_views$weighted_sum);
entity_weighted_sums_and_page_views$expected_quality = quantile(weighted_sum_distribution, probs=entity_weighted_sums_and_page_views$expected_quality_quantile);
entity_weighted_sums_and_page_views$quality_difference = entity_weighted_sums_and_page_views$weighted_sum - entity_weighted_sums_and_page_views$expected_quality;

entity_weighted_sums_and_page_views$quality_quantile = ecdf(entity_weighted_sums_and_page_views$weighted_sum)(entity_weighted_sums_and_page_views$weighted_sum)

entity_weighted_sums_and_page_views$quality_difference_sign = sign(entity_weighted_sums_and_page_views$quality_difference);

mae_quantile = mean(abs(entity_weighted_sums_and_page_views$quality_quantile - entity_weighted_sums_and_page_views$expected_quality_quantile))
mae = mean(abs(entity_weighted_sums_and_page_views$quality_difference))

weighted_sums_sorted = sort(entity_weighted_sums_and_page_views$weighted_sum)
print(weighted_sums_sorted[1:2])
n = length(weighted_sums_sorted)
typeof(weighted_sums_sorted)
print(n)

below_median = NULL
above_median = NULL

if ((n %% 2) == 0){

	below_median = weighted_sums_sorted[1:(n/2)]
	print("below")

	print(weighted_sums_sorted[1:(n/2)])
	
	above_median = weighted_sums_sorted[((n/2)+1):n]
	
} else {

	below_median = weighted_sums_sorted[1:floor(n/2)]

	# Skip over median
	above_median = weighted_sums_sorted[(floor(n/2)+2):n]
}

potential_variability = 2(sum(above_median - below_median))



output = data.frame()
output = rbind(output, c(entity_weighted_sums_and_page_views[1,2], 
                         entity_weighted_sums_and_page_views[1,3], 
                         mae_quantile,
                         mae,
                         potential_variability))

write.table(output[1,], output_file, row.names=FALSE, col.names=FALSE, quote=FALSE, sep='\t', append = TRUE);




