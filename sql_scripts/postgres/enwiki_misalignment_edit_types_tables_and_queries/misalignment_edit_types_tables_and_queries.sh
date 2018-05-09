
# First ran this to grab data from Wikimedia dumps

# wget -r -l 1 -A "enwiki-20180420-stub-meta-history*.xml.gz" -nd --reject "enwiki-20180420-stub-meta-history.xml.gz" -nv https://dumps.wikimedia.org/enwiki/20180420/

# Reusing the next two scripts since it doesn't make sense to create new ones doing essentially the same thing.

python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/edit_analyses/wikidata_revision_extraction.py \
	/export/scratch2/wmf/wbc_entity_usage/enwiki_page_revisions/enwiki-20180420-stub-meta-history* \
	--revisions-output=/export/scratch2/wmf/wbc_entity_usage/usage_results/enwiki_misalignment_edit_types_tables_and_queries/enwiki_page_revisions_20180420.tsv \
	--verbose \
	--debug > & \
	/export/scratch2/wmf/wbc_entity_usage/usage_results/enwiki_misalignment_edit_types_tables_and_queries/enwiki_page_revisions_20180420_error_log.txt

python /export/scratch2/wmf/scripts/wikidata_usage_tracking/python_analysis_scripts/revisions_postgres_post_process.py \
	/export/scratch2/wmf/wbc_entity_usage/usage_results/enwiki_misalignment_edit_types_tables_and_queries/enwiki_page_revisions_20180420.tsv \
	--revisions-output=/export/scratch2/wmf/wbc_entity_usage/usage_results/enwiki_misalignment_edit_types_tables_and_queries/enwiki_page_revisions_20180420_escaped_backslashes.tsv \
	--verbose \
	--debug > & \
	/export/scratch2/wmf/wbc_entity_usage/usage_results/enwiki_misalignment_edit_types_tables_and_queries/enwiki_page_revisions_20180420_escaped_backslashes_error_log.txt