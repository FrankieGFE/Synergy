

declare @STUDENT_ID as nvarchar(20)
 
-- Change to student ID
set @STUDENT_ID = '102790268'
 
SELECT FORMAT(r1.[add_date_time_stamp], 'yyyy-MM-dd hh:mm:ss tt')  as 'Changed Time',
       r3.[last_name] + ',' + r3.[first_name] as 'Changed By',
          r4.[name] AS 'Business Object',
          r0.[property_name] 'Property',
       r0.[new_value] as 'New Value',
       r0.[old_value] as 'Old Value',         
       r1.[crud_action] as 'Action'       
FROM   REV.[REV_AUDIT_TRAIL_PROP] r0
       INNER JOIN REV.[REV_AUDIT_TRAIL] r1
               ON ( r0.audit_trail_gu = r1.audit_trail_gu )
       LEFT OUTER JOIN REV.[REV_BOD_OBJECT] r4
                    ON ( r1.bod_object_gu = r4.bod_object_gu )
       LEFT OUTER JOIN REV.[REV_USER] r2
                    ON ( r1.add_id_stamp = r2.user_gu )
       LEFT OUTER JOIN REV.[REV_PERSON] r3
                   ON ( r2.user_gu = r3.person_gu )
WHERE  ((( r1.[parent_identity_gu] IN (SELECT STUDENT_SCHOOL_YEAR_GU FROM REV.EPC_STU_SCH_YR SSY INNER JOIN REV.EPC_STU S 
ON S.STUDENT_GU = SSY.STUDENT_GU WHERE SIS_NUMBER = @STUDENT_ID) AND
           r1.[bod_object_gu] = '1AA8CA46-4179-4CA0-9AB4-D1789694FDAF' )))
ORDER  BY r1.[add_date_time_stamp] DESC,r1.[add_id_stamp] ASC,r0.[audit_trail_gu] ASC 
