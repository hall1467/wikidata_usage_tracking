CREATE TABLE anonymous_session_gradient_boosting_bot_pred_table(
	revision_user                        VARCHAR(265),
	session_start                        BIGINT,
	mean_in_seconds                      DECIMAL,
	std_in_seconds                       DECIMAL,
	namespace_0_edits                    INT,
	namespace_1_edits                    INT,
	namespace_2_edits                    INT,
	namespace_3_edits                    INT,
	namespace_4_edits                    INT,
	namespace_5_edits                    INT,
	namespace_120_edits                  INT,
	namespace_121_edits                  INT,
	edits                                INT,
	session_length_in_seconds            DECIMAL,
	inter_edits_less_than_5_seconds      INT,
	inter_edits_between_5_and_20_seconds INT,
	inter_edits_greater_than_20_seconds  INT,
	claims                               INT,
	distinct_claims                      INT,
	distinct_pages                       INT,
	distinct_edit_kinds                  INT,
	generic_bot_comment                  INT,
	bot_revision_comment                 INT,
	sitelink_changes                     INT,
	alias_changed                        INT,
	label_changed                        INT,
	description_changed                  INT,
	edit_war                             INT,
	inter_edits_less_than_2_seconds      INT,
	things_removed                       INT,
	things_modified                      INT,
	bot_prediction                       INT
);