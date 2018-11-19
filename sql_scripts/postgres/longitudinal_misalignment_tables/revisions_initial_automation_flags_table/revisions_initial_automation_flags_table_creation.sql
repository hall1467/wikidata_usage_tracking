CREATE TABLE revisions_initial_automation_flags AS (
	SELECT revisions_and_bot_flags.*, tools_based_on_change_tag.revision_id AS change_tag_revision_id
	FROM
	(
		SELECT revisions.*, user_id AS bot_user_id
		FROM revisions
		LEFT JOIN
		wikidata_bots
		ON user_id = revision_user_id
	) AS revisions_and_bot_flags
	LEFT JOIN
	tools_based_on_change_tag
	ON revisions_and_bot_flags.revision_id = tools_based_on_change_tag.revision_id
);