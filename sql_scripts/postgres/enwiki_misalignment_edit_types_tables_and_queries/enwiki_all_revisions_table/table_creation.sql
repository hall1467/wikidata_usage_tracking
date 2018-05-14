CREATE TABLE enwiki_all_revisions(
	page_title          VARCHAR(255),
	page_id             BIGINT,
	revision_id         BIGINT,
	user_id             VARCHAR(265),
	user_text           VARCHAR(265),
	comment             VARCHAR(355),
	namespace           BIGINT,
	revision_timestamp  BIGINT
);