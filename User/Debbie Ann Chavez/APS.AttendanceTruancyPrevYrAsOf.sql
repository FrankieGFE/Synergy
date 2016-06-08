USE [ST_Production]
GO


ALTER FUNCTION [APS].[AttendanceTruancyPrevYrAsOf](@AsOfDate DATETIME)
RETURNS TABLE
AS
RETURN

SELECT DISTINCT
	[Org].[ORGANIZATION_NAME] AS [School Name]
	,[Truant].[SIS_NUMBER]
	,[Student].[LAST_NAME]+', '+[Student].[FIRST_NAME] AS [Name]
	,[Truant].[Total Unexcused] AS [Unexc Absences]
	,[Student].[RESOLVED_RACE] AS [Race Code]
	,[Student].[HISPANIC_INDICATOR] AS [Hispanic]
	,[Student].[HOME_LANGUAGE] AS [Home Language]
	,[Levels].[VALUE_DESCRIPTION] AS [Grade]
	,CONVERT(VARCHAR(10),[Student].[BIRTH_DATE],101) AS [Birth Date]
	,[Student].[Parents] AS [Parent or Guardian]
	,[Student].[PRIMARY_PHONE] AS [Home Phone]
	,[HomeAddress].[ADDRESS]+' '+[HomeAddress].[CITY]+', '+[HomeAddress].[STATE]+' '+[HomeAddress].[ZIP_5] AS [Mailing Address]
	,CONVERT(VARCHAR(10),[SSY].[ENTER_DATE],101) AS [Enrollment Start Date]
	,CASE WHEN [SSY].[LEAVE_DATE] IS NULL THEN '' ELSE CONVERT(VARCHAR(10),[SSY].[LEAVE_DATE],101) END AS [Enrollment End Date]
	,CASE WHEN ([Two].[TWO_DAY_TRUANT] IS NOT NULL) THEN 'X' ELSE '' END AS [2 Day Call]
	,CASE WHEN ([Two].[TWO_DAY_TRUANT] IS NOT NULL) THEN CONVERT(VARCHAR(10),[Two].[ADD_DATE_TIME_STAMP],101) ELSE '' END AS [2 Day Call Date]
	,CASE WHEN ([Five].[FIVE_DAY_TRUANT] IS NOT NULL) THEN 'X' ELSE '' END AS [5 Day Call]
	,CASE WHEN ([Five].[FIVE_DAY_TRUANT] IS NOT NULL) THEN CONVERT(VARCHAR(10),[Five].[ADD_DATE_TIME_STAMP],101) ELSE '' END AS [5 Day Call Date]
	,CASE WHEN ([Ten].[TEN_DAY_TRUANT] IS NOT NULL) THEN 'X' ELSE '' END AS [10 Day Call]
	,CASE WHEN ([Ten].[TEN_DAY_TRUANT] IS NOT NULL) THEN CONVERT(VARCHAR(10),[Ten].[ADD_DATE_TIME_STAMP],101) ELSE '' END AS [10 Day Call Date]
	,[Truant].[SCHOOL_CODE]
FROM
(
/*
SELECT
    [Daily].[SIS_NUMBER]
	,[Daily].[SCHOOL_CODE]
	,[Daily].[Half-Day Unexcused]*0.5 AS [Half-Day Unexcused]
    ,[Daily].[Full-Day Unexcused] AS [Full-Day Unexcused]
	,([Daily].[Half-Day Unexcused]*0.5)+[Daily].[Full-Day Unexcused] AS [Total Unexcused]
FROM
    [APS].[DailyAttendanceAsOf](@asOfDate) AS [Daily]

UNION
*/
SELECT
    [Period].[SIS_NUMBER]
	,[Period].[SCHOOL_CODE]
	,[Period].[Half Days Unexcused]*0.5 as [Half-Day Unexcused]
    ,[Period].[Full Days Unexcused] AS [Full-Day Unexcused]
	,([Period].[Half Days Unexcused]*0.5)+[Period].[Full Days Unexcused] AS [Total Unexcused]
FROM
    [APS].[PeriodUnexcusedPrevYrsAsOf](@asOfDate) AS [Period]

) AS [Truant]

INNER HASH JOIN
[APS].[BasicStudentWithMoreInfo] AS [Student]
ON
[Truant].[SIS_NUMBER]=[Student].[SIS_NUMBER]

LEFT HASH JOIN
[rev].[REV_ADDRESS] AS [HomeAddress]
ON
[Student].[HOME_ADDRESS_GU]=[HomeAddress].[ADDRESS_GU]

INNER HASH JOIN
[rev].[EPC_SCH] AS [School]
ON
[Truant].[SCHOOL_CODE]=[School].[SCHOOL_CODE]

INNER HASH JOIN
[rev].[REV_ORGANIZATION] AS [Org]
ON
[School].[ORGANIZATION_GU]=[Org].[ORGANIZATION_GU]

INNER HASH JOIN
[rev].[REV_ORGANIZATION_YEAR] AS [OrgYear]
ON
[School].[ORGANIZATION_GU]=[OrgYear].[ORGANIZATION_GU]
AND [OrgYear].[YEAR_GU]='26F066A3-ABFC-4EDB-B397-43412EDABC8B'

INNER HASH JOIN
(
SELECT 
	*
	,ROW_NUMBER() OVER (PARTITION BY [STUDENT_GU],[ORGANIZATION_YEAR_GU],[YEAR_GU] ORDER BY [ORGANIZATION_YEAR_GU],[ENTER_DATE]) AS [RN]
FROM
	[rev].[EPC_STU_SCH_YR] AS [SSY]

WHERE
	[SSY].[YEAR_GU]='26F066A3-ABFC-4EDB-B397-43412EDABC8B'
	AND [SSY].[EXCLUDE_ADA_ADM] IS NULL AND ([SSY].[LEAVE_DATE] IS NULL OR [SSY].[LEAVE_DATE]<=@asOfDate)
	AND [SSY].[ENTER_DATE] IS NOT NULL
) AS [SSY]
ON
[Student].[STUDENT_GU]=[SSY].[STUDENT_GU]
AND [OrgYear].[ORGANIZATION_YEAR_GU]=[SSY].[ORGANIZATION_YEAR_GU]
--AND [SSY].[RN]=1

INNER HASH JOIN
[APS].[LookupTable]('K12','GRADE') AS [Levels]
ON
[SSY].[GRADE]=[Levels].[VALUE_CODE]

LEFT HASH JOIN
[rev].[UD_TRUANT_STUDENT] AS [Two]
ON
[STUDENT].[STUDENT_GU]=[Two].[STUDENT_GU]
AND [Two].[TWO_DAY_TRUANT]='Y'

LEFT HASH JOIN
[rev].[UD_TRUANT_STUDENT] AS [Five]
ON
[STUDENT].[STUDENT_GU]=[Five].[STUDENT_GU]
AND [Five].[FIVE_DAY_TRUANT]='Y'

LEFT HASH JOIN
[rev].[UD_TRUANT_STUDENT] AS [Ten]
ON
[STUDENT].[STUDENT_GU]=[Ten].[STUDENT_GU]
AND [Ten].[TEN_DAY_TRUANT]='Y'

--WHERE
	/*[Org].[ORGANIZATION_GU] LIKE @School
	AND 
	[Truant].[Total Unexcused] >= 
		CASE WHEN @DayCount=11 THEN 10
		         WHEN @DayCount=12 THEN 0
		         ELSE    @DayCount END


ORDER BY
	[Truant].[SCHOOL_CODE]
	,[Truant].[SIS_NUMBER]
*/

GO


