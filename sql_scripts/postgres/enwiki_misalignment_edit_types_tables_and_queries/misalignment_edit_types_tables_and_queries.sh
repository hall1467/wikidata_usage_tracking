set base = /export/scratch2/wmf/scripts/wikidata_usage_tracking/sql_scripts/postgres/enwiki_misalignment_edit_types_tables_and_queries
set results = /export/scratch2/wmf/wbc_entity_usage/usage_results/enwiki_misalignment_edit_types_tables_and_queries

# First ran these two manually to grab data from Wikimedia dumps

# wget -r -l 1 -A "enwiki-20180420-stub-meta-history*.xml.gz" -nd --reject "enwiki-20180420-stub-meta-history.xml.gz" -nv https://dumps.wikimedia.org/enwiki/20180420/

# wget -r -l 1 -A "enwiki-20180420-pages-articles*.xml*" -nd --reject "enwiki-20180420-pages-articles.xml.bz2","enwiki-20180420-pages-articles-multistream.xml.bz2" -nv https://dumps.wikimedia.org/enwiki/20180420/

# Reusing the next two scripts since it doesn't make sense to create new ones doing essentially the same thing.

python $base/revision_extraction.py \
	/export/scratch2/wmf/wbc_entity_usage/enwiki_page_revisions/enwiki-20180420-stub-meta-history* \
	--revisions-output=$results/enwiki_page_revisions_20180420.tsv \
	--verbose \
	--debug > & \
	$results/enwiki_page_revisions_20180420_error_log.txt

python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/revisions_postgres_post_process.py \
	$results/enwiki_page_revisions_20180420.tsv \
	--revisions-output=$results/enwiki_page_revisions_20180420_escaped_backslashes.tsv \
	--verbose \
	--debug > & \
	$results/enwiki_page_revisions_20180420_escaped_backslashes_error_log.txt

################################################################################################
echo "'randomly_selected_main_namespace_articles' table creation and querying section"
################################################################################################

# python $base/randomly_selected_main_namespace_articles_table/wikipedia_main_namespace_article_extraction.py \
# 	/export/scratch2/wmf/wbc_entity_usage/enwiki_current_page_info/enwiki-20180420-pages-articles* \
# 	--revisions-output=$results/main_namespace_articles_20180420.tsv \
# 	--verbose \
# 	--debug > & \
# 	$results/main_namespace_articles_20180420_error_log.txt


# Next need to sample and dump results in a table


# tail -n +2 /export/scratch2/wmf/wbc_entity_usage/enwiki_monthly_item_quality/enwiki-20160801-20170701.monthly_scores.tsv | \
# 	grep -v -P "^[^\t]+\t[^\t]+\t[^\t]+\t20160801000000" > \
# 	/export/scratch2/wmf/wbc_entity_usage/enwiki_monthly_item_quality/enwiki.monthly_scores_20170701_no_header.tsv

# tail -n +2 /export/scratch2/wmf/wbc_entity_usage/enwiki_monthly_item_quality/enwiki20160801.monthly_scores.complete.tsv >> \
# 	/export/scratch2/wmf/wbc_entity_usage/enwiki_monthly_item_quality/enwiki.monthly_scores_20170701_no_header.tsv

# python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/revisions_postgres_post_process.py \
# 	/export/scratch2/wmf/wbc_entity_usage/enwiki_monthly_item_quality/enwiki.monthly_scores_20170701_no_header.tsv \
# 	--revisions-output=/export/scratch2/wmf/wbc_entity_usage/enwiki_monthly_item_quality/enwiki.monthly_scores_20170701_no_header_escaped_backslashes.tsv \
# 	--verbose \
# 	--debug > & \
# 	$results/enwiki.monthly_scores_20170701_no_header_escaped_backslashes_error_log.txt

# psql wikidata_entities < $base/monthly_item_quality_table/table_creation.sql
# psql wikidata_entities < $base/monthly_item_quality_table/table_import.sql

################################################################################################
echo "'enwiki_2016_2017_page_views' table creation and querying section"
################################################################################################

tail -n +2 /export/scratch2/wmf/wbc_entity_usage/page_views/pageview_rate.20170607.tsv | grep -P "^en\.wikipedia\t" | grep -v -P "^en\.wikipedia\tNULL" > \
	$results/enwiki_page_views_2016_2017.txt

echo "Dropping old version of 'enwiki_2016_2017_page_views' table (if it exists)."
psql wikidata_entities -c "drop table enwiki_2016_2017_page_views;"

psql wikidata_entities < $base/enwiki_2016_2017_page_views_table/table_creation.sql
psql wikidata_entities < $base/enwiki_2016_2017_page_views_table/table_import.sql
# psql wikidata_entities < $base/enwiki_2016_2017_page_views_table/remove_redundant_project_column.sql




