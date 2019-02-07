CREATE TABLE items_with_one_coordinate_location_revisions AS (
	SELECT revisions_final.*, coordinate_location
	FROM
	items_with_one_coordinate_location_12_29_18
	INNER JOIN
	revisions_final
	ON revisions_final.page_title = items_with_one_coordinate_location_12_29_18.page_title
	WHERE revisions_final.namespace = 0
);