CREATE TABLE enwiki_random_revisions_filtered_with_all_metadata AS (
	SELECT filtered_revisions_with_bots.*,
	(CASE WHEN comment LIKE '%AWB|AWB]]%' OR comment LIKE '%AutoWikiBrowser%' OR comment LIKE '% via awb %' THEN 'awb'
	 	  WHEN comment LIKE '%WP:AFCH%' THEN 'afch'
	 	  WHEN comment LIKE '%Scripts|CSDH%' THEN 'csdh'
	 	  WHEN comment LIKE '%[[Help:Cat-a-lot|Cat-a-lot]]%' THEN 'cat-a-lot'
	 	  WHEN comment LIKE '%|AutoEd]]%' THEN 'autoed'
	 	  WHEN comment LIKE '%[[:en:WP:REFILL|reFill]]%' THEN 'refill'
	 	  WHEN comment LIKE '%WP:HC|HotCat%' THEN 'hotcat'
	 	  WHEN comment LIKE '%WP:MOSNUMscript%' THEN 'mosnumscript'
	 	  WHEN comment LIKE '%WP:REFLINKS|Reflinks]%' THEN 'reflinks'
	 	  WHEN comment LIKE '%via CenPop%' THEN 'cenpop'
	 	  WHEN comment LIKE '%User:Ohconfucius/script|Script%' THEN 'ohconfucius'
	 	  WHEN comment LIKE '%User:GregU/dashes.js|script%' THEN 'gregu-dashes'
	 	  ELSE 'human_edit' END
	) AS agent_type
	FROM (
		  SELECT enwiki_all_revisions.*, username AS bot_username
		  FROM enwiki_randomly_selected_main_namespace_article_revisions
		  LEFT JOIN
		  enwiki_bots
		  ON enwiki_all_revisions.user_text = enwiki_bots.username
		  WHERE revision_timestamp <= 20170501000000
		) AS filtered_revisions_with_bots
	LEFT JOIN
	enwiki_2016_2017_page_views
	ON filtered_revisions_with_bots.page_id = enwiki_2016_2017_page_views.page_id
);




-- ## Need to make null page view values be 0 instead

