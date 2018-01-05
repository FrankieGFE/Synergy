

--UPDATE
--	[Student Registration Export 2015-04-02T16_19_59.719+0000]
--SET [Assessment Session Location] = [Session Name]
SELECT
	*
FROM
(

SELECT
	[State Student Identifier]
	,TESTREG
	,TESTSF
	,[Assessment Session Location]
	,[Session Name]
	,[Test Code]

FROM
		 (
		  SELECT
			[State Student Identifier]
			,CASE WHEN [TEST CODE] LIKE '%ELA%' THEN 'ELA'
				  WHEN [TEST CODE] LIKE 'ALG%' THEN 'ALG'
				  WHEN [TEST CODE] LIKE '%GEO%' THEN 'GEO'
				  WHEN [TEST CODE] LIKE '%MAT%' THEN 'MATH'
		  END AS TESTREG
		  ,[Assessment Session Location]
		  ,[Test Code]
		  FROM
			[dbo].[Student Registration Export 2015-04-02T16_19_59.719+0000] AS REG
		  ) AS REGTEST
		LEFT JOIN
		(		  
		  SELECT
			[STUDENT CODE]
			,[SESSION NAME]
			,CASE WHEN TEST LIKE '%ELA%' THEN 'ELA'
				  WHEN TEST LIKE '%MATH%' THEN 'MATH'
				  WHEN TEST LIKE 'ALG%' THEN 'ALG'
				  WHEN TEST LIKE '%GEO%' THEN 'GEO'
			END AS TESTSF
			,Test
		  FROM
			[SESSION FILE] AS SF
		 ) AS TEST
		 ON REGTEST.[State Student Identifier] = TEST.[Student Code]
		 AND TEST.TESTSF = REGTEST.TESTREG
) AS SESSIONS
--LEFT JOIN
--	[Student Registration Export 2015-04-02T16_19_59.719+0000] STUD
--	ON STUD.[State Student Identifier] = SESSIONS.[State Student Identifier]
--	AND STUD.[Test Code] = SESSIONS.[Test Code]
--WHERE [Session Name] IS NOT NULL OR [Session Name] != ''

WHERE [State Student Identifier] = '102560976'
