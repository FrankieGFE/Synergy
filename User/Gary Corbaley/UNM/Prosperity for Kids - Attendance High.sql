

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

    INNER HASH JOIN
    [rev].[EPC_STU_ATT_PERIOD] AS [atp]
    ON
    [atd].[DAILY_ATTEND_GU]=[atp].[DAILY_ATTEND_GU]

    INNER HASH JOIN
    [rev].[EPC_STU_ENROLL] AS [enr]
    ON
    [atd].[ENROLLMENT_GU]=[enr].[ENROLLMENT_GU]
    AND [enr].[EXCLUDE_ADA_ADM] IS NULL

    INNER HASH JOIN
    [rev].[EPC_STU_SCH_YR] AS [ssy]
    ON
    [enr].[STUDENT_SCHOOL_YEAR_GU]=[ssy].[STUDENT_SCHOOL_YEAR_GU]
    AND [ssy].[EXCLUDE_ADA_ADM] IS NULL

    INNER HASH JOIN
    [rev].[REV_ORGANIZATION_YEAR] AS [oy]
    ON
    [ssy].[ORGANIZATION_YEAR_GU]=[oy].[ORGANIZATION_YEAR_GU]

    INNER HASH JOIN
    [rev].[EPC_SCH] AS [sch]
    ON
    [oy].[ORGANIZATION_GU]=[sch].[ORGANIZATION_GU]

    INNER HASH JOIN
    [rev].[REV_YEAR] AS [yr]
    ON
    [oy].[YEAR_GU]=[yr].[YEAR_GU]

    LEFT HASH JOIN
    [rev].[EPC_SCH_ATT_CAL] AS [cal]
    ON
    [oy].[ORGANIZATION_YEAR_GU]=[cal].[SCHOOL_YEAR_GU] 
    AND [atd].[ABS_DATE]=[cal].[CAL_DATE]

    LEFT HASH JOIN
    [rev].[EPC_SCH_YR_BELL_SCHED] AS [bs]
    ON
    [oy].[ORGANIZATION_YEAR_GU]=[bs].[ORGANIZATION_YEAR_GU]
    AND [cal].[BELL_SCHEDULE]=[bs].[BELL_SCHEDULE_CODE]

    LEFT HASH JOIN
    [rev].[EPC_SCH_YR_BELL_SCHED_PER] AS [bel]
    ON
    [bs].[BELL_SCHEDULE_GU]=[bel].[BELL_SCHEDULE_GU]
    AND [atp].[BELL_PERIOD]=[bel].[BELL_PERIOD]

    LEFT HASH JOIN
    [rev].[EPC_CODE_ABS_REAS_SCH_YR] AS [abry]
    ON
    [atp].[CODE_ABS_REAS_GU]=[abry].[CODE_ABS_REAS_SCH_YEAR_GU]

    LEFT HASH JOIN
    [rev].[EPC_CODE_ABS_REAS] AS [abr]
    ON
    [abry].[CODE_ABS_REAS_GU]=[abr].[CODE_ABS_REAS_GU]

    INNER HASH JOIN
    [rev].[EPC_STU_CLASS] AS [scls]
    ON
    [ssy].[STUDENT_SCHOOL_YEAR_GU]=[scls].[STUDENT_SCHOOL_YEAR_GU]
    AND
    ([atd].[ABS_DATE]<=[scls].[LEAVE_DATE] OR [scls].[LEAVE_DATE] IS NULL)
    AND 
    [atd].[ABS_DATE]>=[scls].[ENTER_DATE]

    INNER HASH JOIN
    [rev].[EPC_SCH_YR_SECT] AS [sect]
    ON
    [scls].[SECTION_GU]=[sect].[SECTION_GU]
    AND
    ([atp].[BELL_PERIOD]=[sect].[PERIOD_BEGIN] OR [atp].[BELL_PERIOD]=[sect].[PERIOD_END])
    
    INNER HASH JOIN
    [rev].[EPC_STU] AS [stu]
    ON
    [ssy].[STUDENT_GU]=[stu].[STUDENT_GU]

