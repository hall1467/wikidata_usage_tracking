site_usage_results = ../../../../wbc_entity_usage/usage_results/entity_usage_on_corresponding_articles
entity_usage_on_corresponding_articles_storage = ../../../../wbc_entity_usage/entity_usage_on_corresponding_articles_storage
page_storage = ../../../../wbc_entity_usage/page_storage
date_for_dumps = 20170801
entity_usage_on_corresponding_articles_sql = $(entity_usage_on_corresponding_articles_storage)/wikidatawiki-$(date_for_dumps)-wb_items_per_site.sql.gz
entity_usage_on_corresponding_articles = $(site_usage_results)/entity_usage_on_corresponding_articles.json
pages = $(site_usage_results)/pages.json
stderr_log = $(site_usage_results)/stderr_log.txt

# date_for_dumps is formatted yyyymmdd

run:
	mkdir -p $(site_usage_results)
	mkdir -p $(entity_usage_on_corresponding_articles_storage)
	mkdir -p $(page_storage)
	python ../../utility determine_wikis |\
	python download_page_tables.py $(date_for_dumps) \
		$(page_storage) 2> $(stderr_log)
	python extract_page_information.py $(page_storage)/* > $(entity_usage_on_corresponding_articles) \
		2>> $(stderr_log)
	python extract_site_usage_information.py $(entity_usage_on_corresponding_articles_sql)/* > $(entity_usage_on_corresponding_articles) \
		2>> $(stderr_log)



	
clean:
	rm -r $(site_usage_results)
	rm -r $(entity_usage_on_corresponding_articles_storage)
	rm -r $(page_storage)

