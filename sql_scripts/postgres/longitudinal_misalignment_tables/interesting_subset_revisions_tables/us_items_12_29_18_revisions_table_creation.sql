CREATE TABLE us_items_12_29_18_revisions AS (
	SELECT revisions_final.*
	FROM
	items_with_one_coordinate_location_processed_12_29_18
	INNER JOIN
	revisions_final
	ON revisions_final.page_title = us_items_12_29_18.page_title
	WHERE fip = 'NULL'
);