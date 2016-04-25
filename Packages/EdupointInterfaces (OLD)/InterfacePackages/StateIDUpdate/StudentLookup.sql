select stu.SIS_NUMBER
FROM rev.EPC_STU stu
JOIN rev.EPC_STU_SCH_YR ssyr                ON ssyr.STUDENT_GU = stu.STUDENT_GU 
JOIN rev.REV_ORGANIZATION_YEAR oyr          ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
                                               AND oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)