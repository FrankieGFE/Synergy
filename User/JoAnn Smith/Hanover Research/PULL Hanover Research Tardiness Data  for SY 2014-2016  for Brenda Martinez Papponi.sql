--/*
-- * Revision 1
-- * Last Changed By:    JoAnn Smith
-- * Last Changed Date:  1/26/17
-- ******************************************************
-- Hanover will examine the impact of Nspire on students’ attendance.
--	1.	Attendance information for all Highland students between 2011-12 to Present school year
--	Total Membership days
--	Total absences
--	Total Present
--	School year identified
--	2.	Tardiness information if available
 
-- ******************************************************
-- 1-26-2017 Initial query

--5-22-2015 sy 2014
--5-25-2016 sy 2015
--getdate for 2016

--Change out SY and date in this snippet
--	[oy].[YEAR_GU]=[yr].[YEAR_GU]
--AND getdate() BETWEEN [yr].[START_DATE] AND [yr].[END_DATE]
--AND [yr].EXTENSION = 'R'



WITH TARDYCTE(SY, SISNUMBER, SCHOOLCODE, ABSENTDATE, TARDYCOUNT)
AS
(
SELECT 
	 '2016' SY,
    [stu].[SIS_NUMBER]
    ,[sch].[SCHOOL_CODE]
    ,[atd].[ABS_DATE]
    ,CAST(COUNT(*) AS DECIMAL(5,2)) AS [Tardy Count For Day]
FROM
    [rev].[EPC_STU_ATT_DAILY] AS [atd] WITH (NOLOCK)

    INNER JOIN
    [rev].[EPC_STU_ATT_PERIOD] AS [atp] WITH (NOLOCK)
    ON
    [atd].[DAILY_ATTEND_GU]=[atp].[DAILY_ATTEND_GU]

    INNER JOIN
    [rev].[EPC_STU_ENROLL] AS [enr] WITH (NOLOCK)
    ON
    [atd].[ENROLLMENT_GU]=[enr].[ENROLLMENT_GU]
    AND [enr].[EXCLUDE_ADA_ADM] IS NULL

    INNER JOIN
    [rev].[EPC_STU_SCH_YR] AS [ssy] WITH (NOLOCK)
    ON
    [enr].[STUDENT_SCHOOL_YEAR_GU]=[ssy].[STUDENT_SCHOOL_YEAR_GU]
    AND [ssy].[EXCLUDE_ADA_ADM] IS NULL

    INNER JOIN
    [rev].[REV_ORGANIZATION_YEAR] AS [oy] WITH (NOLOCK)
    ON
    [ssy].[ORGANIZATION_YEAR_GU]=[oy].[ORGANIZATION_YEAR_GU]

    INNER JOIN
    [rev].[EPC_SCH] AS [sch] WITH (NOLOCK)
    ON
    [oy].[ORGANIZATION_GU]=[sch].[ORGANIZATION_GU]

	INNER JOIN
	[APS].[YearDates] AS [yr] WITH (NOLOCK)
	ON
	[oy].[YEAR_GU]=[yr].[YEAR_GU]
	AND getdate() BETWEEN [yr].[START_DATE] AND [yr].[END_DATE]
	AND [yr].EXTENSION = 'R'
    LEFT JOIN
    [rev].[EPC_SCH_ATT_CAL] AS [cal] WITH (NOLOCK)
    ON
    [oy].[ORGANIZATION_YEAR_GU]=[cal].[SCHOOL_YEAR_GU] 
    AND [atd].[ABS_DATE]=[cal].[CAL_DATE]

    LEFT JOIN
    [rev].[EPC_SCH_YR_BELL_SCHED] AS [bs] WITH (NOLOCK)
    ON
    [oy].[ORGANIZATION_YEAR_GU]=[bs].[ORGANIZATION_YEAR_GU]
    AND [cal].[BELL_SCHEDULE]=[bs].[BELL_SCHEDULE_CODE]

    LEFT JOIN
    [rev].[EPC_SCH_YR_BELL_SCHED_PER] AS [bel] WITH (NOLOCK)
    ON
    [bs].[BELL_SCHEDULE_GU]=[bel].[BELL_SCHEDULE_GU]
    AND [atp].[BELL_PERIOD]=[bel].[BELL_PERIOD]

    LEFT JOIN
    [rev].[EPC_CODE_ABS_REAS_SCH_YR] AS [abry] WITH (NOLOCK)
    ON
    [atp].[CODE_ABS_REAS_GU]=[abry].[CODE_ABS_REAS_SCH_YEAR_GU]

    LEFT JOIN
    [rev].[EPC_CODE_ABS_REAS] AS [abr] WITH (NOLOCK)
    ON
    [abry].[CODE_ABS_REAS_GU]=[abr].[CODE_ABS_REAS_GU]

    INNER JOIN
    [rev].[EPC_STU_CLASS] AS [scls] WITH (NOLOCK)
    ON
    [ssy].[STUDENT_SCHOOL_YEAR_GU]=[scls].[STUDENT_SCHOOL_YEAR_GU]
    AND
    ([atd].[ABS_DATE]<=[scls].[LEAVE_DATE] OR [scls].[LEAVE_DATE] IS NULL)
    AND 
    [atd].[ABS_DATE]>=[scls].[ENTER_DATE]

    INNER JOIN
    [rev].[EPC_SCH_YR_SECT] AS [sect] WITH (NOLOCK)
    ON
    [scls].[SECTION_GU]=[sect].[SECTION_GU]
    AND
    ([atp].[BELL_PERIOD]=[sect].[PERIOD_BEGIN] OR [atp].[BELL_PERIOD]=[sect].[PERIOD_END])
    
    INNER JOIN
    [rev].[EPC_STU] AS [stu] WITH (NOLOCK)
    ON
    [ssy].[STUDENT_GU]=[stu].[STUDENT_GU]

	INNER JOIN 
	REV.EPC_SCH_YR_OPT AS SETUP
	ON
	SETUP.ORGANIZATION_YEAR_GU = OY.ORGANIZATION_YEAR_GU

WHERE
    [abr].[TYPE] in ('TAR', 'TDY')
  	and SETUP.SCHOOL_ATT_TYPE IN ('P', 'B')
	and sch.SCHOOL_CODE = '520'
	
GROUP BY
	
    [stu].[SIS_NUMBER]
    ,[sch].[SCHOOL_CODE]
    ,[atd].[ABS_DATE]

)

SELECT
	TAR.SY,
	TAR.SISNUMBER,
	TAR.SCHOOLCODE,
	SUM(TAR.TARDYCOUNT) AS [TOTAL TARDIES]
FROM
	TARDYCTE TAR
GROUP BY
	tar.sy, TAR.SISNUMBER, TAR.SCHOOLCODE
ORDER BY
	TAR.SISNUMBER


