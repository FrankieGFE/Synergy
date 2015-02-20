


DECLARE @SchoolGu VARCHAR = '%'
DECLARE @AsOfDate DATETIME = '12/02/2014' --GETDATE()
DECLARE @Grade AS VARCHAR(2) = 'K'
DECLARE @Buisness AS VARCHAR(1) = 'Y'
DECLARE @University AS VARCHAR(1) = 'N'
DECLARE @Military AS VARCHAR(1) = 'N'


SELECT DISTINCT
	[Student].[FIRST_NAME]
	,[Student].[LAST_NAME]
	,[Student].[MIDDLE_NAME]
	,[Grades].[VALUE_DESCRIPTION] AS [GRADE_LEVEL]
	--,[ETHNIC_CODES].[RACE_1]
 --   ,[ETHNIC_CODES].[RACE_2]
 --   ,[ETHNIC_CODES].[RACE_3]
 --   ,[ETHNIC_CODES].[RACE_4]
 --   ,[ETHNIC_CODES].[RACE_5]
    ,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
    ,[School].[SCHOOL_CODE]
	,CASE WHEN [Student].[MAIL_ADDRESS] IS NULL THEN [Student].[HOME_ADDRESS] ELSE [Student].[MAIL_ADDRESS] END AS [ADDRESS]
    ,CASE WHEN [Student].[MAIL_ADDRESS] IS NULL THEN [Student].[HOME_ADDRESS_2] ELSE [Student].[MAIL_ADDRESS_2] END AS [ADDRESS_2]
    ,CASE WHEN [Student].[MAIL_CITY] IS NULL THEN [Student].[HOME_CITY] ELSE [Student].[MAIL_CITY] END AS [CITY]
    ,CASE WHEN [Student].[MAIL_STATE] IS NULL THEN [Student].[HOME_STATE] ELSE [Student].[MAIL_STATE] END AS [STATE]
    ,CASE WHEN [Student].[MAIL_ZIP] IS NULL THEN [Student].[HOME_ZIP] ELSE [Student].[MAIL_ZIP] END AS [ZIP]
	,[PARENT_NAMES].[Parents]
	
	--,[STUDENT_EXCEPTIONS].[EXCLUDE_BUSINESS]
	
