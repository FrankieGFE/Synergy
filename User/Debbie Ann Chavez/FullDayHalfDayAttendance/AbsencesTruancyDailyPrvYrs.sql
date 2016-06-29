USE [ST_Production]
GO


ALTER FUNCTION [APS].[AttendanceFDHDESAsOf](@AsOfDate DATETIME)
RETURNS TABLE
AS
RETURN

SELECT DISTINCT
	[Org].[ORGANIZATION_NAME] AS [School Name]
	,[Truant].[SCHOOL_CODE]
	,[Truant].[SIS_NUMBER]
	,[Student].[LAST_NAME]+', '+[Student].[FIRST_NAME] AS [Name]
	,[Truant].[Total Unexcused] AS [Absences]
	,[Levels].[VALUE_DESCRIPTION] AS [Grade]
		
FROM
(

SELECT
    [Daily].[SIS_NUMBER]
	,[Daily].[SCHOOL_CODE]
	,[Daily].[Half-Day Unexcused]*0.5 AS [Half-Day Unexcused]
    ,[Daily].[Full-Day Unexcused] AS [Full-Day Unexcused]
	,([Daily].[Half-Day Unexcused]*0.5)+[Daily].[Full-Day Unexcused] AS [Total Unexcused]
FROM
    [APS].[FDHDAbsencesESAsOf](@asOfDate) AS [Daily]
/*
UNION
SELECT
    [Period].[SIS_NUMBER]
	,[Period].[SCHOOL_CODE]
	,[Period].[Half Days Unexcused]*0.5 as [Half-Day Unexcused]
    ,[Period].[Full Days Unexcused] AS [Full-Day Unexcused]
	,([Period].[Half Days Unexcused]*0.5)+[Period].[Full Days Unexcused] AS [Total Unexcused]
FROM
    [APS].[FDHDAbsencesAsOf](@asOfDate) AS [Period]
*/
) AS [Truant]

INNER HASH JOIN
[APS].[BasicStudentWithMoreInfo] AS [Student]
ON
[Truant].[SIS_NUMBER]=[Student].[SIS_NUMBER]


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



GO


