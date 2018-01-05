SELECT 
	  RIGHT([SchoolNum],3)SchoolNumber
      ,[SchoolName]
      ,[StudentID]
	  ,'' AS 'GRADE LEVEL'
      --,[First]
      --,[last]
      --,[mi]
      ,'' AS ETHNICITY
	  ,'' AS 'ELL STATUS'
	  ,'' AS 'SPED STATUS'
      --,[Testname]
      ,[Subtest]
      ,[SSRead]
      ,[SSWrite]
      ,[ReadingPF]
      ,[WritingPF]
		,CASE
			WHEN PL = '1' THEN 'Did not yet meet expectations'
			WHEN PL = '2' THEN 'Partially met expectations'
			WHEN PL = '3' THEN 'Aproached expectations'
			WHEN PL = '4' THEN 'Met expectations'
			WHEN PL = '5' THEN 'Exceeded expectations'
		END AS PL
      ,[SS]
      --,[SCH_YR]
  FROM [Assessments].[dbo].[Preliminary_2015_PARCC] AS PARCC
  ORDER BY StudentID, Subtest
