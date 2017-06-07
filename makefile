results = ./results
usages = $(results)/usages.json
aggregated_usages = $(results)/aggregated_usages.json
wbc_entity_usage_storage = ./wbc_entity_usage_storage
date_for_dumps = 20170501
stderr_log = $(results)/stderr_log.txt

# date_for_dumps is formatted yyyymmdd

run:
	mkdir -p $(results)
	mkdir -p $(wbc_entity_usage_storage)
	python utility determine_wikis |\
	python utility download_entity_usage $(date_for_dumps) \
		$(wbc_entity_usage_storage) 2> $(stderr_log)
	python utility extract_usage $(wbc_entity_usage_storage)/* > $(usages) \
		2>> $(stderr_log)
	python utility aggregate_usage $(usages) --output=aggregated_usages \
		--file-output-prefix=$(results)/$(date_for_dumps)_ 2>> $(stderr_log)
	
clean:
	rm -r $(results)
	rm -r $(wbc_entity_usage_storage)