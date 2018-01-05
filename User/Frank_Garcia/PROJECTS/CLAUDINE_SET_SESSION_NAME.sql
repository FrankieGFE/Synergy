

SELECT
	--[State Student Identifier]
	[Student Code]
	--,TESTREG
	--,TESTSF
	,[Assessment Session Location]
	,[Session Name]
	--,test
	--,[Test Code]


--UPDATE 
--	[Student Registration Export 2015-04-02T16_19_59.719+0000]
--SET
--	[Assessment Session Location] = [Session Name]
FROM
	(
	SELECT
		--TESTREG
		--,TESTSF
		--,[State Student Identifier]
		[Student Code]
		,[Assessment Session Location]
		,[Session Name]
		--,TEST
		,[test code]
	
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
		 ON REGTEST.[STATE Student Identifier] = TEST.[Student Code]
		 AND REGTEST.TESTREG = TEST.TESTSF
 
) AS T1
WHERE T1.[Student Code] = '102560976'
--ORDER BY [State Student Identifier]
--WHERE [Session Name] IS NOT NULL



