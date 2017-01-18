


ALTER FUNCTION [APS].[ShayneAttendanceExcUnexTotalsAsOf](@AsOfDate DATETIME)
RETURNS TABLE
AS
RETURN

SELECT * 
FROM
(
SELECT
    [Daily].[SIS_NUMBER] AS [SIS Number]
	,[Daily].[SCHOOL_CODE] AS [School Code]
	,[Daily].[Half-Day Unexcused]*0.5 AS [Half-Day Unexcused]
    ,[Daily].[Full-Day Unexcused] AS [Full-Day Unexcused]
	,([Daily].[Half-Day Unexcused]*0.5)+[Daily].[Full-Day Unexcused] AS [Total Unexcused]
	,[Daily].[Half-Day Excused]*0.5 AS [Half-Day Excused]
    ,[Daily].[Full-Day Excused] AS [Full-Day Excused]
	,([Daily].[Half-Day Excused]*0.5)+[Daily].[Full-Day Excused] AS [Total Excused]

FROM
    [APS].[ShayneDailyAttendanceAsOf](@AsOfDate) AS [Daily]

UNION
SELECT
    CASE WHEN [Period].[SIS_NUMBER] IS NULL THEN Period2.SIS_NUMBER ELSE PERIOD.SIS_NUMBER END AS [SIS Number]
	,CASE WHEN [Period].[SCHOOL_CODE] IS NULL THEN Period2.SCHOOL_CODE ELSE PERIOD.SCHOOL_CODE END AS [School Code]
	,[Period].[Half Days Unexcused]*0.5 as [Half-Day Unexcused]
    ,[Period].[Full Days Unexcused] AS [Full-Day Unexcused]
	,([Period].[Half Days Unexcused]*0.5)+[Period].[Full Days Unexcused] AS [Total Unexcused]
	,[Period2].[Half Days Excused]*0.5 as [Half-Day Excused]
    ,[Period2].[Full Days Excused] AS [Full-Day Excused]
	,([Period2].[Half Days Excused]*0.5)+[Period2].[Full Days Excused] AS [Total Excused]

FROM
    [APS].[ShaynePeriodUnexcusedAsOf](@AsOfDate) AS [Period]

	FULL OUTER JOIN 
	 [APS].[ShaynePeriodExcusedAsOf](@AsOfDate) AS [Period2]
	ON
	Period.SCHOOL_CODE = Period2.SCHOOL_CODE
	AND Period.SIS_NUMBER = Period2.SIS_NUMBER


) AS [Totals]
GO


