EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT 
ROW_NUMBER() OVER (PARTITION BY T2.[Local Student Identifier] ORDER BY T2.[Test Code] DESC) AS RN,
T2.*, PARCC.* 
FROM 
(
SELECT 
	'NM' AS [State Abbreviation]
	,1 AS [Testing District]
	,PRIM.SCHOOL_CODE AS [Testing School]
	,'' AS [Responsible District Code]
	,PRIM.SCHOOL_CODE  AS [Responsible School Code]

	,STU.STATE_STUDENT_NUMBER AS [State Student Identifier]
	,STU.SIS_NUMBER AS [Local Student Identifier]
	,STU.STUDENT_GU AS [PARCC Student ID]
	,PERS.LAST_NAME AS [Last or Surname]
	,PERS.FIRST_NAME AS [First Name]
	,CASE WHEN PERS.MIDDLE_NAME IS NULL THEN '' ELSE PERS.MIDDLE_NAME END AS [Middle Name]
	,CAST(PERS.BIRTH_DATE AS DATE) AS [Birthdate]

	,PERS.GENDER AS [Sex]
	,'' AS [State Field 1]
	--,'2015-2016' AS [Optional State Data 1]
	,PRIM.GRADE AS [Grade Level When Assessed]
	,PERS.HISPANIC_INDICATOR AS [Hispanic or Latino Ethnicity]
	,CASE WHEN PERS.RACE_1 = 'Native American' THEN 'Y' 
			WHEN PERS.RACE_2 = 'Native American' THEN 'Y' 
			WHEN PERS.RACE_3 = 'Native American' THEN 'Y' 
			WHEN PERS.RACE_4 = 'Native American' THEN 'Y' 
			WHEN PERS.RACE_5 = 'Native American' THEN 'Y' 
	ELSE 'N' END AS [American Indian or Alaska Native]
	,CASE WHEN PERS.RACE_1 = 'Asian' THEN 'Y' 
			WHEN PERS.RACE_2 = 'Asian' THEN 'Y' 
			WHEN PERS.RACE_3 = 'Asian' THEN 'Y' 
			WHEN PERS.RACE_4 = 'Asian' THEN 'Y' 
			WHEN PERS.RACE_5 = 'Asian' THEN 'Y' 
	ELSE 'N' END AS [Asian]
	,CASE WHEN PERS.RACE_1 = 'African-American' THEN 'Y' 
			WHEN PERS.RACE_2 = 'African-American' THEN 'Y' 
			WHEN PERS.RACE_3 = 'African-American' THEN 'Y' 
			WHEN PERS.RACE_4 = 'African-American' THEN 'Y' 
			WHEN PERS.RACE_5 = 'African-American' THEN 'Y' 
	ELSE 'N' END AS [Black or African American]
	,CASE WHEN PERS.RACE_1 = 'Pacific Islander' THEN 'Y' 
			WHEN PERS.RACE_2 = 'Pacific Islander' THEN 'Y' 
			WHEN PERS.RACE_3 = 'Pacific Islander' THEN 'Y' 
			WHEN PERS.RACE_4 = 'Pacific Islander' THEN 'Y' 
			WHEN PERS.RACE_5 = 'Pacific Islander' THEN 'Y' 
	ELSE 'N' END AS [Native Hawaiian or Other Pacific Islander]
	,CASE WHEN PERS.RACE_1 = 'White' THEN 'Y' 
			WHEN PERS.RACE_2 = 'White' THEN 'Y' 
			WHEN PERS.RACE_3 = 'White' THEN 'Y' 
			WHEN PERS.RACE_4 = 'White' THEN 'Y' 
			WHEN PERS.RACE_5 = 'White' THEN 'Y' 
	ELSE 'N' END AS [White]

	,'' AS [Blank Field]

	,CASE WHEN PERS.RESOLVED_RACE = 'Two or More' THEN 'Y' ELSE 'N' END AS [Two or More Races]

	,ELL_STATUS AS [English Learner (El)]
	,ELL_STATUS AS [Title III Limited English Proficient Participation Status]

	,GIFTED_STATUS AS [Gifted and Talented]
	,MIGRANT AS [Migrant Status]
	,CASE WHEN LUNCH_STATUS IN ( '2', 'F', 'R', 'C') THEN 'Y' ELSE 'N' END  AS [Economic Disadvantage Status]
	
	,CASE
		WHEN PRIMARY_DISABILITY_CODE != 'GI' AND PRIM.ACCESS_504 IS NOT NULL THEN '504' 
		WHEN PRIMARY_DISABILITY_CODE != 'GI' AND SPED_STATUS = 'Y' THEN 'IEP' ELSE '' END AS [Student With Disabilities]

	,CASE WHEN PRIMARY_DISABILITY_CODE != 'GI' THEN SPED.ALT_CODE_SIF ELSE '' END AS [Primary Disability Type]

	,'20170217' AS [State Field 2]
	,'' AS [State Field 3]
	,'' AS [State Field 4]
	
	,CASE WHEN ELAMTH0305.[Optional State Data 5] IS NOT NULL THEN ELAMTH0305.[Optional State Data 5] 
		  WHEN ELAMTH0608.[Optional State Data 5] IS NOT NULL THEN ELAMTH0608.[Optional State Data 5]
		  WHEN ELAMTH0911.[Optional State Data 5] IS NOT NULL THEN ELAMTH0911.[Optional State Data 5]
	END AS [State Field 5]
	
	,'PUBLIC' AS [State Field 6]
	,'' AS [State Field 7]
	,'' AS [State Field 8]


	,'' AS [State Field 9]
	,'' AS [State Field 10]
	,'' AS [State Field 11]
	,'' AS [State Field 12]


	,CASE WHEN ELAMTH0305.[Assessment Session Location] IS NOT NULL THEN ELAMTH0305.[Assessment Session Location] 
		  WHEN ELAMTH0608.[Assessment Session Location] IS NOT NULL THEN ELAMTH0608.[Assessment Session Location]
		  WHEN ELAMTH0911.[Assessment Session Location] IS NOT NULL THEN ELAMTH0911.[Assessment Session Location]
	END AS [Session Name]


	--,'' AS [Assessment Session Test Administrator Identifier]

	,CASE WHEN ELAMTH0305.[Classroom Identifier] IS NOT NULL THEN ELAMTH0305.[Classroom Identifier] 
			WHEN ELAMTH0608.[Classroom Identifier] IS NOT NULL THEN ELAMTH0608.[Classroom Identifier]
			WHEN ELAMTH0911.[Classroom Identifier] IS NOT NULL THEN ELAMTH0911.[Classroom Identifier]
	END AS [Class Name]

	,'' AS [Test Administrator]
	
	,CASE WHEN ELAMTH0305.[Staff Member Identifier] IS NOT NULL THEN ELAMTH0305.[Staff Member Identifier]
			WHEN ELAMTH0608.[Staff Member Identifier] IS NOT NULL THEN ELAMTH0608.[Staff Member Identifier]
			WHEN ELAMTH0911.[Staff Member Identifier] IS NOT NULL THEN ELAMTH0911.[Staff Member Identifier]
			
	END AS [Staff Member Identifier]


	,CASE WHEN ELAMTH0305.[Test Code] IS NOT NULL THEN ELAMTH0305.[Test Code]
			WHEN ELAMTH0608.[Test Code] IS NOT NULL THEN ELAMTH0608.[Test Code]
			WHEN ELAMTH0911.[Test Code] IS NOT NULL THEN ELAMTH0911.[Test Code]

	END AS [Test Code]

	,CASE WHEN SCHOOL_CODE = '591' THEN 'P' ELSE 'O' END AS [Test Format]

	,'N' AS [Retest]

FROM 
	APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
	INNER JOIN 
	rev.EPC_STU AS STU
	ON
	PRIM.STUDENT_GU = STU.STUDENT_GU
	INNER JOIN 
	APS.BasicStudentWithMoreInfo AS PERS
	ON
	STU.STUDENT_GU = PERS.STUDENT_GU

	LEFT JOIN
	APS.LookupTable('K12.SpecialEd', 'DISABILITY_CODE') AS SPED
	ON
	SPED.VALUE_CODE = PERS.PRIMARY_DISABILITY_CODE


	/************************************
	03-05 ELA AND MTH
	*************************************/
	LEFT JOIN 
	
		(SELECT 	
		SCH.STUDENT_GU
		,SCH.COURSE_ID AS [Optional State Data 5]
		,SCH.[TEACHER NAME] AS [Assessment Session Location]
		,SCH.COURSE_ID + '-'+ SCH.SECTION_ID + '-'+ STF.STATE_ID AS [Classroom Identifier]
		,SCH.[TEACHER NAME] AS [Staff Member Identifier]
		,'ELA' + PRIM.GRADE AS [Test Code]
		,SCH.SIS_NUMBER

		FROM 
		APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
		INNER JOIN 
		APS.ScheduleDetailsAsOf(GETDATE()) AS SCH
		ON
		PRIM.STUDENT_GU = SCH.STUDENT_GU
		AND 
		PRIM.ORGANIZATION_YEAR_GU = SCH.ORGANIZATION_YEAR_GU
		--INNER HASH JOIN 
		--APS.TermDatesAsOf(GETDATE()) AS TRMS
		--ON
		--SCH.TERM_CODE = TRMS.TermCode
		--AND TRMS.OrgYearGU = SCH.ORGANIZATION_YEAR_GU
		INNER JOIN 
		rev.EPC_STAFF AS STF
		ON
		SCH.STAFF_GU = STF.STAFF_GU

		WHERE
		(PRIM.GRADE IN ('03', '04', '05')
		OR PRIM.SCHOOL_CODE = '900')
		AND PERIOD_BEGIN = '01'
		AND SCH.PRIMARY_STAFF = 1
		AND SCH.TERM_CODE IN ('YR', 'S2')

		UNION ALL
		SELECT 	
			SCH.STUDENT_GU
			,SCH.COURSE_ID AS [Optional State Data 5]
			,SCH.[TEACHER NAME] AS [Assessment Session Location]
			,SCH.COURSE_ID + '-'+ SCH.SECTION_ID + '-'+ STF.STATE_ID AS [Classroom Identifier]
			,SCH.[TEACHER NAME] AS [Staff Member Identifier]
			,'MAT' + PRIM.GRADE AS [Test Code]
			,SCH.SIS_NUMBER

		FROM 
		APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
		INNER JOIN 
		APS.ScheduleDetailsAsOf(GETDATE()) AS SCH
		ON
		PRIM.STUDENT_GU = SCH.STUDENT_GU
		AND 
		PRIM.ORGANIZATION_YEAR_GU = SCH.ORGANIZATION_YEAR_GU
		--INNER HASH JOIN 
		--APS.TermDatesAsOf(GETDATE()) AS TRMS
		--ON
		--SCH.TERM_CODE = TRMS.TermCode
		--AND TRMS.OrgYearGU = SCH.ORGANIZATION_YEAR_GU

		INNER JOIN 
		rev.EPC_STAFF AS STF
		ON
		SCH.STAFF_GU = STF.STAFF_GU

		WHERE
		(PRIM.GRADE IN ('03', '04', '05')
		OR PRIM.SCHOOL_CODE = '900')
		AND PERIOD_BEGIN = '01'
		AND SCH.PRIMARY_STAFF = 1
		AND SCH.TERM_CODE IN ('YR', 'S2')
		) AS ELAMTH0305
		
		ON
		PRIM.STUDENT_GU = ELAMTH0305.STUDENT_GU

LEFT JOIN 		
		(
		/******************************************
		06-08 ELA
		********************************************/
		SELECT * FROM (SELECT 	
			SCH.STUDENT_GU
			,SCH.COURSE_ID AS [Optional State Data 5]
			,SCH.[TEACHER NAME] + '-'+  DCM.COURSE_SHORT_TITLE + '-'+ SCH.SECTION_ID + '-'+ CAST(SCH.PERIOD_BEGIN AS VARCHAR)  AS [Assessment Session Location]
			,SCH.COURSE_ID + '-'+ SCH.SECTION_ID + '-'+ STF.STATE_ID AS [Classroom Identifier]
			,SCH.[TEACHER NAME] AS [Staff Member Identifier]
			,CASE WHEN SCH.DEPARTMENT = 'Eng' THEN 'ELA' + PRIM.GRADE
			END	 AS [Test Code]
	
			,SIS_NUMBER
			--,SCH.COURSE_ID + '-'+ SCH.SECTION_ID + '-'+ STF.STATE_ID 
			,ROW_NUMBER() OVER (PARTITION BY SCH.STUDENT_GU, SCH.DEPARTMENT ORDER BY SCH.COURSE_ID DESC) AS RN

		FROM 
		APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
		INNER JOIN 
		APS.ScheduleDetailsAsOf(GETDATE()) AS SCH
		ON
		PRIM.STUDENT_GU = SCH.STUDENT_GU
		AND 
		PRIM.ORGANIZATION_YEAR_GU = SCH.ORGANIZATION_YEAR_GU
		--INNER HASH JOIN 
		--APS.TermDatesAsOf(GETDATE()) AS TRMS
		--ON
		--SCH.TERM_CODE = TRMS.TermCode
		--AND TRMS.OrgYearGU = SCH.ORGANIZATION_YEAR_GU

		INNER JOIN 
		rev.EPC_CRS AS DCM
		ON
		SCH.COURSE_GU = DCM.COURSE_GU

		INNER JOIN 
		rev.EPC_STAFF AS STF
		ON
		SCH.STAFF_GU = STF.STAFF_GU

		WHERE
		PRIM.GRADE IN ('06', '07', '08')
		AND SCH.PRIMARY_STAFF = 1
		AND SCH.DEPARTMENT IN ('Eng')
		AND SCH.TERM_CODE IN ('YR', 'S2', 'Q3', 'Q4')
		) AS T1		
			WHERE RN = 1


UNION ALL
		/******************************************
		06-08 MTH
		********************************************/

		SELECT * FROM(SELECT 	
			SCH.STUDENT_GU
			,SCH.COURSE_ID AS [Optional State Data 5]
			,SCH.[TEACHER NAME] + '-'+  DCM.COURSE_SHORT_TITLE + '-'+ SCH.SECTION_ID + '-'+ CAST(SCH.PERIOD_BEGIN AS VARCHAR)  AS [Assessment Session Location]
			,SCH.COURSE_ID + '-'+ SCH.SECTION_ID + '-'+ STF.STATE_ID AS [Classroom Identifier]
			,SCH.[TEACHER NAME] AS [Staff Member Identifier]
			,CASE WHEN PRIM.GRADE = '08' AND SCH.COURSE_TITLE LIKE 'ALGEBRA%' THEN 'ALG' + '01'
				WHEN PRIM.GRADE = '08' AND SCH.COURSE_TITLE LIKE 'GEOM%' THEN 'GEO' + '01'
				WHEN SCH.DEPARTMENT = 'Math' THEN 'MAT' + PRIM.GRADE 
			END	 AS [Test Code]
	
			,SIS_NUMBER
			--,SCH.COURSE_ID + '-'+ SCH.SECTION_ID + '-'+ STF.STATE_ID 
			,ROW_NUMBER() OVER (PARTITION BY SCH.STUDENT_GU, SCH.DEPARTMENT ORDER BY SCH.COURSE_ID DESC) AS RN

		FROM 
		APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
		INNER JOIN 
		APS.ScheduleDetailsAsOf(GETDATE()) AS SCH
		ON
		PRIM.STUDENT_GU = SCH.STUDENT_GU
		AND 
		PRIM.ORGANIZATION_YEAR_GU = SCH.ORGANIZATION_YEAR_GU
		--INNER HASH JOIN 
		--APS.TermDatesAsOf(GETDATE()) AS TRMS
		--ON
		--SCH.TERM_CODE = TRMS.TermCode
		--AND TRMS.OrgYearGU = SCH.ORGANIZATION_YEAR_GU
		INNER JOIN 
		rev.EPC_CRS AS DCM
		ON
		SCH.COURSE_GU = DCM.COURSE_GU

		INNER JOIN 
		rev.EPC_STAFF AS STF
		ON
		SCH.STAFF_GU = STF.STAFF_GU

		WHERE
		PRIM.GRADE IN ('06', '07', '08')
		AND SCH.PRIMARY_STAFF = 1
		AND SCH.DEPARTMENT IN ('Math')
		AND SCH.TERM_CODE IN ('YR', 'S2', 'Q3', 'Q4')
			) AS T1		
			WHERE RN = 1
) AS ELAMTH0608

ON
ELAMTH0608.STUDENT_GU = PRIM.STUDENT_GU

LEFT JOIN 
(
		/***********************************************
		09-11 MTH
		************************************************/
		SELECT * FROM  (
			SELECT 	
						SCH.STUDENT_GU
						,SCH.COURSE_ID AS [Optional State Data 5]
						,SCH.COURSE_TITLE
						,SCH.[TEACHER NAME] + '-'+  DCM.COURSE_SHORT_TITLE + '-'+ SCH.SECTION_ID + '-'+ CAST(SCH.PERIOD_BEGIN AS VARCHAR)  AS [Assessment Session Location]
						,SCH.COURSE_ID + '-'+ SCH.SECTION_ID + '-'+ STF.STATE_ID AS [Classroom Identifier]
						,SCH.[TEACHER NAME] AS [Staff Member Identifier]
						,CASE	
							WHEN [GROUP] LIKE 'ALG 1%' THEN  'ALG' + '01'	
							WHEN [GROUP] LIKE 'GEOM%' THEN 'GEO' + '01'
							WHEN DCM.COURSE_TITLE IN ('MATH 1', 'MATH 2', 'MATH3') THEN 'ALG' + '01'
						ELSE 'ALG' + '02'				
						END	 AS [Test Code]
						,SIS_NUMBER
						,ROW_NUMBER() OVER (PARTITION BY SCH.STUDENT_GU ORDER BY SCH.COURSE_ID DESC) AS RN

					FROM 
					APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
					INNER JOIN 
					APS.ScheduleDetailsAsOf(GETDATE()) AS SCH
					ON
					PRIM.STUDENT_GU = SCH.STUDENT_GU
					AND 
					PRIM.ORGANIZATION_YEAR_GU = SCH.ORGANIZATION_YEAR_GU
		--			INNER HASH JOIN 
		--APS.TermDatesAsOf(GETDATE()) AS TRMS
		--ON
		--SCH.TERM_CODE = TRMS.TermCode
		--AND TRMS.OrgYearGU = SCH.ORGANIZATION_YEAR_GU
					INNER JOIN 
					rev.EPC_CRS AS DCM
					ON
					SCH.COURSE_GU = DCM.COURSE_GU

					LEFT JOIN 
					rev.UD_CRS_GROUP AS GRPS
					ON 
					GRPS.COURSE_GU = DCM.COURSE_GU
					
					INNER JOIN 
					rev.EPC_STAFF AS STF
					ON
					SCH.STAFF_GU = STF.STAFF_GU

					WHERE
					PRIM.GRADE IN ('09', '10', '11')
					AND SCH.PRIMARY_STAFF = 1
					AND SCH.TERM_CODE IN ('YR', 'S2')
					AND (GRPS.[GROUP] IN 
									(
									'ALG 1 S1',
									'ALG 1 S2',
									'ALG 2 S1',
									'ALG 2 S2',
									'CALC S1',
									'CALC S2',
									'GEOM S1',
									'GEOM S2',
									'PreCALC S1',
									'PreCALC S2',
									'TRIG S1',
									'TRIG S2',
									'STATS S1',
									'STATS S2'
									)
						OR DCM.COURSE_TITLE IN ('MATH 1', 'MATH 2', 'MATH 3', 'MATH 4'))
	
				) AS T1	
				WHERE RN = 1
	UNION ALL
		/***********************************************
		09-11 ELA
		************************************************/
		SELECT * FROM  (
			SELECT 	
						SCH.STUDENT_GU
						,SCH.COURSE_ID AS [Optional State Data 5]
						,SCH.COURSE_TITLE
						,SCH.[TEACHER NAME] + '-'+  DCM.COURSE_SHORT_TITLE + '-'+ SCH.SECTION_ID + '-'+ CAST(SCH.PERIOD_BEGIN AS VARCHAR)  AS [Assessment Session Location]
						,SCH.COURSE_ID + '-'+ SCH.SECTION_ID + '-'+ STF.STATE_ID AS [Classroom Identifier]
						,SCH.[TEACHER NAME] AS [Staff Member Identifier]
						,CASE 
							WHEN SCH.DEPARTMENT = 'Eng' THEN 'ELA' + CASE WHEN SCH.SUBJECT_AREA_1 = 'Ele' THEN PRIM.GRADE 
																		  WHEN SCH.SUBJECT_AREA_1 = 'E12' THEN PRIM.GRADE	
																	ELSE SUBSTRING(SCH.SUBJECT_AREA_1,2,2) END 
							
						END	 AS [Test Code]
						,SIS_NUMBER
						,ROW_NUMBER() OVER (PARTITION BY SCH.STUDENT_GU, SCH.DEPARTMENT ORDER BY SCH.SUBJECT_AREA_1 DESC) AS RN

					FROM 
					APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
					INNER JOIN 
					APS.ScheduleDetailsAsOf(GETDATE()) AS SCH
					ON
					PRIM.STUDENT_GU = SCH.STUDENT_GU
					AND 
					PRIM.ORGANIZATION_YEAR_GU = SCH.ORGANIZATION_YEAR_GU
		--			INNER HASH JOIN 
		--APS.TermDatesAsOf(GETDATE()) AS TRMS
		--ON
		--SCH.TERM_CODE = TRMS.TermCode
		--AND TRMS.OrgYearGU = SCH.ORGANIZATION_YEAR_GU
					INNER JOIN 
					rev.EPC_CRS AS DCM
					ON
					SCH.COURSE_GU = DCM.COURSE_GU

					INNER JOIN 
					rev.EPC_STAFF AS STF
					ON
					SCH.STAFF_GU = STF.STAFF_GU

					WHERE
					PRIM.GRADE IN ('09', '10', '11')
					AND SCH.PRIMARY_STAFF = 1
					AND SCH.DEPARTMENT = 'Eng'
					AND SCH.TERM_CODE IN ('YR', 'S2')
				) AS T1	
				WHERE RN = 1

	) AS ELAMTH0911

	ON
	ELAMTH0911.STUDENT_GU = PRIM.STUDENT_GU


) AS T2


  LEFT JOIN 
           OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                  'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
                  'SELECT * from PARCCSPRING.csv'
                ) AS [PARCC]
	
	ON
	PARCC.[State Student Identifier] = T2.[State Student Identifier]
	AND PARCC.[Test Code] = T2.[Test Code]

WHERE 
T2.[State Field 5] IS NOT NULL
--AND [Staff Member Identifier] = 'Elizabeth Alvarado'
--AND [Testing School] = '900'
AND T2.[Grade Level When Assessed] IN ('03', '04', '05', '06', '07', '08', '09', '10', '11')
-- this is Jude's TEST kid 970093990
AND T2.[State Student Identifier] != 412719213


--ORDER BY [Testing School], T2.[Grade Level When Assessed], T2.[Local Student Identifier]

      REVERT
GO





