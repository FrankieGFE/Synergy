
SELECT
    [Period].[SIS_NUMBER]
	,[Period].[SCHOOL_CODE]
	,[Period].[Half Days Unexcused]*0.5 as [Half-Day Unexcused]
    ,[Period].[Full Days Unexcused] AS [Full-Day Unexcused]
	,([Period].[Half Days Unexcused]*0.5)+[Period].[Full Days Unexcused] AS [Total Unexcused]
FROM
    [APS].[PeriodAbsencesAsOf]('2016-05-25') AS [Period]
