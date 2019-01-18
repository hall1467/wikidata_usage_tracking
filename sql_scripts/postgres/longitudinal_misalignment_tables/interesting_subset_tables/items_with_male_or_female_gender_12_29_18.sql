CREATE TABLE items_with_male_or_female_gender_12_29_18 AS (
	SELECT (CASE WHEN human_male_items_12_29_18.page_title IS NOT NULL THEN human_male_items_12_29_18.page_title 
	ELSE human_female_items_12_29_18.page_title END) as page_title, 
	human_male_items_12_29_18.page_title AS male_item,
	human_female_items_12_29_18.page_title AS female_item
	FROM human_male_items_12_29_18
	FULL JOIN
	human_female_items_12_29_18
	ON human_male_items_12_29_18.page_title = human_female_items_12_29_18.page_title
	WHERE (pages_with_male_or_female_gender.male_item IS NULL OR pages_with_male_or_female_gender.female_item IS NULL)
);