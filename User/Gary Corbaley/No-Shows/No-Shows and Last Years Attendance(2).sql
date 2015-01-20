

USE [PR]

--DECLARE @SYNERGYNOSHOWS TABLE
--	(
--		[SIS_NUMBER] INT
--	)

SELECT
	[SYNERGY_NO_SHOWS].[SYNERGY_SCHOOL_CODE]
	,[SYNERGY_NO_SHOWS].[SYNERGY_SCHOOL_NAME]
	,[SYNERGY_NO_SHOWS].[SYNERGY_GRADE_LEVEL]
	,[SYNERGY_NO_SHOWS].[SIS_NUMBER]
	,[PrimaryEnrollments].SCH_YR -1 AS [LAST_SCH_YEAR]
	,[PrimaryEnrollments].[SCH_NBR] AS [SMAX_SCH_NBR]
	,[School].SCH_NME AS [SMAX_SCH_NAME]
	,[Attendance].UX_FULL_DAY
	,[Attendance].UX_HALF_DAY
	,[Attendance].EX_FULL_DAY
	,[Attendance].EX_HALF_DAY
	,[Attendance].[TOTAL ABSENCES]
	,[DISIPLINE_ACTIONS].[TOTAL_EVENTS] AS [DISIPLINE]
	--,[GPA].[Cumulative Flat GPA]
