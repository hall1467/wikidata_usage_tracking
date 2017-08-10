CREATE TABLE s53311__wikidata_usage_and_views_p.pp_value_items AS
(
  	SELECT pp_value
	FROM enwiki_p.page_props
	WHERE pp_propname = 'wikibase_item'
);

select page_title
from wikidatawiki_p.revision 
INNER JOIN
wikidatawiki_p.page
ON page_id = rev_page
where rev_comment like '/* wbsetsitelink-add:1|enwiki%' AND rev_timestamp >= 20170916000000 AND rev_timestamp < 20170916300000 AND page_namespace = 0 AND page_title IN 
(
	SELECT pp_value
	FROM s53311__wikidata_usage_and_views_p.pp_value_items
);


select page_title
from wikidatawiki_p.revision 
INNER JOIN
wikidatawiki_p.page
ON page_id = rev_page
where rev_comment like '/* wbsetsitelink-add:1|enwiki%' AND rev_timestamp >= 20170916000000 AND rev_timestamp < 20170916300000 AND page_namespace = 0 AND page_title NOT IN 
(
	SELECT pp_value
	FROM s53311__wikidata_usage_and_views_p.pp_value_items
);

select page_title
from wikidatawiki_p.revision 
INNER JOIN
wikidatawiki_p.page
ON page_id = rev_page
where rev_comment like '/* wbsetsitelink-add:1|enwiki%' AND rev_timestamp >= 20150916000000 AND rev_timestamp < 20150916300000 AND page_namespace = 0 AND page_title IN 
(
	SELECT pp_value
	FROM s53311__wikidata_usage_and_views_p.pp_value_items
);

select page_title
from wikidatawiki_p.revision 
INNER JOIN
wikidatawiki_p.page
ON page_id = rev_page
where rev_comment like '/* wbsetsitelink-add:1|enwiki%' AND rev_timestamp >= 20150916000000 AND rev_timestamp < 20150916300000 AND page_namespace = 0 AND page_title NOT IN 
(
	SELECT pp_value
	FROM s53311__wikidata_usage_and_views_p.pp_value_items
);