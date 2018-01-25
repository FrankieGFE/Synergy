USE [Assessments]
GO

SELECT 
      [DistrictStudentID] AS SIS_NUMBER
	  ,LastName AS LAST_NAME
	  ,FirstName AS FIRST_NAME
	  ,CASE WHEN ACC_2015.GRADE = '0' THEN 'K' ELSE ACC_2015.GRADE END AS '2015_GRADE_LEVEL'
	  ,CASE WHEN ACC_2014.Grade = '0' THEN 'K' ELSE ACC_2014.GRADE END AS '2014_GRADE_LEVEL'
	  ,SchoolName AS '2015_SCHOOL_NAME'
	  ,ACC_2014.[School Name] AS '2014_SCHOOL_NAME'
	  ,SchoolCode AS '2015_SCHOOL_NUMBER'
	  ,ACC_2014.[School Number] AS '2014_SCHOOL_NUMBER'
	  ,ScaleScoreL AS '2015_LISTENING SCALE SCORE'
	  ,ACC_2014.[Listening Scale Score] AS '2014_LISTENING SCALE SCORE'
	  ,ScaleScoreS AS '2015_Speaking Scale Score'
	  ,ACC_2014.[Speaking Scale Score] AS '2014_SPEAKING SCALE SCORE'
	  ,ScaleScoreR AS '2015_Reading Scale Score'
	  ,ACC_2014.[Reading Scale Score] AS '2014_READING SCALE SCORE'
	  ,ScaleScoreW AS '2015_Writing Scale Score'
	  ,ACC_2014.[Writing Scale Score] AS '2014_WRITING SCALE SCORE'
	  ,CompositeScaleScore AS '2015_Composite (Overall) Scale Score'
	  ,ACC_2014.[Composite (Overall) Scale Score] AS '2014_COMPOSITE (OVERALL) SCALE SCORE'
	  ,ACC_2015.PerformanceLevelComposite AS '2015_COMPOSITE (OVERALL) PROFICIENCY LEVEL'
	  ,ACC_2014.[Composite (Overall) Proficiency Level] AS '2014_COMPOSITE (OVERALL) PROFICIENCY LEVEL'
      --,ACC_2015.[Date of Testing]
      --,[StudentID]
      --,ACC_2015.[SCH_YR]
  FROM [dbo].[CCR_ACCESS_2015-2016] AS ACC_2015

  LEFT JOIN
  CCR_ACCESS AS ACC_2014
  ON ACC_2015.DistrictStudentID = ACC_2014.[District Student ID]
  AND ACC_2014.SCH_YR = '2014-2015'

  GO


