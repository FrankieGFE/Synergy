


DECLARE @asOfDate DATETIME = '05/22/2015'

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
	
	,[UNEXCUSED].*
	
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
		   AND [Year].[YEAR_GU]=(SELECT YEAR_GU FROM APS.YearDates WHERE @asOfDate BETWEEN YearDates.START_DATE AND YearDates.END_DATE)

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
		   AND [Year].[YEAR_GU]=(SELECT YEAR_GU FROM APS.YearDates WHERE @asOfDate BETWEEN YearDates.START_DATE AND YearDates.END_DATE)

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
	) AS [UNEXCUSED]
	ON
	[STUDENT].[SIS_NUMBER] = [UNEXCUSED].[SIS_NUMBER]
		
WHERE
	[ENROLLMENTS].[RN] = 1
	AND [ENROLLMENTS].[SCHOOL_CODE] BETWEEN '200' AND '399'
	--AND ([ENROLLMENTS].[GRADE] BETWEEN '01' AND '08' OR [ENROLLMENTS].[GRADE] IN ('PK','K'))
	