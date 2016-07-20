


EXECUTE AS LOGIN='QueryFileUser'
GO
SELECT
	[FILE].IID
	,distric_school_id
	,EST.school
	,district_teacher_id
	,teacher_email
	,teacher_last_name
	,teacher_first_name
	,grade
	,[group]
	,fluency
	,student_id
	,student_last_name
	,student_first_name
	,student_username
	,student_password
	,permanent_login
	,birthdate
	,mss
	,[action]
FROM
(
SELECT 
	--ENR.SCHOOL_CODE AS campus_id
	'' AS iid
	,ENR.SCHOOL_CODE AS distric_school_id
	,CASE WHEN ENR.SCHOOL_NAME = 'Reginald Chavez Elementary School' THEN 'REGINALD CHAVEZ ELEM SCHOOL' 
	      WHEN ENR.SCHOOL_NAME = 'A. Montoya Elementary School' THEN 'A MONTOYA ELEMENTARY SCHOOL'
		  WHEN ENR.SCHOOL_NAME = 'Dolores Gonzales Elementary School' THEN 'DOLORES GONZALES ELEM SCHOOL'
		  WHEN ENR.SCHOOL_NAME = 'East San Jose Elementary School' THEN 'EAST SAN JOSE ELEMENTARY SCH'
		  WHEN ENR.SCHOOL_NAME = 'Edmund G. Ross Elementary School' THEN 'EDMUND G ROSS ELEM SCHOOL'
		  WHEN ENR.SCHOOL_NAME = 'Edward Gonzales Elementary School' THEN 'EDWARD GONZALES ELEM SCHOOL'
		  WHEN ENR.SCHOOL_NAME = 'George I. Sanchez Collaborative Community School' THEN 'GEORGE I SANCHEZ CMTY SCHOOL'
		  WHEN ENR.SCHOOL_NAME = 'Governor Bent Elementary School' THEN 'GOVERNOR BENT ELEM SCHOOL'
		  WHEN ENR.SCHOOL_NAME = 'Helen Cordero Elementary School' THEN 'HELEN CORDERO PRIMARY SCHOOL'
		  WHEN ENR.SCHOOL_NAME = 'Janet Kahn Fine Arts Academy a.k.a Eubank Elementary School' THEN 'EUBANK ELEMENTARY SCHOOL'
		  WHEN ENR.SCHOOL_NAME = 'Marie M. Hughes Elementary School' THEN 'MARIE M HUGHES ELEM SCHOOL'
		  WHEN ENR.SCHOOL_NAME = 'Mary Ann Binford Elementary School' THEN 'MARY ANN BINFORD ELEM SCHOOL'
		  WHEN ENR.SCHOOL_NAME = 'Matheson Park Elementary School' THEN 'MATHESON PARK ELEM SCHOOL'
		  WHEN ENR.SCHOOL_NAME = 'Mission Avenue Elementary School' THEN 'MISSION AVE ELEMENTARY SCHOOL'
		  WHEN ENR.SCHOOL_NAME = 'Mountain View Elementary School' THEN 'MOUNTAIN VIEW ELEM SCHOOL'
		  WHEN ENR.SCHOOL_NAME = 'Rudolfo Anaya Elementary School' THEN 'RUDOLFO ANAYA ELEMENTARY SCH'
		  WHEN ENR.SCHOOL_NAME = 'Sombra Del Monte Elementary School' THEN 'SOMBRA DEL MONTE ELEM SCHOOL'
		  WHEN ENR.SCHOOL_NAME = 'Susie Rayos Marmon Elementary School' THEN 'SUSIE RAYOS MARMON ELEM SCHOOL'
		  WHEN ENR.SCHOOL_NAME = '' THEN ''
		  WHEN ENR.SCHOOL_NAME = '' THEN ''
	ELSE ENR.SCHOOL_NAME
	END AS school
	,TCH.EMP_ID AS district_teacher_id
	,TCH.EMAIL AS teacher_email
	,TCH.FIRST_NAME AS teacher_last_name
	,PER.FIRST_NAME AS teacher_first_name
	,GRADE AS grade
	,'' AS [group]
	,'' AS fluency
	,ENR.SIS_NUMBER AS student_id
	,REPLACE (PER.LAST_NAME,',','') AS student_last_name
	,REPLACE (PER.FIRST_NAME, ',','') AS student_first_name
	,LEFT(PER.LAST_NAME,1) + ENR.SIS_NUMBER AS student_username
	,'#student1aps' AS student_password
	,'' AS permanent_login
	,CONVERT(VARCHAR, BS.BIRTH_DATE, 101) AS birthdate
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
	--AND TCH.EMP_ID = '70652'
) AS EST

		LEFT JOIN
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
			'SELECT * FROM admins_8_early_start_schools.csv'  
		)AS [FILE]
		ON [FILE].SCHOOL = EST.school

