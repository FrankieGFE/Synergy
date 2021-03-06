USE [db_DRA]
GO

SELECT [fld_ID_NBR] AS 'APS ID'
	  ,'2013-2014' AS 'SCHOOL YEAR'
      ,[fld_STATE_ID] AS 'STATE ID'
      ,[fld_TestLoc] 'SCHOOL LOCATION CODE'
      ,[fld_Assessment_Used] AS 'TEST NAME'
      ,[fld_AssessmentWindow] AS 'TEST WINDOW'
      ,[fld_GRDE] AS 'GRADE LEVEL'
      ,[fld_Performance_Lvl] AS 'OVERALL PROFICIENCY LEVEL'
      --,[fld_PRIOR_ID]
      ,[fld_FRST_NME] AS 'FIRST NAME'
      ,[fld_LST_NME] AS 'LAST NAME'
      --,[fld_BRTH_DT]
      --,[fld_EmployeeID]
      --,[fld_Level]
      --,[fld_Story]
      --,[fld_Score_Sect1_1]
      --,[fld_Score_Sect1_2]
      --,[fld_Score_Sect1_3]
      --,[fld_Total_Sect1]
      --,[fld_Score_Sect2_1]
      --,[fld_Score_Sect2_2]
      --,[fld_Score_Sect2_3]
      --,[fld_Score_Sect2_4]
      --,[fld_Total_Sect2]
      --,[fld_Score_Sect3_1]
      --,[fld_Score_Sect3_2]
      --,[fld_Score_Sect3_3]
      --,[fld_Score_Sect3_4]
      --,[fld_Score_Sect3_5]
      --,[fld_Score_Sect3_6]
      --,[fld_Score_Sect3_7]
      --,[fld_Total_Sect3]
      --,[fld_DateCreate]
      --,[fld_DateLastUpdate]
  FROM [db_DRA].[dbo].[Results_1314]
  WHERE fld_TestLoc IN ('255','279','285','260','333','379','413','460','470','570')
  AND FLD_GRDE IN ('01','02','03')

GO



  
  