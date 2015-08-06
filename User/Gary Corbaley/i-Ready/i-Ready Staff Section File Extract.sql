



USE ST_Production
GO


-- Remove Procedure if it exists
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[iReadyStaffSection]') AND type in (N'P', N'PC'))
	EXEC ('CREATE PROCEDURE [APS].iReadyStaffSection AS SELECT 0')
GO

ALTER PROC [APS].[iReadyStaffSection]

AS
BEGIN

; WITH

-- From School of Record [EPC_STU_YR]
ASOF_ENROLLMENTS AS
(
SELECT
	[StudentSchoolYear].[STUDENT_GU]
	,[StudentSchoolYear].[ORGANIZATION_YEAR_GU]
	,[Organization].[ORGANIZATION_GU]
	,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
	,[Grades].[LIST_ORDER]
	,[School].[SCHOOL_CODE]
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	,[StudentSchoolYear].[ENTER_DATE]
	,[StudentSchoolYear].[LEAVE_DATE]
	,[StudentSchoolYear].[EXCLUDE_ADA_ADM]
	,[StudentSchoolYear].[ACCESS_504]
	,CASE WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 2 THEN 'CONCURRENT'
		WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 1 THEN 'NO ADA/ADM'
		ELSE '' END AS [CONCURRENT]
	,[OrgYear].[YEAR_GU]
	,[RevYear].[SCHOOL_YEAR]
	,[RevYear].[EXTENSION]
FROM
	APS.PrimaryEnrollmentsAsOf(CASE WHEN MONTH(GETDATE()) = 8 THEN '10/1/' + CONVERT(VARCHAR(4),YEAR(GETDATE())) ELSE GETDATE() END) AS [Enrollments]
	
	INNER JOIN
	rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
	ON
	[Enrollments].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
	ON 
	[StudentSchoolYear].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	INNER JOIN 
	rev.REV_YEAR AS [RevYear] -- Contains the School Year
	ON 
	[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
	
	LEFT OUTER JOIN
	APS.LookupTable('K12','Grade') AS [Grades]
	ON
	[StudentSchoolYear].[GRADE] = [Grades].[VALUE_CODE]
	
	INNER JOIN 
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
)

-- From APS.BasicStudent
, STUDENT_DETAILS AS
(
SELECT
	-- Basic Student Demographics
	[STUDENT].[STUDENT_GU]
	,[STUDENT].[SIS_NUMBER]
	,[STUDENT].[STATE_STUDENT_NUMBER]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[STUDENT].[BIRTH_DATE]
	,[STUDENT].[GENDER]
	,[STUDENT].[CLASS_OF]	
	,[STUDENT].[HOME_ADDRESS] AS [HOME_ADDRESS]
	,[STUDENT].[HOME_ADDRESS_2] AS [HOME_ADDRESS_2]
	,[STUDENT].[HOME_CITY] AS [HOME_CITY]
	,[STUDENT].[HOME_STATE] AS [HOME_STATE]
	,[STUDENT].[HOME_ZIP] AS [HOME_ZIP]
	,[STUDENT].[MAIL_ADDRESS] AS [MAIL_ADDRESS]
	,[STUDENT].[MAIL_ADDRESS_2] AS [MAIL_ADDRESS_2]
	,[STUDENT].[MAIL_CITY] AS [MAIL_CITY]
	,[STUDENT].[MAIL_STATE] AS [MAIL_STATE]
	,[STUDENT].[MAIL_ZIP] AS [MAIL_ZIP]
	
	-- Format Primary Phone
	,'(' + left([PERSON].[PRIMARY_PHONE],3) + ')' 
       + substring([PERSON].[PRIMARY_PHONE], 4,3)+ '-'
                   + RIGHT([PERSON].[PRIMARY_PHONE],4) AS [PRIMARY_PHONE]
    
    -- Most Recent Lunch Status
    ,[FRMHistory].[FRM_CODE]
    
    -- Most Recent ELL Status
    ,CASE WHEN [ELL_PGM].[PROGRAM_CODE] = '1' AND [ELL_PGM].[EXIT_DATE] IS NULL THEN 'Y' ELSE 'N' END AS [ELL_STATUS]
    
    -- Current SPED or Gifted Status
    ,[CurrentSPED].[PRIMARY_DISABILITY_CODE]
    -- SPED Not Gifted
    ,CASE WHEN [CurrentSPED].[PRIMARY_DISABILITY_CODE] != 'GI' AND [CurrentSPED].[PRIMARY_DISABILITY_CODE] IS NOT NULL THEN 'Y' ELSE 'N' END AS [SPED_STATUS]
    ,CASE WHEN [CurrentSPED].[PRIMARY_DISABILITY_CODE] = 'GI' OR [CurrentSPED].[SECONDARY_DISABILITY_CODE] = 'GI' THEN 'Y' ELSE 'N' END AS [GIFTED_STATUS]
    
    -- Prefered Home Contact Language
    ,CASE WHEN [Contact_Language].[VALUE_DESCRIPTION] IS NULL THEN [STUDENT].[HOME_LANGUAGE] ELSE [Contact_Language].[VALUE_DESCRIPTION] END AS [HOME_LANGUAGE2]
    
    ,[STUDENT].[HISPANIC_INDICATOR]
    ,[ETHNIC_CODES].[RACE_1]
    ,[ETHNIC_CODES].[RACE_2]
    ,[ETHNIC_CODES].[RACE_3]
    ,[ETHNIC_CODES].[RACE_4]
    ,[ETHNIC_CODES].[RACE_5]
    
    ,CASE 
		WHEN [STUDENT].[HISPANIC_INDICATOR] = 'Y' THEN 'Hispanic'
		WHEN [ETHNIC_CODES].[RACE_2] IS NOT NULL THEN 'Two or More'
		ELSE [ETHNIC_CODES].[RACE_1]
	END AS [RESOLVED_RACE]
    
    ,[PARENT_NAMES].[Parents]
    
FROM
	APS.BasicStudent AS [STUDENT]
	
	INNER JOIN
	rev.REV_PERSON AS [PERSON]
	ON
	[STUDENT].[STUDENT_GU] = [PERSON].[PERSON_GU]
	
	LEFT JOIN
    (
    SELECT
               *
    FROM
                REV.EP_STUDENT_SPECIAL_ED AS SPED
    WHERE
                NEXT_IEP_DATE IS NOT NULL
                AND (
                            EXIT_DATE IS NULL 
                            OR EXIT_DATE >= CONVERT(DATE, GETDATE())
                            )
    ) AS [CurrentSPED]
    ON
    [STUDENT].[STUDENT_GU] = [CurrentSPED].[STUDENT_GU]
    
    LEFT JOIN
    rev.EPC_STU_PGM_ELL AS [ELL_PGM]
    ON
    [STUDENT].[STUDENT_GU] = [ELL_PGM].[STUDENT_GU] 
    
    LEFT JOIN
    (
	SELECT
		  ROW_NUMBER() OVER (PARTITION BY [STU].[STUDENT_GU] order by [FRM].[ENTER_DATE],[STU].[STUDENT_GU]) [RN]
		, [STU].[STUDENT_GU]
		, [FRM].[FRM_CODE]
	FROM 
		rev.EPC_STU [STU]
		
		LEFT JOIN 
		rev.EPC_STU_PGM_FRM_HIS [FRM] 
		ON
		[FRM].[STUDENT_GU] = [STU].[STUDENT_GU]
		AND [FRM].[ENTER_DATE] IS NOT NULL 
		AND ([FRM].[EXIT_DATE] IS NOT NULL OR [FRM].[EXIT_DATE] > GETDATE())
	) AS [FRMHistory]
	ON
	[STUDENT].[STUDENT_GU] = [FRMHistory].[STUDENT_GU]
	AND [FRMHistory].[RN] = 1
	
	-- Get Home Contact Language
	LEFT JOIN
	APS.LookupTable ('K12', 'Language') AS [Contact_Language]	
	ON
	[ELL_PGM].[LANGUAGE_TO_HOME] = [Contact_Language].[VALUE_CODE]
	
	-- Get All Racial Codes
	LEFT JOIN
	(
	SELECT
		[ETHNIC_PIVOT].[PERSON_GU]
		,(SELECT [VALUE_DESCRIPTION] FROM APS.LookupTable ('Revelation', 'ETHNICITY') WHERE [VALUE_CODE] = [ETHNIC_PIVOT].[1]) AS [RACE_1]
		,(SELECT [VALUE_DESCRIPTION] FROM APS.LookupTable ('Revelation', 'ETHNICITY') WHERE [VALUE_CODE] = [ETHNIC_PIVOT].[2]) AS [RACE_2]
		,(SELECT [VALUE_DESCRIPTION] FROM APS.LookupTable ('Revelation', 'ETHNICITY') WHERE [VALUE_CODE] = [ETHNIC_PIVOT].[3]) AS [RACE_3]
		,(SELECT [VALUE_DESCRIPTION] FROM APS.LookupTable ('Revelation', 'ETHNICITY') WHERE [VALUE_CODE] = [ETHNIC_PIVOT].[4]) AS [RACE_4]
		,(SELECT [VALUE_DESCRIPTION] FROM APS.LookupTable ('Revelation', 'ETHNICITY') WHERE [VALUE_CODE] = [ETHNIC_PIVOT].[5]) AS [RACE_5]
	FROM
		(
		SELECT
			[SECONDARY_ETHNIC_CODES].[PERSON_GU]
			,[SECONDARY_ETHNIC_CODES].[ETHNIC_CODE]
			,ROW_NUMBER() OVER(PARTITION by [SECONDARY_ETHNIC_CODES].[PERSON_GU] order by [SECONDARY_ETHNIC_CODES].[ETHNIC_CODE]) [RN]
		FROM
			rev.REV_PERSON_SECONDRY_ETH_LST AS [SECONDARY_ETHNIC_CODES]
		) [PVT]
		PIVOT (MIN(ETHNIC_CODE) FOR [RN] IN ([1],[2],[3],[4],[5])) AS [ETHNIC_PIVOT]
	) AS [ETHNIC_CODES]
	ON
	[STUDENT].[STUDENT_GU] = [ETHNIC_CODES].[PERSON_GU]
	
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
	
)

, SCHEDULE AS
(
	SELECT
		--[COURSE].*
		[SCHEDULE].*
		--,[COURSE].[COURSE_ID]
		--,[COURSE].[COURSE_TITLE]
		--,[SCHEDULE].[COURSE_ENTER_DATE]
		--,[SCHEDULE].[COURSE_LEAVE_DATE]
		--,[SCHEDULE].[SECTION_ID]
		--,[SCHEDULE].[TERM_CODE]
		--,[COURSE].[DUAL_CREDIT]
		--,[COURSE].[OTHER_PROVIDER_NAME]
		--,[COURSE].[CREDIT]
		--,[COURSE].[DEPARTMENT]
		--,[COURSE].[SUBJECT_AREA_1]
		--,[COURSE].[SUBJECT_AREA_2]
		--,[COURSE].[SUBJECT_AREA_3]
		--,[COURSE].[SUBJECT_AREA_4]
		--,[COURSE].[SUBJECT_AREA_5]
		
		--[ALL_STAFF_SCH_YR].*
		,[STAFF_PERSON].[FIRST_NAME] +' '+ [STAFF_PERSON].[LAST_NAME] AS [TEACHER NAME]	
		,REPLACE([STAFF].[BADGE_NUM],'e','') AS [BADGE_NUM]
		,[ALL_STAFF_SCH_YR].[PRIMARY_STAFF]
		
	FROM
		--APS.BasicSchedule AS [SCHEDULE]
		APS.ScheduleAsOf(CASE WHEN MONTH(GETDATE()) = 8 THEN '10/1/' + CONVERT(VARCHAR(4),YEAR(GETDATE())) ELSE GETDATE() END) AS [SCHEDULE]
		
		INNER JOIN
		rev.EPC_CRS AS [COURSE]
		ON
		[SCHEDULE].[COURSE_GU] = [COURSE].[COURSE_GU]
		
		-- Get both primary and secodary staff
		INNER JOIN
		(
		SELECT
			[STAFF_SCHOOL_YEAR_GU]
			,[STAFF_GU]
			,[ORGANIZATION_YEAR_GU]
			,1 AS [PRIMARY_STAFF]
		FROM
			rev.[EPC_STAFF_SCH_YR] AS [STAFF_SCHOOL_YEAR]
			
		UNION ALL
			
		SELECT
			[STAFF_SCHOOL_YEAR].[STAFF_SCHOOL_YEAR_GU]
			,[STAFF_SCHOOL_YEAR].[STAFF_GU]
			,[STAFF_SCHOOL_YEAR].[ORGANIZATION_YEAR_GU]
			,0 AS [PRIMARY_STAFF]
		FROM
			rev.[EPC_SCH_YR_SECT_STF] AS [SECONDARY_STAFF]
			
			INNER JOIN
			rev.[EPC_STAFF_SCH_YR] AS [STAFF_SCHOOL_YEAR]
			ON
			[SECONDARY_STAFF].[STAFF_SCHOOL_YEAR_GU] = [STAFF_SCHOOL_YEAR].[STAFF_SCHOOL_YEAR_GU]
		) AS [ALL_STAFF_SCH_YR]
		ON
	   [SCHEDULE].[STAFF_SCHOOL_YEAR_GU] = [ALL_STAFF_SCH_YR].[STAFF_SCHOOL_YEAR_GU]
	   
		INNER JOIN
		rev.[EPC_STAFF] AS [STAFF]
		ON
		[ALL_STAFF_SCH_YR].[STAFF_GU] = [STAFF].[STAFF_GU]

		INNER JOIN
		rev.[REV_PERSON] AS [STAFF_PERSON]
		ON
		[STAFF].[STAFF_GU] = [STAFF_PERSON].[PERSON_GU]
)

--------------------------------------------------------------------------------------------------------------------

SELECT DISTINCT
	'nm-albuq87774' AS [Client ID]
	--,[STUDENT].[STATE_STUDENT_NUMBER] AS [Student SIS ID]
	,[SCHEDULE].[BADGE_NUM] AS [Staff Member SIS ID]
	--,[ENROLLMENTS].[SCHOOL_CODE] AS [School ID]
	
	,CONVERT(VARCHAR,[School].[SCHOOL_CODE]) + '-' + CONVERT(VARCHAR,[SCHEDULE].[SECTION_ID]) AS [Section ID]
	--,[SCHEDULE].[COURSE_TITLE] AS [Name]
	
	--,CASE WHEN [Course Grades].[VALUE_DESCRIPTION] = 'K' THEN '0' ELSE [Course Grades].[VALUE_DESCRIPTION] END AS [Grade Level]
	--,[Course Grades].[VALUE_DESCRIPTION] AS [Grade Level]
	
	--,[SCHEDULE].[TERM_CODE] AS [Term]
	--,'' AS [Code]
	--,[ENROLLMENTS].[SCHOOL_NAME] AS [Location]
	--,'' AS [Partner ID]
	,'' AS [Action]
	--,[SCHEDULE].[COURSE_TITLE] AS [Course Name]
	--,[SCHEDULE].[SUBJECT_AREA_1] AS [Subject]
	
	--,[STUDENT].[STATE_STUDENT_NUMBER] AS [Student SIS ID]
	--,[STUDENT].[SIS_NUMBER] AS [Student Number]
	--,[STUDENT].[FIRST_NAME] AS [First Name]
	--,[STUDENT].[LAST_NAME] as [Last Name]
	--,CASE WHEN [ENROLLMENTS].[GRADE] = 'K' THEN '0' ELSE [ENROLLMENTS].[GRADE] END AS [Grade Level]
	--,LEFT([STUDENT].[FIRST_NAME],1) + LEFT([STUDENT].[LAST_NAME],1) + RIGHT(CONVERT(VARCHAR,[STUDENT].[SIS_NUMBER]),5) AS [User Name]
	--,'student' AS [Password]
	--,CONVERT(VARCHAR(4),YEAR([STUDENT].[BIRTH_DATE])) + '-' + RIGHT('000'+CONVERT(VARCHAR(2),DATEPART(MM,[STUDENT].[BIRTH_DATE])),2) + '-' + RIGHT('000'+CONVERT(VARCHAR(2),DATEPART(DD,[STUDENT].[BIRTH_DATE])),2) AS [DOB]
	--,CASE 
	--	WHEN [STUDENT].[RACE_1] = 'Native American' THEN 1
	--	WHEN [STUDENT].[RACE_1] = 'Asian' THEN 2
	--	WHEN [STUDENT].[RACE_1] = 'African-American' THEN 3
	--	WHEN [STUDENT].[RACE_1] = 'Pacific Islander' THEN 4
	--	WHEN [STUDENT].[RACE_1] = 'White' THEN 5
	--	ELSE 6		
	--END AS [Ethnicity]
	--,CASE WHEN [STUDENT].[HISPANIC_INDICATOR] = 'Y' THEN 'true' ELSE 'false' END AS [Hispanic]
	--,CASE WHEN [STUDENT].[GENDER] = 'M' THEN 'Male' ELSE 'Female' END AS [Gender]
	--,CASE WHEN [STUDENT].[FRM_CODE] IS NOT NULL THEN 'true' ELSE 'false' END AS [Economically Disadvantaged]
	--,CASE WHEN [STUDENT].[ELL_STATUS] = 'Y' THEN 'true' ELSE 'false' END AS [English Learner]
	--,CASE WHEN [STUDENT].[SPED_STATUS] = 'Y' THEN 'true' ELSE 'false' END AS [Special Education]
	--,'' AS [Migrant]
	--,'' AS [Math Developmental Level]
	--,'' AS [English Developmental Level]
	--,'' AS [Partner ID]
	--,'' AS [Action]
	--,'' AS [RTI Level]
	--,[STUDENT].[GIFTED_STATUS] AS [Gifted / Talented]
	,'' AS [Reserved1]
	,'' AS [Reserved2]
	,'' AS [Reserved3]
	,'' AS [Reserved4]
	,'' AS [Reserved5]
	,'' AS [Reserved6]
	,'' AS [Reserved7]
	,'' AS [Reserved8]
	,'' AS [Reserved9]
	,'' AS [Reserved10]
	
	
	--,[SCHEDULE].[BADGE_NUM] AS [Staff Member SIS ID]
	--,[SCHEDULE].*
	
FROM
	ASOF_ENROLLMENTS AS [ENROLLMENTS]
	
	INNER JOIN
	STUDENT_DETAILS AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	INNER JOIN
	SCHEDULE AS [SCHEDULE]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [SCHEDULE].[STUDENT_GU]
	AND [ENROLLMENTS].[YEAR_GU] = [SCHEDULE].[YEAR_GU]
	
	LEFT OUTER JOIN
	APS.LookupTable('K12','Grade') AS [Course Grades]
	ON
	[SCHEDULE].[GRADE_RANGE_LOW] = [Course Grades].[VALUE_CODE]
	
	INNER JOIN 
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[SCHEDULE].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
	
WHERE
	[ENROLLMENTS].[GRADE] IN ('K','01','02','03','04','05','06','07','08')
	AND [SCHEDULE].[PRIMARY_STAFF] = 1
	
	AND ISNUMERIC([SCHEDULE].[BADGE_NUM]) = 1
	AND LEFT([SCHEDULE].[BADGE_NUM],1) != '9'
	AND [SCHEDULE].[BADGE_NUM] NOT IN ('222222222','666666666','777777777','888888888','999999999')

END
GO