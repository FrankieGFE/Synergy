/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [fld_ID_NBR]
      ,[fld_STATE_ID]
      ,[fld_PRIOR_ID]
      ,[fld_FRST_NME]
      ,[fld_LST_NME]
      ,[fld_BRTH_DT]
      ,[fld_GRDE]
      ,[fld_TestLoc]
      ,[fld_EmployeeID]
      ,[fld_AssessmentWindow]
      ,[fld_Assessment_Used]
      ,[fld_Level]
      ,[fld_Story]
      ,[fld_Score_Sect1_1]
      ,[fld_Score_Sect1_2]
      ,[fld_Score_Sect1_3]
      ,[fld_Total_Sect1]
      ,[fld_Score_Sect2_1]
      ,[fld_Score_Sect2_2]
      ,[fld_Score_Sect2_3]
      ,[fld_Score_Sect2_4]
      ,[fld_Total_Sect2]
      ,[fld_Score_Sect3_1]
      ,[fld_Score_Sect3_2]
      ,[fld_Score_Sect3_3]
      ,[fld_Score_Sect3_4]
      ,[fld_Score_Sect3_5]
      ,[fld_Score_Sect3_6]
      ,[fld_Score_Sect3_7]
      ,[fld_Total_Sect3]
      ,[fld_Performance_Lvl]
      ,[fld_DateCreate]
      ,[fld_DateLastUpdate]
  FROM [db_DRA].[dbo].[Results]
  WHERE 
	fld_AssessmentWindow = 'SPRING'
	AND (FLD_GRDE = '01' OR FLD_GRDE = '02')
  
