USE [ST_Daily]
GO


ALTER FUNCTION [APS].[Daily](@asOfDate DATE)
RETURNS TABLE
AS
RETURN
SELECT DISTINCT 
    ISNULL([Excused].[SIS_NUMBER],[Unexcused].[SIS_NUMBER]) AS [SIS_NUMBER]
	,ISNULL([Excused].[STATE_STUDENT_NUMBER],[Unexcused].[STATE_STUDENT_NUMBER]) AS [STATE_STUDENT_NUMBER]
    ,ISNULL([Excused].[SCHOOL_CODE],[Unexcused].[SCHOOL_CODE]) AS [SCHOOL_CODE]
	,ISNULL([Excused].[ABS_DATE],[Unexcused].[ABS_DATE]) AS [ABS_DATE]
    ,0 AS [Half-Day Unexcused]
    ,ISNULL([Unexcused].[Unexcused Absence Count],0) AS [Full-Day Unexcused]
    ,0 AS [Half-Day Excused]
    ,ISNULL([Excused].[Excused Absence Count],0) AS [Full-Day Excused]
FROM
	(
    SELECT
	   [Student].[SIS_NUMBER]
	   ,Student.STATE_STUDENT_NUMBER
	   ,[School].[SCHOOL_CODE]
	   ,DAILY.ABS_DATE
	   ,COUNT([Daily].[ABS_DATE]) AS [Excused Absence Count]
    FROM
	   [rev].[EPC_STU_ATT_DAILY] AS [Daily]

	   INNER HASH JOIN
	   [rev].[EPC_STU_ENROLL] AS [Enroll]
	   ON
	   [Daily].[ENROLLMENT_GU]=[Enroll].[ENROLLMENT_GU]

	   INNER HASH JOIN
	   [rev].[EPC_STU_SCH_YR] AS [SSY]
	   ON
	   [Enroll].[STUDENT_SCHOOL_YEAR_GU]=[SSY].[STUDENT_SCHOOL_YEAR_GU]

	   INNER HASH JOIN
	   [rev].[REV_ORGANIZATION_YEAR] AS [OrgYear]
	   ON
	   [SSY].[ORGANIZATION_YEAR_GU]=[OrgYear].[ORGANIZATION_YEAR_GU]

	   INNER HASH JOIN
	   [rev].[EPC_SCH] AS [School]
	   ON
	   [OrgYear].[ORGANIZATION_GU]=[School].[ORGANIZATION_GU]

	   LEFT HASH JOIN 
	   rev.EPC_CODE_ABS_REAS_SCH_YR AS [ReasonSSY]
	   ON 
	   [ReasonSSY].CODE_ABS_REAS_SCH_YEAR_GU = Daily.CODE_ABS_REAS1_GU
	   AND OrgYear.ORGANIZATION_YEAR_GU = ReasonSSY.ORGANIZATION_YEAR_GU

	   LEFT HASH JOIN 
	   rev.EPC_CODE_ABS_REAS AS [Reason] 
	   ON 
	   ReasonSSY.CODE_ABS_REAS_GU = Reason.CODE_ABS_REAS_GU
    
	   INNER HASH JOIN
	   [rev].[EPC_STU] AS [Student]
	   ON
	   [SSY].[STUDENT_GU]=[Student].[STUDENT_GU]

	   INNER HASH JOIN
	   [APS].[YearDates] AS [Year]
	   ON
	   [SSY].[YEAR_GU]=[Year].[YEAR_GU]
	   AND (@asOfDate BETWEEN [Year].[START_DATE] AND [Year].[END_DATE])

    WHERE
	   [Reason].[TYPE]='UNE'
	   AND ([School].[SCHOOL_CODE] BETWEEN '200' AND '399' OR [School].[SCHOOL_CODE]='496')
	   AND [Daily].ABS_DATE<=@asOfDate

    GROUP BY
	   [Student].[SIS_NUMBER]
	    ,Student.STATE_STUDENT_NUMBER
		,ABS_DATE
	   ,[School].[SCHOOL_CODE]
    ) AS [Excused]

	FULL JOIN
    (
    SELECT
	   [Student].[SIS_NUMBER]
	    ,Student.STATE_STUDENT_NUMBER
		,[School].[SCHOOL_CODE]
		,ABS_DATE 
	   ,COUNT([Daily].[ABS_DATE]) AS [Unexcused Absence Count]
    FROM
	   [rev].[EPC_STU_ATT_DAILY] AS [Daily]

	   INNER HASH JOIN
	   [rev].[EPC_STU_ENROLL] AS [Enroll]
	   ON
	   [Daily].[ENROLLMENT_GU]=[Enroll].[ENROLLMENT_GU]

	   INNER HASH JOIN
	   [rev].[EPC_STU_SCH_YR] AS [SSY]
	   ON
	   [Enroll].[STUDENT_SCHOOL_YEAR_GU]=[SSY].[STUDENT_SCHOOL_YEAR_GU]

	   INNER HASH JOIN
	   [rev].[REV_ORGANIZATION_YEAR] AS [OrgYear]
	   ON
	   [SSY].[ORGANIZATION_YEAR_GU]=[OrgYear].[ORGANIZATION_YEAR_GU]

	   INNER HASH JOIN
	   [rev].[EPC_SCH] AS [School]
	   ON
	   [OrgYear].[ORGANIZATION_GU]=[School].[ORGANIZATION_GU]

	   LEFT HASH JOIN 
	   rev.EPC_CODE_ABS_REAS_SCH_YR AS [ReasonSSY]
	   ON 
	   [ReasonSSY].CODE_ABS_REAS_SCH_YEAR_GU = Daily.CODE_ABS_REAS1_GU
	   AND OrgYear.ORGANIZATION_YEAR_GU = ReasonSSY.ORGANIZATION_YEAR_GU

	   LEFT HASH JOIN 
	   rev.EPC_CODE_ABS_REAS AS [Reason] 
	   ON 
	   ReasonSSY.CODE_ABS_REAS_GU = Reason.CODE_ABS_REAS_GU
    
	   INNER HASH JOIN
	   [rev].[EPC_STU] AS [Student]
	   ON
	   [SSY].[STUDENT_GU]=[Student].[STUDENT_GU]

	   INNER HASH JOIN
	   [APS].[YearDates] AS [Year]
	   ON
	   [SSY].[YEAR_GU]=[Year].[YEAR_GU]
	   AND (@asOfDate BETWEEN [Year].[START_DATE] AND [Year].[END_DATE])

    WHERE
	   [Reason].[TYPE]='UNE'
	   AND ([School].[SCHOOL_CODE] BETWEEN '200' AND '399' OR [School].[SCHOOL_CODE]='496')
	   AND [Daily].ABS_DATE<=@asOfDate

    GROUP BY
	   [Student].[SIS_NUMBER]
	    ,Student.STATE_STUDENT_NUMBER
	   ,[School].[SCHOOL_CODE]
	   ,ABS_DATE
    ) AS [Unexcused]
    ON
    [Unexcused].[SIS_NUMBER]=[Excused].[SIS_NUMBER]
    AND [Unexcused].[SCHOOL_CODE]=[Excused].[SCHOOL_CODE]


GO


