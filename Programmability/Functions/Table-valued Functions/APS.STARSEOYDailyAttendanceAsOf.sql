USE [ST_Production]
GO

/****** Object:  UserDefinedFunction [APS].[DailyAttendanceAsOf]    Script Date: 6/28/2017 10:26:55 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--THIS IS GROUPED BY ABSENCE DATE -- DETAILS RECORDS NEEDED FOR STARS  -- THIS IS ONLY UNEXCUSED

CREATE FUNCTION [APS].[STARSEOYDailyAttendanceAsOf](@asOfDate DATE)
RETURNS TABLE
AS
RETURN
SELECT
    [Unexcused].[SIS_NUMBER] AS [SIS_NUMBER]
    ,[Unexcused].[SCHOOL_CODE] AS [SCHOOL_CODE]

	,[Unexcused].STATE_STUDENT_NUMBER AS STATE_STUDENT_NUMBER
    ,[Unexcused].STATE_SCHOOL_CODE AS STATE_SCHOOL_CODE

	,[Unexcused].EXCLUDE_ADA_ADM AS [EXCLUDE_ADA_ADM]

	,[Unexcused].ABS_DATE AS ABS_DATE

    ,0 AS [Half-Day Unexcused]
    ,ISNULL([Unexcused].[Unexcused Absence Count],0) AS [Full-Day Unexcused]


FROM
	 
    (
    SELECT
	   [Student].[SIS_NUMBER]
	   ,[School].[SCHOOL_CODE]
	   ,STUDENT.STATE_STUDENT_NUMBER
	   ,SCHOOL.STATE_SCHOOL_CODE
	     ,[SSY].[EXCLUDE_ADA_ADM]
		 ,[Daily].[ABS_DATE]
	   ,COUNT([Daily].[ABS_DATE]) AS [Unexcused Absence Count]
    FROM
	   [rev].[EPC_STU_ATT_DAILY] AS [Daily] WITH (NOLOCK)

	   INNER HASH JOIN
	   [rev].[EPC_STU_ENROLL] AS [Enroll] WITH (NOLOCK)
	   ON
	   [Daily].[ENROLLMENT_GU]=[Enroll].[ENROLLMENT_GU]

	   INNER HASH JOIN
	   [rev].[EPC_STU_SCH_YR] AS [SSY] WITH (NOLOCK)
	   ON
	   [Enroll].[STUDENT_SCHOOL_YEAR_GU]=[SSY].[STUDENT_SCHOOL_YEAR_GU]

	   INNER HASH JOIN
	   [rev].[REV_ORGANIZATION_YEAR] AS [OrgYear] WITH (NOLOCK)
	   ON
	   [SSY].[ORGANIZATION_YEAR_GU]=[OrgYear].[ORGANIZATION_YEAR_GU]

	   INNER HASH JOIN
	   [rev].[EPC_SCH] AS [School] WITH (NOLOCK)
	   ON
	   [OrgYear].[ORGANIZATION_GU]=[School].[ORGANIZATION_GU]

	   LEFT HASH JOIN 
	   rev.EPC_CODE_ABS_REAS_SCH_YR AS [ReasonSSY] WITH (NOLOCK)
	   ON 
	   [ReasonSSY].CODE_ABS_REAS_SCH_YEAR_GU = Daily.CODE_ABS_REAS1_GU
	   AND OrgYear.ORGANIZATION_YEAR_GU = ReasonSSY.ORGANIZATION_YEAR_GU

	   LEFT HASH JOIN 
	   rev.EPC_CODE_ABS_REAS AS [Reason] WITH (NOLOCK)
	   ON 
	   ReasonSSY.CODE_ABS_REAS_GU = Reason.CODE_ABS_REAS_GU
    
	   INNER HASH JOIN
	   [rev].[EPC_STU] AS [Student] WITH (NOLOCK)
	   ON
	   [SSY].[STUDENT_GU]=[Student].[STUDENT_GU]

	   INNER HASH JOIN
	   [APS].[YearDates] AS [Year] WITH (NOLOCK)
	   ON
	   [SSY].[YEAR_GU]=[Year].[YEAR_GU]
	   AND (@asOfDate BETWEEN [Year].[START_DATE] AND [Year].[END_DATE])
	   AND [Year].EXTENSION = 'R'
    WHERE
	   [Reason].[TYPE]='UNE'
	    AND ([School].[SCHOOL_CODE] BETWEEN '200' AND '399' 
	   OR [School].[SCHOOL_CODE]IN ('496', '022', '045', '058', '910', '973', '983', '900', '901'))
	   AND [Daily].ABS_DATE<=@asOfDate

    GROUP BY
	   [Student].[SIS_NUMBER]
	   ,[School].[SCHOOL_CODE]
	   ,STUDENT.STATE_STUDENT_NUMBER
	   ,SCHOOL.STATE_SCHOOL_CODE
	     ,[SSY].[EXCLUDE_ADA_ADM]
		 ,[Daily].[ABS_DATE]
    ) AS [Unexcused]






GO


