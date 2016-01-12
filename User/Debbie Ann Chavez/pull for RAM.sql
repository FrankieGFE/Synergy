

SELECT STU.SIS_NUMBER, EXIT_REASON, T1.TEST_NAME, T1.PERFORMANCE_LEVEL, T1.TEST_DATE, [Overall LP] AS OVERALL_LP, Scale AS SCALE, FRM.VALUE_DESCRIPTION AS LUNCH_STATUS,
BS.HOME_LANGUAGE, GETGPA.[HS Cum Flat], GETGPA.[HS Cum Weighted], GETGPA.[MS Cum Flat]

 FROM 
	rev.EPC_STU_PGM_ELL AS EY2
	INNER JOIN
	rev.EPC_STU AS STU
	ON
	EY2.STUDENT_GU = STU.STUDENT_GU
	INNER JOIN
	APS.BasicStudentWithMoreInfo AS BS
	ON
	BS.STUDENT_GU = STU.STUDENT_GU
	INNER JOIN
	APS.LookupTable('K12.ProgramInfo', 'FRM_CODE') AS FRM
	ON
	BS.LUNCH_STATUS = FRM.VALUE_CODE

/*******************************************************************************

GET TEST STUFF AND PIVOT
********************************************************************************/
INNER JOIN
(
SELECT * FROM 
(
SELECT 

	   FIRST_NAME
       ,LAST_NAME
       ,SIS_NUMBER
	   ,TEST_NAME
       ,SCORE_DESCRIPTION
       ,PERFORMANCE_LEVEL
       ,TEST_SCORE
       ,CAST (ADMIN_DATE AS DATE) AS TEST_DATE
       ,ADMIN_DATE
FROM
(
SELECT 

	   PERSON.FIRST_NAME
       ,PERSON.LAST_NAME
       ,SIS_NUMBER
	   ,TEST.TEST_NAME
       ,SCORE_DESCRIPTION
       ,STU_PART.PERFORMANCE_LEVEL
       ,SCORES.TEST_SCORE
       ,STUDENTTEST.ADMIN_DATE
FROM
       rev.EPC_STU_TEST AS StudentTest

       JOIN
       rev.EPC_TEST_PART AS PART
       ON StudentTest.TEST_GU = PART.TEST_GU

       JOIN
       rev.EPC_STU_TEST_PART AS STU_PART
       ON PART.TEST_PART_GU = STU_PART.TEST_PART_GU
       AND STU_PART.STUDENT_TEST_GU = StudentTest.STUDENT_TEST_GU

    INNER JOIN
    rev.EPC_STU_TEST_PART_SCORE AS SCORES
    ON
    SCORES.STU_TEST_PART_GU = STU_PART.STU_TEST_PART_GU

    LEFT JOIN
    rev.EPC_TEST_SCORE_TYPE AS SCORET
    ON
    SCORET.TEST_GU = StudentTest.TEST_GU
    AND SCORES.TEST_SCORE_TYPE_GU = SCORET.TEST_SCORE_TYPE_GU

    LEFT JOIN
    rev.EPC_TEST_DEF_SCORE AS SCORETDEF
    ON
    SCORETDEF.TEST_DEF_SCORE_GU = SCORET.TEST_DEF_SCORE_GU

       LEFT JOIN
       rev.EPC_TEST AS TEST
       ON TEST.TEST_GU = StudentTest.TEST_GU

       INNER JOIN
       rev.EPC_STU AS Student
       ON Student.STUDENT_GU = StudentTest.STUDENT_GU

       INNER JOIN
       rev.REV_PERSON AS Person
       ON Person.PERSON_GU = StudentTest.STUDENT_GU

WHERE
       TEST_NAME like '%ACCESS%'

) AS SYN
) AS GETALLTOPIVOT

PIVOT
	(
	MAX(TEST_SCORE)
	FOR SCORE_DESCRIPTION IN ([Overall LP], [Scale])
	) AS PIVOTME
) AS T1
ON
T1.SIS_NUMBER = STU.SIS_NUMBER

/*******************************************************************************

GET GPA
********************************************************************************/
LEFT JOIN
(
			SELECT 
			SIS_NUMBER
			,[HS Cum Flat]
			,[HS Cum Weighted]
			,[MS Cum Flat]
	FROM		
		APS.BasicStudentWithMoreInfo AS [STUDENT]

INNER JOIN
		
		(
		SELECT
			*
			,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY ENTER_DATE DESC, EXCLUDE_ADA_ADM ) AS RN
		FROM
			APS.StudentEnrollmentDetails
			
		)  AS [ENROLLMENT]
		ON
		[STUDENT].[STUDENT_GU] = [ENROLLMENT].[STUDENT_GU]
		AND [ENROLLMENT].[RN] = 1
		
		INNER JOIN
		rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
		ON
		[ENROLLMENT].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
		
		LEFT OUTER JOIN
		(
		SELECT DISTINCT
			[GPA].[STUDENT_SCHOOL_YEAR_GU]
			
			,SUM(CASE WHEN [GPA_DEF].[GPA_CODE] = 'HSCF' THEN [GPA].[GPA] ELSE 0 END) AS [HS Cum Flat]
			,SUM(CASE WHEN [GPA_DEF].[GPA_CODE] = 'HSCW' THEN [GPA].[GPA] ELSE 0 END) AS [HS Cum Weighted]
			,SUM(CASE WHEN [GPA_DEF].[GPA_CODE] = 'MSCF' THEN [GPA].[GPA] ELSE 0 END) AS [MS Cum Flat]
			
		FROM	
			rev.[EPC_STU_GPA] AS [GPA]  
				
			INNER JOIN
			rev.[EPC_SCH_YR_GPA_TYPE_RUN] [GPA_RUN]
			ON
			[GPA].[SCHOOL_YEAR_GPA_TYPE_RUN_GU] = [GPA_RUN].[SCHOOL_YEAR_GPA_TYPE_RUN_GU]
			AND [GPA_RUN].[SCHOOL_YEAR_GRD_PRD_GU] IS NULL
			
			INNER JOIN
			rev.[EPC_GPA_DEF_TYPE] [GPA_TYPE] 
			ON 
			[GPA_RUN].[GPA_DEF_TYPE_GU] = [GPA_TYPE].[GPA_DEF_TYPE_GU]
			AND (
				[GPA_TYPE].[GPA_TYPE_NAME] = 'HS Cum Flat' 
				OR
				[GPA_TYPE].[GPA_TYPE_NAME] = 'HS Cum Weighted' 
				OR
				[GPA_TYPE].[GPA_TYPE_NAME] = 'MS Cum Flat'
				)
					
			INNER JOIN 
			rev.[EPC_GPA_DEF] [GPA_DEF]  
			ON 
			[GPA_TYPE].[GPA_DEF_GU] = [GPA_DEF].[GPA_DEF_GU]
			
		GROUP BY
			[GPA].[STUDENT_SCHOOL_YEAR_GU]
		) AS [CUM_GPA]


		ON
		[ENROLLMENT].[STUDENT_SCHOOL_YEAR_GU] = [CUM_GPA].[STUDENT_SCHOOL_YEAR_GU]

) AS GETGPA
ON
T1.SIS_NUMBER = GETGPA.SIS_NUMBER


WHERE
EXIT_REASON = 'EY2'

ORDER BY STU.SIS_NUMBER, TEST_DATE DESC
