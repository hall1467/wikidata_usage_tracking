CREATE TABLE revisions_final AS (
	SELECT *
	FROM revisions_all_automation_flags_and_usages
	WHERE (comment !~* '^/\*\s\S*client' and 
		  comment !~* '^/\*\s\S*merge' and 
		  comment !~* '^/\*\s\S*sitelnk') and
		  revision_parent_id != 'NULL'
);
