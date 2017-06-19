/**
 * $Revision: 0 $
 * $LastChangedBy: e134728 $
 * $LastChangedDate: 2016-11-01 $
 */

BEGIN TRAN
    --Graduation Date='2016-05-25'
    --Graduation Status='02'
    --Diploma Type='01'
    --Post Secondary='01'
    --Graduation Semester='02'

SELECT
    [Student].[SIS_NUMBER]
    ,[Person].[LAST_NAME]
    ,[Person].[FIRST_NAME]
    ,[O].[ORGANIZATION_NAME]
    ,[Diplomas].[VALUE_DESCRIPTION]
    ,[Grades].[VALUE_DESCRIPTION]
    ,[Student].[GRADUATION_DATE]
    ,[Student].[GRADUATION_STATUS]
    ,[Student].[GRADUATION_SEMESTER]
    ,[Student].[POST_SECONDARY]
FROM
    [rev].[EPC_STU] AS [Student]

    INNER JOIN
    [rev].[REV_PERSON] AS [Person]
    ON
    [Student].[STUDENT_GU]=[Person].[PERSON_GU]

    INNER JOIN
    [APS].[PrimaryEnrollmentsAsOf](GETDATE()) AS [Enroll]
    ON
    [Student].[STUDENT_GU]=[Enroll].[STUDENT_GU]

    INNER JOIN
    [rev].[REV_ORGANIZATION_YEAR] AS [OY]
    ON
    [Enroll].[ORGANIZATION_YEAR_GU]=[OY].[ORGANIZATION_YEAR_GU]

    INNER JOIN
    [rev].[REV_ORGANIZATION] AS [O]
    ON
    [OY].[ORGANIZATION_GU]=[O].[ORGANIZATION_GU]

    INNER JOIN
    [APS].[LookupTable]('K12','GRADE') AS [Grades]
    ON
    [Enroll].[GRADE]=[Grades].[VALUE_CODE]

    LEFT JOIN
    [APS].[LookupTable]('K12','DIPLOMA_TYPE') AS [Diplomas]
    ON
    [Student].[DIPLOMA_TYPE]=[Diplomas].[VALUE_CODE]

WHERE
    [Grades].[VALUE_DESCRIPTION]= '12'
	OR [Grades].[VALUE_DESCRIPTION]= '11'
	OR [Grades].[VALUE_DESCRIPTION]= '10'
	OR [Grades].[VALUE_DESCRIPTION]= '09'
    --AND [Student].[EXPECTED_GRADUATION_YEAR]=2016
    --AND ([Student].[GRADUATION_DATE] IS NULL
    --AND [Student].[GRADUATION_STATUS] IS NULL
    --AND [Student].[GRADUATION_SEMESTER] IS NULL
    --AND [Student].[POST_SECONDARY] IS NULL
    AND [Student].[DIPLOMA_TYPE] IS NULL
	AND ORGANIZATION_NAME NOT IN ('Career Enrichment Center', 'Homebound', 'Private School', 'Title One School') 
/*
UPDATE
    [rev].[EPC_STU]

    SET
    [DIPLOMA_TYPE]=CASE WHEN [DIPLOMA_TYPE] IS NULL THEN '01' ELSE [DIPLOMA_TYPE] END
    --,[GRADUATION_DATE]=CASE WHEN [GRADUATION_DATE] IS NULL THEN '2016-05-25' ELSE [GRADUATION_DATE] END
    --,[POST_SECONDARY]=CASE WHEN [POST_SECONDARY] IS NULL THEN '01' ELSE [POST_SECONDARY] END
   --,[GRADUATION_SEMESTER]=CASE WHEN [GRADUATION_SEMESTER] IS NULL THEN '02' ELSE [GRADUATION_SEMESTER] END
    --,[GRADUATION_STATUS]=CASE WHEN [GRADUATION_STATUS] IS NULL THEN '2' ELSE [GRADUATION_STATUS] END
	,CHANGE_DATE_TIME_STAMP = GETDATE()
	,CHANGE_ID_STAMP = '135699EF-FBEF-494C-8A2B-048EEAA1ADF7'  -- e134728 USER_GU
FROM
    [rev].[EPC_STU] AS [Student]

    INNER JOIN
    [APS].[PrimaryEnrollmentsAsOf](GETDATE()) AS [Enroll]
    ON
    [Student].[STUDENT_GU]=[Enroll].[STUDENT_GU]

    INNER JOIN
    [APS].[LookupTable]('K12','GRADE') AS [Grades]
    ON
    [Enroll].[GRADE]=[Grades].[VALUE_CODE]

	    INNER JOIN
    [rev].[REV_ORGANIZATION_YEAR] AS [OY]
    ON
    [Enroll].[ORGANIZATION_YEAR_GU]=[OY].[ORGANIZATION_YEAR_GU]

    INNER JOIN
    [rev].[REV_ORGANIZATION] AS [O]
    ON
    [OY].[ORGANIZATION_GU]=[O].[ORGANIZATION_GU]

WHERE
    [Grades].[VALUE_DESCRIPTION]='12'
	OR [Grades].[VALUE_DESCRIPTION]= '11'
	OR [Grades].[VALUE_DESCRIPTION]= '10'
	OR [Grades].[VALUE_DESCRIPTION]= '09'
    --AND [Student].[EXPECTED_GRADUATION_YEAR]=2016
    --AND ([Student].[GRADUATION_DATE] IS NULL
    --AND [Student].[GRADUATION_STATUS] IS NULL
    --AND [Student].[GRADUATION_SEMESTER] IS NULL
    --AND [Student].[POST_SECONDARY] IS NULL
    AND [Student].[DIPLOMA_TYPE] IS NULL)
	AND ORGANIZATION_NAME NOT IN ('Career Enrichment Center', 'Homebound', 'Private School', 'Title One School') 

SELECT
    [Student].[SIS_NUMBER]
    ,[Student].[DIPLOMA_TYPE]
    ,[Grades].[VALUE_DESCRIPTION]
    ,[Student].[GRADUATION_DATE]
    ,[Student].[GRADUATION_STATUS]
    ,[Student].[GRADUATION_SEMESTER]
    ,[Student].[POST_SECONDARY]
FROM
    [rev].[EPC_STU] AS [Student]

    INNER JOIN
    [APS].[PrimaryEnrollmentsAsOf](GETDATE()) AS [Enroll]
    ON
    [Student].[STUDENT_GU]=[Enroll].[STUDENT_GU]

    INNER JOIN
    [APS].[LookupTable]('K12','GRADE') AS [Grades]
    ON
    [Enroll].[GRADE]=[Grades].[VALUE_CODE]

WHERE
    [Grades].[VALUE_DESCRIPTION]='12'
	OR [Grades].[VALUE_DESCRIPTION]= '11'
	OR [Grades].[VALUE_DESCRIPTION]= '10'
	OR [Grades].[VALUE_DESCRIPTION]= '09'
    --AND [Student].[EXPECTED_GRADUATION_YEAR]=2016
	AND STUDENT.CHANGE_ID_STAMP = '135699EF-FBEF-494C-8A2B-048EEAA1ADF7'
	
ROLLBACK
*/