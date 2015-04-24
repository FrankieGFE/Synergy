



;WITH
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
	,[RevYear].[SCHOOL_YEAR]
	,[RevYear].[EXTENSION]
FROM
	APS.PrimaryEnrollmentsAsOf(GETDATE()) AS [Enrollments]
	
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
		,[COURSE].[DUAL_CREDIT]
		,[COURSE].[OTHER_PROVIDER_NAME]
		--,[COURSE].[CREDIT]
		--,[COURSE].[DEPARTMENT]
		--,[COURSE].[SUBJECT_AREA_1]
		--,[COURSE].[SUBJECT_AREA_2]
		--,[COURSE].[SUBJECT_AREA_3]
		--,[COURSE].[SUBJECT_AREA_4]
		--,[COURSE].[SUBJECT_AREA_5]
		
		--[ALL_STAFF_SCH_YR].*
		,[STAFF_PERSON].[FIRST_NAME] +' '+ [STAFF_PERSON].[LAST_NAME] AS [TEACHER NAME]	
		,[ALL_STAFF_SCH_YR].[PRIMARY_STAFF]
		,SUBSTRING([STAFF].[BADGE_NUM],2,99) AS [BADGE_NUM]
		
	FROM
		--APS.BasicSchedule AS [SCHEDULE]
		APS.ScheduleAsOf(GETDATE()) AS [SCHEDULE]
		
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

-----------------------------------------------------------

SELECT
	[SCHOOL_CODE]
	,[SCHOOL_NAME]
	,[GRADE]
	,COUNT([SECTION_ID]) AS [SECTIONS]
	--,COUNT([BADGE_NUM]) AS [TEACHERS]
FROM
	(
	SELECT DISTINCT
		[ENROLLMENTS].[SCHOOL_CODE]
		,[ENROLLMENTS].[SCHOOL_NAME]
		,[ENROLLMENTS].[GRADE]
		,[SCHEDULE].[COURSE_ID]
		,[SCHEDULE].[SECTION_ID]
		--,COUNT(DISTINCT [SCHEDULE].[SECTION_ID]) AS [SECTIONS]
		,[SCHEDULE].[COURSE_TITLE]	
		--,[SCHEDULE].[GRADE_RANGE_LOW]
		--,[SCHEDULE].[GRADE_RANGE_HIGH]
		,[SCHEDULE].[BADGE_NUM]
		
		--,COUNT(DISTINCT [SCHEDULE].[BADGE_NUM]) AS [TEACHERS]
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
		
	WHERE
		[ENROLLMENTS].[SCHOOL_CODE] IN 	
	/*		
			('321'	-- TITLE 1 SCHOOLS
			,'204'
			,'206'
			,'207'
			,'210'
			,'213'
			,'214'
			,'215'
			,'329'
			,'216'
			,'225'
			,'228'
			,'229'
			,'339'
			,'234'
			,'236'
			,'237'
			,'240'
			,'241'
			,'243'
			,'244'
			,'249'
			,'252'
			,'219'
			,'262'
			,'255'
			,'258'
			,'261'
			,'230'
			,'267'
			,'270'
			,'395'
			,'273'
			,'276'
			,'279'
			,'231'
			,'282'
			,'285'
			,'288'
			,'373'
			,'291'
			,'297'
			,'336'
			,'300'
			,'303'
			,'260'
			,'365'
			,'364'
			,'250'
			,'305'
			,'307'
			,'309'
			,'310'
			,'315'
			,'324'
			,'327'
			,'227'
			,'275'
			,'333'
			,'330'
			,'392'
			,'356'
			,'357'
			,'280'
			,'363'
			,'370'
			,'376'
			,'379'
			,'385'
			,'388'
			,'590'
			,'576'
			,'847'
			,'514'
			,'520'
			,'530'
			,'549'
			,'540'
			,'597'
			,'560'
			,'570'
			,'407'
			,'450'
			,'410'
			,'413'
			,'415'
			,'416'
			,'420'
			,'425'
			,'445'
			,'405'
			,'427'
			,'440'
			,'448'
			,'455'
			,'457'
			,'475'
			,'460'
			,'840'
			,'465'
			,'470')
		--*/
		--/*		
		('225'		-- NON-TITLE 1 SCHOOLS
		,'351'
		,'203'
		,'350'
		,'328'
		,'221'
		,'217'
		,'312'
		,'268'
		,'332'
		,'317'
		,'345'
		,'348'
		,'265'
		,'393'
		,'360'
		,'389'
		,'264'
		,'580'
		,'591'
		,'517'
		,'593'
		,'515'
		,'900'
		,'596'
		,'525'
		,'516'
		,'550'
		,'575'
		,'430'
		,'480'
		,'418'
		,'490'
		,'485'
		,'435'
		,'452'
		,'457'
		,'492')
		--*/
	) AS [DETAILS]
	
GROUP BY
	[SCHOOL_CODE]
	,[SCHOOL_NAME]
	,[GRADE]
	
ORDER BY
	[SCHOOL_CODE]
	,[GRADE]
