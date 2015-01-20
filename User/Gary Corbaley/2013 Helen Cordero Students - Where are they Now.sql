

SELECT
	'2013' [LAST YEAR]
	,[SMAX_ENROLLMENTS].*
	,'2014' AS [CURRENT YEAR]
	,[SYN_ENROLLMENTS].[SCHOOL_CODE] AS [CURRENT_SCHOOL_CODE]
	,[SYN_ENROLLMENTS].[SCHOOL_NAME] AS [CURRENT_SCHOOL_NAME]
	,[SYN_ENROLLMENTS].[GRADE] AS [CURRENT_GRADE]
FROM
	(
	SELECT
		[Enrollments].[ID_NBR]
		--,[Student].[STATE_ID]
		,[Student].[LST_NME]
		,[Student].[FRST_NME]
		,[Enrollments].[SCH_NBR]
		,[School].[SCH_NME]
		,[Enrollments].[GRDE]
		,[Enrollments].[BEG_ENR_DT]
		,[Enrollments].[END_ENR_DT]
		,[Enrollments].[END_STAT]
		,[Withdrawal].[STAT_DESCR]
		,[Transfers].[XCOMMENT]
		,[Transfers].[REASON]
		,[TransferReason].[STAT_DSC]
		,[Transfers].[TO_STATE]
		,[Transfers].[TO_CITY]
		,[Transfers].[TO_SCH_NME]
		,[Transfers].[TO_ST_SCH]
	FROM
		(
		SELECT DISTINCT
			_Id,
			DST_NBR,
			SCH_YR,
			SCH_NBR,
			GRDE,
			ID_NBR,
			BEG_ENR_DT,
			END_ENR_DT,
			END_STAT
		FROM 
			(
			SELECT
				ST010._Id,
				ST010.DST_NBR,
				ST010.SCH_NBR,
				ST010.GRDE,
				ST010.ID_NBR,
				ST010.SCH_YR,
				ST010.BEG_ENR_DT,
				ST010.END_ENR_DT,
				ST010.END_STAT,
				ROW_NUMBER() OVER (PARTITION BY ST010.DST_NBR, ST010.ID_NBR ORDER BY ST010.BEG_ENR_DT DESC) AS RN
			FROM
				DBTSIS.ST010 WITH(NOLOCK) 
			WHERE
				  SCH_YR = 2014
				  AND NONADA_SCH != 'X'
				  --AND BEG_ENR_DT = '20130813'
				  AND END_ENR_DT = '20140522'
				  --AND SCH_NBR = '395'

			) AS ST010CURR
		WHERE RN = 1
		) AS [Enrollments]
		
		INNER JOIN
		APS.BasicStudent AS [Student]
		ON
		[Enrollments].[DST_NBR] = [Student].[DST_NBR]
		AND [Enrollments].[ID_NBR] = [Student].[ID_NBR]
		
		INNER JOIN
		APS.School AS [School]	
		ON
		[Enrollments].[SCH_NBR] = [School].[SCH_NBR]

		LEFT OUTER JOIN
		[DBTSIS].[ST080_V] AS [Withdrawal]
		ON
		[Enrollments].[DST_NBR] = [Withdrawal].[DST_NBR]
		AND [Enrollments].[END_STAT] = [Withdrawal].[END_STAT]
		AND [Enrollments].[SCH_YR] = [Withdrawal].[SCH_YR]
		
		LEFT OUTER JOIN
		[DBTSIS].[ST016_V] AS [Transfers]
		ON
		[Enrollments].[DST_NBR] = [Transfers].[DST_NBR]
		AND [Enrollments].[ID_NBR] = [Transfers].[ID_NBR]
		AND [Enrollments].[SCH_YR] = [Transfers].[SCH_YR]
		AND [Enrollments].[SCH_NBR] = [Transfers].[SCH_NBR]
		
		-- Get transfer reason
		LEFT JOIN
		[DBTSIS].[ST081_V] AS [TransferReason]		
		ON
		[Transfers].[DST_NBR] = [TransferReason].[DST_NBR]
		AND [Transfers].[SCH_YR] = [TransferReason].[SCH_YR]
		AND [Transfers].[REASON] = [TransferReason].[END_STAT]
	
	) AS [SMAX_ENROLLMENTS]
	
	LEFT OUTER JOIN
	(	
	SELECT
		[School].[SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME]	AS [SCHOOL_NAME]
		,[BasicStudent].[SIS_NUMBER]
		,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
	FROM		
		OPENQUERY([SYNERGYDBDC.APS.EDU.ACTD],'SELECT * FROM  [ST_Production].APS.PrimaryEnrollmentsAsOf(GETDATE())') AS [PrimaryEnrollments]
		
		-- Get location year
		LEFT OUTER JOIN 
		[SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
		ON 
		[PrimaryEnrollments].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
		
		-- Get location details and name
		LEFT OUTER JOIN
		[SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
		ON 
		[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
		
		-- Get the location code
		LEFT OUTER JOIN
		[SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].rev.EPC_SCH AS [School] -- Contains the School Code / Number
		ON 
		[OrgYear].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
		
		INNER JOIN
		OPENQUERY([SYNERGYDBDC.APS.EDU.ACTD],'SELECT * FROM  [ST_Production].APS.BasicStudent') AS [BasicStudent]
		ON
		[PrimaryEnrollments].[STUDENT_GU] = [BasicStudent].[STUDENT_GU]
		
		LEFT OUTER JOIN
		OPENQUERY([SYNERGYDBDC.APS.EDU.ACTD],'SELECT * FROM  [ST_Production].APS.LookupTable(''K12'',''Grade'')') AS [Grades]
		ON
		[PrimaryEnrollments].[GRADE] = [Grades].[VALUE_CODE]
	) AS [SYN_ENROLLMENTS]
	ON
	[SMAX_ENROLLMENTS].[ID_NBR] = [SYN_ENROLLMENTS].[SIS_NUMBER]
	
--WHERE
--	[SYN_ENROLLMENTS].[SCHOOL_CODE] IS NULL