--ORDER BY grade

UNION

SELECT
	[FILE].IID
	,distric_school_id
	,ST.school
	,district_teacher_id
	,teacher_email
	,teacher_first_name
	,teacher_last_name
	,grade
	,[group]
	,fluency
	,student_id
	,student_last_name
	,student_first_name
	,student_username
	,student_password
	,permanent_login
	,birthdate
	,mss
	,[action]
FROM
(

SELECT 
	DISTINCT
	ROW_NUMBER () OVER (PARTITION BY ENR.SIS_NUMBER ORDER BY ENR.SIS_NUMBER DESC) AS RN
	,'' AS iid
	,ENR.SCHOOL_CODE AS distric_school_id
	,CASE WHEN LTRIM(RTRIM(ENR.SCHOOL_NAME)) = 'George I. Sanchez Collaborative Community School' THEN 'GEORGE I SANCHEZ CMTY SCHOOL' 
	      WHEN ENR.SCHOOL_NAME = '' THEN ''
	ELSE ENR.SCHOOL_NAME
	END AS school
	,TCH.EMP_ID AS district_teacher_id
	,TCH.EMAIL AS teacher_email
	,TCH.LAST_NAME AS teacher_last_name
	,TCH.FIRST_NAME AS teacher_first_name
	,GRADE AS grade
	,'' AS [group]
	,'' AS fluency
	,ENR.SIS_NUMBER AS student_id
	,REPLACE (PER.LAST_NAME,',','') AS student_last_name
	,REPLACE (PER.FIRST_NAME, ',','') AS student_first_name
	,ENR.SIS_NUMBER AS student_username
	,'#student1aps' AS student_password
	,'' AS permanent_login
	,CONVERT(VARCHAR, BS.BIRTH_DATE, 101) AS birthdate
	,'' AS mss
	,'' AS [action]

	,TCH.DEPARTMENT
	,TCH.PRIMARY_STAFF
	,TCH.PERIOD_BEGIN

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
	APS.ScheduleAsOf ('08/13/2016') AS SCH  --- Change to getdate when school starts
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
			,SCH.DEPARTMENT
			,CAST(replace(lower(st.BADGE_NUM), 'e', '')AS VARCHAR(9)) AS EMP_ID
	
			FROM 
			APS.ScheduleDetailsAsOf ('08/13/2016') AS SCH --- Change to getdate in August

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
			AND DEPARTMENT = 'MATH'
			--AND PERIOD_BEGIN = 1
			AND PRIMARY_STAFF = 1
			) AS TCH
		
		ON
		STU.SIS_NUMBER = TCH.SIS_NUMBER
		
WHERE 
	1 = 1
	AND ENR.SCHOOL_YEAR = '2016'
	AND EXTENSION = 'R'
	AND GRADE IN ('06','07','08')
	AND ENR.LEAVE_DATE IS NULL
	AND ENR.EXCLUDE_ADA_ADM IS NULL
	AND ENR.SUMMER_WITHDRAWL_CODE IS NULL
	AND TCH.BADGE_NUM NOT LIKE 'SPDPR%'
	--AND TCH.EMP_ID = '203050'
) AS ST

		LEFT JOIN
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
			'SELECT * FROM admins_8_early_start_schools.csv'  
		)AS [FILE]
		ON [FILE].SCHOOL = ST.school

WHERE 1 = 1
AND RN = 1
ORDER BY IID, school

