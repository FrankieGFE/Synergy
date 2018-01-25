USE [AIMS]
GO
begin tran
--SELECT [DistrictCode]
--      ,[LocationID]
--      ,[StudentID]
--      ,[LastName]
--      ,[FirstName]
--      ,[DOB]
--      ,[Gender]
--      ,[Ethnicity]
--      ,[EverELL]
--      ,[EverIEP]
--      ,[FRL]
--      ,[NumSnapshots]
--      ,[TotalSnapshots]
--      ,[Outcome]
--      ,[Outcome SchoolYear]
--      ,[Outcome Unknown]
--      ,[Outcome Desc]
--      ,[Enter9Grade]
--      ,[TransferIN10Grade]
--      ,[TransferIN11Grade]
--      ,[TransferIN12Grade]
--      ,[LastLocation]
update [6_Year_Consolidated_Outcome_Report] set Outcome = COH.[OUTCOME CHANGED]
  FROM [dbo].[6_Year_Consolidated_Outcome_Report] AS YR
  JOIN
	[cohort_15_graduation_verification 6 Year] AS COH
	ON YR.StudentID = COH.STUDENTID

  rollback
GO


