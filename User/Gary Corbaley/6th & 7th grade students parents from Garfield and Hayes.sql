
--SELECT
--	*
--FROM

--(
SELECT
	[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[SIS_NUMBER]
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL NAME]
	,[Grades].[VALUE_DESCRIPTION] AS [GRADE LEVEL]
	
	,[PARENT].[FIRST_NAME] + ' ' + [PARENT].[LAST_NAME] AS [PARENT NAME]
	,[STUDENT_PARENTS].[MAILINGS_ALLOWED]
	,[STUDENT_PARENTS].[LIVES_WITH]
	
	,[PARENT_HOME_ADDRESS].[ADDRESS] AS [HOME_ADDRESS]
	,[PARENT_HOME_ADDRESS].[ADDRESS2] AS [HOME_ADDRESS_2]
	,[PARENT_HOME_ADDRESS].[CITY] AS [HOME_CITY]
	,[PARENT_HOME_ADDRESS].[STATE] AS [HOME_STATE]
	,[PARENT_HOME_ADDRESS].[ZIP_5] AS [HOME_ZIP]
	
	,[PARENT_MAIL_ADDRESS].[ADDRESS] AS [MAIL_ADDRESS]
	,[PARENT_MAIL_ADDRESS].[ADDRESS2] AS [MAIL_ADDRESS_2]
	,[PARENT_MAIL_ADDRESS].[CITY] AS [MAIL_CITY]
	,[PARENT_MAIL_ADDRESS].[STATE] AS [MAIL_STATE]
	,[PARENT_MAIL_ADDRESS].[ZIP_5] AS [MAIL_ZIP]
	
	,[PRIMARY_PHONE].[PHONE] AS [STUDENT 1ST CONTACT PHONE]
	,[PARENT].[EMAIL]
	
	,CASE WHEN [Contact_Language].[VALUE_DESCRIPTION] IS NULL THEN [STUDENT].[HOME_LANGUAGE] ELSE [Contact_Language].[VALUE_DESCRIPTION] END AS [STUDENT LANGUAGE PREFERENCE] 
	
	,CASE WHEN [CurrentSPED].[PRIMARY_DISABILITY_CODE] IS NULL THEN 'N' ELSE 'Y' END AS [SPED_STAT]
	
	,CASE WHEN [ELL_PGM].[PROGRAM_CODE] = '1' AND [ELL_PGM].[EXIT_DATE] IS NULL THEN 'Y' ELSE 'N' END AS [ELL_STAT]
	
FROM
	-----------------------------------------------------------------
	-- Enrollment Details
	
	APS.PrimaryEnrollmentsAsOf(GETDATE()) AS [ENROLLMENTS]
	
	INNER JOIN 
	rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
	ON 
	[ENROLLMENTS].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	LEFT OUTER JOIN
	APS.LookupTable('K12','Grade') AS [Grades]
	ON
	[ENROLLMENTS].[GRADE] = [Grades].[VALUE_CODE]
	
	---------------------------------------------------------------
	-- Student Details
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	LEFT OUTER JOIN
	rev.[REV_PERSON_PHONE] AS [PRIMARY_PHONE]
	ON
	[STUDENT].[STUDENT_GU] = [PRIMARY_PHONE].[PERSON_GU]
	AND [PRIMARY_PHONE].[PRIMARY_PHONE] = 'Y'
	AND [PRIMARY_PHONE].[CONTACT_PHONE] = 'Y'
	
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
	LEFT OUTER JOIN
	APS.LookupTable ('K12', 'Language') AS [Contact_Language]	
	ON
	[ELL_PGM].[LANGUAGE_TO_HOME] = [Contact_Language].[VALUE_CODE]
	
	------------------------------------------------------------------
	-- Parent Details
	
	LEFT OUTER JOIN
	rev.[EPC_STU_PARENT] AS [STUDENT_PARENTS]
	ON
	[STUDENT].[STUDENT_GU] = [STUDENT_PARENTS].[STUDENT_GU]
	--AND [STUDENT_PARENTS].[MAILINGS_ALLOWED] = 'Y'
	--AND [STUDENT_PARENTS].[LIVES_WITH] = 'Y'
	
	LEFT OUTER JOIN
	rev.[REV_PERSON] AS [PARENT]
	ON
	[STUDENT_PARENTS].[PARENT_GU] = [PARENT].[PERSON_GU]
	
	-- Get Home Address
	LEFT OUTER JOIN
	rev.REV_ADDRESS AS [PARENT_HOME_ADDRESS]
	ON
	[PARENT].[HOME_ADDRESS_GU] = [PARENT_HOME_ADDRESS].[ADDRESS_GU]
	
	-- Get Mailing Address
	LEFT OUTER JOIN
	rev.REV_ADDRESS AS [PARENT_MAIL_ADDRESS]
	ON
	[PARENT].[MAIL_ADDRESS_GU] = [PARENT_MAIL_ADDRESS].[ADDRESS_GU]
	
WHERE
	[Grades].[VALUE_DESCRIPTION] IN ('06','07')
	AND [Organization].[ORGANIZATION_NAME] IN ('Garfield Middle School','Hayes Middle School')
	
	--AND [STUDENT].[SIS_NUMBER] = '980009257'
	
--) AS [STUDENT_PARENT_LIST]

--WHERE
--	[PARENT NAME] IS NULL