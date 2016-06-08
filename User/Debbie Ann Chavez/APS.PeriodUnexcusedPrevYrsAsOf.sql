USE [ST_Production]
GO


ALTER FUNCTION [APS].[PeriodUnexcusedPrevYrsAsOf](@AsOfDate DATE)
RETURNS TABLE
AS
RETURN

WITH [HighSchoolTruant] AS 
(
SELECT
    [stu].[STUDENT_GU]
    ,[stu].[SIS_NUMBER]
    ,[sch].[SCHOOL_CODE]
    ,[atd].[ABS_DATE]
    ,[cal].[ROTATION]
    ,CAST(COUNT(*) AS DECIMAL(5,2)) AS [Unexcused Count For Day]
FROM
    [rev].[EPC_STU_ATT_DAILY] AS [atd]

    INNER JOIN
    [rev].[EPC_STU_ATT_PERIOD] AS [atp]
    ON
    [atd].[DAILY_ATTEND_GU]=[atp].[DAILY_ATTEND_GU]

    INNER JOIN
    [rev].[EPC_STU_ENROLL] AS [enr]
    ON
    [atd].[ENROLLMENT_GU]=[enr].[ENROLLMENT_GU]
    AND [enr].[EXCLUDE_ADA_ADM] IS NULL

    INNER JOIN
    [rev].[EPC_STU_SCH_YR] AS [ssy]
    ON
    [enr].[STUDENT_SCHOOL_YEAR_GU]=[ssy].[STUDENT_SCHOOL_YEAR_GU]
    AND [ssy].[EXCLUDE_ADA_ADM] IS NULL

    INNER JOIN
    [rev].[REV_ORGANIZATION_YEAR] AS [oy]
    ON
    [ssy].[ORGANIZATION_YEAR_GU]=[oy].[ORGANIZATION_YEAR_GU]

    INNER JOIN
    [rev].[EPC_SCH] AS [sch]
    ON
    [oy].[ORGANIZATION_GU]=[sch].[ORGANIZATION_GU]

	INNER JOIN
	[APS].[YearDates] AS [yr]
	ON
	[oy].[YEAR_GU]=[yr].[YEAR_GU]
	AND (@asOfDate BETWEEN [yr].[START_DATE] AND [yr].[END_DATE])

    LEFT JOIN
    [rev].[EPC_SCH_ATT_CAL] AS [cal]
    ON
    [oy].[ORGANIZATION_YEAR_GU]=[cal].[SCHOOL_YEAR_GU] 
    AND [atd].[ABS_DATE]=[cal].[CAL_DATE]

    LEFT JOIN
    [rev].[EPC_SCH_YR_BELL_SCHED] AS [bs]
    ON
    [oy].[ORGANIZATION_YEAR_GU]=[bs].[ORGANIZATION_YEAR_GU]
    AND [cal].[BELL_SCHEDULE]=[bs].[BELL_SCHEDULE_CODE]

    LEFT JOIN
    [rev].[EPC_SCH_YR_BELL_SCHED_PER] AS [bel]
    ON
    [bs].[BELL_SCHEDULE_GU]=[bel].[BELL_SCHEDULE_GU]
    AND [atp].[BELL_PERIOD]=[bel].[BELL_PERIOD]

    LEFT JOIN
    [rev].[EPC_CODE_ABS_REAS_SCH_YR] AS [abry]
    ON
    [atp].[CODE_ABS_REAS_GU]=[abry].[CODE_ABS_REAS_SCH_YEAR_GU]

    LEFT JOIN
    [rev].[EPC_CODE_ABS_REAS] AS [abr]
    ON
    [abry].[CODE_ABS_REAS_GU]=[abr].[CODE_ABS_REAS_GU]

    INNER JOIN
    [rev].[EPC_STU_CLASS] AS [scls]
    ON
    [ssy].[STUDENT_SCHOOL_YEAR_GU]=[scls].[STUDENT_SCHOOL_YEAR_GU]
    AND
    ([atd].[ABS_DATE]<=[scls].[LEAVE_DATE] OR [scls].[LEAVE_DATE] IS NULL)
    AND 
    [atd].[ABS_DATE]>=[scls].[ENTER_DATE]

    INNER JOIN
    [rev].[EPC_SCH_YR_SECT] AS [sect]
    ON
    [scls].[SECTION_GU]=[sect].[SECTION_GU]
    AND
    ([atp].[BELL_PERIOD]=[sect].[PERIOD_BEGIN] OR [atp].[BELL_PERIOD]=[sect].[PERIOD_END])
    
    INNER JOIN
    [rev].[EPC_STU] AS [stu]
    ON
    [ssy].[STUDENT_GU]=[stu].[STUDENT_GU]

WHERE
    [abr].[TYPE]='UNE'
    AND ([sch].[SCHOOL_CODE] BETWEEN '500' AND '599' OR [sch].[SCHOOL_CODE]!='496')
	AND [ssy].GRADE = '180'

GROUP BY
    [stu].[STUDENT_GU]
    ,[stu].[SIS_NUMBER]
    ,[sch].[SCHOOL_CODE]
    ,[atd].[ABS_DATE]
    ,[cal].[ROTATION]
), [MiddleSchoolTruant] AS 
(
SELECT
    [stu].[STUDENT_GU]
    ,[stu].[SIS_NUMBER]
    ,[sch].[SCHOOL_CODE]
    ,[atd].[ABS_DATE]
    ,[cal].[ROTATION]
    ,CAST(COUNT(*) AS DECIMAL(5,2)) AS [Unexcused Count For Day]
FROM
    [rev].[EPC_STU_ATT_DAILY] AS [atd]

    INNER JOIN
    [rev].[EPC_STU_ATT_PERIOD] AS [atp]
    ON
    [atd].[DAILY_ATTEND_GU]=[atp].[DAILY_ATTEND_GU]

    INNER JOIN
    [rev].[EPC_STU_ENROLL] AS [enr]
    ON
    [atd].[ENROLLMENT_GU]=[enr].[ENROLLMENT_GU]
    AND [enr].[EXCLUDE_ADA_ADM] IS NULL

    INNER JOIN
    [rev].[EPC_STU_SCH_YR] AS [ssy]
    ON
    [enr].[STUDENT_SCHOOL_YEAR_GU]=[ssy].[STUDENT_SCHOOL_YEAR_GU]
    AND [ssy].[EXCLUDE_ADA_ADM] IS NULL

    INNER JOIN
    [rev].[REV_ORGANIZATION_YEAR] AS [oy]
    ON
    [ssy].[ORGANIZATION_YEAR_GU]=[oy].[ORGANIZATION_YEAR_GU]

    INNER JOIN
    [rev].[EPC_SCH] AS [sch]
    ON
    [oy].[ORGANIZATION_GU]=[sch].[ORGANIZATION_GU]

	INNER JOIN
	[APS].[YearDates] AS [yr]
	ON
	[oy].[YEAR_GU]=[yr].[YEAR_GU]
	AND (@asOfDate BETWEEN [yr].[START_DATE] AND [yr].[END_DATE])

    LEFT JOIN
    [rev].[EPC_SCH_ATT_CAL] AS [cal]
    ON
    [oy].[ORGANIZATION_YEAR_GU]=[cal].[SCHOOL_YEAR_GU] AND [atd].[ABS_DATE]=[cal].[CAL_DATE]

    LEFT JOIN
    [rev].[EPC_SCH_YR_BELL_SCHED] AS [bs]
    ON
    [oy].[ORGANIZATION_YEAR_GU]=[bs].[ORGANIZATION_YEAR_GU]
    AND [cal].[BELL_SCHEDULE]=[bs].[BELL_SCHEDULE_CODE]

    LEFT JOIN
    [rev].[EPC_SCH_YR_BELL_SCHED_PER] AS [bel]
    ON
    [bs].[BELL_SCHEDULE_GU]=[bel].[BELL_SCHEDULE_GU]
    AND [atp].[BELL_PERIOD]=[bel].[BELL_PERIOD]

    LEFT JOIN
    [rev].[EPC_CODE_ABS_REAS_SCH_YR] AS [abry]
    ON
    [atp].[CODE_ABS_REAS_GU]=[abry].[CODE_ABS_REAS_SCH_YEAR_GU]

    LEFT JOIN
    [rev].[EPC_CODE_ABS_REAS] AS [abr]
    ON
    [abry].[CODE_ABS_REAS_GU]=[abr].[CODE_ABS_REAS_GU]

    INNER JOIN
    [rev].[EPC_STU_CLASS] AS [scls]
    ON
    [ssy].[STUDENT_SCHOOL_YEAR_GU]=[scls].[STUDENT_SCHOOL_YEAR_GU]
    AND
    ([atd].[ABS_DATE]<=[scls].[LEAVE_DATE] OR [scls].[LEAVE_DATE] IS NULL)
    AND 
    [atd].[ABS_DATE]>=[scls].[ENTER_DATE]

    INNER JOIN
    [rev].[EPC_SCH_YR_SECT] AS [sect]
    ON
    [scls].[SECTION_GU]=[sect].[SECTION_GU]
    AND
    ([atp].[BELL_PERIOD]=[sect].[PERIOD_BEGIN] OR [atp].[BELL_PERIOD]=[sect].[PERIOD_END])
    
    INNER JOIN
    [rev].[EPC_STU] AS [stu]
    ON
    [ssy].[STUDENT_GU]=[stu].[STUDENT_GU]

WHERE
	[abr].[TYPE]='UNE'
    AND ([sch].[SCHOOL_CODE] BETWEEN '400' AND '499' 
	OR [sch].[SCHOOL_CODE]='496')
	AND [Cal].[CAL_DATE]<=@AsOfDate
	AND [ssy].GRADE = '180'

GROUP BY
    [stu].[STUDENT_GU]
    ,[stu].[SIS_NUMBER]
    ,[sch].[SCHOOL_CODE]
    ,[atd].[ABS_DATE]
    ,[cal].[ROTATION]
), [HSSchedCount] AS 
(
SELECT
    [stu].[STUDENT_GU]
    ,[stu].[SIS_NUMBER]
    ,[Section].[TERM_CODE]
    ,[cal].[CAL_DATE]
    ,[cal].[ROTATION]
    ,COUNT(*) AS [Total Classes]
FROM
    [rev].[EPC_STU_CLASS] AS [Class]

    INNER JOIN
    [rev].[EPC_SCH_YR_SECT] AS [Section]
    ON
    [Class].[SECTION_GU]=[Section].[SECTION_GU]
    AND [Section].[EXCLUDE_ATTENDANCE]='Y'

    INNER JOIN 
	rev.[EPC_SCH_YR_CRS] AS [SchoolYearCourse]
	ON [Section].[SCHOOL_YEAR_COURSE_GU] = [SchoolYearCourse].[SCHOOL_YEAR_COURSE_GU]

	INNER JOIN
	rev.[REV_ORGANIZATION_YEAR] AS [OrgYear]
	ON [Section].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]

	INNER JOIN
	[APS].[YearDates] AS [Year]
	ON
	[OrgYear].[YEAR_GU]=[Year].[YEAR_GU]
	AND (@asOfDate BETWEEN [Year].[START_DATE] AND [Year].[END_DATE])

	LEFT OUTER JOIN
	rev.[EPC_STU_SCH_YR] AS [StudentSchoolYear] -- Contains Grade and Start Date 	
	ON
	[Class].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
	AND [StudentSchoolYear].[EXCLUDE_ADA_ADM] IS NULL

    INNER JOIN
    [rev].[EPC_STU] AS [stu]
    ON
    [StudentSchoolYear].[STUDENT_GU]=[stu].[STUDENT_GU]

    INNER JOIN
    [rev].[EPC_SCH_ATT_CAL] AS [cal]
    ON
    [OrgYear].[ORGANIZATION_YEAR_GU]=[cal].[SCHOOL_YEAR_GU]
    AND
    [cal].[CAL_DATE]>=[StudentSchoolYear].[ENTER_DATE] AND ([cal].[CAL_DATE]<=[StudentSchoolYear].[LEAVE_DATE] OR [StudentSchoolYear].[LEAVE_DATE] IS NULL)
    AND
    [cal].[CAL_DATE]>=[Class].[ENTER_DATE] AND ([cal].[CAL_DATE]<=[Class].[LEAVE_DATE] OR [Class].[LEAVE_DATE] IS NULL)

    INNER JOIN 
    rev.EPC_SCH_YR_SECT_MET_DY AS sysmd 
    ON 
    sysmd.SECTION_GU      = [Section].SECTION_GU
    
    LEFT JOIN 
    rev.EPC_SCH_YR_MET_DY AS symd  
    ON 
    symd.SCH_YR_MET_DY_GU = sysmd.SCH_YR_MET_DY_GU 
    AND 
    [cal].[ROTATION]=[symd].[MEET_DAY_CODE]

