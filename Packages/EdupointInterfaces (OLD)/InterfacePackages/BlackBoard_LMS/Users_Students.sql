--<APS - Blackboard - Users_Students>
--Header row - SYSTEM_ROLE|INSTITUTION_ROLE|EXTERNAL_PERSON_KEY|USER_ID|PASSWORD|FIRSTNAME|MIDDLENAME|LASTNAME|STUDENT_ID
--Must have a footer in the output - Three asterisks, ‘FileFooter’, |, data row count, |, time file created, date MM/DD/YYYY||||||?
--***FileFooter|92043|17:35:38 04/01/2014||||||
SELECT 
     'None|Student|' +
     stu.SIS_NUMBER + '|' +
     stu.SIS_NUMBER + '|' +
     stu.SIS_NUMBER + '|' +
	 per.FIRST_NAME + '|' +
	 COALESCE(per.MIDDLE_NAME, '') + '|' +
	 per.LAST_NAME + '|' +
	 COALESCE(stu.STATE_STUDENT_NUMBER , '999999999') as DataRow



FROM rev.EPC_STU stu
JOIN rev.EPC_STU_SCH_YR ssyr        ON ssyr.STUDENT_GU = stu.STUDENT_GU
                                       AND ssyr.STATUS IS NULL
                                       AND ssyr.LEAVE_DATE IS NULL 
JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
                                       AND oyr.YEAR_GU IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
JOIN rev.REV_ORGANIZATION org       ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH sch                ON sch.ORGANIZATION_GU = org.ORGANIZATION_GU
JOIN rev.REV_PERSON     per         ON per.PERSON_GU = stu.STUDENT_GU

