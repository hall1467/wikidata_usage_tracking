CREATE INDEX revision_and_bot_info_timestamp_index ON wikidata_page_revisions_with_timestamp(revision_timestamp);
CREATE INDEX revision_and_bot_info_page_title_index ON wikidata_page_revisions_with_timestamp(page_title);
CREATE INDEX revision_and_bot_info_revision_id_index ON wikidata_page_revisions_with_timestamp(revision_id);
CREATE INDEX wevision_and_bot_info_user_index ON wikidata_page_revisions_with_timestamp(revision_user);
CREATE INDEX revision_and_bot_info_comment_index ON wikidata_page_revisions_with_timestamp(comment);