results = ../../../../wbc_entity_usage/usage_results/entity_usage_on_corresponding_articles
entity_usage_on_corresponding_articles = $(results)/entity_usage_on_corresponding_articles.json
entity_usage_on_corresponding_articles_storage = ../../../../wbc_entity_usage/entity_usage_on_corresponding_articles_storage
date_for_dumps = 20170801
stderr_log = $(results)/stderr_log.txt

# date_for_dumps is formatted yyyymmdd

run:
	mkdir -p $(results)
	mkdir -p $(entity_usage_on_corresponding_articles_storage)
	python ../../utility determine_wikis |\
	python download_page_props $(date_for_dumps) \
		$(entity_usage_on_corresponding_articles_storage) 2> $(stderr_log)
	python extract_page_properties $(entity_usage_on_corresponding_articles_storage)/* > $(entity_usage_on_corresponding_articles) \
		2>> $(stderr_log)

	
clean:
	rm -r $(results)
	rm -r $(entity_usage_on_corresponding_articles_storage)

