CREATE TABLE s53311__wikidata_usage_and_views_p.pp_value_items AS
(
  	SELECT pp_value
	FROM enwiki_p.page_props
	WHERE pp_propname = 'wikibase_item'
);


CREATE TABLE s53311__wikidata_usage_and_views_p.2017_revisions AS
(
	select rev_page, rev_timestamp
	from wikidatawiki_p.revision
	where rev_timestamp >= 20170809000000 AND rev_timestamp < 20170810000000 and rev_comment like '/* wbsetsitelink-add:1|enwiki */%'
);

CREATE TABLE s53311__wikidata_usage_and_views_p.2015_revisions AS
(
	select rev_page, rev_timestamp
	from wikidatawiki_p.revision
	where rev_timestamp >= 20150809000000 AND rev_timestamp < 20150810000000 and rev_comment like '/* wbsetsitelink-add:1|enwiki */%'
);



select page_title
from s53311__wikidata_usage_and_views_p.2017_revisions
INNER JOIN
wikidatawiki_p.page
ON page_id = rev_page
where page_namespace = 0 AND page_title IN 
(
	SELECT pp_value
	FROM s53311__wikidata_usage_and_views_p.pp_value_items
);

select page_title
from s53311__wikidata_usage_and_views_p.2015_revisions
INNER JOIN
wikidatawiki_p.page
ON page_id = rev_page
where page_namespace = 0 AND page_title IN 
(
	SELECT pp_value
	FROM s53311__wikidata_usage_and_views_p.pp_value_items
);

select page_title
from s53311__wikidata_usage_and_views_p.2017_revisions
INNER JOIN
wikidatawiki_p.page
ON page_id = rev_page
where page_namespace = 0 AND page_title NOT IN 
(
	SELECT pp_value
	FROM s53311__wikidata_usage_and_views_p.pp_value_items
);

select page_title
from s53311__wikidata_usage_and_views_p.2015_revisions
INNER JOIN
wikidatawiki_p.page
ON page_id = rev_page
where page_namespace = 0 AND page_title NOT IN 
(
	SELECT pp_value
	FROM s53311__wikidata_usage_and_views_p.pp_value_items
);


