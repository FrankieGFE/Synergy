
ALTER VIEW [APS].[ISTATION_CLASSES] AS 



SELECT DISTINCT
	ENR.SCHOOL_CODE AS campus_id
	,ENR.SIS_NUMBER as id
	,PER.FIRST_NAME AS fname
	,PER.LAST_NAME AS lname
	,PER.MIDDLE_NAME AS mi
	,'' AS login_id 
	,'' AS password
	,GRADE AS grade
	,TCH.FIRST_NAME AS tfname
	,TCH.LAST_NAME AS tlname
	,TCH.EMAIL AS email
	,TCH.EMP_ID AS tid
	,TCH.BADGE_NUM AS tlogin_id --- teacher's login e012345
	,'' AS cid
	,'1' AS period
	,'' AS class_name
	,STU.STATE_STUDENT_NUMBER AS state_id
	,BS.GENDER AS GENDER
	,BS.RESOLVED_RACE AS RACE
	,BS.SPED_STATUS AS SPECIAL_ED
	,'' AS CLASS_INSTR
	,CASE WHEN BS.LUNCH_STATUS IN ('F','2') THEN 'Y' ELSE BS.LUNCH_STATUS
	END AS ECON_DISADV
	,BS.ELL_STATUS AS ENG_PROFICIENCY
	,BS.PRIMARY_DISABILITY_CODE AS DISABILITY
	,BS.GIFTED_STATUS AS 'G/T'
	,STU.HOME_LESS AS HOMELESS
	,STU.MIGRANT AS MIGRANT
	,BS.HISPANIC_INDICATOR AS ETHNICITY
	,CONVERT(DATE, BS.BIRTH_DATE) AS birthdate
	--,TCH.PERIOD_BEGIN
	--,TCH.PRIMARY_STAFF
	--,SCH.COURSE_ID
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
			APS.ScheduleDetailsAsOf ('07/21/2016') AS SCH

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
			AND EXTENSION = 'R'
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
	--AND  ENR.SIS_NUMBER = '970052733'

--ORDER BY id