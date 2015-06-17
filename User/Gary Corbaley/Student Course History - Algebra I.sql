



--SELECT
--	SUM([A]) AS [A]
--	,SUM([B]) AS [B]
--	,SUM([C]) AS [C]
--	,SUM([D]) AS [D]
--	,SUM([E]) AS [E]
--	,SUM([F]) AS [F]
--	,SUM([I]) AS [I]
--	,SUM([N]) AS [N]
--	,SUM([P]) AS [P]
--	,SUM([W]) AS [W]
--	,SUM([WF]) AS [WF]
--FROM
--	(
	SELECT --DISTINCT
		[STUDENT].[SIS_NUMBER]
		,[STUDENT].[FIRST_NAME]
		,[STUDENT].[MIDDLE_NAME]
		,[STUDENT].[LAST_NAME]
		,[School].[SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
		,[HISTORY].[COURSE_ID]
		,[HISTORY].[COURSE_TITLE]
		,[HISTORY].[TERM_CODE]
		,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
		,[HISTORY].[MARK]
		--CASE WHEN [HISTORY].[MARK] LIKE 'A%' THEN 1 ELSE 0 END AS [A]
		--,CASE WHEN [HISTORY].[MARK] LIKE 'B%' THEN 1 ELSE 0 END AS [B]
		--,CASE WHEN [HISTORY].[MARK] LIKE 'C%' THEN 1 ELSE 0 END AS [C]
		--,CASE WHEN [HISTORY].[MARK] LIKE 'D%' THEN 1 ELSE 0 END AS [D]
		--,CASE WHEN [HISTORY].[MARK] LIKE 'E%' THEN 1 ELSE 0 END AS [E]
		--,CASE WHEN [HISTORY].[MARK] LIKE 'A%' THEN 1 ELSE 0 END AS [F]
		--,CASE WHEN [HISTORY].[MARK] LIKE 'I%' THEN 1 ELSE 0 END AS [I]
		--,CASE WHEN [HISTORY].[MARK] LIKE 'N%' THEN 1 ELSE 0 END AS [N]
		--,CASE WHEN [HISTORY].[MARK] LIKE 'P%' THEN 1 ELSE 0 END AS [P]
		--,CASE WHEN [HISTORY].[MARK] = 'W' THEN 1 ELSE 0 END AS [W]
		--,CASE WHEN [HISTORY].[MARK] = 'WF' THEN 1 ELSE 0 END AS [WF]
		--,[HISTORY].*
		
	FROM
		rev.[EPC_STU_CRS_HIS] AS [HISTORY]
		
		INNER JOIN 
		rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
		ON 
		[HISTORY].[SCHOOL_IN_DISTRICT_GU] = [Organization].[ORGANIZATION_GU]
		
		INNER JOIN 
		rev.EPC_SCH AS [School] -- Contains the School Code / Number
		ON 
		[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
		
		INNER JOIN
		APS.BasicStudentWithMoreInfo AS [STUDENT]
		ON
		[HISTORY].[STUDENT_GU] = [STUDENT].STUDENT_GU
		
		LEFT OUTER JOIN
		APS.LookupTable('K12','Grade') AS [Grades]
		ON
		[HISTORY].[GRADE] = [Grades].[VALUE_CODE]
		
	WHERE
		[HISTORY].[SCHOOL_YEAR] = '2014'
		
		--AND [STUDENT].[SIS_NUMBER] = '104458120'	

		AND [HISTORY].[COURSE_ID] IN
		-- Old Course Numbers 
	/*('330400',
	'330401',
	'330402',
	'330403',
	'330471',
	'330472',
	'330801',
	'330802',
	'330811',
	'330812',
	'3304000',
	'060C41',
	'060C42',
	'061C1',
	'061C11',
	'061C12',
	'061C41',
	'061C42',
	'061C51',
	'061C52',
	'062C11',
	'062C12',
	'33040C',
	'33040C1',
	'33040C2',
	'33040DE1',
	'33040DE2',
	'33040DI1',
	'33040DI2',
	'3304A1',
	'3304A2',
	'MATH322',
	'330401de1',
	'330401de2',
	'311001',
	'311002',
	'3110B1',
	'3110B2',
	'3110D1',
	'3110D2',
	'312001',
	'312002',
	'312101',
	'312102')*/
	-- New Course Numbers
	('330400',
	'330401',
	'330402',
	'330403',
	'330471',
	'330472',
	'330801',
	'330802',
	'330811',
	'330812',
	'3304000',
	'060C41',
	'060C42',
	'061C1',
	'061C11',
	'061C12',
	'061C41',
	'061C42',
	'061C51',
	'061C52',
	'062C11',
	'062C12',
	'33040C',
	'33040C1',
	'33040C2',
	'33040DE1',
	'33040DE2',
	'33040DI1',
	'33040DI2',
	'3304A1',
	'3304A2',
	'MATH322',
	'330401de1',
	'330401de2')
	--) AS [COURSE_GRADES]+
	