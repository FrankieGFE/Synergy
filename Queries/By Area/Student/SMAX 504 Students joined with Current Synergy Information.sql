/*
*	Created By:  Don Jarrett
*	Date:  9/30/2014
*
*    This query takes SMAX 504 students from 2013-14 and joins in
*    the following information from Synergy:
*    First Name, Last Name, SIS Number, Current Primary School, Current Grade Level    
*/

SELECT
    [Student].*
FROM
(
SELECT DISTINCT
    [504Students].[ID_NBR]
FROM
    [DBTSIS].[HE010_V] AS [504Students]

    INNER JOIN
    [DBTSIS].[ST010_V] AS [Enroll]
    ON
    [504Students].[ID_NBR]=[Enroll].[ID_NBR]
    AND [504Students].[DST_NBR]=[Enroll].[DST_NBR]

WHERE
    [504Students].[DST_NBR]=1
    AND [504Students].[ADA_504]='X'
    AND [Enroll].[SCH_YR]=2013

) AS [SMAX]

    LEFT JOIN
    OPENQUERY([SYNERGYDBDC.APS.EDU.ACTD],
    'SELECT
    ISNULL([Person].[FIRST_NAME],'''') AS [First Name]
    ,ISNULL([Person].[LAST_NAME],'''') AS [Last Name]
    ,ISNULL([Student].[SIS_NUMBER],'''') AS [SIS Number]
    ,ISNULL([Organization].[ORGANIZATION_NAME],'''') AS [Current Primary School]
    ,ISNULL([Grades].[VALUE_DESCRIPTION],'''') AS [Current Grade Level]
FROM 
    [ST_Production].[rev].[EPC_STU] AS [Student]

    LEFT JOIN --join Person to get their First/Last Name
    [rev].[REV_PERSON] AS [Person]
    ON
    [Student].[STUDENT_GU]=[Person].[PERSON_GU]

    LEFT JOIN --Join enrollments for their current grade and organization_year gu
    [APS].[PrimaryEnrollmentsAsOf](GETDATE()) AS [Enroll]
    ON
    [Student].[STUDENT_GU]=[Enroll].[STUDENT_GU]

    LEFT JOIN --join orgyear to get the school gu
    [rev].[REV_ORGANIZATION_YEAR] AS [OrgYear]
    ON
    [Enroll].[ORGANIZATION_YEAR_GU]=[OrgYear].[ORGANIZATION_YEAR_GU]

    LEFT JOIN --finally join organization to get their school name
    [rev].[REV_ORGANIZATION] AS [Organization]
    ON
    [OrgYear].[ORGANIZATION_GU]=[Organization].[ORGANIZATION_GU]

    LEFT JOIN --join the k12.grade lookup to get their grade level
    [APS].[LookupTable](''K12'',''GRADE'') AS [Grades]
    ON
    [Enroll].[GRADE]=[Grades].[VALUE_CODE]') AS [Student]

    ON
    [SMAX].[ID_NBR]=[Student].[SIS Number]
