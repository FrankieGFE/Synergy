/****** Script for SelectTopNRows command from SSMS  ******/
INSERT INTO SchoolNet.dbo.[PLAN]

SELECT
	STID
	,FNAME
	,MI
	,LNAME
	,DOB
	,TEST
	,SUBTEST
	,SCORE
	,APS_ID
	,test_level_name
	,test_date_code
	,school_code
	,[School Year]
FROM
(	



SELECT [STID]
      ,[FNAME]
      ,[MI]
      ,[LNAME]
      ,SUBSTRING (DOB, 1,4)+ '-' + SUBSTRING(DOB,5,2)+ '-'+SUBSTRING (DOB,7,2) AS DOB
      ,[TEST]
      ,SUBTEST
      ,[SCORE]
      ,STARS.[ALTERNATE STUDENT ID] AS APS_ID
      ,STARS.[CURRENT GRADE LEVEL] AS test_level_name
      ,'10/01/2012' AS test_date_code
      ,STARS.[LOCATION CODE] AS school_code
      ,'2013' AS [School Year]
  FROM [SchoolNet].[dbo].[Temp_Table] TEST
  LEFT JOIN
  [046-WS02].[db_STARS_History].dbo.STUDENT AS STARS
  ON
  STARS.[STUDENT ID] = TEST.STID
  AND STARS.SY = 2013
  AND STARS.PERIOD = '2013-06-01'
  AND STARS.[DISTRICT CODE] = '001'
) AS PLAN_PULL
  