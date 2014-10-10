

------------------------------------
-- DEFINE WITH CLAUSES COPIED FROM EDUPOINT SCRIPTS

; WITH ParentNames AS -- Get parent names -- code copied from Edupoint
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
)

--Ethnicity code -- copy from Edupoint
, EthCodes AS 
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
)

-- FRM History --- need to find out what this is
, FRMHistory AS
(
SELECT
      ROW_NUMBER() OVER (PARTITION BY stu.student_gu order by f.ENTER_DATE,stu.STUDENT_gu) rn
    , stu.STUDENT_GU
                , f.FRM_CODE
    FROM rev.EPC_STU stu
                LEFT JOIN rev.EPC_STU_PGM_FRM_HIS f on f.STUDENT_GU = stu.STUDENT_GU
                AND f.ENTER_DATE is not null and (f.EXIT_DATE is null or f.EXIT_DATE > getdate())
)

------------------------------------------------------------------------------
-- DEFINE MAIN SELECT


SELECT DISTINCT --TOP 1000
	[SCHOOL].[SCHOOL_CODE]
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
    --,[CurrentSPED].*
    ,[EPC_STU].[GRID_CODE]
    
    ,[STUDENT].[MAIL_ADDRESS]
    ,[STUDENT].[MAIL_ADDRESS_2]
    ,[STUDENT].[MAIL_CITY]
    ,[STUDENT].[MAIL_STATE]
    ,[STUDENT].[MAIL_ZIP]
    
    --,[PARENT_NAMES].[Parents]
    --,[PARENT_PERSON].[FIRST_NAME] + ' ' + [PARENT_PERSON].[LAST_NAME] AS [PARENT_NAME]
    ,[PARENT_NAMES].[Parents]
    ,[STUDENT_SCHOOL_YEAR].[ENTER_DATE]
    
    --,[STUDENT_PARENT].*
    ,CASE WHEN [PARENT_EXTRA_DETAILS].[ACTIVE_MILITARY] IS NOT NULL THEN [PARENT_PERSON].[FIRST_NAME] + ' ' + [PARENT_PERSON].[LAST_NAME] END AS [PARENT_NAME]
    ,[PARENT_EXTRA_DETAILS].[ACTIVE_MILITARY]
    ,[PARENT_EXTRA_DETAILS].[BRANCH_OF_SERVICE]
    ,[PARENT_EXTRA_DETAILS].[MILITARY_RANK]
    ,[PARENT_EXTRA_DETAILS].[FEDERAL_EMPLOYER]
    
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
	
	INNER JOIN 
	rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
	ON 
	[STUDENT_SCHOOL_YEAR].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	-- Get the school year
	LEFT JOIN 
	rev.REV_YEAR AS [RevYear] -- Contains the School Year
	ON 
	[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]

	INNER JOIN
	rev.[EPC_SCH] AS [SCHOOL]
	ON
	[OrgYear].[ORGANIZATION_GU] = [SCHOOL].[ORGANIZATION_GU]
	
	LEFT OUTER JOIN
	APS.LookupTable('K12','Grade') AS [Grades]
	ON
	[STUDENT_SCHOOL_YEAR].[GRADE] = [Grades].[VALUE_CODE]
	
	--------------------------------------------------------------------
	-- Student Details
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[StudentYear].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	INNER JOIN
	rev.EPC_STU AS [EPC_STU]
	ON
	[STUDENT].[STUDENT_GU] = [EPC_STU].[STUDENT_GU]
	
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
    APS.ELLCalculatedAsOf (GETDATE()) AS [ELL]
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
	LEFT JOIN
	ParentNames AS [PARENT_NAMES]
	ON
	[STUDENT].[STUDENT_GU] = [PARENT_NAMES].[STUDENT_GU] 
	AND [PARENT_NAMES].[rno] = 1
	
	-- Get a list of ethnic codes pivoted into 5 columns
	LEFT JOIN
	EthCodes AS [ETHNIC_CODES]
	ON
	[STUDENT].[STUDENT_GU] = [ETHNIC_CODES].[PERSON_GU]
	AND [ETHNIC_CODES].[rno] = 1
	
	LEFT JOIN
	FRMHistory AS [FRMHistory]
	ON
	[STUDENT].[STUDENT_GU] = [FRMHistory].[STUDENT_GU]
	AND [FRMHistory].[rn] = 1
	
	LEFT JOIN
	rev.[EPC_STU_PARENT] AS [STUDENT_PARENT]
	ON
	[STUDENT].[STUDENT_GU] = [STUDENT_PARENT].[STUDENT_GU]
	AND [STUDENT_PARENT].[LIVES_WITH] = 'Y'
	
	LEFT JOIN
	rev.REV_PERSON AS [PARENT_PERSON]
	ON
	[STUDENT_PARENT].[PARENT_GU] = [PARENT_PERSON].[PERSON_GU]
	
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
	[STUDENT_SCHOOL_YEAR].[ENTER_DATE] < GETDATE()
	AND [RevYear].[SCHOOL_YEAR] = '2014'
	AND [RevYear].[EXTENSION] = 'R'
	AND [Grades].[VALUE_DESCRIPTION] NOT IN ('P1','P2','PK')
	
	--AND [CurrentSPED].[SECONDARY_DISABILITY_CODE] IS NOT NULL
	
	--AND [STUDENT].[SIS_NUMBER] = '970057675' -- 956 1016     --'970034817' -- 960 70472