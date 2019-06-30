ALTER TABLE revisions_all_automation_flags_and_usages
ADD COLUMN original_page_views numeric;

UPDATE revisions_all_automation_flags_and_usages
SET original_page_views = page_views;

UPDATE revisions_all_automation_flags_and_usages
SET page_views = 0
WHERE page_views IS NULL;
