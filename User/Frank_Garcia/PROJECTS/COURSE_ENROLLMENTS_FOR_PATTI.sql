




--SELECT distinct
--	ORGANIZATION_NAME
--	,SIS_NUMBER
--	,LAST_NAME
--	,FIRST_NAME
--	,COURSE_ENTER_DATE
--	,COURSE_LEAVE_DATE
--	,TERM_CODE
--	,sche.COURSE_ID
--FROM
--	APS.ScheduleDetailsAsOf ('2017-11-14') SCHE
--	JOIN
--	REV.REV_PERSON PER
--	ON SCHE.STUDENT_GU = PER.PERSON_GU
--WHERE 1 = 1
--	--AND COURSE_ENTER_DATE = '2017-08-14 00:00:00' AND COURSE_LEAVE_DATE = '2017-08-14 00:00:00'
--	--AND COURSE_ENTER_DATE > GETDATE()
--	AND COURSE_ENTER_DATE = COURSE_LEAVE_DATE
--	AND TERM_CODE NOT IN ('S2','Q2','Q3','Q4')
--	--and first_name = 'kayla'
--ORDER BY COURSE_ENTER_DATE DESC	







SELECT distinct
	ORGANIZATION_NAME
	,SIS_NUMBER
	,LAST_NAME
	,FIRST_NAME
	,COURSE_ENTER_DATE
	,COURSE_LEAVE_DATE
	,TERM_CODE
	,sche.COURSE_ID
FROM
	APS.ScheduleDetailsAsOf (GETDATE()) SCHE
	JOIN
	REV.REV_PERSON PER
	ON SCHE.STUDENT_GU = PER.PERSON_GU
WHERE 1 = 1
	AND COURSE_ENTER_DATE = GETDATE()
	 AND COURSE_LEAVE_DATE = GETDATE()
	--AND COURSE_ENTER_DATE > '2017-08-14 00:00:00'
	--AND TERM_CODE NOT IN ('S2','Q2','Q3','Q4')
	--and first_name = 'kayla'
ORDER BY COURSE_ENTER_DATE DESC	







SELECT distinct
	ORGANIZATION_NAME
	,SIS_NUMBER
	,LAST_NAME
	,FIRST_NAME
	,COURSE_ENTER_DATE
	,COURSE_LEAVE_DATE
	,TERM_CODE
	,sche.COURSE_ID
FROM
	APS.ScheduleDetailsAsOf ('2017-11-14') SCHE
	JOIN
	REV.REV_PERSON PER
	ON SCHE.STUDENT_GU = PER.PERSON_GU
WHERE 1 = 1
	--AND COURSE_ENTER_DATE = '2017-08-14 00:00:00' AND COURSE_LEAVE_DATE = '2017-08-14 00:00:00'
	AND COURSE_ENTER_DATE > GETDATE()
	AND TERM_CODE NOT IN ('S2','Q2','Q3','Q4')
	--and first_name = 'kayla'
ORDER BY COURSE_ENTER_DATE DESC	