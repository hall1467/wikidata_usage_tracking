import mwcli

router = mwcli.Router(
    "wbc_usage",
    "This script provides access to a set of utilities for tracking wikibase" +
    "client usage.",
    {'extract_usage': "Extract Wikibase client usage information from an " +
                      "(gross, icky) SQL file."}
)

main = router.main
