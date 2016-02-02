



SELECT
	*
FROM
	(
	SELECT
		[Teachers].[EMP_NBR]
		,[Teachers].[FRST_NME]
		,[Teachers].[LST_NME]
		
		,[Schedules].[SCH_NBR]
		,[CourseMaster].[CRS_DESCR]
		,[Schedules].[SCH_YR]
		
		,ROW_NUMBER() OVER (PARTITION BY [Teachers].[EMP_NBR] ORDER BY [Schedules].[SCH_YR] DESC) AS RN
		
	FROM
		[DBTSIS].[SC055_V] AS [Schedules]
		
		INNER JOIN
		[DBTSIS].[SC031_V] AS [CourseMaster]

		ON
		[Schedules].[DST_NBR] = [CourseMaster].[DST_NBR]
		AND [Schedules].[SCH_YR] = [CourseMaster].[SCH_YR]
		AND [Schedules].[SCH_NBR] = [CourseMaster].[SCH_NBR]
		AND [Schedules].[COURSE] = [CourseMaster].[COURSE]
		AND [Schedules].[VERSION] = [CourseMaster].[VERSION]
		
		INNER JOIN 
		[DBTSIS].[SC060_V] AS [Sections]

		ON
		[Schedules].[DST_NBR] = [Sections].[DST_NBR]
		AND [Schedules].[COURSE] = [Sections].[COURSE]
		AND [Schedules].[SCH_NBR] = [Sections].[SCH_NBR]
		AND [Schedules].[SCH_YR] = [Sections].[SCH_YR]
		AND [Schedules].[VERSION] = [Sections].[VERSION]
		AND [Schedules].[SECT_ASG] = [Sections].[XSECTION]
		
		-- Get Assigned Teachers
		INNER JOIN
		[DBTSIS].[SC070_V] AS [TeachersCourses]
		
		ON
		[Sections].[DST_NBR] = [TeachersCourses].[DST_NBR]
		AND [Sections].[SCH_YR] = [TeachersCourses].[SCH_YR]
		AND [Sections].[SCH_NBR] = [TeachersCourses].[SCH_NBR]
		AND [Sections].[COURSE] = [TeachersCourses].[COURSE]
		AND [Sections].[XSECTION] = [TeachersCourses].[XSECTION]
		AND [Sections].[VERSION] = [TeachersCourses].[VERSION]
		
		-- Get Teacher names
		INNER JOIN
		[DBTSIS].[SY030_V] AS [Teachers]
		
		ON
		[TeachersCourses].[DST_NBR] = [Teachers].[DST_NBR]
		AND [TeachersCourses].[EMP_NBR] = [Teachers].[EMP_NBR]
		
	WHERE
		[Schedules].[SCH_NBR] = '592'
	) AS [TEACHERS]
	
WHERE
	[TEACHERS].[RN] = 1