--<APS - Blackboard - Roles_Students>
--Header row - EXTERNAL_PERSON_KEY|ROLE_ID
--Must have a footer in the output like below with ***FileFooter|(only data row count)|run date time
--***FileFooter|92018|17:35:21 04/01/2014
SELECT 
     stu.SIS_NUMBER + '|' +        
     ltrim(rtrim(sch.SCHOOL_CODE)) + '_' + org.ORGANIZATION_NAME as DataRow


FROM rev.EPC_STU stu
JOIN rev.EPC_STU_SCH_YR ssyr        ON ssyr.STUDENT_GU = stu.STUDENT_GU
                                       AND ssyr.STATUS IS NULL
                                       AND ssyr.LEAVE_DATE IS NULL 
JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
                                       AND oyr.YEAR_GU IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
JOIN rev.REV_ORGANIZATION org       ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH sch                ON sch.ORGANIZATION_GU = org.ORGANIZATION_GU

