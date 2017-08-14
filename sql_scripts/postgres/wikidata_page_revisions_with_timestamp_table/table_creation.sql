CREATE TABLE wikidata_page_revisions_with_timestamp(
	page_title         VARCHAR(255),
	revision_id        BIGINT,
	revision_user      VARCHAR(265),
	comment            VARCHAR(355),
	namespace          BIGINT,
	revision_timestamp BIGINT
);