WHERE
    [Cal].[ROTATION] IS NOT NULL
    AND [Cal].[CAL_DATE]<=@AsOfDate
	AND [StudentSchoolYear].GRADE = '180'

GROUP BY
    [stu].[STUDENT_GU]
    ,[stu].[SIS_NUMBER]
    ,[Section].[TERM_CODE]
    ,[cal].[CAL_DATE]
    ,[cal].[ROTATION]
), [MSSchedCount] AS 
(
SELECT
    [stu].[STUDENT_GU]
    ,[stu].[SIS_NUMBER]
    ,[Section].[TERM_CODE]
    ,[cal].[CAL_DATE]
    ,[cal].[ROTATION]
    ,COUNT(*) AS [Total Classes]
FROM
    [rev].[EPC_STU_CLASS] AS [Class]

    INNER JOIN
    [rev].[EPC_SCH_YR_SECT] AS [Section]
    ON
    [Class].[SECTION_GU]=[Section].[SECTION_GU]
    AND [Section].[EXCLUDE_ATTENDANCE]='Y'

    INNER JOIN 
	rev.[EPC_SCH_YR_CRS] AS [SchoolYearCourse]
	ON [Section].[SCHOOL_YEAR_COURSE_GU] = [SchoolYearCourse].[SCHOOL_YEAR_COURSE_GU]

	INNER JOIN
	rev.[REV_ORGANIZATION_YEAR] AS [OrgYear]
	ON [Section].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]

	INNER JOIN
	[APS].[YearDates] AS [Year]
	ON
	[OrgYear].[YEAR_GU]=[Year].[YEAR_GU]
	AND (@asOfDate BETWEEN [Year].[START_DATE] AND [Year].[END_DATE])

	LEFT OUTER JOIN
	rev.[EPC_STU_SCH_YR] AS [StudentSchoolYear] -- Contains Grade and Start Date 	
	ON
	[Class].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
	AND [StudentSchoolYear].[EXCLUDE_ADA_ADM] IS NULL

    INNER JOIN
    [rev].[EPC_STU] AS [stu]
    ON
    [StudentSchoolYear].[STUDENT_GU]=[stu].[STUDENT_GU]

    INNER JOIN
    [rev].[EPC_SCH_ATT_CAL] AS [cal]
    ON
    [OrgYear].[ORGANIZATION_YEAR_GU]=[cal].[SCHOOL_YEAR_GU] /*AND [atd].[ABS_DATE]=[cal].[CAL_DATE]*/
    AND
    [cal].[CAL_DATE]>=[StudentSchoolYear].[ENTER_DATE] AND ([cal].[CAL_DATE]<=[StudentSchoolYear].[LEAVE_DATE] OR [StudentSchoolYear].[LEAVE_DATE] IS NULL)
    AND
    [cal].[CAL_DATE]>=[Class].[ENTER_DATE] AND ([cal].[CAL_DATE]<=[Class].[LEAVE_DATE] OR [Class].[LEAVE_DATE] IS NULL)

    INNER JOIN 
    rev.EPC_SCH_YR_SECT_MET_DY AS sysmd 
    ON 
    sysmd.SECTION_GU      = [Section].SECTION_GU
    
    LEFT JOIN 
    rev.EPC_SCH_YR_MET_DY AS symd  
    ON 
    symd.SCH_YR_MET_DY_GU = sysmd.SCH_YR_MET_DY_GU 
    AND 
    [cal].[ROTATION]=[symd].[MEET_DAY_CODE]

