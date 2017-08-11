results = ../../../../wbc_entity_usage/usage_results/entity_usage_on_corresponding_articles
entity_usage_on_corresponding_articles = $(results)/entity_usage_on_corresponding_articles.tsv
wbc_entity_usage_storage = ./wbc_entity_usage_storage
date_for_dumps = 20170801
stderr_log = $(results)/stderr_log.txt

# date_for_dumps is formatted yyyymmdd

run:
	mkdir -p $(results)
	mkdir -p $(wbc_entity_usage_storage)
	python ../../utility determine_wikis |\
	python page_props $(date_for_dumps) \
		$(wbc_entity_usage_storage) 2> $(stderr_log)
	python extract_page_properties $(wbc_entity_usage_storage)/* > $(entity_usage_on_corresponding_articles) \
		2>> $(stderr_log)

	
clean:
	rm -r $(results)
	rm -r $(wbc_entity_usage_storage)

