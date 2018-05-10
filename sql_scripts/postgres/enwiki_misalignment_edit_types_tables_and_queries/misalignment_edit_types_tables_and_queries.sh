set base = /export/scratch2/wmf/scripts/wikidata_usage_tracking/sql_scripts/postgres/enwiki_misalignment_edit_types_tables_and_queries
set results = /export/scratch2/wmf/wbc_entity_usage/usage_results/enwiki_misalignment_edit_types_tables_and_queries

# First ran this to grab data from Wikimedia dumps

# wget -r -l 1 -A "enwiki-20180420-stub-meta-history*.xml.gz" -nd --reject "enwiki-20180420-stub-meta-history.xml.gz" -nv https://dumps.wikimedia.org/enwiki/20180420/

# Reusing the next two scripts since it doesn't make sense to create new ones doing essentially the same thing.

# python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/edit_analyses/wikidata_revision_extraction.py \
# 	/export/scratch2/wmf/wbc_entity_usage/enwiki_page_revisions/enwiki-20180420-stub-meta-history* \
# 	--revisions-output=$results/enwiki_page_revisions_20180420.tsv \
# 	--verbose \
# 	--debug > & \
# 	$results/enwiki_page_revisions_20180420_error_log.txt

# python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/revisions_postgres_post_process.py \
# 	$results/enwiki_page_revisions_20180420.tsv \
# 	--revisions-output=$results/enwiki_page_revisions_20180420_escaped_backslashes.tsv \
# 	--verbose \
# 	--debug > & \
# 	$results/enwiki_page_revisions_20180420_escaped_backslashes_error_log.txt


################################################################################################
echo "'enwiki_monthly_item_quality' table creation and querying section"
################################################################################################


tail -n +2 /export/scratch2/wmf/wbc_entity_usage/enwiki_monthly_item_quality/enwiki-20160801-20170701.monthly_scores.tsv | \
	grep -v -P "^[^\t]+\t[^\t]+\t[^\t]+\t20160801000000" > \
	/export/scratch2/wmf/wbc_entity_usage/enwiki_monthly_item_quality/enwiki.monthly_scores_20170701_no_header.tsv

tail -n +2 /export/scratch2/wmf/wbc_entity_usage/enwiki_monthly_item_quality/enwiki20160801.monthly_scores.complete.tsv >> \
	/export/scratch2/wmf/wbc_entity_usage/enwiki_monthly_item_quality/enwiki.monthly_scores_20170701_no_header.tsv

psql wikidata_entities < $base/monthly_item_quality_table/table_creation.sql
psql wikidata_entities < $base/monthly_item_quality_table/table_import.sql