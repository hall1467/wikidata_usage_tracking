source anon_edits_for_used_entities_query_and_post_processing.sh
source registered_users_edits_for_used_entities_query_and_post_processing.sh
psql wikidata_entities < all_edits_for_user_entities.sql
psql wikidata_entities < used_entity_revision_comments.sql
psql wikidata_entities < edit_type_sums.sql
psql wikidata_entities < random_revisions.sql
psql wikidata_entities < semi_automated_revision_word_counts.sql