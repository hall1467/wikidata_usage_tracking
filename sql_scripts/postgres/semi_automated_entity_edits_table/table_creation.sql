CREATE TABLE semi_automated_entity_edits AS(
    SELECT year, month, type_of_semi_automated_edit, count(*) 
    FROM
    (SELECT semi_automated_edits.*
     FROM (
              SELECT page_title, year, month, type_of_semi_automated_edit, count(*) 
              FROM entity_monthly_types_of_semi_automated_edits
              WHERE type_of_semi_automated_edit IS NOT NULL 
              GROUP BY page_title, year, month, type_of_semi_automated_edit
          ) AS semi_automated_edits
          ,
          misalignment_and_edits as misalignment 
          WHERE semi_automated_edits.page_title = misalignment.entity_id 
              AND ((semi_automated_edits.month < 12 AND semi_automated_edits.year = misalignment.year AND semi_automated_edits.month+1 = misalignment.month) 
                  OR (semi_automated_edits.month = 12 AND semi_automated_edits.year+1 = misalignment.year AND misalignment.month = 1))) AS semi_automated_entity_edits
    GROUP BY year, month, type_of_semi_automated_edit
);