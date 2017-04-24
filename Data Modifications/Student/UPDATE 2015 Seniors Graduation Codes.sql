/**
 * $Revision: 1 $
 * $LastChangedBy: e104090 $
 * $LastChangedDate: 2017-04-21 $
 */

BEGIN TRAN
    --Graduation Date='2016-05-25'
    --Graduation Status='02'
    --Diploma Type='01'
    --Post Secondary='01'
    --Graduation Semester='02'

--SELECT
--    EXPECTED_GRADUATION_YEAR
--	,[Student].[SIS_NUMBER]
--    ,[Person].[LAST_NAME]
--    ,[Person].[FIRST_NAME]
--    ,[O].[ORGANIZATION_NAME]
--    ,[Diplomas].[VALUE_DESCRIPTION] AS DIPLOMA_TYPE
--    ,[Grades].[VALUE_DESCRIPTION] AS GRADE
--    ,[Student].[GRADUATION_DATE]
--    ,[Student].[GRADUATION_STATUS]
--    ,[Student].[GRADUATION_SEMESTER]
--    ,[Student].[POST_SECONDARY]
--	,SSY.YEAR_END_STATUS
--FROM
--    [rev].[EPC_STU] AS [Student]

--    INNER JOIN
--    [rev].[REV_PERSON] AS [Person]
--    ON
--    [Student].[STUDENT_GU]=[Person].[PERSON_GU]

--    INNER JOIN
--    [APS].[PrimaryEnrollmentsAsOf](GETDATE()) AS [Enroll]
--    ON
--    [Student].[STUDENT_GU]=[Enroll].[STUDENT_GU]

--    INNER JOIN
--    [rev].[REV_ORGANIZATION_YEAR] AS [OY]
--    ON
--    [Enroll].[ORGANIZATION_YEAR_GU]=[OY].[ORGANIZATION_YEAR_GU]

--    INNER JOIN
--    [rev].[REV_ORGANIZATION] AS [O]
--    ON
--    [OY].[ORGANIZATION_GU]=[O].[ORGANIZATION_GU]

--    INNER JOIN
--    [APS].[LookupTable]('K12','GRADE') AS [Grades]
--    ON
--    [Enroll].[GRADE]=[Grades].[VALUE_CODE]

--    LEFT JOIN
--    [APS].[LookupTable]('K12','DIPLOMA_TYPE') AS [Diplomas]
--    ON
--    [Student].[DIPLOMA_TYPE]=[Diplomas].[VALUE_CODE]

--	INNER JOIN 
--	rev.EPC_STU_SCH_YR AS SSY
--	ON
--	Enroll.STUDENT_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU

--WHERE
--    [Grades].[VALUE_DESCRIPTION]='12'
--    AND [Student].[EXPECTED_GRADUATION_YEAR]=2017
--    AND ([Student].[GRADUATION_DATE] IS NULL
--    AND [Student].[GRADUATION_STATUS] IS NULL
--    AND [Student].[GRADUATION_SEMESTER] IS NULL
--    AND [Student].[POST_SECONDARY] IS NULL
--    OR [Student].[DIPLOMA_TYPE] IS NULL)
--	AND ORGANIZATION_NAME NOT IN ('Career Enrichment Center', 'Homebound', 'Private School', 'Title One School', 'Continuation School', 'eCademy Virtual', 'Highland Autism Center Annex', 'Interim Alternative Ed Setting') 

--	ORDER BY ORGANIZATION_NAME

UPDATE
    [rev].[EPC_STU_SCH_YR]

    SET  YEAR_END_STATUS = CASE WHEN ENROLL.YEAR_END_STATUS IS NULL THEN 'G' ELSE ENROLL.YEAR_END_STATUS END
	,CHANGE_DATE_TIME_STAMP = GETDATE()
	,CHANGE_ID_STAMP = '27CDCD0E-BF93-4071-94B2-5DB792BB735F'
