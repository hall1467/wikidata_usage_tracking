CREATE TABLE items_with_male_or_female_gender_revisions AS (
	SELECT revisions_all_automation_flags_and_usages.*, male_item, female_item
	FROM
	(
		SELECT (CASE WHEN human_male_items_12_29_18.page_title IS NOT NULL THEN human_male_items_12_29_18.page_title 
		ELSE human_female_items_12_29_18.page_title END) as page_title, 
		human_male_items_12_29_18.page_title AS male_item,
		human_female_items_12_29_18.page_title AS female_item
		FROM human_male_items_12_29_18
		FULL JOIN
		human_female_items_12_29_18
		ON human_male_items_12_29_18.page_title = human_female_items_12_29_18.page_title
	) AS pages_with_male_or_female_gender
	INNER JOIN
	revisions_all_automation_flags_and_usages
	ON revisions_all_automation_flags_and_usages.page_title = pages_with_male_or_female_gender.page_title
	WHERE revisions_all_automation_flags_and_usages.namespace = 0 AND 
	(pages_with_male_or_female_gender.male_item IS NULL OR pages_with_male_or_female_gender.female_item IS NULL)
);

