

SELECT
	[SCH_NBR]
	,[SCH_NME]
	,SUM([MALE]) AS [MALE]
	,SUM([FEMALE]) AS [FEMALE]
	,SUM([Caucasian]) AS [Caucasian]
	,SUM([Hispanic]) AS [Hispanic]
	,SUM([Asian]) AS [Asian]
	,SUM([American Indian or Alaskan Native]) AS [American Indian or Alaskan Native]
	,SUM([Black or African American]) AS [Black or African American]
	,SUM([Native Hawaiian or Other Pacific Islande]) AS [Native Hawaiian or Other Pacific Islande]
	
FROM
	(
	SELECT DISTINCT
		[Enrollments].[DST_NBR]
		,[Enrollments].[ID_NBR]
		,[Student].[FRST_NME]
		,[Student].[LST_NME]
		,[Enrollments].[SCH_NBR]
		,[School].[SCH_NME]
		,CASE WHEN [Student].[GENDER] = 'M' THEN 1 ELSE 0 END AS [MALE]
		,CASE WHEN [Student].[GENDER] = 'F' THEN 1 ELSE 0 END AS [FEMALE]
		,CASE WHEN [Student].[Race] = 'Caucasian' THEN 1 ELSE 0 END AS [Caucasian]
		,CASE WHEN [Student].[Race] = 'Hispanic' THEN 1 ELSE 0 END AS [Hispanic]
		,CASE WHEN [Student].[Race] = 'Asian' THEN 1 ELSE 0 END AS [Asian]
		,CASE WHEN [Student].[Race] = 'American Indian or Alaskan Native' THEN 1 ELSE 0 END AS [American Indian or Alaskan Native]
		,CASE WHEN [Student].[Race] = 'Black or African American' THEN 1 ELSE 0 END AS [Black or African American]
		,CASE WHEN [Student].[Race] = 'Native Hawaiian or Other Pacific Islande' THEN 1 ELSE 0 END AS [Native Hawaiian or Other Pacific Islande]
		,[Transcripts].[GRAD_DT]
	FROM
		APS.PrimaryEnrollmentsAsOf('5/22/14') AS [Enrollments]
		
		INNER JOIN
		APS.BasicStudent AS [Student]
		ON
		[Enrollments].[DST_NBR] = [Student].[DST_NBR]
		AND [Enrollments].[ID_NBR] = [Student].[ID_NBR]

		INNER JOIN
		[DBTSIS].[TN010_V] AS [Transcripts]
		ON
		[Enrollments].[DST_NBR] = [Transcripts].[DST_NBR]
		AND [Enrollments].[ID_NBR] = [Transcripts].[ID_NBR]
		
		INNER JOIN
		APS.School AS [School]
		ON
		[Enrollments].[SCH_NBR] = [School].[SCH_NBR]
		
	WHERE
		[Transcripts].[DST_NBR] = 1
		AND [Enrollments].[SCH_YR] = 2014
		AND [Transcripts].[GRAD_DT] != 0
	) [Minorities]
	
GROUP BY
	[SCH_NBR]
	,[SCH_NME]

ORDER BY
	[SCH_NBR]
	