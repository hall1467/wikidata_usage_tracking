CREATE TABLE items_with_male_or_female_gender_revisions AS (
	SELECT revisions_final.*, male_item, female_item
	FROM 
	items_with_male_or_female_gender_12_29_18
	INNER JOIN
	revisions_final
	ON revisions_final.page_title = items_with_male_or_female_gender_12_29_18.page_title
	WHERE revisions_final.namespace = 0
);