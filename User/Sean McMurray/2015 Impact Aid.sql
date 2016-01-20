
DECLARE @SchoolGu VARCHAR(MAX) = '%' -- '%7048BAD5-19EE-489A-A51E-05E4CE55DD7E%' --'%'
DECLARE @YearGu uniqueidentifier = '26F066A3-ABFC-4EDB-B397-43412EDABC8B'
DECLARE @AsOfDate DATETIME = GETDATE()
DECLARE @Grade AS VARCHAR(2) = NULL



------------------------------------------------------------------------------
-- DEFINE MAIN SELECT


SELECT DISTINCT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[STUDENT].[BIRTH_DATE] AS [DOB]
	,[Grades].[VALUE_DESCRIPTION] AS [GRADE_LEVEL]
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	,[PARENT_NAMES].[Parents]
	,rev.UD_PARENT_LOG.DATE AS [Impact Date]
	,rev.UD_PARENT_LOG.DATE_RESENT_ERROR AS [Resent Error]
	,rev.UD_PARENT_LOG.DATE_RETURNED_ERROR AS [Returned Error]
	,rev.UD_PARENT_LOG.DATE_SURVEY_RETURNED AS [Survey Returned]
	,rev.UD_PARENT_LOG.HOW_FIRST_PARENT_QUALIFIED AS [First Qualified]
	,rev.UD_PARENT_LOG.HOW_SECOND_PARENT_QUALIFIED AS [Second Qualified]
	,rev.UD_PARENT_LOG.QUALIFIED AS [Qualified]
	,rev.UD_PARENT_LOG.REFUSED_TO_SIGN AS [Refused]
	,rev.UD_PARENT_LOG.SECOND_PARENT_QUALIFIED AS [Second Qualified]


FROM
	----------------------------------------------------------
	-- Enrollment Details
	rev.EPC_STU_YR AS [StudentYear] -- School of record
	
	INNER JOIN
	rev.EPC_STU_SCH_YR AS [STUDENT_SCHOOL_YEAR]
	ON
	[StudentYear].[STU_SCHOOL_YEAR_GU] = [STUDENT_SCHOOL_YEAR].[STUDENT_SCHOOL_YEAR_GU]
	
	-- Get a specific school or all of them in a given school year
	INNER HASH JOIN 
	(
	SELECT
		*
	FROM
		rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year		
	WHERE
		[OrgYear].[ORGANIZATION_GU] LIKE @SchoolGu
		AND [OrgYear].[YEAR_GU] = @YearGu
	) AS [OrgYear] -- Links between School and Year
	ON 
	[STUDENT_SCHOOL_YEAR].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
	
	-- Get school name
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	-- Get the school number
	INNER JOIN
	rev.[EPC_SCH] AS [SCHOOL]
	ON
	[OrgYear].[ORGANIZATION_GU] = [SCHOOL].[ORGANIZATION_GU]
	
	--------------------------------------------------------------------
	-- Student Details
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[StudentYear].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	-- Get student info
	INNER JOIN
	rev.EPC_STU AS [EPC_STU]
	ON
	[STUDENT].[STUDENT_GU] = [EPC_STU].[STUDENT_GU]
	
	-- Get student personal details
	INNER HASH JOIN
	rev.REV_PERSON AS [PERSON]
	ON
	[STUDENT].[STUDENT_GU] = [PERSON].[PERSON_GU]
	
	-- Get concatenated list of parent names
	LEFT HASH JOIN
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
		JOIN rev.EPC_STU_PARENT spar ON spar.STUDENT_GU = stu.STUDENT_GU AND spar.CONTACT_ALLOWED = 'Y'
		JOIN rev.REV_PERSON pper     ON pper.PERSON_GU  = spar.PARENT_GU
	  ) 
	  pn PIVOT (min(pname) for rn in ([1], [2], [3], [4])) PNm
	) AS [PARENT_NAMES]
	ON
	[STUDENT].[STUDENT_GU] = [PARENT_NAMES].[STUDENT_GU] 
	AND [PARENT_NAMES].[rno] = 1
	
	
	-- Get student parents
	LEFT JOIN
	rev.[EPC_STU_PARENT] AS [STUDENT_PARENT]
	ON
	[STUDENT].[STUDENT_GU] = [STUDENT_PARENT].[STUDENT_GU]
	AND [STUDENT_PARENT].[LIVES_WITH] = 'Y'
	
	-- Get parent info
	LEFT JOIN
	rev.EPC_PARENT AS [PARENT]
	ON
	[STUDENT_PARENT].[PARENT_GU] = [PARENT].[PARENT_GU]

	--Get Grade Level
	INNER JOIN
	APS.LookupTable('K12','Grade') AS [Grades]
	ON
	[STUDENT_SCHOOL_YEAR].[GRADE] = [Grades].[VALUE_CODE]
	
	-- Get parent personal details
	LEFT JOIN
	rev.REV_PERSON AS [PARENT_PERSON]
	ON
	[STUDENT_PARENT].[PARENT_GU] = [PARENT_PERSON].[PERSON_GU]
	
	-- Get parent extra details
	LEFT JOIN
	rev.[UD_PARENT] AS [PARENT_EXTRA_DETAILS]
	ON
	[STUDENT_PARENT].[PARENT_GU] = [PARENT_EXTRA_DETAILS].[PARENT_GU]

	--Get UD ParentGuardian Info
	LEFT JOIN
	rev.UD_PARENT_LOG ON [STUDENT_PARENT].PARENT_GU = rev.UD_PARENT_LOG.PARENT_GU
	
WHERE
rev.UD_PARENT_LOG.DATE IS NOT NULL