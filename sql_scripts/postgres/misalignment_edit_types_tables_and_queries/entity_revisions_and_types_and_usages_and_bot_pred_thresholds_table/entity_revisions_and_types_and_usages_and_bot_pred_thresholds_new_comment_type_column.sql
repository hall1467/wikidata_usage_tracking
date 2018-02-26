ALTER TABLE entity_revisions_and_types_and_usages_and_bot_pred_thresholds
ADD COLUMN reference_manipulation text;
ALTER TABLE entity_revisions_and_types_and_usages_and_bot_pred_thresholds
ADD COLUMN sitelink_manipulation text;
ALTER TABLE entity_revisions_and_types_and_usages_and_bot_pred_thresholds
ADD COLUMN label_description_or_alias_manipulation text;

UPDATE entity_revisions_and_types_and_usages_and_bot_pred_thresholds
SET reference_manipulation = (CASE WHEN lower(comment) LIKE '%reference%' THEN 'reference' END);

UPDATE entity_revisions_and_types_and_usages_and_bot_pred_thresholds
SET sitelink_manipulation = (CASE WHEN lower(comment) LIKE '%sitelink%' THEN 'sitelink' END);

UPDATE entity_revisions_and_types_and_usages_and_bot_pred_thresholds
SET label_description_or_alias_manipulation = (CASE WHEN lower(comment) LIKE '%alias%' OR lower(comment) LIKE '%label%' OR lower(comment) LIKE '%description%' THEN 'label_description_or_alias' END);
