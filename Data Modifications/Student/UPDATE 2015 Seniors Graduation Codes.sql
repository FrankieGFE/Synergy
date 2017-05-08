/**
 * $Revision: 1 $
 * $LastChangedBy: e104090 $
 * $LastChangedDate: 2017-04-21 $
 */


 /*


 4/26/17 DAC - Change per Patti, do not skip kids if they have data in any one of the fields.  Changed the AND's to OR's

     AND ([Student].[GRADUATION_DATE] IS NULL
    OR [Student].[GRADUATION_STATUS] IS NULL
    OR [Student].[GRADUATION_SEMESTER] IS NULL
    OR [Student].[POST_SECONDARY] IS NULL
    OR [Student].[DIPLOMA_TYPE] IS NULL)

 */


BEGIN TRAN


UPDATE
    [rev].[EPC_STU_SCH_YR]

    SET  

 YEAR_END_STATUS = CASE WHEN ENROLL.YEAR_END_STATUS IS NULL THEN 'G' ELSE ENROLL.YEAR_END_STATUS END
	,CHANGE_DATE_TIME_STAMP = GETDATE()
	,CHANGE_ID_STAMP = '27CDCD0E-BF93-4071-94B2-5DB792BB735F'


/****************************************************************************************************

Comment SELECT out to run in update mode, move Select to SET to pull changes for review

****************************************************************************************************/

--SELECT	
	--,SIS_NUMBER
	--,YEAR_END_STATUS


FROM
(
SELECT YEAR_END_STATUS, SSY.STUDENT_SCHOOL_YEAR_GU AS SSYGU, SIS_NUMBER FROM
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
    OR [Student].[GRADUATION_STATUS] IS NULL
    OR [Student].[GRADUATION_SEMESTER] IS NULL
    OR [Student].[POST_SECONDARY] IS NULL
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

/****************************************************************************************************

Comment SELECT out to run in update mode, move Select to SET to pull changes for review

****************************************************************************************************/

--SELECT	,SIS_NUMBER
--	,DIPLOMA_TYPE,GRADUATION_DATE, POST_SECONDARY, GRADUATION_SEMESTER,GRADUATION_STATUS

 
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
    OR [Student].[GRADUATION_STATUS] IS NULL
    OR [Student].[GRADUATION_SEMESTER] IS NULL
    OR [Student].[POST_SECONDARY] IS NULL
    OR [Student].[DIPLOMA_TYPE] IS NULL)
	AND ORGANIZATION_NAME NOT IN ('Career Enrichment Center', 'Homebound', 'Private School', 'Title One School', 'Continuation School', 'eCademy Virtual', 'Highland Autism Center Annex', 'Interim Alternative Ed Setting') 



	
ROLLBACK