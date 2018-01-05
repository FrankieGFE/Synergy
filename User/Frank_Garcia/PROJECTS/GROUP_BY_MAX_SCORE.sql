USE [SchoolNet]
GO

SELECT 
	  [Student ID]
      ,[Student State ID]
      ,[School Year]
      ,[Grade Level]
      ,[School]
      ,[Term]
      ,[Course #]
      ,[Course]
      ,[Credit Attempted]
      ,[Credit Completed]
      ,[Mark]
      ,[Repeat]
	  ,MAX (CASE WHEN  [test_section_name] = 'MATH' THEN scaled_score 
	  END) AS SBA_MATH
      ,MAX (CASE WHEN test_section_name = 'READING' THEN scaled_score 
	  END) AS SBA_READING
  FROM [dbo].[META Students Receiving Services_TAB_3] AS META
  LEFT JOIN
	(SELECT
	*
	FROM
	(
	SELECT
		ROW_NUMBER () OVER (PARTITION BY STUDENT_CODE,TEST_SECTION_NAME ORDER BY SCALED_SCORE DESC) AS RN
		,STUDENT_CODE
		,test_section_name
		,scaled_score

	FROM
		SBA
	WHERE test_section_name IN ('MATH','READING')
	
	) AS SBA
	WHERE RN = 1
	)AS T2
	ON 
	META.[Student ID] = T2.student_code

	GROUP BY
	  [Student ID]
      ,[Student State ID]
      ,[School Year]
      ,[Grade Level]
      ,[School]
      ,[Term]
      ,[Course #]
      ,[Course]
      ,[Credit Attempted]
      ,[Credit Completed]
      ,[Mark]
      ,[Repeat]

	
  --ON META.[Student ID] = SBA.student_code
GO


