

SELECT 
	ORGANIZATION_NAME,SIS_NUMBER, LAST_NAME, FIRST_NAME, COURSE_ID, COURSE_TITLE, GFT

 FROM 
(
SELECT 
	ORGANIZATION_NAME
	,SIS_NUMBER
	,PERS.LAST_NAME
	,PERS.FIRST_NAME
	,CourseMaster.COURSE_ID
	,CourseMaster.COURSE_TITLE
	,GIFTED.COURSE_LEVEL
	,SCHTYP.SCHOOL_TYPE
	
 FROM
	APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enroll
	INNER JOIN
	APS.ScheduleAsOf(GETDATE()) AS Schedule
	ON
	Enroll.STUDENT_GU = Schedule.STUDENT_GU
	INNER JOIN
	rev.EPC_CRS AS CourseMaster
	ON
	Schedule.COURSE_GU = CourseMaster.COURSE_GU
	INNER JOIN
	rev.EPC_CRS_LEVEL_LST AS GIFTED
	ON
	GIFTED.COURSE_GU = Schedule.COURSE_GU
	INNER JOIN
	rev.EPC_STU AS STU
	ON
	STU.STUDENT_GU = Schedule.STUDENT_GU
	INNER JOIN
	rev.REV_PERSON AS PERS
	ON
	PERS.PERSON_GU = STU.STUDENT_GU
	INNER JOIN
	rev.EPC_SCH_YR_OPT AS SCHTYP
	ON
	SCHTYP.ORGANIZATION_YEAR_GU = Schedule.ORGANIZATION_YEAR_GU

	INNER JOIN
	rev.REV_ORGANIZATION AS ORG
	ON
	Schedule.ORGANIZATION_GU = ORG.ORGANIZATION_GU


	WHERE
	COURSE_LEVEL = 'GFT'
	OR
	SUBSTRING(CourseMaster.STATE_COURSE_CODE,5,1) = '6'

	
	) AS T1


PIVOT
(
MAX(COURSE_LEVEL)
FOR COURSE_LEVEL IN ([GFT], [A])
) AS PIVOTME


WHERE
SCHOOL_TYPE NOT IN (1,2)

ORDER BY GFT




	