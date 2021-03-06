/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	   [fld_ID_NBR]
      ,[fld_FRST_NME]
      ,[fld_LST_NME]
      ,[fld_GRDE]
      ,[fld_TestLoc]
      ,[fld_AssessmentWindow]
      ,[fld_Assessment_Used]
      ,[fld_Performance_Lvl]
  FROM [db_DRA].[dbo].[Results_1415]
  WHERE FLD_ID_NBR > 13
  ORDER BY FLD_GRDE,FLD_TESTLOC, FLD_LST_NME,FLD_FRST_NME, FLD_ASSESSMENTWINDOW