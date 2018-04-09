

revisions_weighted_sums_and_page_views_2013_2014 <- read.table("../../../results/misalignment_edit_types_tables_and_queries/revision_edit_and_agent_type_may_2013_to_2014_million_sampled_with_weighted_score_extracted.tsv", header=TRUE, sep="\t")

revisions_weighted_sums_and_page_views_2014_2015 <- read.table("../../../results/misalignment_edit_types_tables_and_queries/revision_edit_and_agent_type_may_2014_to_2015_million_sampled_with_weighted_score_extracted.tsv", header=TRUE, sep="\t")

revisions_weighted_sums_and_page_views_2015_2016 <- read.table("../../../results/misalignment_edit_types_tables_and_queries/revision_edit_and_agent_type_may_2015_to_2016_million_sampled_with_weighted_score_extracted.tsv", header=TRUE, sep="\t")

revisions_weighted_sums_and_page_views_2016_2017 <- read.table("../../../results/misalignment_edit_types_tables_and_queries/revision_edit_and_agent_type_may_2016_to_2017_million_sampled_with_weighted_score_extracted.tsv", header=TRUE, sep="\t")

# summary(revisions_weighted_sums_and_page_views_2013_2014)
# summary(revisions_weighted_sums_and_page_views_2014_2015)
# summary(revisions_weighted_sums_and_page_views_2015_2016)
# summary(revisions_weighted_sums_and_page_views_2016_2017)


directory_2014 = '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2014/'

for (rmse_file in c('input_for_RMSE_sub_06',
                    'input_for_RMSE_sub_07',
                    'input_for_RMSE_sub_08',
                    'input_for_RMSE_sub_09',
                    'input_for_RMSE_sub_10',
                    'input_for_RMSE_sub_11',
                    'input_for_RMSE_sub_12',
                    'input_for_RMSE_sub_13',
                    'input_for_RMSE_sub_14',
                    'input_for_RMSE_sub_15',
                    'input_for_RMSE_sub_16',
                    'input_for_RMSE_sub_17',
                    'input_for_RMSE_sub_18'                     
)){
    rmse_full_path = directory_2014 + rmse_file;
    quality_and_page_views <- read.table(rmse_full_path, header=FALSE, sep="\t")
    colnames(quality_and_page_views) <- c('page_title','yyyy','mm', 'weighted_sum', 'page_views')
    
    # 2013-2014

    quality_and_page_views$expected_quality_quantile = ecdf(quality_and_page_views$page_views)(quality_and_page_views$page_view)
    weighted_sum_distribution = ecdf(quality_and_page_views$weighted_sum)
    quality_and_page_views$expected_quality = quantile(weighted_sum_distribution, probs=quality_and_page_views$expected_quality_quantile)

    revisions_weighted_sums_and_page_views_2013_2014 = merge(revisions_weighted_sums_and_page_views_2013_2014, quality_and_page_views, by = "page_title")
    revisions_weighted_sums_and_page_views_2013_2014 = revisions_weighted_sums_and_page_views_2013_2014[c("page_title", "namespace", "edit_type", "agent_type", "rev_id", "weighted_sum.x","expected_quality","expected_quality_quantile","page_views.y","yyyy","mm")]
    colnames(revisions_weighted_sums_and_page_views_2013_2014) <- c("page_title", "namespace", "edit_type", "agent_type", "rev_id", "weighted_sum","expected_quality","expected_quality_quantile","page_views","yyyy","mm")
    revisions_weighted_sums_and_page_views_2013_2014$quality_difference = revisions_weighted_sums_and_page_views_2013_2014$weighted_sum - revisions_weighted_sums_and_page_views_2013_2014$expected_quality


    
    quality_and_page_views = NULL

    output = data.frame()
    output = rbind(output, c(quality_and_page_views[1,2], 
                             quality_and_page_views[1,3],
                             mean(revisions_weighted_sums_and_page_views_2013_2014[revisions_weighted_sums_and_page_views_2013_2014$agent_type == 'bot_edit',]$quality_difference),
                             median(revisions_weighted_sums_and_page_views_2013_2014[revisions_weighted_sums_and_page_views_2013_2014$agent_type == 'bot_edit',]$quality_difference),
                             mean(revisions_weighted_sums_and_page_views_2013_2014[revisions_weighted_sums_and_page_views_2013_2014$agent_type == 'human_bot_like_edit',]$quality_difference),
                             median(revisions_weighted_sums_and_page_views_2013_2014[revisions_weighted_sums_and_page_views_2013_2014$agent_type == 'human_bot_like_edit',]$quality_difference),
                             mean(revisions_weighted_sums_and_page_views_2013_2014[revisions_weighted_sums_and_page_views_2013_2014$agent_type == 'anon_bot_like_edit',]$quality_difference),
                             median(revisions_weighted_sums_and_page_views_2013_2014[revisions_weighted_sums_and_page_views_2013_2014$agent_type == 'anon_bot_like_edit',]$quality_difference),
                             mean(revisions_weighted_sums_and_page_views_2013_2014[revisions_weighted_sums_and_page_views_2013_2014$agent_type == 'semi_automated_edit',]$quality_difference),
                             median(revisions_weighted_sums_and_page_views_2013_2014[revisions_weighted_sums_and_page_views_2013_2014$agent_type == 'semi_automated_edit',]$quality_difference),
                             mean(revisions_weighted_sums_and_page_views_2013_2014[revisions_weighted_sums_and_page_views_2013_2014$agent_type == 'human_edit',]$quality_difference),
                             median(revisions_weighted_sums_and_page_views_2013_2014[revisions_weighted_sums_and_page_views_2013_2014$agent_type == 'human_edit',]$quality_difference),
                             mean(revisions_weighted_sums_and_page_views_2013_2014[revisions_weighted_sums_and_page_views_2013_2014$agent_type == 'anon_edit',]$quality_difference),
                             median(revisions_weighted_sums_and_page_views_2013_2014[revisions_weighted_sums_and_page_views_2013_2014$agent_type == 'anon_edit',]$quality_difference)))
    
    write.table(output[1,], '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/revision_expected_quality_versus_actual_quality_varying_distributions_output.tsv', row.names=FALSE, col.names=FALSE, quote=FALSE, sep='\t', append = TRUE);
    
}


