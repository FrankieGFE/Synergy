

BEGIN TRAN

SELECT
    [Sections].[SECTION_ID]
    ,[Courses].[COURSE_ID]
    --,[Org].[ORGANIZATION_NAME]
    --,[Teacher].[LAST_NAME]+', '+[Teacher].[FIRST_NAME] AS [Teacher Name]
    ,[Student].[SIS_NUMBER]
    ,[StudentPerson].[LAST_NAME]+', '+[StudentPerson].[FIRST_NAME] AS [Student Name]
    ,[Levels].[VALUE_DESCRIPTION] AS [Grade Level]
    ,[Sections].[TERM_CODE]
    ,[Year].[SCHOOL_YEAR]
FROM
    [rev].[EPC_CRS] AS [Courses]

    INNER HASH JOIN
    [rev].[EPC_SCH_YR_CRS] AS [SchoolYearCourse]
    ON
    [Courses].[COURSE_GU]=[SchoolYearCourse].[COURSE_GU]

    INNER HASH JOIN
    [rev].[EPC_STU_SCHD_REQUEST] AS [Requests]
    ON
    [SchoolYearCourse].[SCHOOL_YEAR_COURSE_GU]=[Requests].[SCHOOL_YEAR_COURSE_GU]

    INNER HASH JOIN
    [rev].[EPC_SCH_YR_SCHD_SECT] AS [Sections]
    ON
    [Requests].[SCHOOL_YEAR_COURSE_GU]=[Sections].[SCHOOL_YEAR_COURSE_GU]

    INNER HASH JOIN
    [rev].[EPC_STU_SCH_YR] AS [SSY]
    ON
    [Requests].[STUDENT_SCHOOL_YEAR_GU]=[SSY].[STUDENT_SCHOOL_YEAR_GU]

    INNER HASH JOIN
    [rev].[EPC_STU] AS [Student]
    ON
    [SSY].[STUDENT_GU]=[Student].[STUDENT_GU]

    INNER HASH JOIN
    [rev].[REV_PERSON] AS [StudentPerson]
    ON
    [Student].[STUDENT_GU]=[StudentPerson].[PERSON_GU]

    INNER HASH JOIN
    [rev].[REV_YEAR] AS [Year]
    ON
    [SSY].[YEAR_GU]=[Year].[YEAR_GU]

    INNER HASH JOIN
   [rev].[EPC_SCH_YR_OPT_SCHED] AS [SchedOpt]
    ON
    [SSY].[ORGANIZATION_YEAR_GU]=[SchedOpt].[ORGANIZATION_YEAR_GU]

    LEFT JOIN
    [APS].[LookupTable]('K12','GRADE') AS [Levels]
    ON
    [SSY].[GRADE]=[Levels].[VALUE_CODE]

WHERE
    /*[Courses].[COURSE_ID] IN ('330403','350403','360403')
    AND */
	[Year].[SCHOOL_YEAR]=2015 AND [Year].[EXTENSION]='R'
    --AND [Levels].[VALUE_DESCRIPTION]!='12'
    AND	 [Student].[SIS_NUMBER]=102790268

ORDER BY
    [COURSE_ID]

ROLLBACK

