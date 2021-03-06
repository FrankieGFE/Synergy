/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
	*
FROM
	(
	  SELECT [LocationCode]
      ,[LName]
      ,[FName]
      ,[MI]
      ,CASE
		WHEN DOB = '' THEN '' ELSE SUBSTRING (DOB,1,4)+'-'+SUBSTRING (DOB,5,2)+'-'+SUBSTRING (DOB,7,2) END AS DOB
      ,[Gender]
      ,TEST_DATE_CODE
      ,[test_level_name]
      ,[ENGLISH]
      ,[MATH]
      ,[READING]
      ,[SCIENCE]
      ,[COMPOSITE]
      ,[APS_ID]
      ,'2013-2014' AS [School Year]
  FROM [AIMS].[dbo].[PLAN_01_17_2014]
  ) AS T1
  unpivot (SCORE for SUBTEST IN
  (ENGLISH, MATH, READING, SCIENCE, COMPOSITE)) AS UNPVT