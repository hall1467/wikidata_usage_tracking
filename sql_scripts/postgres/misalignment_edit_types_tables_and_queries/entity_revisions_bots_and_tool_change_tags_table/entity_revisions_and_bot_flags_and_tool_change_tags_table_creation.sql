CREATE TABLE entity_revisions_and_bot_flags_and_tool_change_tags AS (
	SELECT entity_revisions_and_bot_flags.*, tools_based_on_change_tag.revision_id AS change_tag_revision_id
	FROM
	(
		SELECT entity_revisions.*, user_id AS bot_user_id
		FROM entity_revisions
		LEFT JOIN
		wikidata_bots
		ON user_id = revision_user
	) AS entity_revisions_and_bot_flags
	LEFT JOIN
	tools_based_on_change_tag
	ON entity_revisions_and_bot_flags.revision_id = tools_based_on_change_tag.revision_id
);