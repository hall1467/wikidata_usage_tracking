import mwcli

router = mwcli.Router(
    "wbc_usage",
    "This script provides access to a set of utilities for tracking wikibase" +
    "client usage.",
    {'extract_usage': "Extract Wikibase client usage information from an " +
                      "(gross, icky) SQL file.",
	"aggregate_usage": "Aggregates usage information from json file.",
	"determine_wikis": "Print all wikis to stdout.",
	"download_entity_usage": "Given json containing wiki(s), downloads " +
	"corresponding Wikibase entity usage sql files.",
	"entity_page_views": "Prints page views for each entity_aspect_wikidb. " + 
						 "Merges page view and entity usage data.",
	"download_page_views": "Downloads page views zipped file.",
	"entity_page_view_aggregator" : "Aggregates entity_aspect_wikidb_page_views"
									" returned from \"entity_page_views\".",
	"convert_json_to_tsv" : "Converts json resulting from utilities to TSV."},
)

main = router.main
