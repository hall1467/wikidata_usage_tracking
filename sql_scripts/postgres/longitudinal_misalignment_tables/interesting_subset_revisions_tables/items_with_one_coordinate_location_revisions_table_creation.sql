CREATE TABLE items_with_one_coordinate_location_revisions AS (
	SELECT revisions_all_automation_flags_and_usages.*, coordinate_location
	FROM
	items_with_one_coordinate_location_12_29_18
	INNER JOIN
	revisions_all_automation_flags_and_usages
	ON revisions_all_automation_flags_and_usages.page_title = items_with_one_coordinate_location_12_29_18.page_title
	WHERE revisions_all_automation_flags_and_usages.namespace = 0
);