WHERE
    [yr].[YEAR_GU]=(SELECT YEAR_GU FROM APS.YearDates WHERE '05/22/2015' BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
    AND [abr].[TYPE]='UNE'
    AND [sch].[SCHOOL_CODE] BETWEEN '500' AND '599'

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

    INNER HASH JOIN
    [rev].[EPC_STU_ATT_PERIOD] AS [atp]
    ON
    [atd].[DAILY_ATTEND_GU]=[atp].[DAILY_ATTEND_GU]

    INNER HASH JOIN
    [rev].[EPC_STU_ENROLL] AS [enr]
    ON
    [atd].[ENROLLMENT_GU]=[enr].[ENROLLMENT_GU]
    AND [enr].[EXCLUDE_ADA_ADM] IS NULL

    INNER HASH JOIN
    [rev].[EPC_STU_SCH_YR] AS [ssy]
    ON
    [enr].[STUDENT_SCHOOL_YEAR_GU]=[ssy].[STUDENT_SCHOOL_YEAR_GU]
    AND [ssy].[EXCLUDE_ADA_ADM] IS NULL

    INNER HASH JOIN
    [rev].[REV_ORGANIZATION_YEAR] AS [oy]
    ON
    [ssy].[ORGANIZATION_YEAR_GU]=[oy].[ORGANIZATION_YEAR_GU]

    INNER HASH JOIN
    [rev].[EPC_SCH] AS [sch]
    ON
    [oy].[ORGANIZATION_GU]=[sch].[ORGANIZATION_GU]

    INNER HASH JOIN
    [rev].[REV_YEAR] AS [yr]
    ON
    [oy].[YEAR_GU]=[yr].[YEAR_GU]

    LEFT HASH JOIN
    [rev].[EPC_SCH_ATT_CAL] AS [cal]
    ON
    [oy].[ORGANIZATION_YEAR_GU]=[cal].[SCHOOL_YEAR_GU] AND [atd].[ABS_DATE]=[cal].[CAL_DATE]

    LEFT HASH JOIN
    [rev].[EPC_SCH_YR_BELL_SCHED] AS [bs]
    ON
    [oy].[ORGANIZATION_YEAR_GU]=[bs].[ORGANIZATION_YEAR_GU]
    AND [cal].[BELL_SCHEDULE]=[bs].[BELL_SCHEDULE_CODE]

    LEFT HASH JOIN
    [rev].[EPC_SCH_YR_BELL_SCHED_PER] AS [bel]
    ON
    [bs].[BELL_SCHEDULE_GU]=[bel].[BELL_SCHEDULE_GU]
    AND [atp].[BELL_PERIOD]=[bel].[BELL_PERIOD]

    LEFT HASH JOIN
    [rev].[EPC_CODE_ABS_REAS_SCH_YR] AS [abry]
    ON
    [atp].[CODE_ABS_REAS_GU]=[abry].[CODE_ABS_REAS_SCH_YEAR_GU]

    LEFT HASH JOIN
    [rev].[EPC_CODE_ABS_REAS] AS [abr]
    ON
    [abry].[CODE_ABS_REAS_GU]=[abr].[CODE_ABS_REAS_GU]

    INNER HASH JOIN
    [rev].[EPC_STU_CLASS] AS [scls]
    ON
    [ssy].[STUDENT_SCHOOL_YEAR_GU]=[scls].[STUDENT_SCHOOL_YEAR_GU]
    AND
    ([atd].[ABS_DATE]<=[scls].[LEAVE_DATE] OR [scls].[LEAVE_DATE] IS NULL)
    AND 
    [atd].[ABS_DATE]>=[scls].[ENTER_DATE]

    INNER HASH JOIN
    [rev].[EPC_SCH_YR_SECT] AS [sect]
    ON
    [scls].[SECTION_GU]=[sect].[SECTION_GU]
    AND
    ([atp].[BELL_PERIOD]=[sect].[PERIOD_BEGIN] OR [atp].[BELL_PERIOD]=[sect].[PERIOD_END])
    
    INNER HASH JOIN
    [rev].[EPC_STU] AS [stu]
    ON
    [ssy].[STUDENT_GU]=[stu].[STUDENT_GU]

WHERE
    [yr].[YEAR_GU]=(SELECT YEAR_GU FROM APS.YearDates WHERE '05/22/2015' BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
    AND [abr].[TYPE]='UNE'
    AND [sch].[SCHOOL_CODE] BETWEEN '400' AND '499'

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

    INNER HASH JOIN
    [rev].[EPC_SCH_YR_SECT] AS [Section]
    ON
    [Class].[SECTION_GU]=[Section].[SECTION_GU]
    AND [Section].[EXCLUDE_ATTENDANCE]='Y'

    	INNER HASH JOIN 
	rev.[EPC_SCH_YR_CRS] AS [SchoolYearCourse]
	ON [Section].[SCHOOL_YEAR_COURSE_GU] = [SchoolYearCourse].[SCHOOL_YEAR_COURSE_GU]

	INNER HASH JOIN
	rev.[REV_ORGANIZATION_YEAR] AS [OrgYear]
	ON [Section].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]

	INNER HASH JOIN
	[rev].[REV_YEAR] AS [Year]
	ON
	[OrgYear].[YEAR_GU]=[Year].[YEAR_GU]

	LEFT OUTER HASH JOIN
	rev.[EPC_STU_SCH_YR] AS [StudentSchoolYear] -- Contains Grade and Start Date 	
	ON
	[Class].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
	AND [StudentSchoolYear].[EXCLUDE_ADA_ADM] IS NULL

    INNER HASH JOIN
    [rev].[EPC_SCH_ATT_CAL] AS [cal]
    ON
    [OrgYear].[ORGANIZATION_YEAR_GU]=[cal].[SCHOOL_YEAR_GU] /*AND [atd].[ABS_DATE]=[cal].[CAL_DATE]*/
    AND
    [cal].[CAL_DATE]>=[StudentSchoolYear].[ENTER_DATE] AND ([cal].[CAL_DATE]<=[StudentSchoolYear].[LEAVE_DATE] OR [StudentSchoolYear].[LEAVE_DATE] IS NULL)
    AND
    [cal].[CAL_DATE]>=[Class].[ENTER_DATE] AND ([cal].[CAL_DATE]<=[Class].[LEAVE_DATE] OR [Class].[LEAVE_DATE] IS NULL)

    INNER HASH JOIN
    [rev].[EPC_STU] AS [stu]
    ON
    [StudentSchoolYear].[STUDENT_GU]=[stu].[STUDENT_GU]

    INNER HASH JOIN 
    rev.EPC_SCH_YR_SECT_MET_DY AS sysmd 
    ON 
    sysmd.SECTION_GU      = [Section].SECTION_GU
    
    INNER HASH JOIN 
    rev.EPC_SCH_YR_MET_DY AS symd  
    ON 
    symd.SCH_YR_MET_DY_GU = sysmd.SCH_YR_MET_DY_GU 
    AND 
    [cal].[ROTATION]=[symd].[MEET_DAY_CODE]

WHERE
    [Year].[YEAR_GU]=(SELECT YEAR_GU FROM APS.YearDates WHERE '05/22/2015' BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
    AND [Cal].[ROTATION] IS NOT NULL
    
GROUP BY
    [stu].[STUDENT_GU]
    ,[stu].[SIS_NUMBER]
    ,[Section].[TERM_CODE]
    ,[cal].[CAL_DATE]
    ,[cal].[ROTATION]
)



SELECT --DISTINCT
	'2014-2015' AS [SCHOOL_YEAR]
	,[STUDENT].[SIS_NUMBER]
	,[STUDENT].[STATE_STUDENT_NUMBER]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[STUDENT].[BIRTH_DATE]
	,[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[ENROLLMENTS].[GRADE]
	,[STUDENT].[LUNCH_STATUS]
	,[STUDENT].[ELL_STATUS]
	,[STUDENT].[SPED_STATUS]
	,[STUDENT].[RESOLVED_RACE]
	,[STUDENT].[GENDER]
	,[ENROLLMENTS].[LEAVE_DATE]
	,[ENROLLMENTS].[LEAVE_DESCRIPTION]
	
	,[ENROLLMENTS].[YEAR_END_STATUS]
	
	,[UNEXCUSED].[Total Unexcused]
	
	--,[CUM_GPA].[MS Cum Flat]
	
FROM
	(
	SELECT
		*
		,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU, SCHOOL_YEAR ORDER BY ENTER_DATE DESC) AS RN
	FROM
		APS.StudentEnrollmentDetails
	WHERE
		SCHOOL_YEAR = '2014'
		AND EXTENSION = 'R'
		AND EXCLUDE_ADA_ADM IS NULL
		AND ENTER_DATE IS NOT NULL
		--AND LEAVE_DATE IS NULL
		--AND ([GRADE] BETWEEN '01' AND '08' OR [GRADE] IN ('PK','K'))
	
	)  AS [ENROLLMENTS]
	
	INNER JOIN
	APS.BasicStudentWithMoreInfo  AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	--LEFT OUTER JOIN
	--	(
	--	SELECT DISTINCT
	--		[GPA].[STUDENT_SCHOOL_YEAR_GU]
			
	--		,SUM(CASE WHEN [GPA_DEF].[GPA_CODE] = 'HSCF' THEN [GPA].[GPA] ELSE 0 END) AS [HS Cum Flat]
	--		,SUM(CASE WHEN [GPA_DEF].[GPA_CODE] = 'HSCW' THEN [GPA].[GPA] ELSE 0 END) AS [HS Cum Weighted]
	--		,SUM(CASE WHEN [GPA_DEF].[GPA_CODE] = 'MSCF' THEN [GPA].[GPA] ELSE 0 END) AS [MS Cum Flat]
			
	--	FROM	
	--		rev.[EPC_STU_GPA] AS [GPA]  
				
	--		INNER JOIN
	--		rev.[EPC_SCH_YR_GPA_TYPE_RUN] [GPA_RUN]
	--		ON
	--		[GPA].[SCHOOL_YEAR_GPA_TYPE_RUN_GU] = [GPA_RUN].[SCHOOL_YEAR_GPA_TYPE_RUN_GU]
	--		AND [GPA_RUN].[SCHOOL_YEAR_GRD_PRD_GU] IS NULL
			
	--		INNER JOIN
	--		rev.[EPC_GPA_DEF_TYPE] [GPA_TYPE] 
	--		ON 
	--		[GPA_RUN].[GPA_DEF_TYPE_GU] = [GPA_TYPE].[GPA_DEF_TYPE_GU]
	--		AND (
	--			[GPA_TYPE].[GPA_TYPE_NAME] = 'HS Cum Flat' 
	--			OR
	--			[GPA_TYPE].[GPA_TYPE_NAME] = 'HS Cum Weighted' 
	--			OR
	--			[GPA_TYPE].[GPA_TYPE_NAME] = 'MS Cum Flat'
	--			)
					
	--		INNER JOIN 
	--		rev.[EPC_GPA_DEF] [GPA_DEF]  
	--		ON 
	--		[GPA_TYPE].[GPA_DEF_GU] = [GPA_DEF].[GPA_DEF_GU]
			
	--	GROUP BY
	--		[GPA].[STUDENT_SCHOOL_YEAR_GU]
	--	) AS [CUM_GPA]
	--	ON
	--	[ENROLLMENTS].[STUDENT_SCHOOL_YEAR_GU] = [CUM_GPA].[STUDENT_SCHOOL_YEAR_GU]
	
	LEFT OUTER JOIN
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

LEFT HASH JOIN
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
AND [Truant1].[Unexcused Count For Day]>=2
) AS [Truant]

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

LEFT HASH JOIN
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
) AS [Truant]

WHERE
    [Truant].[ABS_DATE]<='05/22/2015'
GROUP BY
    [Truant].[SIS_NUMBER]
    ,[Truant].[SCHOOL_CODE]
	) AS [UNEXCUSED]
	ON
	[STUDENT].[SIS_NUMBER] = [UNEXCUSED].[SIS_NUMBER]
		
WHERE
	[ENROLLMENTS].[RN] = 1
	AND [ENROLLMENTS].[SCHOOL_CODE] BETWEEN '400' AND '499'
	--AND ([ENROLLMENTS].[GRADE] BETWEEN '01' AND '08' OR [ENROLLMENTS].[GRADE] IN ('PK','K'))
	