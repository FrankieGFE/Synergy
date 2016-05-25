

DECLARE @SchoolYear INTEGER = 2013
DECLARE @ASOFDATE DATETIME = '05/20/2013' 

SELECT
	[Enrollments].[SCH_YR]
	,[Enrollments].[ID_NBR]
	,[Student].[STATE_ID]
	,[Student].[LST_NME]
	,[Student].[FRST_NME]
	,[Student].[BRTH_DT]
	,[Student].[GENDER]
	,[Student].[FRPL]
	,[Student].[Race]
	,[SPED].[Primary Disability]	
	,CASE WHEN [ELLSTAT].[ID_NBR] IS NOT NULL THEN 'Y' ELSE 'N' END AS [ELL]
	,[Enrollments].[SCH_NBR] AS [LOCATION_CODE]
	,[School].[SCH_NME] AS [SCHOOL_NAME]
	,[Enrollments].[NONADA_SCH]
	,[Enrollments].[BEG_ENR_DT] AS [BEGIN_DATE]
	,[Enrollments].[END_ENR_DT] AS [END_DATE]
	,[Enrollments].[END_STAT] AS [END_STAT]
	,[Withdrawal].[STAT_DESCR]
	,[Enrollments].[GRDE] AS [GRADE]
	
	,[Sections].[TERM_CD]
	,[Schedules].[COURSE]
	,SUBSTRING([Schedules].[COURSE],4,1) AS [PROGRAM_CODE]
	,[Schedules].[XSECTION]
	,[CourseMaster].[CRS_DESCR]
	,[CourseMaster].[DEPARTMENT]
	
FROM
	-- Get Primary Enrollments
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
		END_STAT,
		NONADA_SCH
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
			NONADA_SCH,
			ROW_NUMBER() OVER (PARTITION BY ST010.DST_NBR, ST010.ID_NBR ORDER BY ST010.BEG_ENR_DT DESC) AS RN
		FROM
			DBTSIS.ST010 WITH(NOLOCK) 
		WHERE
			  SCH_YR = @SchoolYear
			  --AND NONADA_SCH != 'X'
			  --AND END_ENR_DT > BEG_ENR_DT
			  AND GRDE IN ('K','01','02','03','04','05','06','07','08')

		) AS ST010CURR
	--WHERE RN = 1
	) AS [Enrollments]
	
	---- Get Student Details
	INNER JOIN
	APS.BasicStudent AS [Student]	
	ON
	[Enrollments].[DST_NBR] = [Student].[DST_NBR]
	AND [Enrollments].[ID_NBR] = [Student].[ID_NBR]
	
	INNER JOIN
	APS.School AS [School]	
	ON
	[Enrollments].[SCH_NBR] = [School].[SCH_NBR]
	
	LEFT JOIN
	-- Get Current SPED status
	APS.SpedAsOf(@ASOFDATE) AS [SPED]	
	ON
	[Enrollments].[DST_NBR] = [SPED].[DST_NBR]
	AND [Enrollments].[ID_NBR] = [SPED].[ID_NBR]
	AND [Enrollments].[SCH_YR] = [SPED].[SCH_YR]
	
	-- Get ELL Stats
	LEFT JOIN
	APS.ELLStudentsAsOf(@ASOFDATE) AS [ELLSTAT]	
	ON
	[Enrollments].[DST_NBR] = [ELLSTAT].[DST_NBR]
	AND [Enrollments].[ID_NBR] = [ELLSTAT].[ID_NBR]
	
	LEFT OUTER JOIN
	[DBTSIS].[ST080_V] AS [Withdrawal]
	ON
	[Enrollments].[DST_NBR] = [Withdrawal].[DST_NBR]
	AND [Enrollments].[END_STAT] = [Withdrawal].[END_STAT]
	AND [Enrollments].[SCH_YR] = [Withdrawal].[SCH_YR]
	
	---- Get Student Schedules
	LEFT OUTER HASH JOIN
	[DBTSIS].[SC055_V] AS [Schedules]	
	ON
	[Enrollments].[DST_NBR] = [Schedules].[DST_NBR]
	AND [Enrollments].[ID_NBR] = [Schedules].[ID_NBR]
	AND [Enrollments].[SCH_YR] = [Schedules].[SCH_YR]
	AND [Enrollments].[SCH_NBR] = [Schedules].[SCH_NBR]
	AND (
		-- Get K3+ and Smartstart Course ID's with letters K or I from 2011 thru 2013
		([Enrollments].[SCH_YR] IN ('2011','2012','2013','2014') AND SUBSTRING([Schedules].[COURSE],4,1) IN ('K','I'))
		OR
		-- Get specific SmartStart course ID's in 2011
		([Enrollments].[SCH_YR] = '2011' AND [Schedules].[COURSE] IN ('339SS01', '339SS02', '339SS03', '339SS04', '339SS05', '219SS01', '219SS02', '219SS03', '219SS04', '219SS05', '291SS01', '291SS02', '291SS03', '291SS04', '291SS05', '275SS01', '275SS02', '275SS03', '275SS04', '275SS05',
								 '333SS01', '333SS02', '333SS03', '333SS04', '333SS05', '363SS01', '363SS02', '363SS03', '363SS04', '363SS05'))
		OR
		-- Get Section ID's 2000 thru 2999 and 5000 thru 5999 in 2014
		([Enrollments].[SCH_YR] = '2013' AND ([Schedules].[XSECTION] BETWEEN 2000 AND 2999 OR [Schedules].[XSECTION] BETWEEN 5000 AND 5999))
		)
	AND [Schedules].[COURSE] NOT LIKE 'ADVIS%'
	AND [Schedules].[COURSE] NOT LIKE 'ESLINT%'
		
	-- Get Course Details
	LEFT OUTER JOIN
	[DBTSIS].[SC031_V] AS [CourseMaster]
	ON
	[Schedules].[DST_NBR] = [CourseMaster].[DST_NBR]
	AND [Schedules].[SCH_YR] = [CourseMaster].[SCH_YR]
	AND [Schedules].[SCH_NBR] = [CourseMaster].[SCH_NBR]
	AND [Schedules].[COURSE] = [CourseMaster].[COURSE]
	AND [Schedules].[VERSION] = [CourseMaster].[VERSION]
	
	LEFT OUTER JOIN 
	[DBTSIS].[SC060_V] AS [Sections]
	ON
	[Schedules].[DST_NBR] = [Sections].[DST_NBR]
	AND [Schedules].[COURSE] = [Sections].[COURSE]
	AND [Schedules].[SCH_NBR] = [Sections].[SCH_NBR]
	AND [Schedules].[SCH_YR] = [Sections].[SCH_YR]
	AND [Schedules].[VERSION] = [Sections].[VERSION]
	AND [Schedules].[SECT_ASG] = [Sections].[XSECTION]
	
--WHERE
--	[Enrollments].[GRDE] IN ('K','01','02','03')
	--[Enrollments].[ID_NBR] = '970057790'

ORDER BY
	[Enrollments].[GRDE]
	,[Enrollments].[ID_NBR]