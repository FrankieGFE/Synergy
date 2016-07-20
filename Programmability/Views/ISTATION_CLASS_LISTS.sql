
--CREATE VIEW [APS].[ST_MATH_STUDENTS] AS 



SELECT 
	--ENR.SCHOOL_CODE AS campus_id
	ENR.SIS_NUMBER as iid
	,ENR.SCHOOL_CODE AS distric_school_id
	,ENR.SCHOOL_NAME AS school
	,TCH.EMP_ID AS district_teacher_id
	,TCH.EMAIL AS teacher_email
	,TCH.FIRST_NAME AS teacher_last_name
	,PER.FIRST_NAME AS teacher_first_name
	,GRADE AS grade
	,'' AS [group]
	,'' AS fluency
	,PER.LAST_NAME AS student_last_name
	,PER.FIRST_NAME AS student_first_name
	,LEFT(PER.LAST_NAME,1) + ENR.SIS_NUMBER AS student_username
	,ENR.SIS_NUMBER AS student_password
	,'' AS permanent_login
	,CONVERT(DATE, BS.BIRTH_DATE) AS birthdate
	,'' AS mss
	,'' AS [action]

FROM
	APS.StudentEnrollmentDetails AS ENR
	LEFT JOIN
	rev.EPC_STU AS STU
	ON ENR.SIS_NUMBER = STU.SIS_NUMBER

	LEFT JOIN
	rev.REV_PERSON AS PER
	ON PER.PERSON_GU = STU.STUDENT_GU

	LEFT JOIN
	APS.BasicStudentWithMoreInfo AS BS
	ON BS.SIS_NUMBER = ENR.SIS_NUMBER

	LEFT JOIN
	APS.ScheduleAsOf ('07/21/2016') AS SCH  --- Change to getdate when school starts
	ON SCH.SIS_NUMBER = ENR.SIS_NUMBER

		INNER JOIN 
			(
			SELECT  
			SCH.SIS_NUMBER
			,SCH.COURSE_ID
			,SCH.COURSE_TITLE 
			,SCH.PERIOD_BEGIN
			,SCH.PERIOD_END
			,SCH.YEAR_GU
			,SCH.PRIMARY_STAFF
			,YR.SCHOOL_YEAR
			,PER.FIRST_NAME
			,PER.LAST_NAME
			,ST.BADGE_NUM
			,PER.EMAIL
			,CAST(replace(lower(st.BADGE_NUM), 'e', '')AS INT) AS EMP_ID
	
			FROM 
			APS.ScheduleDetailsAsOf ('07/20/2016') AS SCH --- Change to getdate in August

			LEFT JOIN
			REV.REV_YEAR AS YR
			ON YR.YEAR_GU = SCH.YEAR_GU

			LEFT JOIN
			REV.REV_PERSON AS PER
			ON SCH.STAFF_GU = PER.PERSON_GU

			LEFT JOIN 
			REV.EPC_STAFF AS ST
			ON PER.PERSON_GU = ST.STAFF_GU
			WHERE 1 = 1
			AND SCHOOL_YEAR = '2016'
			AND PERIOD_BEGIN = 1
			AND PRIMARY_STAFF = 1
			) AS TCH
		
		ON
		STU.SIS_NUMBER = TCH.SIS_NUMBER


WHERE 
	1 = 1
	AND ENR.SCHOOL_YEAR = '2016'
	AND EXTENSION = 'R'
	AND GRADE IN ('K','01','02','03')
	AND ENR.LEAVE_DATE IS NULL
	AND ENR.EXCLUDE_ADA_ADM IS NULL
	AND ENR.SUMMER_WITHDRAWL_CODE IS NULL
	--AND TCH.EMP_ID = '203050'

--ORDER BY id