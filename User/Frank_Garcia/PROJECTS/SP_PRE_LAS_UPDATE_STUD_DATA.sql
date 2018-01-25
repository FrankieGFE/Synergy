BEGIN TRAN

USE [SchoolNet]
GO
UPDATE
	[180-SMAXODS-01].SCHOOLNET.DBO.[SP_PRE_LAS]
	SET
		FRST_NME = STUD.FRST_NME
		,LST_NME = STUD.LST_NME
		,BRTH_DT = STUD.BRTH_DT
		,STID = STATE_ID
--SELECT [DST_NBR]
--      ,[ID_NBR]
--      ,[TEST_ID]
--      ,[TEST_SUB]
--      ,[SCH_YR]
--      ,[TEST_DT]
--      ,[SCH_NBR]
--      ,[GRDE]
--      ,[SCORE1]
--      ,[SCORE2]
--      ,[SCORE3]
--      ,[FRST_NME]
--      ,[LST_NME]
--      ,[BRTH_DT]
--      ,[STID]
  FROM [180-SMAXODS-01].SCHOOLNET.[dbo].[SP_PRE_LAS] AS PRELAS
  LEFT JOIN
	SMAXDBPROD.[PR].[DBTSIS].[CE020_V] AS STUD
	ON PRELAS.ID_NBR = CAST (STUD.ID_NBR AS NVARCHAR (50))
	----ON LTRIM(RTRIM(EOC.FIRST_NAME)) = STUD.FRST_NME COLLATE Latin1_General_BIN
	----AND EOC.LAST_NAME   = STUD.LST_NME COLLATE Latin1_General_BIN
	--ON EOC.ID_NBR = CAST(STUD.ID_NBR AS NVARCHAR (50))
--LEFT JOIN
--	SMAXDBPROD.[PR].[DBTSIS].[ST010_V] AS STUD
--	ON EOC.ID_NBR = CAST(STUD.[ID_NBR] AS NVARCHAR (50))
--	AND STUD.SCH_YR = '2014'
--LEFT JOIN
--	[180-SMAXODS-01].[PR].[DBTSIS].[SY010_V] AS STUD
--	ON EOC.[ID NUMBER] = STUD.[ID_NBR]
	--WHERE EOC.School IS NULL
--LEFT JOIN
--	[046-WS02].db_STARS_History.dbo.STUDENT AS STUD
--	ON
--	EOC.[ID Number] = STUD.[ALTERNATE STUDENT ID]
--AND STUD.SY = EOC.SCH_YR + 1
--WHERE EOC.School < 200 AND EOC.School != '048'
GO

ROLLBACK