directory_2015 = '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2015/'

for (rmse_file in c('input_for_RMSE_sub_18',
                    'input_for_RMSE_sub_19',
                    'input_for_RMSE_sub_20',
                    'input_for_RMSE_sub_21',
                    'input_for_RMSE_sub_22',
                    'input_for_RMSE_sub_23',
                    'input_for_RMSE_sub_24',
                    'input_for_RMSE_sub_25',
                    'input_for_RMSE_sub_26',
                    'input_for_RMSE_sub_27',
                    'input_for_RMSE_sub_28',
                    'input_for_RMSE_sub_29',
                    'input_for_RMSE_sub_30'                     
)){
    rmse_full_path = directory_2015 + rmse_file;
    quality_and_page_views <- read.table(rmse_full_path, header=FALSE, sep="\t")
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
    output = rbind(output, c(quality_and_page_views[1,2], 
                             quality_and_page_views[1,3],
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
    
    write.table(output[1,], '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/revision_expected_quality_versus_actual_quality_varying_distributions_output.tsv', row.names=FALSE, col.names=FALSE, quote=FALSE, sep='\t', append = TRUE);
    
}

directory_2016 = '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2016/'

for (rmse_file in c('input_for_RMSE_sub_30',
                    'input_for_RMSE_sub_31',
                    'input_for_RMSE_sub_32',
                    'input_for_RMSE_sub_33',
                    'input_for_RMSE_sub_34',
                    'input_for_RMSE_sub_35',
                    'input_for_RMSE_sub_36',
                    'input_for_RMSE_sub_37',
                    'input_for_RMSE_sub_38',
                    'input_for_RMSE_sub_39',
                    'input_for_RMSE_sub_40',
                    'input_for_RMSE_sub_41',
                    'input_for_RMSE_sub_42'                     
)){
    rmse_full_path = directory_2016 + rmse_file;
    quality_and_page_views <- read.table(rmse_full_path, header=FALSE, sep="\t")
    colnames(quality_and_page_views) <- c('page_title','yyyy','mm', 'weighted_sum', 'page_views')
    
    # 2013-2014

    quality_and_page_views$expected_quality_quantile = ecdf(quality_and_page_views$page_views)(quality_and_page_views$page_view)
    weighted_sum_distribution = ecdf(quality_and_page_views$weighted_sum)
    quality_and_page_views$expected_quality = quantile(weighted_sum_distribution, probs=quality_and_page_views$expected_quality_quantile)

    revisions_weighted_sums_and_page_views_2015_2016 = merge(revisions_weighted_sums_and_page_views_2015_2016, quality_and_page_views, by = "page_title")
    revisions_weighted_sums_and_page_views_2015_2016 = revisions_weighted_sums_and_page_views_2015_2016[c("page_title", "namespace", "edit_type", "agent_type", "rev_id", "weighted_sum.x","expected_quality","expected_quality_quantile","page_views.y","yyyy","mm")]
    colnames(revisions_weighted_sums_and_page_views_2015_2016) <- c("page_title", "namespace", "edit_type", "agent_type", "rev_id", "weighted_sum","expected_quality","expected_quality_quantile","page_views","yyyy","mm")
    revisions_weighted_sums_and_page_views_2015_2016$quality_difference = revisions_weighted_sums_and_page_views_2015_2016$weighted_sum - revisions_weighted_sums_and_page_views_2015_2016$expected_quality


    
    quality_and_page_views = NULL

    output = data.frame()
    output = rbind(output, c(quality_and_page_views[1,2], 
                             quality_and_page_views[1,3],
                             mean(revisions_weighted_sums_and_page_views_2015_2016[revisions_weighted_sums_and_page_views_2015_2016$agent_type == 'bot_edit',]$quality_difference),
                             median(revisions_weighted_sums_and_page_views_2015_2016[revisions_weighted_sums_and_page_views_2015_2016$agent_type == 'bot_edit',]$quality_difference),
                             mean(revisions_weighted_sums_and_page_views_2015_2016[revisions_weighted_sums_and_page_views_2015_2016$agent_type == 'human_bot_like_edit',]$quality_difference),
                             median(revisions_weighted_sums_and_page_views_2015_2016[revisions_weighted_sums_and_page_views_2015_2016$agent_type == 'human_bot_like_edit',]$quality_difference),
                             mean(revisions_weighted_sums_and_page_views_2015_2016[revisions_weighted_sums_and_page_views_2015_2016$agent_type == 'anon_bot_like_edit',]$quality_difference),
                             median(revisions_weighted_sums_and_page_views_2015_2016[revisions_weighted_sums_and_page_views_2015_2016$agent_type == 'anon_bot_like_edit',]$quality_difference),
                             mean(revisions_weighted_sums_and_page_views_2015_2016[revisions_weighted_sums_and_page_views_2015_2016$agent_type == 'semi_automated_edit',]$quality_difference),
                             median(revisions_weighted_sums_and_page_views_2015_2016[revisions_weighted_sums_and_page_views_2015_2016$agent_type == 'semi_automated_edit',]$quality_difference),
                             mean(revisions_weighted_sums_and_page_views_2015_2016[revisions_weighted_sums_and_page_views_2015_2016$agent_type == 'human_edit',]$quality_difference),
                             median(revisions_weighted_sums_and_page_views_2015_2016[revisions_weighted_sums_and_page_views_2015_2016$agent_type == 'human_edit',]$quality_difference),
                             mean(revisions_weighted_sums_and_page_views_2015_2016[revisions_weighted_sums_and_page_views_2015_2016$agent_type == 'anon_edit',]$quality_difference),
                             median(revisions_weighted_sums_and_page_views_2015_2016[revisions_weighted_sums_and_page_views_2015_2016$agent_type == 'anon_edit',]$quality_difference)))
    
    write.table(output[1,], '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/revision_expected_quality_versus_actual_quality_varying_distributions_output.tsv', row.names=FALSE, col.names=FALSE, quote=FALSE, sep='\t', append = TRUE);
    
}

directory_2017 = '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/input_for_rmse_split_directory/2017/'

for (rmse_file in c('input_for_RMSE_sub_42',
                    'input_for_RMSE_sub_43',
                    'input_for_RMSE_sub_44',
                    'input_for_RMSE_sub_45',
                    'input_for_RMSE_sub_46',
                    'input_for_RMSE_sub_47',
                    'input_for_RMSE_sub_48',
                    'input_for_RMSE_sub_49',
                    'input_for_RMSE_sub_50',
                    'input_for_RMSE_sub_51',
                    'input_for_RMSE_sub_52',
                    'input_for_RMSE_sub_53',
                    'input_for_RMSE_sub_54'                     
)){
    rmse_full_path = directory_2017 + rmse_file;
    quality_and_page_views <- read.table(rmse_full_path, header=FALSE, sep="\t")
    colnames(quality_and_page_views) <- c('page_title','yyyy','mm', 'weighted_sum', 'page_views')
    
    # 2013-2014

    quality_and_page_views$expected_quality_quantile = ecdf(quality_and_page_views$page_views)(quality_and_page_views$page_view)
    weighted_sum_distribution = ecdf(quality_and_page_views$weighted_sum)
    quality_and_page_views$expected_quality = quantile(weighted_sum_distribution, probs=quality_and_page_views$expected_quality_quantile)

    revisions_weighted_sums_and_page_views_2016_2017 = merge(revisions_weighted_sums_and_page_views_2016_2017, quality_and_page_views, by = "page_title")
    revisions_weighted_sums_and_page_views_2016_2017 = revisions_weighted_sums_and_page_views_2016_2017[c("page_title", "namespace", "edit_type", "agent_type", "rev_id", "weighted_sum.x","expected_quality","expected_quality_quantile","page_views.y","yyyy","mm")]
    colnames(revisions_weighted_sums_and_page_views_2016_2017) <- c("page_title", "namespace", "edit_type", "agent_type", "rev_id", "weighted_sum","expected_quality","expected_quality_quantile","page_views","yyyy","mm")
    revisions_weighted_sums_and_page_views_2016_2017$quality_difference = revisions_weighted_sums_and_page_views_2016_2017$weighted_sum - revisions_weighted_sums_and_page_views_2016_2017$expected_quality


    
    quality_and_page_views = NULL

    output = data.frame()
    output = rbind(output, c(quality_and_page_views[1,2], 
                             quality_and_page_views[1,3],
                             mean(revisions_weighted_sums_and_page_views_2016_2017[revisions_weighted_sums_and_page_views_2016_2017$agent_type == 'bot_edit',]$quality_difference),
                             median(revisions_weighted_sums_and_page_views_2016_2017[revisions_weighted_sums_and_page_views_2016_2017$agent_type == 'bot_edit',]$quality_difference),
                             mean(revisions_weighted_sums_and_page_views_2016_2017[revisions_weighted_sums_and_page_views_2016_2017$agent_type == 'human_bot_like_edit',]$quality_difference),
                             median(revisions_weighted_sums_and_page_views_2016_2017[revisions_weighted_sums_and_page_views_2016_2017$agent_type == 'human_bot_like_edit',]$quality_difference),
                             mean(revisions_weighted_sums_and_page_views_2016_2017[revisions_weighted_sums_and_page_views_2016_2017$agent_type == 'anon_bot_like_edit',]$quality_difference),
                             median(revisions_weighted_sums_and_page_views_2016_2017[revisions_weighted_sums_and_page_views_2016_2017$agent_type == 'anon_bot_like_edit',]$quality_difference),
                             mean(revisions_weighted_sums_and_page_views_2016_2017[revisions_weighted_sums_and_page_views_2016_2017$agent_type == 'semi_automated_edit',]$quality_difference),
                             median(revisions_weighted_sums_and_page_views_2016_2017[revisions_weighted_sums_and_page_views_2016_2017$agent_type == 'semi_automated_edit',]$quality_difference),
                             mean(revisions_weighted_sums_and_page_views_2016_2017[revisions_weighted_sums_and_page_views_2016_2017$agent_type == 'human_edit',]$quality_difference),
                             median(revisions_weighted_sums_and_page_views_2016_2017[revisions_weighted_sums_and_page_views_2016_2017$agent_type == 'human_edit',]$quality_difference),
                             mean(revisions_weighted_sums_and_page_views_2016_2017[revisions_weighted_sums_and_page_views_2016_2017$agent_type == 'anon_edit',]$quality_difference),
                             median(revisions_weighted_sums_and_page_views_2016_2017[revisions_weighted_sums_and_page_views_2016_2017$agent_type == 'anon_edit',]$quality_difference)))
    
    write.table(output[1,], '/export/scratch2/wmf/wbc_entity_usage/usage_results/misalignment_edit_types_tables_and_queries/revision_expected_quality_versus_actual_quality_varying_distributions_output.tsv', row.names=FALSE, col.names=FALSE, quote=FALSE, sep='\t', append = TRUE);
    
}


