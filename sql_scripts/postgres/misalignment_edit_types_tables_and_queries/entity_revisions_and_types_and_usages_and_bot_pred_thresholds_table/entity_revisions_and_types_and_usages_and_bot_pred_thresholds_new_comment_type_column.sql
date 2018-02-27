ALTER TABLE entity_revisions_and_types_and_usages_and_bot_pred_thresholds
ADD COLUMN reference_manipulation BOOLEAN;
ALTER TABLE entity_revisions_and_types_and_usages_and_bot_pred_thresholds
ADD COLUMN sitelink_manipulation BOOLEAN;
ALTER TABLE entity_revisions_and_types_and_usages_and_bot_pred_thresholds
ADD COLUMN label_description_or_alias_manipulation BOOLEAN;

UPDATE entity_revisions_and_types_and_usages_and_bot_pred_thresholds
SET reference_manipulation = (CASE WHEN lower(comment) LIKE '%reference%' THEN TRUE ELSE FALSE END);

UPDATE entity_revisions_and_types_and_usages_and_bot_pred_thresholds
SET sitelink_manipulation = (CASE WHEN lower(comment) LIKE '%sitelink%' THEN TRUE ELSE FALSE END);

UPDATE entity_revisions_and_types_and_usages_and_bot_pred_thresholds
SET label_description_or_alias_manipulation = (CASE WHEN lower(comment) LIKE '%alias%' OR lower(comment) LIKE '%label%' OR lower(comment) LIKE '%description%' THEN TRUE ELSE FALSE END);
