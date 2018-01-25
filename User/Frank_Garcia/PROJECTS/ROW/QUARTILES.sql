---QUERY TO GET latest q1 AND q3 data  from the XTBL

Select

                DTBL_STUDENTS.STUDENT_ID


                , [Q1_Q3_MATH_PRE]
                , [Q1_Q3_READ_PRE]  
                , SchoolYear
                , STUDENT_CURRENT_GRADE_CODE
FROM k12inteL_dw.DTBL_STUDENTS
LEFT JOIN 
(
                SELECT 
                                DTBL_STUDENT_DETAILS.STUDENT_KEY
                                , SchoolYear
                                , [Q1_Q3_MATH_PRE]
                                , [Q1_Q3_READ_PRE]  
                                , ROW_NUMBER() OVER ( PARTITION BY StudentID ORDER BY SchoolYear DESC) RN
                FROM K12INTEL_DW.DTBL_STUDENT_DETAILS
                INNER JOIN [K12INTEL_USERDATA].[XTBL_ANNUAL_NM_QUARTILE]
                                ON DTBL_STUDENT_DETAILS.STUDENT_STATE_ID = StudentID
) QUARTILE
ON QUARTILE.STUDENT_KEY =  DTBL_STUDENTS.STUDENT_KEY 
AND QUARTILE.RN = 1
WHERE STUDENT_ACTIVITY_INDICATOR = 'Active'
