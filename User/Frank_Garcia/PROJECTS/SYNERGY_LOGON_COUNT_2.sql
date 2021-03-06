/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	  TOP 1000 [USER_ACTIVITY_GU]
      ,ACT.[USER_GU]
	  ,USR.LOGIN_NAME
	  ,USR.LOGIN_ATTEMPTS
      ,[ACCESS_DT]
      ,[ACCESS_IP]
      ,[LOGIN_STATUS]
  FROM [ST_Production].[rev].[REV_USER_ACT] AS ACT
  LEFT JOIN
  REV.REV_USER AS USR
  ON ACT.USER_GU = USR.USER_GU
  ORDER BY LOGIN_NAME, ACCESS_DT DESC