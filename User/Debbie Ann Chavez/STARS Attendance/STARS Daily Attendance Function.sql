
/****** Object:  UserDefinedFunction [APS].[STARSDailyAttendanceAsOf]    Script Date: 10/23/2017 5:16:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER FUNCTION [APS].[STARSDailyAttendanceAsOf](@startDate DATE, @endDate DATE)
RETURNS TABLE
AS
RETURN



SELECT
    [Daily].[SIS_NUMBER] AS [SIS Number]
	,Daily.STATE_STUDENT_NUMBER AS [State Student Number]
	,[Daily].[SCHOOL_CODE] AS [School Code]
	,Daily.STATE_SCHOOL_CODE AS [State School Code]
	,DAILY.EXCLUDE_ADA_ADM AS [Exclude_ADA_ADM]
	,Daily.ABS_DATE AS [Absence Date]

	,'' AS [Unexcused Half Day]
	,CASE WHEN EXCUSED = 'U' AND [Excused Absence Count] IN (1.0, 1) THEN 'UNFD' ELSE '' END AS [Unexcused Full Day]

	,'' AS [Excused Religious Half Day]
	,CASE WHEN EXCUSED = 'E' AND [Excused Absence Count] IN (1.0, 1) THEN 'EFDCO' ELSE '' END AS [Excused Religious Full Day]


FROM
	(
    SELECT
	   [Student].[SIS_NUMBER]
	   ,Student.STATE_STUDENT_NUMBER
	   ,[School].[SCHOOL_CODE]
	   ,School.STATE_SCHOOL_CODE
	   ,[SSY].[EXCLUDE_ADA_ADM]
	   ,[Daily].ABS_DATE
	   ,COUNT([Daily].[ABS_DATE]) AS [Excused Absence Count]
	   ,'E' AS EXCUSED
    FROM
	   [rev].[EPC_STU_ATT_DAILY]  AS [Daily] WITH (NOLOCK)

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
	   rev.EPC_CODE_ABS_REAS AS [Reason]  WITH (NOLOCK)
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
	   AND [Year].YEAR_GU = (SELECT YEAR_GU FROM REV.SIF_22_Common_CurrentYearGU)
	--AND (@asOfDate BETWEEN [yr].[START_DATE] AND [yr].[END_DATE])
	AND [Year].EXTENSION = 'R'
    WHERE
	   [Reason].[TYPE]='EXC' AND REASON.ABBREVIATION = 'RC'
	      AND (
	   [School].[SCHOOL_CODE] BETWEEN '200' AND '399' 
	   OR [School].[SCHOOL_CODE]IN ('022', '045', '058', '910', '973', '983', '900', '901')
	   OR ([School].SCHOOL_CODE = '496' AND SSY.GRADE IN ('050','070','090','100', '110','120','130','140','150'))
	   )
	   AND Daily.ABS_DATE<=@endDate
		AND Daily.[ABS_DATE]>=@startDate
	   AND SSY.GRADE NOT IN ('050', '070', '090')
	  -- AND Student.SIS_NUMBER = 980023595

    GROUP BY
	   [Student].[SIS_NUMBER]
	   ,Student.STATE_STUDENT_NUMBER
	   ,[School].[SCHOOL_CODE]
	    ,School.STATE_SCHOOL_CODE
	     ,[SSY].[EXCLUDE_ADA_ADM]
		 ,Daily.ABS_DATE
   -- ) AS [Excused]

	UNION ALL
   -- (
    SELECT
	   [Student].[SIS_NUMBER]
	   ,Student.STATE_STUDENT_NUMBER
	   ,[School].[SCHOOL_CODE]
	    ,School.STATE_SCHOOL_CODE
	     ,[SSY].[EXCLUDE_ADA_ADM]
		 ,[Daily].[ABS_DATE]
	   ,COUNT([Daily].[ABS_DATE]) AS [Unexcused Absence Count]
	   ,'U' AS UNEXCUSED
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
	  AND [Year].YEAR_GU = (SELECT YEAR_GU FROM REV.SIF_22_Common_CurrentYearGU)
	--AND (@asOfDate BETWEEN [yr].[START_DATE] AND [yr].[END_DATE])
	AND [Year].EXTENSION = 'R'
    WHERE
	   [Reason].[TYPE]='UNE'
	       AND (
	   [School].[SCHOOL_CODE] BETWEEN '200' AND '399' 
	   OR [School].[SCHOOL_CODE]IN ('022', '045', '058', '910', '973', '983', '900', '901')
	   OR ([School].SCHOOL_CODE = '496' AND SSY.GRADE IN ('050','070','090','100', '110','120','130','140','150'))
	   )
	  	   AND Daily.ABS_DATE<=@endDate
		AND Daily.[ABS_DATE]>=@startDate
	   AND SSY.GRADE NOT IN ('050', '070', '090')
	   --AND Student.SIS_NUMBER = 980023595
    GROUP BY
	   [Student].[SIS_NUMBER]
	   ,Student.STATE_STUDENT_NUMBER
	   ,[School].[SCHOOL_CODE]
	    ,School.STATE_SCHOOL_CODE
	     ,[SSY].[EXCLUDE_ADA_ADM]
		 ,Daily.ABS_DATE

) AS Daily





GO