FROM
	(
	SELECT
		[School].[SCHOOL_CODE] AS [SYNERGY_SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME] AS [SYNERGY_SCHOOL_NAME]
		,[Grades].[ALT_CODE_1] AS [SYNERGY_GRADE_LEVEL]
		,[Student].[SIS_NUMBER]
	FROM
		[SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
		
		INNER JOIN 
		[SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
		ON 
		[StudentSchoolYear].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
		
		INNER JOIN 
		[SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
		ON 
		[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
		
		INNER JOIN 
		[SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].rev.REV_YEAR AS [RevYear] -- Contains the School Year
		ON 
		[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
		
		INNER JOIN 
		[SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].rev.EPC_SCH AS [School] -- Contains the School Code / Number
		ON 
		[OrgYear].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
		
		LEFT OUTER JOIN
		(
		SELECT
			  [Val].[ALT_CODE_1]
			  ,[Val].[VALUE_CODE]
		FROM
			  [SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].[rev].[REV_BOD_LOOKUP_DEF] AS [Def]
			  INNER JOIN
			  [SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].[rev].[REV_BOD_LOOKUP_VALUES] AS [Val]
			  ON
			  [Def].[LOOKUP_DEF_GU]=[Val].[LOOKUP_DEF_GU]
			  AND [Def].[LOOKUP_NAMESPACE]='K12'
			  AND [Def].[LOOKUP_DEF_CODE]='Grade'
		) AS [Grades]
		ON
		[StudentSchoolYear].[GRADE] = [Grades].[VALUE_CODE]
		
		--LEFT OUTER JOIN
		--OPENQUERY([SYNERGYDBDC.APS.EDU.ACTD],'SELECT * FROM  [ST_Production].APS.PrimaryEnrollmentsAsOf(GETDATE())') AS [EnrollmentsAsOf]
		
		--ON
		----[StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU] = [EnrollmentsAsOf].[STUDENT_SCHOOL_YEAR_GU]
		----AND 
		--[StudentSchoolYear].[STUDENT_GU] = [EnrollmentsAsOf].[STUDENT_GU]
		
		INNER JOIN 
		[SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].rev.EPC_STU AS [Student] -- Contains Student ID State ID Language Code Cohort Year
		ON 
		[StudentSchoolYear].[STUDENT_GU] = [Student].[STUDENT_GU]
		
	WHERE
		NO_SHOW_STUDENT = 'Y'
		AND [Grades].[ALT_CODE_1] IN ('06','09')
		AND [RevYear].[SCHOOL_YEAR] = 2014
		AND [RevYear].[EXTENSION] = 'R'
		
		--AND [EnrollmentsAsOf].[STUDENT_GU] IS NULL
	) AS [SYNERGY_NO_SHOWS]
	
	LEFT OUTER JOIN
	APS.PrimaryEnrollmentsAsOf('05/22/2014') AS [PrimaryEnrollments]	
	ON
	[PrimaryEnrollments].[DST_NBR] = 1
	AND [SYNERGY_NO_SHOWS].[SIS_NUMBER] = [PrimaryEnrollments].[ID_NBR]
	
	LEFT OUTER JOIN
	APS.School AS [School]
	ON
	[PrimaryEnrollments].[SCH_NBR] = [School].[SCH_NBR]
	
	LEFT OUTER JOIN
	(
	SELECT
		IV3.DST_NBR
		--,IV3.MNT_DT
		,IV3.SCH_NBR
		,IV3.ID_NBR
		,IV3.SCH_YR
		
		--SUM The absence types into their respective columns. UX = Unexcused, EX = Excused. 
		,SUM(CASE WHEN (IV3.FIELDNUM=80) THEN 1.0 ELSE 0.0 END) AS UX_FULL_DAY
		,SUM(CASE WHEN (IV3.FIELDNUM=82) THEN 1.0 ELSE 0.0 END) AS UX_HALF_DAY
		,SUM(CASE WHEN (IV3.FIELDNUM=84) THEN 1.0 ELSE 0.0 END) AS EX_FULL_DAY
		,SUM(CASE WHEN (IV3.FIELDNUM=86) THEN 1.0 ELSE 0.0 END) AS EX_HALF_DAY
	
		,SUM(CASE WHEN (IV3.FIELDNUM=80) THEN 1.0 ELSE 0.0 END) 
		+SUM(CASE WHEN (IV3.FIELDNUM=82) THEN 1.0 ELSE 0.0 END)/2.0
		+SUM(CASE WHEN (IV3.FIELDNUM=84) THEN 1.0 ELSE 0.0 END) 
		+SUM(CASE WHEN (IV3.FIELDNUM=86) THEN 1.0 ELSE 0.0 END)/2.0 AS [TOTAL ABSENCES]
					
	FROM
		--Join IV table to CurrentPrimaryEnrollment 
		DBTSIS.IV030_V AS IV3

	WHERE
		IV3.DST_NBR = 1
		AND IV3.SCH_YR = 2014
		
	GROUP BY 
		IV3.DST_NBR
		,IV3.ID_NBR
		,IV3.SCH_NBR
		--,IV3.MNT_DT
		,IV3.SCH_YR
	) AS [Attendance]	
	ON
	[PrimaryEnrollments].[DST_NBR] = [Attendance].[DST_NBR]
	AND[PrimaryEnrollments].[ID_NBR] = [Attendance].[ID_NBR]
	AND [PrimaryEnrollments].[SCH_NBR] = [Attendance].SCH_NBR
	AND [PrimaryEnrollments].[SCH_YR] = [Attendance].[SCH_YR]
	
	LEFT OUTER JOIN
	(
	SELECT
		[DisiplineParticipants].[DST_NBR]
		,[DisiplineParticipants].[ID_NBR]
		,COUNT(*) AS [TOTAL_EVENTS]
	FROM
		[DBTSIS].[EV020_V] AS [DisiplineParticipants]
	WHERE
		[DisiplineParticipants].[DST_NBR] = 1
		AND [DisiplineParticipants].[SCH_YR] = 2014
	GROUP BY
		[DisiplineParticipants].[DST_NBR]
		,[DisiplineParticipants].[ID_NBR]
	) AS [DISIPLINE_ACTIONS]
	ON
	[PrimaryEnrollments].[DST_NBR] = [DISIPLINE_ACTIONS].[DST_NBR]
	AND[PrimaryEnrollments].[ID_NBR] = [DISIPLINE_ACTIONS].[ID_NBR]
	
	