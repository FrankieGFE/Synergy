--<APS - SchoolNet attendance_type data>

SELECT  
        abt.VALUE_CODE        AS [attendance_type_code]
      , abt.VALUE_DESCRIPTION AS [attendance_type_name]
      , '' AS [absence_type_code]
      , '' AS [absence_cost]
      , abt.VALUE_DESCRIPTION AS [absence_type_name]
FROM  rev.SIF_22_Common_GetLookupValues('K12.AttendanceInfo', 'ABSENCE_TYPE') abt
       