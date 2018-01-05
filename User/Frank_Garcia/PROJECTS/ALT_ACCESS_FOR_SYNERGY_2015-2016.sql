USE [Assessments]
GO

SELECT 
	  DistrictStudentID AS APS_ID	  
	  ,GRADE
	  ,'2016-01-01' AS TEST_DATE
	  ,SchoolCode AS SCHOOL
	  ,CompositeScaleScore AS SCALE_SCORE
	  ,PerformanceLevelComposite AS LANGUAGE_PROFICIENCY
	  ,CASE 
		WHEN PerformanceLevelComposite = 'A1' THEN 'Initiating'
		WHEN PerformanceLevelComposite = 'A2' THEN 'Exploring'
		WHEN PerformanceLevelComposite = 'A3' THEN 'Engaging'
		WHEN PerformanceLevelComposite = 'P1' THEN 'Entering'
		WHEN PerformanceLevelComposite = 'P2' THEN 'Emerging'
		WHEN PerformanceLevelComposite = 'P3' THEN 'Developing'
	  ELSE 'Incomplete'
	  END AS PERFORMANCE_LEVEL
  FROM [dbo].[ALT_ACCESS_2015-2016] AS ALT

GO


