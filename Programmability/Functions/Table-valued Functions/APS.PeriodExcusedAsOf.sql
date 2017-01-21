
/*********************************************************************
Last Changed by Debbie Ann Chavez
Modified on 1/20/2017

Main Function that pulls Period Attendance

**********************************************************************/



--DECLARE @AsOfDate DATE = GETDATE()


ALTER FUNCTION [APS].[PeriodExcusedAsOf](@AsOfDate DATE)
RETURNS TABLE
AS
RETURN


/*-------------------PART 1 - COUNT THE NUMBER OF ABSENCES ON EACH DAY -----------------------------

----------------------------------------------------------------------------------------------------*/
--;
WITH [HighSchoolTruant] AS 
(
SELECT
    [stu].[STUDENT_GU]
    ,[stu].[SIS_NUMBER]
    ,[sch].[SCHOOL_CODE]
	,[ssy].EXCLUDE_ADA_ADM
    ,[atd].[ABS_DATE]
    ,[cal].[ROTATION]
    ,CAST(COUNT(*) AS DECIMAL(5,2)) AS [Excused Count For Day]
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
	AND (@asOfDate BETWEEN [yr].[START_DATE] AND [yr].[END_DATE])
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
    [abr].[TYPE]= 'EXC'
  	AND SETUP.SCHOOL_ATT_TYPE IN ('P', 'B')

GROUP BY
    [stu].[STUDENT_GU]
    ,[stu].[SIS_NUMBER]
    ,[sch].[SCHOOL_CODE]
	,[ssy].EXCLUDE_ADA_ADM
    ,[atd].[ABS_DATE]
    ,[cal].[ROTATION]

/*-------------------PART 2 - COUNT THE NUMBER OF CLASSES ON EACH DAY -----------------------------

----------------------------------------------------------------------------------------------------*/
), [HSSchedCount] AS 
(
SELECT 

    [stu].[STUDENT_GU]
    ,[stu].[SIS_NUMBER]
    ,class.SCHOOL_CODE
    ,[cal].[CAL_DATE]
    ,[cal].[ROTATION]
    ,COUNT (*) AS [Total Classes]

FROM 
       (
		SELECT 
				BS.COURSE_ENTER_DATE,BS.COURSE_LEAVE_DATE ,BS.TERM_CODE ,BS.SECTION_GU,BS.SECTION_ID
			   ,BS.STUDENT_SCHOOL_YEAR_GU ,BS.COURSE_GU ,BS.SCHOOL_YEAR_COURSE_GU  ,BS.ORGANIZATION_GU
			   ,BS.ORGANIZATION_YEAR_GU,BS.STUDENT_GU,SYMD.MEET_DAY_CODE,SCHOOL_CODE
			   FROM 
				APS.BASICSCHEDULE AS BS
				INNER JOIN
			   [APS].[YearDates] AS [yr] WITH (NOLOCK)  ON   BS.[YEAR_GU]=[yr].[YEAR_GU] 
			   AND (@AsOfDate BETWEEN [yr].[START_DATE] AND [yr].[END_DATE])
			   AND [yr].EXTENSION = 'R'
			   INNER JOIN rev.EPC_SCH_YR_SECT_MET_DY   sysmd ON sysmd.SECTION_GU      = BS.SECTION_GU
			   INNER JOIN rev.EPC_SCH_YR_MET_DY        symd  ON symd.SCH_YR_MET_DY_GU = sysmd.SCH_YR_MET_DY_GU
			   INNER JOIN  rev.EPC_SCH AS SCH    ON    BS.ORGANIZATION_GU = SCH.ORGANIZATION_GU
			   INNER JOIN  REV.EPC_SCH_YR_OPT AS SETUP	ON	SETUP.ORGANIZATION_YEAR_GU = BS.ORGANIZATION_YEAR_GU

			   WHERE SETUP.SCHOOL_ATT_TYPE IN ('P', 'B')

		)AS Class    
        
    INNER JOIN
    [rev].[EPC_SCH_YR_SECT] AS [Section] WITH (NOLOCK)
    ON
    [Class].[SECTION_GU]=[Section].[SECTION_GU]
    AND CLASS.SCHOOL_YEAR_COURSE_GU = SECTION.SCHOOL_YEAR_COURSE_GU
    AND [Section].[EXCLUDE_ATTENDANCE]='Y'
       

    INNER JOIN
    [rev].[EPC_STU] AS [stu] WITH (NOLOCK)
    ON
    Class.[STUDENT_GU]=[stu].[STUDENT_GU]

    INNER JOIN
    [rev].[EPC_SCH_ATT_CAL] AS [cal] WITH (NOLOCK)
    ON
    Class.[ORGANIZATION_YEAR_GU]=[cal].[SCHOOL_YEAR_GU]
    AND CAL.ROTATION = CLASS.MEET_DAY_CODE
    AND  [cal].[CAL_DATE]>=[Class].[COURSE_ENTER_DATE] 
    AND 
    ([cal].[CAL_DATE]<=[Class].[COURSE_LEAVE_DATE] 
    OR [Class].[COURSE_LEAVE_DATE] IS NULL)


WHERE 
       CAL.CAL_DATE <= @AsOfDate
       
       GROUP BY 
            [stu].[STUDENT_GU]
			,[stu].[SIS_NUMBER]
			,class.SCHOOL_CODE
			,[cal].[CAL_DATE]
			,[cal].[ROTATION]
)

