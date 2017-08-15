CREATE INDEX revision_timestamp_index ON wikidata_page_revisions_with_timestamp(revision_timestamp);
CREATE INDEX with_timestamp_table_page_title_index ON wikidata_page_revisions_with_timestamp(page_title);
CREATE INDEX with_timestamp_table_revision_id_index ON wikidata_page_revisions_with_timestamp(revision_id);
CREATE INDEX with_timestamp_table_user_index ON wikidata_page_revisions_with_timestamp(revision_user);
CREATE INDEX with_timestamp_table_comment_index ON wikidata_page_revisions_with_timestamp(comment);
