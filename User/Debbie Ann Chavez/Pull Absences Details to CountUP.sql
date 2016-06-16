SELECT
    [stu].[STUDENT_GU]
    ,[stu].[SIS_NUMBER]
    ,[sch].[SCHOOL_CODE]
    ,[atd].[ABS_DATE]
    ,[cal].[ROTATION]
	,[TYPE]
	,[ABBREVIATION]
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
	AND ('2016-05-25' BETWEEN [yr].[START_DATE] AND [yr].[END_DATE])

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
    --[abr].[TYPE] = ('UNE')
	[abr].[TYPE] IN ('UNE', 'UNV', 'EXC')
	AND [abr].ABBREVIATION NOT IN ('AC', 'PAR')
    AND ([sch].[SCHOOL_CODE] BETWEEN '500' AND '599' OR [sch].[SCHOOL_CODE]!='496')
	AND STU.SIS_NUMBER = 102946514
GROUP BY
    [stu].[STUDENT_GU]
    ,[stu].[SIS_NUMBER]
    ,[sch].[SCHOOL_CODE]
    ,[atd].[ABS_DATE]
    ,[cal].[ROTATION]
	,[TYPE]
	,[ABBREVIATION]