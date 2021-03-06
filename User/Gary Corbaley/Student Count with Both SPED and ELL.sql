



SELECT --DISTINCT
	[GRADE]
	,SUM(CASE WHEN [HOME_LANGUAGE] = 'Arabic' THEN 1 ELSE 0 END) AS [Arabic]
	,SUM(CASE WHEN [HOME_LANGUAGE] = 'Cantonese' THEN 1 ELSE 0 END) AS [Cantonese]
	,SUM(CASE WHEN [HOME_LANGUAGE] = 'Chinese' THEN 1 ELSE 0 END) AS [Chinese]
	,SUM(CASE WHEN [HOME_LANGUAGE] = 'English' THEN 1 ELSE 0 END) AS [English]
	,SUM(CASE WHEN [HOME_LANGUAGE] = 'Mescalero Apache' THEN 1 ELSE 0 END) AS [Mescalero Apache]
	,SUM(CASE WHEN [HOME_LANGUAGE] = 'Other Non-English' THEN 1 ELSE 0 END) AS [Other Non-English]
	,SUM(CASE WHEN [HOME_LANGUAGE] = 'Pashto' THEN 1 ELSE 0 END) AS [Pashto]
	,SUM(CASE WHEN [HOME_LANGUAGE] = 'Spanish' THEN 1 ELSE 0 END) AS [Spanish]
	,SUM(CASE WHEN [HOME_LANGUAGE] = 'Swahili' THEN 1 ELSE 0 END) AS [Swahili]
	,SUM(CASE WHEN [HOME_LANGUAGE] = 'Tewa' THEN 1 ELSE 0 END) AS [Tewa]
	,SUM(CASE WHEN [HOME_LANGUAGE] = 'Vietnamese' THEN 1 ELSE 0 END) AS [Vietnamese]
	,SUM(CASE WHEN [HOME_LANGUAGE] IS NULL THEN 1 ELSE 0 END) AS [NULL]
FROM
	(
	SELECT
		[STUDENT].[SIS_NUMBER]
		,[STUDENT].[FIRST_NAME]
		,[STUDENT].[LAST_NAME]
		,[STUDENT].[MIDDLE_NAME]
		,[STUDENT].[BIRTH_DATE]
		,[STUDENT].[PRIMARY_DISABILITY_CODE]
		,[STUDENT].[SPED_STATUS]
		,[STUDENT].[ELL_STATUS]
		,CASE WHEN [STUDENT].[HOME_LANGUAGE] IS NULL THEN [STUDENT].[CONTACT_LANGUAGE] ELSE [STUDENT].[HOME_LANGUAGE] END AS [HOME_LANGUAGE]
		,[ENROLLMENT].[SCHOOL_CODE]
		,[ENROLLMENT].[SCHOOL_NAME]
		,[ENROLLMENT].[GRADE]
		
	FROM
		APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS [ENROLLMENT]
		
		INNER JOIN
		APS.BasicStudentWithMoreInfo AS [STUDENT]
		ON
		[ENROLLMENT].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
		
	WHERE
		[STUDENT].[SPED_STATUS] = 'Y'
		AND 
		[STUDENT].[ELL_STATUS] = 'Y'
		--AND 
		--[ENROLLMENT].[SCHOOL_CODE] = '590'
	) AS [STUDENT]
	
GROUP BY
	[GRADE]
	
ORDER BY
	[GRADE]
	
	
