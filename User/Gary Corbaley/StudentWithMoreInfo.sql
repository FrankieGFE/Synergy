/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 08/26/2014 $
 *
 * Request By: Debbie Chavez
 * InitialRequestDate: 4/29/2015
 * 
 * This script will pull detail demographic information for all students in the system
 * One Record Per Student
 */



SELECT
	-- Basic Student Demographics	
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[STATE_STUDENT_NUMBER]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[STUDENT].[BIRTH_DATE]
	,[STUDENT].[GENDER]
	,[STUDENT].[HOME_LANGUAGE]
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
	
	--[STUDENT].*
	
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
    --,CASE WHEN [Contact_Language].[VALUE_DESCRIPTION] IS NULL THEN [STUDENT].[HOME_LANGUAGE] ELSE [Contact_Language].[VALUE_DESCRIPTION] END AS [HOME_CONTACT_LANGAUGE]
    ,[Contact_Language].[VALUE_DESCRIPTION] AS [CONTACT_LANGUAGE]
    
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
    
    ----------------------------------------------------
    -- LIST OF GU'S
    ,[STUDENT].[STUDENT_GU]
    ,[STUDENT].[HOME_ADDRESS_GU]
    ,[STUDENT].[MAIL_ADDRESS_GU]
    --,[STUDENT].[
    
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