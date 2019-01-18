CREATE TABLE items_with_one_coordinate_location_12_29_18 AS (
	SELECT revisions_all_automation_flags_and_usages.*, coordinate_location
	FROM
	(
		SELECT page_title_counts.page_title, coord_location_items_2.coordinate_location 
		FROM (
			  SELECT coord_location_items_1.page_title, count(*) as location_count 
			  FROM coordinate_location_items_12_29_18 as coord_location_items_1
			  GROUP BY page_title
			 ) as page_title_counts
		INNER JOIN
		coordinate_location_items_12_29_18 as coord_location_items_2
		ON page_title_counts.page_title = coord_location_items_2.page_title
		WHERE location_count <= 1
	) AS pages_without_multiple_locations
);