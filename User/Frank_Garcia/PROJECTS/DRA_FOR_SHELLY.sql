USE [db_DRA]
GO

SELECT
	   KINDER.[fld_ID_NBR]
      ,KINDER.[fld_STATE_ID]
      ,KINDER.[fld_FRST_NME]
      ,KINDER.[fld_LST_NME]
      ,KINDER.[fld_BRTH_DT]
      ,KINDER.[fld_GRDE]
      ,KINDER.[fld_TestLoc]
      ,KINDER.[fld_EmployeeID]
      ,KINDER.[fld_AssessmentWindow]
      ,KINDER.[fld_Assessment_Used]
      ,KINDER.[fld_Level]
      ,KINDER.[fld_Story]
      ,KINDER.[fld_Performance_Lvl] AS FIRST_PL
	  ,FIRS.[fld_Performance_Lvl] AS SECOND_PL
  FROM [dbo].[Results_1112] AS KINDER
  LEFT JOIN
  RESULTS_1213 AS FIRS
  ON KINDER.FLD_ID_NBR = FIRS.FLD_ID_NBR
  WHERE (KINDER.FLD_GRDE = '01' AND KINDER.FLD_ASSESSMENTWINDOW = 'SPRING' AND KINDER.FLD_PERFORMANCE_LVL = 'ADV')
	  AND (FIRS.FLD_GRDE = '02' AND FIRS.FLD_ASSESSMENTWINDOW = 'SPRING' AND FIRS.FLD_PERFORMANCE_LVL = 'ADV')
GO


