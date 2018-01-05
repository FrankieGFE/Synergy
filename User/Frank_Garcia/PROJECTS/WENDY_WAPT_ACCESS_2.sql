USE [Assessments]
GO

SELECT [APS ID]
      ,[Student Name]
	  ,ACCESS.[Composite (Overall) Scale Score] AS 'Most Recent ACCESS'
	,CASE 
		WHEN ACCESS.[Comprehension Proficiency Level] >= '1' AND ACCESS.[Comprehension Proficiency Level] <= '1.9' THEN 'Entering'
		WHEN ACCESS.[Comprehension Proficiency Level] >= '2' AND ACCESS.[Comprehension Proficiency Level] <= '2.9' THEN 'Emerging'
		WHEN ACCESS.[Comprehension Proficiency Level] >= '3' AND ACCESS.[Comprehension Proficiency Level] <= '3.9' THEN 'Developing'
		WHEN ACCESS.[Comprehension Proficiency Level] >= '4' AND ACCESS.[Comprehension Proficiency Level] <= '4.9' THEN 'Expanding'
		WHEN ACCESS.[Comprehension Proficiency Level] >= '5' AND ACCESS.[Comprehension Proficiency Level] <= '5.9' THEN 'Bridging'
		WHEN ACCESS.[Comprehension Proficiency Level] = '6'  THEN 'Reaching'

	ELSE 'Incomplete'	  
	end as ACCESS_PL
	,ACCESS.[Composite (Overall) Proficiency Level]
	  ,'20'+SUBSTRING ([Date of Testing],5,2) + '-'+SUBSTRING([Date of Testing],1,2) + '-'+SUBSTRING ([Date of Testing],3,2) AS ACCESS_TEST_DATE
	  
	  ,ACCESS.[Date of Testing] AS 'Most Recent ACCESS Test Date'
  FROM [dbo].[Lutheran_Family_Services] AS LFS
  LEFT JOIN
	[180-SMAXODS-01].SCHOOLNET.DBO.CCR_ACCESS AS ACCESS
	ON LFS.[APS ID] = ACCESS.[District Student ID]
	AND ACCESS.[SCH_YR] = '2014-2015'
	--AND WAPT.TEST_SECTION_NAME = 'Overall Score = 35% Reading + 35% Writing + 15% Listening + 15% Speaking'
	--where [APS ID] = '980010738'
ORDER BY [Date of Testing]

GO