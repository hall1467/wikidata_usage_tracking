CREATE TABLE items_with_one_coordinate_location_revisions AS (
	(
		SELECT page_title 
		FROM (
			  SELECT page_title, count(*) as location_count 
			  FROM coordinate_location_items_12_29_18 
			  GROUP BY page_title
			 ) as page_title_counts 
		WHERE location_count <= 1
	) AS pages_without_multiple_locations
	INNER JOIN
	revisions_all_automation_flags_and_usages
	ON revisions_all_automation_flags_and_usages.page_title = pages_without_multiple_locations.page_title
	WHERE revisions_all_automation_flags_and_usages.namespace = 0
);