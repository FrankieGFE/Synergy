



EXECUTE AS LOGIN='QueryFileUser'
GO

--SELECT
--	*
--FROM
--(
SELECT --TOP 1000
	[FILE].*
	--,[SCHEDULE].[DEPARTMENT]
	--,[FILE].[State Student Identifier]
	,SUBSTRING([STAFF].[BADGE_NUM],2,99) AS [STAFF_BADGE_NUM]
	,[PERSON].[FIRST_NAME] + ' ' + [PERSON].[LAST_NAME] AS [STAFF_NAME]
	
	,CASE WHEN [ELL_PGM].[PROGRAM_CODE] = '1' AND [ELL_PGM].[EXIT_DATE] IS NULL THEN 'Y' ELSE 'N' END AS [ELL_STATUS]
	,CASE WHEN [CurrentSPED].[PRIMARY_DISABILITY_CODE] != 'GI' AND [CurrentSPED].[PRIMARY_DISABILITY_CODE] IS NOT NULL THEN 'Y' ELSE 'N' END AS [SPED_STATUS]
	--,[SCHEDULE].*
	
	,[SCHEDULE].[RN]
	--,ROW_NUMBER() OVER (PARTITION BY [FILE].[State Student Identifier], [FILE].[TRANS_CODE] ORDER BY SUBSTRING(CASE WHEN [STAFF].[BADGE_NUM] IS NULL THEN '0' ELSE [STAFF].[BADGE_NUM] END,2,99) DESC) AS RN
	
FROM
	(
	SELECT
		*
		,CASE 
			WHEN [Testing School] < 400 THEN 'Elem'
			WHEN [Test Code] LIKE 'MAT%' THEN 'Math'
			WHEN [Test Code] LIKE 'ALG%' THEN 'Math'
			WHEN [Test Code] LIKE 'GEO%' THEN 'Math'
			WHEN [Test Code] LIKE 'ELA%' THEN 'Eng'
			
			ELSE [Test Code]
		END AS [TRANS_CODE]
	FROM
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
			'SELECT * from Personal_Needs_Profile_Export_20141125_FULL_DISTRICT.csv'
			) 
	)AS [FILE]
	    
	LEFT OUTER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[FILE].[State Student Identifier] = [STUDENT].[STATE_STUDENT_NUMBER]
	
	LEFT OUTER JOIN
	(
	SELECT
		ROW_NUMBER() OVER (PARTITION BY [SCHEDULE].[STUDENT_GU], [SCHEDULE].[DEPARTMENT] ORDER BY [SCHEDULE].[COURSE_ENTER_DATE] DESC) AS RN
		,*
	FROM
		APS.ScheduleAsOf(GETDATE()) AS [SCHEDULE]
	) AS [SCHEDULE]
	ON
	[STUDENT].[STUDENT_GU] = [SCHEDULE].[STUDENT_GU]
	AND ([SCHEDULE].[COURSE_TITLE] NOT LIKE 'PE%' AND [SCHEDULE].[COURSE_TITLE] NOT LIKE 'ART%')
	AND [FILE].[TRANS_CODE] = [SCHEDULE].[DEPARTMENT]
	AND [SCHEDULE].[RN] = 1	
	
	LEFT OUTER JOIN
	rev.[EPC_STAFF] AS [STAFF]
	ON
	[SCHEDULE].[STAFF_GU] = [STAFF].[STAFF_GU]
	
	LEFT OUTER JOIN
	rev.[REV_PERSON] AS [PERSON]
	ON
	[STAFF].[STAFF_GU] = [PERSON].[PERSON_GU]
	
	LEFT JOIN
    (
    SELECT
               *
    FROM
                REV.EP_STUDENT_SPECIAL_ED AS SPED
    WHERE
                NEXT_IEP_DATE IS NOT NULL
                AND (
                            EXIT_DATE IS NULL 
                            OR EXIT_DATE >= CONVERT(DATE, GETDATE())
                            )
    ) AS [CurrentSPED]
    ON
    [STUDENT].[STUDENT_GU] = [CurrentSPED].[STUDENT_GU]
    
    LEFT JOIN
    rev.EPC_STU_PGM_ELL AS [ELL_PGM]
    ON
    [STUDENT].[STUDENT_GU] = [ELL_PGM].[STUDENT_GU] 
--) AS [STUDENT_STAFF]

WHERE
	[FILE].[TRANS_CODE] != 'Elem'    

ORDER BY
	[FILE].[State Student Identifier]
	   
	    
REVERT
GO