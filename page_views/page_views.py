import mwcli

router = mwcli.Router(
    "page_views",
    "This script provides access to a set of utilities for downloading Wikipedia page view logs",
    {"page_view_dump_downloader": "Downloads page view dump data for specified range of dates."}
)

main = router.main
