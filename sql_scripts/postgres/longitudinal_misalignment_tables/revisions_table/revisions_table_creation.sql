CREATE TABLE revisions(
	page_title                  VARCHAR(255),
	revision_id                 BIGINT,
	revision_user_id            VARCHAR(265),
	revision_user_text          VARCHAR(265),
	comment                     VARCHAR(355),
	namespace                   BIGINT,
	revision_timestamp          BIGINT,
	revision_parent_id          VARCHAR(355),
	year                        BIGINT,
	month                       BIGINT,
	misalignment_matching_year  BIGINT,
	misalignment_matching_month BIGINT
);