/*-------------------PART 3 - CALCULATE FULL AND HALF DAYS ----------------------------------------

----------------------------------------------------------------------------------------------------*/

SELECT
	[Truants].[SIS_NUMBER]
	,[Truants].[SCHOOL_CODE]
	,[Truants].EXCLUDE_ADA_ADM
	,SUM([Truants].[Half Days Excused]) AS [Half Days Excused]
	,SUM([Truants].[Full Days Excused]) AS [Full Days Excused]
	,SUM([Truants].[Total Excused]) AS [Total Excused]
FROM
(
SELECT 
    [Truant].[SIS_NUMBER]
    ,[Truant].[SCHOOL_CODE]
	,Truant.EXCLUDE_ADA_ADM
    ,ISNULL(SUM(CASE
	   WHEN [Truant].[Excused Count For Day] >= 2 THEN
		  CASE WHEN [Truant].[Truant Percentage]<=50.00 THEN 1.00
		       ELSE 0
		  END
	   ELSE
		  0
     END),0.00) AS [Half Days Excused]
    ,ISNULL(SUM(CASE
	   WHEN [Truant].[Excused Count For Day] >= 2 THEN
		       CASE WHEN ([Truant].[Truant Percentage]>50.00 AND [Truant].[Truant Percentage]>0) THEN 1.00
		       ELSE 0.00
		  END
	   ELSE
		  0
     END),0.00) AS [Full Days Excused]
    ,ISNULL(SUM(CASE
	   WHEN [Truant].[Excused Count For Day] >= 2 THEN
			  CASE WHEN ([Truant].[Truant Percentage]<=50.00 AND [Truant].[Truant Percentage]>0) THEN 0.50
				  WHEN [Truant].[Truant Percentage]>50.00 THEN 1.00
		       ELSE 0
		  END
	   ELSE
		  0
     END),0.00) AS [Total Excused]
FROM
(
SELECT
    [Truant1].*
    ,[SchedCount].[Total Classes]
    ,([Truant1].[Excused Count For Day]/[SchedCount].[Total Classes])*100 AS [Truant Percentage]
FROM
[HighSchoolTruant] AS [Truant1]

LEFT JOIN
(
SELECT
    [STUDENT_GU]
    ,[SIS_NUMBER]
	,SCHOOL_CODE
    ,[CAL_DATE]
    ,[ROTATION]
    ,CAST(SUM([Total Classes]) AS DECIMAL(5,2)) AS [Total Classes]
FROM
	[HSSchedCount] AS [SchedCount]

GROUP BY
    [STUDENT_GU]
    ,[SIS_NUMBER]
	,SCHOOL_CODE
    ,[CAL_DATE]
    ,[ROTATION]
) AS [SchedCount]
ON
[Truant1].[STUDENT_GU]=[SchedCount].[STUDENT_GU]
AND [Truant1].SCHOOL_CODE = SchedCount.SCHOOL_CODE
AND [Truant1].[ABS_DATE]=[SchedCount].[CAL_DATE]
--AND [Truant1].[ROTATION]=[SchedCount].[ROTATION]
AND [Truant1].[Excused Count For Day]>=2
) AS [Truant]

WHERE
	[Truant].[ABS_DATE]<=@asOfDate
GROUP BY
    [Truant].[SIS_NUMBER]
    ,[Truant].[SCHOOL_CODE]
	,TRUANT.EXCLUDE_ADA_ADM
) AS [Truants]

GROUP BY
	[Truants].[SIS_NUMBER]
	,[Truants].[SCHOOL_CODE]
	,Truants.EXCLUDE_ADA_ADM

GO


