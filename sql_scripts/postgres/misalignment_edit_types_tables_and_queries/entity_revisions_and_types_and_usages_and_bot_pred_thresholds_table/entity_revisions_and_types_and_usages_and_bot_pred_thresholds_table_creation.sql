CREATE TABLE entity_revisions_and_types_and_usages_and_bot_pred_thresholds(
	page_title               VARCHAR(255),
	revision_id              BIGINT,
	revision_user            VARCHAR(265),
	comment                  VARCHAR(355),
	namespace                BIGINT,
	revision_timestamp       BIGINT,
	year                     BIGINT,
	month                    BIGINT,
	bot_user_id              VARCHAR(265),
	change_tag_revision_id   BIGINT,
	number_of_revisions      BIGINT,
	page_views               NUMERIC,
	edit_type                TEXT,
	year_month_page_title    TEXT,
	bot_prediction_threshold TEXT
);