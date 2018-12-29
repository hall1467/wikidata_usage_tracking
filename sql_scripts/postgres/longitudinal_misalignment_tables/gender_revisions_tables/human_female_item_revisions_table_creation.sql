CREATE TABLE human_female_item_revisions AS (
	SELECT revisions_all_automation_flags_and_usages.*
	FROM human_female_items_12_29_18
	INNER JOIN
	revisions_all_automation_flags_and_usages
	ON revisions_all_automation_flags_and_usages.page_title = human_female_items_12_29_18.page_title
);