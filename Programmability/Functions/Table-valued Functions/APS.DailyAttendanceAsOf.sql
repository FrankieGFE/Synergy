USE [ST_Production]
GO

/****** Object:  UserDefinedFunction [APS].[DailyAttendanceAsOf]    Script Date: 9/29/2015 8:32:25 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER FUNCTION [APS].[DailyAttendanceAsOf](@asOfDate DATE)
RETURNS TABLE
AS
RETURN	
SELECT
    [Unexcused].[SIS_NUMBER]
    ,[Unexcused].[SCHOOL_CODE]
    ,0 AS [Half-Day Unexcused]
    ,ISNULL([Unexcused].[Unexcused Absence Count],0) AS [Full-Day Unexcused]
    ,0 AS [Half-Day Excused]
    ,ISNULL([Excused].[Excused Absence Count],0) AS [Full-Day Excused]
FROM
    (
    SELECT
	   [Student].[SIS_NUMBER]
	   ,[School].[SCHOOL_CODE]
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
	   [rev].[REV_YEAR] AS [Year]
	   ON
	   [SSY].[YEAR_GU]=[Year].[YEAR_GU]
	   AND [Year].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2015 AND [EXTENSION]='R') --[rev].[SIF_22_Common_CurrentYearGU])

    WHERE
	   [Reason].[TYPE]='UNE'
	   AND [School].[SCHOOL_CODE] BETWEEN '200' AND '399'
	   AND [Daily].ABS_DATE<=@asOfDate

    GROUP BY
	   [Student].[SIS_NUMBER]
	   ,[School].[SCHOOL_CODE]
    ) AS [Unexcused]

    LEFT HASH JOIN
    (
    SELECT
	   [Student].[SIS_NUMBER]
	   ,[School].[SCHOOL_CODE]
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
	   [rev].[REV_YEAR] AS [Year]
	   ON
	   [SSY].[YEAR_GU]=[Year].[YEAR_GU]
	   AND [Year].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2015 AND [EXTENSION]='R') --[rev].[SIF_22_Common_CurrentYearGU])

    WHERE
	   [Reason].[TYPE]='EXC'
	   AND [School].[SCHOOL_CODE] BETWEEN '200' AND '399'
	   AND [Daily].ABS_DATE<=@asOfDate

    GROUP BY
	   [Student].[SIS_NUMBER]
	   ,[School].[SCHOOL_CODE]
    ) AS [Excused]
    ON
    [Unexcused].[SIS_NUMBER]=[Excused].[SIS_NUMBER]
    AND [Unexcused].[SCHOOL_CODE]=[Excused].[SCHOOL_CODE]
GO


