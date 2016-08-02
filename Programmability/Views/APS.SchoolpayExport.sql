
CREATE VIEW APS.SchoolpayExport AS

SELECT
    [Student].[SIS_NUMBER] AS [Student ID]
    ,[School].[SCHOOL_CODE] AS [School ID]
    ,[Person].[FIRST_NAME] AS [First Name]
    ,[Person].[LAST_NAME] AS [Last Name]
    ,[Grades].[VALUE_DESCRIPTION] AS [Grade]
    ,'' AS [Teacher]
FROM
    [rev].[EPC_STU_SCH_YR] AS [SSY]

    INNER HASH JOIN
    [rev].[EPC_STU_ENROLL] AS [Enrollment]
    ON
    [SSY].[STUDENT_SCHOOL_YEAR_GU] = [Enrollment].[STUDENT_SCHOOL_YEAR_GU]

    INNER HASH JOIN
    [rev].[REV_ORGANIZATION_YEAR] AS [OrgYear]
    ON
    [SSY].[ORGANIZATION_YEAR_GU]=[OrgYear].[ORGANIZATION_YEAR_GU]

    INNER HASH JOIN
    [rev].[EPC_SCH] AS [School]
    ON
    [OrgYear].[ORGANIZATION_GU]=[School].[ORGANIZATION_GU]

    INNER HASH JOIN
    [rev].[EPC_STU] AS [Student]
    ON
    [SSY].[STUDENT_GU]=[Student].[STUDENT_GU]

    INNER HASH JOIN
    [rev].[REV_PERSON] AS [Person]
    ON
    [Student].[STUDENT_GU]=[Person].[PERSON_GU]

    INNER HASH JOIN
    [APS].[LookupTable]('K12','GRADE') AS [Grades]
    ON
    [SSY].[GRADE]=[Grades].[VALUE_CODE]

WHERE
    [SSY].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2015 AND [EXTENSION]='R')
    AND [Enrollment].[EXCLUDE_ADA_ADM] IS NULL
    AND ([Enrollment].[LEAVE_DATE] IS NULL)