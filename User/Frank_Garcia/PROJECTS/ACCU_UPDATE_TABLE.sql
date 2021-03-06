BEGIN TRAN
SELECT
	STID
	,FName
	,MI
	,LName
	,DOB
	,SUBTEST
	,TEST
	,SCORE
	,APS_ID
	,test_level_name
	,test_date_code
	,school_Code
	,school_year
	,STARS.BIRTHDATE
FROM
	(	
	SELECT
		ACCU.STATE_ID AS STID
		,ACCU.First_Name AS FName
		,ACCU.Middle_Initial AS MI
		,ACCU.Last_Name AS LName
		,SUBSTRING (DOB_APS, 1,4)+ '-' + SUBSTRING(DOB_APS,5,2)+ '-'+SUBSTRING (DOB_APS,7,2) AS DOB
		,U2.SUBTEST
		,ACCU.[TEST DESCRIPTION] AS TEST
		,CASE
			WHEN SUBTEST = 'READING COMPREHENSION' THEN ACCU.[READING COMPREHENSION ]
			WHEN SUBTEST = 'SENTENCE SKILLS' THEN ACCU.[SENTENCE SKILLS]
			WHEN SUBTEST = 'ELEMENTARY ALGEBRA' THEN ACCU.[ELEMENTARY ALGEBRA]
			WHEN SUBTEST = 'COLLEGE-LEVEL MATH' THEN ACCU.[COLLEGE-LEVEL MATH]
			WHEN SUBTEST = 'ARITHMETIC' THEN ACCU.ARITHMETIC
			END
		AS SCORE
		,ACCU.APS_ID
		,'11' AS test_level_name
		,ACCU.Test_Date AS test_date_code
		,ACCU.[LOCATION CODE] AS school_Code
		,CASE
		WHEN ACCU.School_Year = '2009-10' THEN '2010'
		WHEN ACCU.School_Year = '2001-10' THEN '2010'
		WHEN ACCU.School_Year = '2010-11' THEN '2011'
		WHEN ACCU.School_Year = '2011-12' THEN '2012'
		WHEN ACCU.School_Year = '2012-13' THEN '2013'
		END
		AS school_year
		
		

	FROM SchoolNet.DBO.Temp_Table AS ACCU

	INNER JOIN
				(
				SELECT
					CNM_ID
					,STATE_ID AS STID
					,APS_ID
					,First_Name AS FName
					,Last_Name AS LName
					,Middle_Initial AS MI
					,DOB_APS AS DOB
					,Test_Date
					,[TEST DESCRIPTION] AS TEST
					,[LOCATION CODE]
					,SUBTEST

				FROM
					(
					SELECT CNM_Student_ID AS CNM_ID
							,APS_ID
							,STATE_ID
							,Last_Name
							,First_Name
							,Middle_Initial
							,DOB_APS
							,Test_Date
							,[TEST DESCRIPTION]
							,[READING COMPREHENSION]
							,[SENTENCE SKILLS]
							,ARITHMETIC
							,[ELEMENTARY ALGEBRA]
							,[COLLEGE-LEVEL MATH]
							,[LOCATION CODE]
							
					FROM SchoolNet.DBO.Temp_Table AS TEST

					) AS QM	
					UNPIVOT
					(QM FOR SUBTEST IN ([READING COMPREHENSION], [SENTENCE SKILLS], [ARITHMETIC], [ELEMENTARY ALGEBRA], [COLLEGE-LEVEL MATH])) AS U1
				) AS U2

			ON
			ACCU.CNM_Student_ID = U2.CNM_ID
			AND ACCU.Test_Date = U2.Test_Date
	)AS WHAT
  LEFT JOIN
  [046-WS02].[db_STARS_History].dbo.STUDENT AS STARS
  ON
  STARS.SY = school_year
  AND STARS.PERIOD = '2011-06-01'
  AND STARS.[DISTRICT CODE] = '001'
  AND FName = STARS.[FIRST NAME LONG]
  AND LName = STARS.[LAST NAME LONG]
  AND DOB = STARS.BIRTHDATE
  AND school_year = 2011
  


WHERE SCORE != ''	
AND school_year = 2011	




ROLLBACK