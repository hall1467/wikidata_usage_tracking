CREATE INDEX page_title_index ON wikidata_page_revisions(page_title);
CREATE INDEX revision_id_index ON wikidata_page_revisions(revision_id);
CREATE INDEX user_index ON wikidata_page_revisions(revision_user);
CREATE INDEX comment_index ON wikidata_page_revisions(comment);
