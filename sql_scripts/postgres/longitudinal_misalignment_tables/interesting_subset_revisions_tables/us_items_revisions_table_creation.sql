CREATE TABLE us_items_revisions AS (
	SELECT revisions_all_automation_flags_and_usages.*
	FROM
	items_with_one_coordinate_location_processed_12_29_18
	INNER JOIN
	revisions_all_automation_flags_and_usages
	ON revisions_all_automation_flags_and_usages.page_title = items_with_one_coordinate_location_processed_12_29_18.page_title
	WHERE fip != 'NULL' and revisions_all_automation_flags_and_usages.namespace = 0
);