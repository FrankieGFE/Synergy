/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 11/25/2014
 *
 * Request By: Andy Gutierrez
 * InitialRequestDate: 10/20/2014
 *
 * Description: Collect student demographic details, home room teacher, SPED ELL and Economic Status, and Parent's Military and Federal Employement status
 * One Record Per Student Per Parent(lives with)
 */

--DECLARE @SchoolGu VARCHAR(MAX) = '%' -- '%7048BAD5-19EE-489A-A51E-05E4CE55DD7E%' --'%'
--DECLARE @YearGu uniqueidentifier = '26F066A3-ABFC-4EDB-B397-43412EDABC8B'
--DECLARE @AsOfDate DATETIME = GETDATE()
--DECLARE @Grade AS VARCHAR(2) = NULL

ALTER FUNCTION APS.ImpactAidReport(@SchoolGu VARCHAR(MAX), @YearGu VARCHAR(MAX), @AsOfDate DATETIME, @Grade AS VARCHAR(2) = NULL )
RETURNS TABLE
AS
RETURN

------------------------------------------------------------------------------
-- DEFINE MAIN SELECT


SELECT DISTINCT
	[SCHOOL].[SCHOOL_CODE]
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	,[OrgYear].[ORGANIZATION_GU]
	,[OrgYear].[YEAR_GU]
	,[STUDENT].[STUDENT_GU]
	,[TEACHER_PERSON].[LAST_NAME] + ', ' + [TEACHER_PERSON].[FIRST_NAME] AS [HOMEROOM_TEACHER]
	,[STUDENT].[SIS_NUMBER]
	,[STUDENT].[STATE_STUDENT_NUMBER]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[Grades].[VALUE_DESCRIPTION] AS [GRADE_LEVEL]
	,'(' + left([PERSON].[PRIMARY_PHONE],3) + ')' 
       + substring([PERSON].[PRIMARY_PHONE], 4,3)+ '-'
                   + RIGHT([PERSON].[PRIMARY_PHONE],4) AS [PRIMARY_PHONE]
    --,''
    ,[STUDENT].[HOME_ADDRESS]
    ,[STUDENT].[HOME_ADDRESS_2]
    ,[STUDENT].[HOME_CITY]
    ,[STUDENT].[HOME_STATE]
    ,[STUDENT].[HOME_ZIP]    
    
    ,[ETHNIC_CODES].[Race1]
    ,[ETHNIC_CODES].[Race2]
    ,[ETHNIC_CODES].[Race3]
    ,[ETHNIC_CODES].[Race4]
    ,[ETHNIC_CODES].[Race5]
    ,[STUDENT].[HISPANIC_INDICATOR]
    ,[STUDENT].[BIRTH_DATE]
    ,[STUDENT].[HOME_LANGUAGE]
    
    ,[FRMHistory].[FRM_CODE]
    ,CASE WHEN [ELL_PGM].[PROGRAM_CODE] = '1' AND [ELL_PGM].[EXIT_DATE] IS NULL THEN 'Y' ELSE 'N' END AS [ELL_STATUS]
    ,[CurrentSPED].[PRIMARY_DISABILITY_CODE]
    ,CASE WHEN [CurrentSPED].[PRIMARY_DISABILITY_CODE] != 'GI' AND [CurrentSPED].[PRIMARY_DISABILITY_CODE] IS NOT NULL THEN 'Y' ELSE 'N' END AS [SPED_STATUS]
    ,CASE WHEN [CurrentSPED].[PRIMARY_DISABILITY_CODE] = 'GI' OR [CurrentSPED].[SECONDARY_DISABILITY_CODE] = 'GI' THEN 'Y' ELSE 'N' END AS [GIFTED_STATUS]
    ,[EPC_STU].[GRID_CODE]
    
    ,[STUDENT].[MAIL_ADDRESS]
    ,[STUDENT].[MAIL_ADDRESS_2]
    ,[STUDENT].[MAIL_CITY]
    ,[STUDENT].[MAIL_STATE]
    ,[STUDENT].[MAIL_ZIP]
    
    ,[PARENT_NAMES].[Parents]
    ,[STUDENT_SCHOOL_YEAR].[ENTER_DATE]
    
    ,[PARENT_PERSON].[FIRST_NAME] + ' ' + [PARENT_PERSON].[LAST_NAME] AS [PARENT_NAME]
    ,[PARENT_EXTRA_DETAILS].[ACTIVE_MILITARY]
    ,[PARENT_EXTRA_DETAILS].[BRANCH_OF_SERVICE]
    ,[PARENT_EXTRA_DETAILS].[MILITARY_RANK]
    ,[PARENT_EXTRA_DETAILS].[FEDERAL_EMPLOYER]
    
    ,[PARENT].[EMPLOYER]
    
    ,[WORK_ADDRESS].[ADDRESS] AS [WORK_ADDRESS]
	,[WORK_ADDRESS].[ADDRESS2] AS [WORK_ADDRESS_2]
	,[WORK_ADDRESS].[CITY] AS [WORK_CITY]
	,[WORK_ADDRESS].[STATE] AS [WORK_STATE]
	,[WORK_ADDRESS].[ZIP_5] AS [WORK_ZIP]
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
	
	-- Translate grade codes into values
	INNER JOIN
	APS.LookupTable('K12','Grade') AS [Grades]
	ON
	[STUDENT_SCHOOL_YEAR].[GRADE] = [Grades].[VALUE_CODE]
	
	----------------------------------------------------
	-- HOME ROOM INFO
	LEFT OUTER HASH JOIN
	rev.[EPC_SCH_YR_SECT] AS [SECTION_SCHOOL_YEAR]
    ON
    [STUDENT_SCHOOL_YEAR].[HOMEROOM_SECTION_GU] = [SECTION_SCHOOL_YEAR].[SECTION_GU]
    
    -- Cross over between section and staff
    INNER JOIN
	rev.[EPC_STAFF_SCH_YR] AS [STAFF_SCHOOL_YEAR]
	ON
	[SECTION_SCHOOL_YEAR].[STAFF_SCHOOL_YEAR_GU] = [STAFF_SCHOOL_YEAR].[STAFF_SCHOOL_YEAR_GU]
    
    -- Get Staff list
    INNER JOIN
	rev.[EPC_STAFF] AS [STAFF]
	ON
	[STAFF_SCHOOL_YEAR].[STAFF_GU] = [STAFF].[STAFF_GU]
    
    -- Get staff's personal details
	INNER JOIN
	rev.[REV_PERSON] AS [TEACHER_PERSON]
	ON
	[STAFF].[STAFF_GU] = [TEACHER_PERSON].[PERSON_GU]
	
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
	
	-- Special ED Info
	LEFT HASH JOIN
    (
    SELECT
               *
    FROM
                REV.EP_STUDENT_SPECIAL_ED AS SPED
    WHERE
                NEXT_IEP_DATE IS NOT NULL
                AND (
                            EXIT_DATE IS NULL 
                            OR EXIT_DATE >= CONVERT(DATE,@AsOfDate)
                            )
    ) AS [CurrentSPED]
    ON
    [STUDENT].[STUDENT_GU] = [CurrentSPED].[STUDENT_GU]
    
    -- Calculated ELL
    LEFT JOIN
    APS.ELLAsOf (@AsOfDate) AS [ELL]
    ON
    [STUDENT].[STUDENT_GU] = [ELL].[STUDENT_GU]
    
    LEFT JOIN
    rev.EPC_STU_PGM_ELL AS [ELL_PGM]
    ON
    [STUDENT].[STUDENT_GU] = [ELL_PGM].[STUDENT_GU]    
    
    -- Get Contact Language
	LEFT JOIN
	APS.LookupTable ('K12', 'Language') AS [Contact_Language]	
	ON
	[ELL_PGM].[LANGUAGE_TO_HOME] = [Contact_Language].[VALUE_CODE]
	
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
	
	-- Get a list of ethnic codes pivoted into 5 columns
	LEFT HASH JOIN
	(
	select 
	  pvt.PERSON_GU
	, ROW_NUMBER() OVER(PARTITION by pvt.PERSON_GU order by pvt.person_gu) rno
	, (select e.ALT_CODE_3 from  rev.SIF_22_Common_GetLookupValues('Revelation', 'ETHNICITY') e where e.VALUE_CODE = pvt.[1]) as Race1
	, (select e.ALT_CODE_3 from  rev.SIF_22_Common_GetLookupValues('Revelation', 'ETHNICITY') e where e.VALUE_CODE = pvt.[2]) as Race2
	, (select e.ALT_CODE_3 from  rev.SIF_22_Common_GetLookupValues('Revelation', 'ETHNICITY') e where e.VALUE_CODE = pvt.[3]) as Race3
	, (select e.ALT_CODE_3 from  rev.SIF_22_Common_GetLookupValues('Revelation', 'ETHNICITY') e where e.VALUE_CODE = pvt.[4]) as Race4
	, (select e.ALT_CODE_3 from  rev.SIF_22_Common_GetLookupValues('Revelation', 'ETHNICITY') e where e.VALUE_CODE = pvt.[5]) as Race5
	from 
	  (select
		   ROW_NUMBER() OVER(PARTITION by seth.PERSON_GU order by seth.Ethnic_code) rn
		,  seth.PERSON_GU
		, seth.ETHNIC_CODE
	   from rev.REV_PERSON_SECONDRY_ETH_LST seth
	  ) pt
	   pivot (min(ETHNIC_CODE) FOR rn in ([1],[2],[3],[4],[5])) pvt
	) AS [ETHNIC_CODES]
	ON
	[STUDENT].[STUDENT_GU] = [ETHNIC_CODES].[PERSON_GU]
	AND [ETHNIC_CODES].[rno] = 1
	
	-- Get lunch status history
	LEFT HASH JOIN
	(
	SELECT
		  ROW_NUMBER() OVER (PARTITION BY stu.student_gu order by f.ENTER_DATE,stu.STUDENT_gu) rn
		, stu.STUDENT_GU
					, f.FRM_CODE
		FROM rev.EPC_STU stu
					LEFT JOIN rev.EPC_STU_PGM_FRM_HIS f on f.STUDENT_GU = stu.STUDENT_GU
					AND f.ENTER_DATE is not null and (f.EXIT_DATE is null or f.EXIT_DATE > @AsOfDate)
	) AS [FRMHistory]
	ON
	[STUDENT].[STUDENT_GU] = [FRMHistory].[STUDENT_GU]
	AND [FRMHistory].[rn] = 1
	
	-- Get student parents
	LEFT JOIN
	rev.[EPC_STU_PARENT] AS [STUDENT_PARENT]
	ON
	[STUDENT].[STUDENT_GU] = [STUDENT_PARENT].[STUDENT_GU]
	--AND [STUDENT_PARENT].[LIVES_WITH] = 'Y'
	
	-- Get parent info
	LEFT JOIN
	rev.EPC_PARENT AS [PARENT]
	ON
	[STUDENT_PARENT].[PARENT_GU] = [PARENT].[PARENT_GU]
	
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
	
	-- Get Work Address
	LEFT OUTER JOIN
	rev.REV_ADDRESS AS [WORK_ADDRESS]
	ON
	[PARENT_PERSON].[WORK_ADDRESS_GU] = [WORK_ADDRESS].[ADDRESS_GU]
	
WHERE
	[STUDENT_SCHOOL_YEAR].[ENTER_DATE] <= @AsOfDate
	AND [Grades].[VALUE_DESCRIPTION] NOT IN ('P1','P2','PK')
	AND [Grades].[VALUE_DESCRIPTION] LIKE @Grade