FROM
	---------------------------------------------
	-- ENROLLMENT INFORMATION
	APS.PrimaryEnrollmentsAsOf(@AsOfDate) AS [Enrollments]	
	
	INNER JOIN 
	rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
	ON 
	[Enrollments].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	INNER JOIN
	rev.[EPC_SCH] AS [SCHOOL] -- Contains School Code
	ON
	[OrgYear].[ORGANIZATION_GU] = [SCHOOL].[ORGANIZATION_GU]
	
	LEFT OUTER JOIN
	APS.LookupTable('K12','Grade') AS [Grades]
	ON
	[Enrollments].[GRADE] = [Grades].[VALUE_CODE]
	
	--------------------------------------------------
	-- STUDENT DEMOGRAPHICS
	INNER JOIN
	APS.BasicStudent AS [Student] 
	ON
	[Enrollments].[STUDENT_GU] = [Student].[STUDENT_GU]
	
	-- Get All Racial Codes
	--LEFT JOIN
	--(
	--SELECT
	--	[ETHNIC_PIVOT].[PERSON_GU]
	--	,(SELECT [VALUE_DESCRIPTION] FROM APS.LookupTable ('Revelation', 'ETHNICITY') WHERE [VALUE_CODE] = [ETHNIC_PIVOT].[1]) AS [RACE_1]
	--	,(SELECT [VALUE_DESCRIPTION] FROM APS.LookupTable ('Revelation', 'ETHNICITY') WHERE [VALUE_CODE] = [ETHNIC_PIVOT].[2]) AS [RACE_2]
	--	,(SELECT [VALUE_DESCRIPTION] FROM APS.LookupTable ('Revelation', 'ETHNICITY') WHERE [VALUE_CODE] = [ETHNIC_PIVOT].[3]) AS [RACE_3]
	--	,(SELECT [VALUE_DESCRIPTION] FROM APS.LookupTable ('Revelation', 'ETHNICITY') WHERE [VALUE_CODE] = [ETHNIC_PIVOT].[4]) AS [RACE_4]
	--	,(SELECT [VALUE_DESCRIPTION] FROM APS.LookupTable ('Revelation', 'ETHNICITY') WHERE [VALUE_CODE] = [ETHNIC_PIVOT].[5]) AS [RACE_5]
	--FROM
	--	(
	--	SELECT
	--		[SECONDARY_ETHNIC_CODES].[PERSON_GU]
	--		,[SECONDARY_ETHNIC_CODES].[ETHNIC_CODE]
	--		,ROW_NUMBER() OVER(PARTITION by [SECONDARY_ETHNIC_CODES].[PERSON_GU] order by [SECONDARY_ETHNIC_CODES].[ETHNIC_CODE]) [RN]
	--	FROM
	--		rev.REV_PERSON_SECONDRY_ETH_LST AS [SECONDARY_ETHNIC_CODES]
	--	) [PVT]
	--	PIVOT (MIN(ETHNIC_CODE) FOR [RN] IN ([1],[2],[3],[4],[5])) AS [ETHNIC_PIVOT]
	--) AS [ETHNIC_CODES]
	--ON
	--[STUDENT].[STUDENT_GU] = [ETHNIC_CODES].[PERSON_GU]
	
	LEFT JOIN
	rev.[UD_STU] AS [STUDENT_EXCEPTIONS]
	ON
	[Student].[STUDENT_GU] = [STUDENT_EXCEPTIONS].[STUDENT_GU]
	
	LEFT JOIN
	rev.[EPC_STU_PARENT] AS [STUDENT_PARENT]
	ON
	[STUDENT].[STUDENT_GU] = [STUDENT_PARENT].[STUDENT_GU]
	AND [STUDENT_PARENT].[LIVES_WITH] = 'Y'
	
	-- Get concatenated list of parent names
	LEFT JOIN
	(
	SELECT
	   PNm.STUDENT_GU
	, ROW_NUMBER() OVER(PARTITION BY PNm.STUDENT_GU order by PNm.STUDENT_GU) rno
	, Parents = STUFF(  COALESCE(', ' + Pnm.[1], '')
					   + COALESCE(', ' + Pnm.[2], '') 
					   + COALESCE(', ' + Pnm.[3], '') 
					   + COALESCE(', ' + Pnm.[4], '') 
					   , 1, 1,'')
	FROM
	  (
		SELECT 
			stu.STUDENT_GU
		  , COALESCE(spar.ORDERBY, (ROW_NUMBER() OVER(PARTITION BY spar.STUDENT_GU order by spar.STUDENT_GU))) rn
		  , pper.FIRST_NAME + ' ' +  pper.LAST_NAME [pname]
		FROM rev.EPC_STU stu
		JOIN rev.EPC_STU_PARENT spar ON spar.STUDENT_GU = stu.STUDENT_GU AND spar.LIVES_WITH = 'Y'
		JOIN rev.REV_PERSON pper     ON pper.PERSON_GU  = spar.PARENT_GU
	  ) 
	  pn PIVOT (min(pname) for rn in ([1], [2], [3], [4])) PNm
	) AS [PARENT_NAMES]
	ON
	[STUDENT].[STUDENT_GU] = [PARENT_NAMES].[STUDENT_GU] 
	AND [PARENT_NAMES].[rno] = 1
	
WHERE
	[Organization].[ORGANIZATION_GU] LIKE @SchoolGu
	AND [Grades].[VALUE_DESCRIPTION] LIKE @Grade
	--AND [Grades].[VALUE_DESCRIPTION] IN ('09','10','11','12')
	AND [School].[SCHOOL_CODE] BETWEEN '200' AND '399'
	
--	--- EXCEPTIONS
	AND ([STUDENT_EXCEPTIONS].[EXCLUDE_BUSINESS] IS NULL OR [STUDENT_EXCEPTIONS].[EXCLUDE_BUSINESS] != @Buisness OR @Buisness = 'N')
	AND ([STUDENT_EXCEPTIONS].[EXCLUDE_UNIVERSITY] IS NULL OR [STUDENT_EXCEPTIONS].[EXCLUDE_UNIVERSITY] != @University OR @University = 'N')
	AND ([STUDENT_EXCEPTIONS].[EXCLUDE_MILITARY] IS NULL OR [STUDENT_EXCEPTIONS].[EXCLUDE_MILITARY] != @Military OR @Military = 'N')
	
	-- RACE NATIVE AMERICAN
	--AND ([ETHNIC_CODES].[RACE_1] = 'Native American' OR [ETHNIC_CODES].[RACE_2] = 'Native American' OR [ETHNIC_CODES].[RACE_3] = 'Native American' )
	
ORDER BY
	[Organization].[ORGANIZATION_NAME]
	,[Student].[LAST_NAME]