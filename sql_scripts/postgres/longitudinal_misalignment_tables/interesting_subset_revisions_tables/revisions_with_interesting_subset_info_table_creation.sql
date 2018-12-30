CREATE TABLE revisions_with_interesting_subset_info_table_creation AS (
	SELECT revisions_with_human_male_gender.*, human_female_items_12_29_18.page_title AS female_item
	FROM 
	(
		SELECT revisions_all_automation_flags_and_usages.*, human_male_items_12_29_18.page_title AS male_item
		FROM revisions_all_automation_flags_and_usages
		LEFT JOIN
		human_male_items_12_29_18
		ON revisions_all_automation_flags_and_usages.page_title = human_male_items_12_29_18.page_title
	) AS revisions_with_human_male_gender
	LEFT JOIN
	human_female_items_12_29_18
	ON revisions_with_human_male_gender.page_title = human_female_items_12_29_18.page_title
);