--<APS - Blackboard - Users Parents>
--Header row - SYSTEM_ROLE|INSTITUTION_ROLE|EXTERNAL_PERSON_KEY|USER_ID|PASSWORD|FIRSTNAME|LASTNAME
--No Footer record/row required

SELECT
'SYSTEM_ROLE|INSTITUTION_ROLE|EXTERNAL_PERSON_KEY|USER_ID|PASSWORD|FIRSTNAME|LASTNAME' as DataRow
UNION ALL
SELECT 
     'Observer|Observer|'+
     'P' + stu.SIS_NUMBER + '|' +
     'p' + stu.SIS_NUMBER + '|' +
     'p' + stu.SIS_NUMBER + '|' +
	 'Obs' + cast(row_number() over(order by stu.sis_number) as varchar(10)) +'|' +
	 'Obs' + cast(row_number() over(order by stu.sis_number) as varchar(10))

FROM rev.EPC_STU stu
JOIN rev.EPC_STU_SCH_YR ssyr        ON ssyr.STUDENT_GU = stu.STUDENT_GU
                                       AND ssyr.STATUS IS NULL
                                       AND ssyr.LEAVE_DATE IS NULL 
JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
                                       AND oyr.YEAR_GU IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)