WHERE
    [Cal].[ROTATION] IS NOT NULL
    AND [Cal].[CAL_DATE]<=@AsOfDate
	AND [StudentSchoolYear].GRADE = '180'

GROUP BY
    [stu].[STUDENT_GU]
    ,[stu].[SIS_NUMBER]
    ,[Section].[TERM_CODE]
    ,[cal].[CAL_DATE]
    ,[cal].[ROTATION]
)

SELECT
	[Truants].[SIS_NUMBER]
	,[Truants].[SCHOOL_CODE]
	,SUM([Truants].[Half Days Unexcused]) AS [Half Days Unexcused]
	,SUM([Truants].[Full Days Unexcused]) AS [Full Days Unexcused]
	,SUM([Truants].[Total Unexcused]) AS [Total Unexcused]
FROM
(
SELECT --start with high schoolers
    [Truant].[SIS_NUMBER]
    ,[Truant].[SCHOOL_CODE]
    ,ISNULL(SUM(CASE
	   WHEN [Truant].[Unexcused Count For Day] >= 2 THEN
		  CASE WHEN [Truant].[Truant Percentage]<=50.00 THEN 1.00
		       ELSE 0
		  END
	   ELSE
		  0
     END),0.00) AS [Half Days Unexcused]
    ,ISNULL(SUM(CASE
	   WHEN [Truant].[Unexcused Count For Day] >= 2 THEN
		       CASE WHEN ([Truant].[Truant Percentage]>50.00 AND [Truant].[Truant Percentage]>0) THEN 1.00
		       ELSE 0.00
		  END
	   ELSE
		  0
     END),0.00) AS [Full Days Unexcused]
    ,ISNULL(SUM(CASE
	   WHEN [Truant].[Unexcused Count For Day] >= 2 THEN
			  CASE WHEN ([Truant].[Truant Percentage]<=50.00 AND [Truant].[Truant Percentage]>0) THEN 0.50
				  WHEN [Truant].[Truant Percentage]>50.00 THEN 1.00
		       ELSE 0
		  END
	   ELSE
		  0
     END),0.00) AS [Total Unexcused]
FROM
(
SELECT
    [Truant1].*
    ,[SchedCount].[Total Classes]
    ,([Truant1].[Unexcused Count For Day]/[SchedCount].[Total Classes])*100 AS [Truant Percentage]
FROM
[HighSchoolTruant] AS [Truant1]

LEFT JOIN
(
SELECT
    [STUDENT_GU]
    ,[SIS_NUMBER]
    ,[CAL_DATE]
    ,[ROTATION]
    ,CAST(SUM([Total Classes]) AS DECIMAL(5,2)) AS [Total Classes]
FROM
	[HSSchedCount] AS [SchedCount]

GROUP BY
    [STUDENT_GU]
    ,[SIS_NUMBER]
    ,[CAL_DATE]
    ,[ROTATION]
) AS [SchedCount]
ON
[Truant1].[STUDENT_GU]=[SchedCount].[STUDENT_GU]
AND [Truant1].[ABS_DATE]=[SchedCount].[CAL_DATE]
--AND [Truant1].[ROTATION]=[SchedCount].[ROTATION]
AND [Truant1].[Unexcused Count For Day]>=2
) AS [Truant]

WHERE
	[Truant].[SCHOOL_CODE] BETWEEN '500' AND '599'
	AND [Truant].[ABS_DATE]<=@asOfDate
GROUP BY
    [Truant].[SIS_NUMBER]
    ,[Truant].[SCHOOL_CODE]

UNION

SELECT --pull middle school truancy
    [Truant].[SIS_NUMBER]
    ,[Truant].[SCHOOL_CODE]
    ,ISNULL(SUM(CASE
	   WHEN [Truant].[Unexcused Count For Day] >= 2 THEN
		  CASE WHEN [Truant].[Truant Percentage]<=50.00 THEN 1.00
		       ELSE 0
		  END
     END),0.00) AS [Half Days Unexcused]
    ,ISNULL(SUM(CASE
	   WHEN [Truant].[Unexcused Count For Day] >= 2 THEN
		       CASE WHEN [Truant].[Truant Percentage]>50.00 THEN 1.00
		       ELSE 0.00
		  END
     END),0.00) AS [Full Days Unexcused]
    ,ISNULL(SUM(CASE
	   WHEN [Truant].[Unexcused Count For Day] >= 2 THEN
			  CASE WHEN [Truant].[Truant Percentage]<=50.00 THEN 0.50
				  WHEN [Truant].[Truant Percentage]>50.00 THEN 1.00
		       ELSE 0
		  END
     END),0.00) AS [Total Unexcused]
FROM
(
SELECT
    [Truant1].*
    ,[SchedCount].[Total Classes]
    ,([Truant1].[Unexcused Count For Day]/[SchedCount].[Total Classes])*100 AS [Truant Percentage]
FROM
	[MiddleSchoolTruant] AS [Truant1]

LEFT JOIN
(
SELECT
    [STUDENT_GU]
    ,[SIS_NUMBER]
    ,[CAL_DATE]
    ,[ROTATION]
    ,CAST(SUM([Total Classes]) AS DECIMAL(5,2)) AS [Total Classes]
FROM
	[HSSchedCount] AS [SchedCount]

GROUP BY
    [STUDENT_GU]
    ,[SIS_NUMBER]
    ,[CAL_DATE]
    ,[ROTATION]
) AS [SchedCount]
ON
[Truant1].[STUDENT_GU]=[SchedCount].[STUDENT_GU]
AND [Truant1].[ABS_DATE]=[SchedCount].[CAL_DATE]
--AND [Truant1].[ROTATION]=[SchedCount].[ROTATION]
) AS [Truant]

WHERE
    [Truant].[ABS_DATE]<=@asOfDate
	AND [Truant].[SCHOOL_CODE] BETWEEN '400' AND '499'
GROUP BY
    [Truant].[SIS_NUMBER]
    ,[Truant].[SCHOOL_CODE]
) AS [Truants]

GROUP BY
	[Truants].[SIS_NUMBER]
	,[Truants].[SCHOOL_CODE]

GO


