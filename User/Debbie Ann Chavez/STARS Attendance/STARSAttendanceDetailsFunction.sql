USE [ST_Stars]
GO

/****** Object:  UserDefinedFunction [APS].[STARSAttendanceDetailsAsOf]    Script Date: 10/19/2017 8:48:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER FUNCTION [APS].[STARSAttendanceDetailsAsOf](@AsOfDate DATETIME)
RETURNS TABLE
AS
RETURN


SELECT
    [SIS Number]
	,[State Student Number]
	,[School Code]
	,[State School Code]
	,[Exclude_ADA_ADM]
	,CAST([Absence Date] AS DATE) AS [Absence Date]
	,[Unexcused Half Day]
	,[Unexcused Full Day]
	,[Excused Religious Half Day]
	,[Excused Religious Full Day]

FROM
    [APS].[STARSDailyAttendanceAsOf](@AsOfDate) AS [Daily]

UNION

	SELECT 

	SIS_NUMBER
	,STATE_STUDENT_NUMBER
	,SCHOOL_CODE
	,STATE_SCHOOL_CODE
	,[Exclude_ADA_ADM]
	,ABS_DATE

	,CASE WHEN EXCUSED = 'U' AND [Half-Day] IN (1.0, 1, 0.500) THEN 'UNHD' ELSE '' END AS  [Unexcused Half Day]
	,CASE WHEN EXCUSED = 'U' AND [Full-Day] IN (1.0, 1) THEN 'UNFD' ELSE '' END AS [Unexcused Full Day]

	,CASE WHEN EXCUSED = 'E' AND [Half-Day] IN (1.0, 1, 0.500) THEN 'EHDCO' ELSE '' END AS  [Excused Religious Half Day]
	,CASE WHEN EXCUSED = 'E' AND [Full-Day] IN (1.0, 1) THEN 'EFDCO' ELSE '' END AS [Excused Religious Full Day]

FROM

(
	SELECT
	 SIS_NUMBER
	,STATE_STUDENT_NUMBER
	,SCHOOL_CODE
	,STATE_SCHOOL_CODE
	,[Exclude_ADA_ADM]
	,ABS_DATE
	,[Half Days Unexcused]*0.5 as [Half-Day]
	,[Full Days Unexcused] AS [Full-Day]
	,'U' AS EXCUSED
	FROM 
   [APS].[STARSPeriodUnexcusedAsOf](@AsOfDate) AS [Period]

	UNION ALL 

	SELECT
	 SIS_NUMBER
	,STATE_STUDENT_NUMBER
	,SCHOOL_CODE 
	,STATE_SCHOOL_CODE
	,[Exclude_ADA_ADM]
	,ABS_DATE
	,[Half Days Unexcused]*0.5 as [Half-Day]
    ,[Full Days Unexcused] AS [Full-Day]
	,'E' AS EXCUSED
	FROM [APS].[STARSPeriodExcusedAsOf](@AsOfDate) AS [Period2]
	
) AS T1

WHERE 
([Half-Day] + [Full-Day] != 0.00)

 	









GO