FROM
(
SELECT YEAR_END_STATUS, SSY.STUDENT_SCHOOL_YEAR_GU AS SSYGU FROM
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

	INNER JOIN 
	rev.EPC_STU_SCH_YR AS SSY
	ON
	Enroll.STUDENT_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU

WHERE
    [Grades].[VALUE_DESCRIPTION]='12'
    AND [Student].[EXPECTED_GRADUATION_YEAR]=2017
    AND ([Student].[GRADUATION_DATE] IS NULL
    AND [Student].[GRADUATION_STATUS] IS NULL
    AND [Student].[GRADUATION_SEMESTER] IS NULL
    AND [Student].[POST_SECONDARY] IS NULL
    OR [Student].[DIPLOMA_TYPE] IS NULL)
	AND ORGANIZATION_NAME NOT IN ('Career Enrichment Center', 'Homebound', 'Private School', 'Title One School', 'Continuation School', 'eCademy Virtual', 'Highland Autism Center Annex', 'Interim Alternative Ed Setting') 
) AS ENROLL	
	
WHERE ENROLL.SSYGU = rev.EPC_STU_SCH_YR.STUDENT_SCHOOL_YEAR_GU

UPDATE
    [rev].[EPC_STU]

    SET
    [DIPLOMA_TYPE]=CASE WHEN [DIPLOMA_TYPE] IS NULL THEN '01' ELSE [DIPLOMA_TYPE] END
    ,[GRADUATION_DATE]=CASE WHEN [GRADUATION_DATE] IS NULL THEN '2017-05-25' ELSE [GRADUATION_DATE] END
    ,[POST_SECONDARY]=CASE WHEN [POST_SECONDARY] IS NULL THEN '01' ELSE [POST_SECONDARY] END
    ,[GRADUATION_SEMESTER]=CASE WHEN [GRADUATION_SEMESTER] IS NULL THEN '2' ELSE [GRADUATION_SEMESTER] END
    ,[GRADUATION_STATUS]=CASE WHEN [GRADUATION_STATUS] IS NULL THEN '2' ELSE [GRADUATION_STATUS] END
	,CHANGE_DATE_TIME_STAMP = GETDATE()
	,CHANGE_ID_STAMP = '27CDCD0E-BF93-4071-94B2-5DB792BB735F'
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
    AND [Student].[EXPECTED_GRADUATION_YEAR]=2017
    AND ([Student].[GRADUATION_DATE] IS NULL
    AND [Student].[GRADUATION_STATUS] IS NULL
    AND [Student].[GRADUATION_SEMESTER] IS NULL
    AND [Student].[POST_SECONDARY] IS NULL
    OR [Student].[DIPLOMA_TYPE] IS NULL)
	AND ORGANIZATION_NAME NOT IN ('Career Enrichment Center', 'Homebound', 'Private School', 'Title One School', 'Continuation School', 'eCademy Virtual', 'Highland Autism Center Annex', 'Interim Alternative Ed Setting') 





--SELECT
--    [Student].[SIS_NUMBER]
--    ,[Student].[DIPLOMA_TYPE]
--    ,[Grades].[VALUE_DESCRIPTION]
--    ,[Student].[GRADUATION_DATE]
--    ,[Student].[GRADUATION_STATUS]
--    ,[Student].[GRADUATION_SEMESTER]
--    ,[Student].[POST_SECONDARY]
--FROM
--    [rev].[EPC_STU] AS [Student]

--    INNER JOIN
--    [APS].[PrimaryEnrollmentsAsOf](GETDATE()) AS [Enroll]
--    ON
--    [Student].[STUDENT_GU]=[Enroll].[STUDENT_GU]

--    INNER JOIN
--    [APS].[LookupTable]('K12','GRADE') AS [Grades]
--    ON
--    [Enroll].[GRADE]=[Grades].[VALUE_CODE]

--WHERE
--    [Grades].[VALUE_DESCRIPTION]='12'
--    AND [Student].[EXPECTED_GRADUATION_YEAR]=2017
--	AND STUDENT.CHANGE_ID_STAMP = '27CDCD0E-BF93-4071-94B2-5DB792BB735F'
	
COMMIT