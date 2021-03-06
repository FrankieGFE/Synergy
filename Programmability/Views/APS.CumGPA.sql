/**
 * 
 * $LastChangedBy: DEBBIE ANN CHAVEZ
 * $LastChangedDate: 2016-02-04$
 *
 * 
 * View to pull Student's CumGPA for Mid and High
 *
 */
 

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[APS].[CumGPA]'))
	EXEC ('CREATE VIEW APS.CumGPA AS SELECT 0 AS DUMMY')
GO

ALTER VIEW APS.CumGPA AS


SELECT
	CASE WHEN T2.SIS_NUMBER IS NOT NULL THEN T2.SIS_NUMBER ELSE T4.SIS_NUMBER END AS SIS_NUMBER
	,CASE WHEN T2.SCHOOL_YEAR IS NOT NULL THEN T2.SCHOOL_YEAR ELSE T4.SCHOOL_YEAR END AS SCHOOL_YEAR
	,CASE WHEN T2.SCHOOL_NAME IS NOT NULL THEN T2.SCHOOL_NAME ELSE T4.SCHOOL_NAME END AS SCHOOL_NAME
	,CASE WHEN T2.GRADE IS NOT NULL THEN T2.GRADE ELSE T4.GRADE END AS GRADE
	,[HS Cum Flat]
	,[HS Cum Weighted]
	,[MS Cum Flat]

FROM	
	(
	SELECT 
	SIS_NUMBER
	,SCHOOL_YEAR
	,SCHOOL_NAME
	,GRADE
	,[HS Cum Flat]
	,[HS Cum Weighted]
	FROM
	(
	SELECT 
	[StudentSchoolYear].SIS_NUMBER
	,SCHOOL_YEAR
	,SCHOOL_NAME
	,GRADE
	,[HS Cum Flat]
	,[HS Cum Weighted]
	,ROW_NUMBER() OVER (PARTITION BY [StudentSchoolYear].STUDENT_GU ORDER BY  ENTER_DATE DESC,  [HS Cum Weighted] DESC, [HS Cum Flat] DESC) AS RN
	FROM		
		APS.BasicStudentWithMoreInfo AS [STUDENT]
		INNER JOIN
		APS.StudentEnrollmentDetails AS [StudentSchoolYear]
		ON
		STUDENT.STUDENT_GU = [StudentSchoolYear].STUDENT_GU
		LEFT OUTER JOIN
		(
		SELECT DISTINCT
			[GPA].[STUDENT_SCHOOL_YEAR_GU]
			
			,SUM(CASE WHEN [GPA_DEF].[GPA_CODE] IN ( 'HSCF', 'HSF') THEN [GPA].[GPA] ELSE 0 END) AS [HS Cum Flat]
			,SUM(CASE WHEN [GPA_DEF].[GPA_CODE] IN ( 'HSCW', 'HSW') THEN [GPA].[GPA] ELSE 0 END) AS [HS Cum Weighted]
			
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
				)
					
			INNER JOIN 
			rev.[EPC_GPA_DEF] [GPA_DEF]  
			ON 
			[GPA_TYPE].[GPA_DEF_GU] = [GPA_DEF].[GPA_DEF_GU]
			GROUP BY
			[GPA].[STUDENT_SCHOOL_YEAR_GU]
			
			)  AS [CUM_GPA]
		ON
		[StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU] = [CUM_GPA].[STUDENT_SCHOOL_YEAR_GU]

WHERE
	([HS Cum Flat] IS NOT NULL
	OR [HS Cum Weighted] IS NOT NULL)
) AS T1
WHERE
	RN = 1
) AS T2

FULL OUTER JOIN

(
SELECT 
	SIS_NUMBER
	,SCHOOL_YEAR
	,SCHOOL_NAME
	,GRADE
	,[MS Cum Flat]
FROM
(
	SELECT 
	[StudentSchoolYear].SIS_NUMBER
	,SCHOOL_YEAR
	,SCHOOL_NAME
	,GRADE
	,[MS Cum Flat]
	,ROW_NUMBER() OVER (PARTITION BY [StudentSchoolYear].STUDENT_GU ORDER BY  ENTER_DATE DESC, [MS Cum Flat] DESC) AS RN

	FROM		
		APS.BasicStudentWithMoreInfo AS [STUDENT]
		INNER JOIN
		APS.StudentEnrollmentDetails AS [StudentSchoolYear]
		ON
		STUDENT.STUDENT_GU = [StudentSchoolYear].STUDENT_GU
		LEFT OUTER JOIN
		(
		SELECT DISTINCT
			[GPA].[STUDENT_SCHOOL_YEAR_GU]
			
			,SUM(CASE WHEN [GPA_DEF].[GPA_CODE] IN ('MSCF', 'MSF') THEN [GPA].[GPA] ELSE 0 END) AS [MS Cum Flat]	
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
				[GPA_TYPE].[GPA_TYPE_NAME] = 'MS Cum Flat'
				)
					
			INNER JOIN 
			rev.[EPC_GPA_DEF] [GPA_DEF]  
			ON 
			[GPA_TYPE].[GPA_DEF_GU] = [GPA_DEF].[GPA_DEF_GU]
			GROUP BY
			[GPA].[STUDENT_SCHOOL_YEAR_GU]
			
			)  AS [CUM_GPA]
		ON
		[StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU] = [CUM_GPA].[STUDENT_SCHOOL_YEAR_GU]

WHERE
	[MS Cum Flat] IS NOT NULL

) AS T3
	WHERE
		RN = 1
) AS T4

ON
T2.SIS_NUMBER = T4.SIS_NUMBER
	


	GO

