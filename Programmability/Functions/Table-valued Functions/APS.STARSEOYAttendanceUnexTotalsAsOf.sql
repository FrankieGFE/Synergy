USE [ST_Production]
GO

/****** Object:  UserDefinedFunction [APS].[AttendanceExcUnexTotalsAsOf]    Script Date: 6/28/2017 10:26:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE FUNCTION [APS].[STARSEOYAttendanceUnexTotalsAsOf](@AsOfDate DATETIME)
RETURNS TABLE
AS
RETURN

SELECT * 
FROM
(
SELECT
    [Daily].[SIS_NUMBER] AS [SIS Number]
	,[Daily].[SCHOOL_CODE] AS [School Code]
	,DAILY.EXCLUDE_ADA_ADM AS [Exclude_ADA_ADM]
	,DAILY.STATE_STUDENT_NUMBER AS STATE_STUDENT_NUMBER
	,DAILY.STATE_SCHOOL_CODE AS STATE_SCHOOL_CODE
	,DAILY.ABS_DATE
	,[Daily].[Half-Day Unexcused]*0.5 AS [Half-Day Unexcused]
    ,[Daily].[Full-Day Unexcused] AS [Full-Day Unexcused]
	,([Daily].[Half-Day Unexcused]*0.5)+[Daily].[Full-Day Unexcused] AS [Total Unexcused]

FROM
    [APS].[STARSEOYDailyAttendanceAsOf](@AsOfDate) AS [Daily]

UNION
SELECT
     [Period].[SIS_NUMBER]  AS [SIS Number]
	,[Period].[SCHOOL_CODE] AS [School Code]
	, [Period].EXCLUDE_ADA_ADM  AS [Exclude_ADA_ADM]
	,PERIOD.STATE_STUDENT_NUMBER
	,PERIOD.STATE_SCHOOL_CODE
	,[Period].ABS_DATE
	,[Period].[Half Days Unexcused]*0.5 as [Half-Day Unexcused]
    ,[Period].[Full Days Unexcused] AS [Full-Day Unexcused]
	,([Period].[Half Days Unexcused]*0.5)+[Period].[Full Days Unexcused] AS [Total Unexcused]
	

FROM
    [APS].[STARSEOYPeriodUnexcusedAsOf](@AsOfDate) AS [Period]

	

) AS [Totals]


GO


