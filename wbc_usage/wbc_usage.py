import mwcli

router = mwcli.Router(
    "wbc_usage",
    "This script provides access to a set of utilities for tracking wikibase" +
    "client usage.",
    {'extract_usage': "Extract Wikibase client usage information from an " +
                      "(gross, icky) SQL file.",
	"aggregate_usage": "Aggregates usage information from json file.",
	"download_entity_usage": "Given json containing wiki(s), downloads corresponding\
	 Wikibase entity usage sql files."}
)

main = router.main
