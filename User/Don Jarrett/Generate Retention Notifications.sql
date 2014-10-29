BEGIN TRAN

DECLARE @StartYear AS INT = (SELECT [SCHOOL_YEAR] FROM [rev].[SIF_22_Common_CurrentYear])+1
DECLARE @asOfDate AS DATE=GETDATE()

/*DELETE FROM 
    [rev].[REV_PERSON_NOT]

WHERE
    [NOT_CFG_GU]='0C130D5B-1FBA-4C56-BC51-A8623A7A7D62'*/

INSERT INTO
    [rev].[REV_PERSON_NOT]

    (
    [PERSON_NOT_GU]
    ,[PERSON_GU]
    ,[NOT_CFG_GU]
    ,[BEGIN_DATE]
    ,[END_DATE]
    ,[ADD_DATE_TIME_STAMP]
    ,[ADD_ID_STAMP]
    ,[ADDED_BY_RULE]
    ,[RULE_GU]
    )

    SELECT
	   NEWID() AS [PERSON_NOT_GU]
	   ,[Enroll].[STUDENT_GU] AS [PERSON_GU]
	   ,[Config].[NOT_CFG_GU] AS [NOT_CFG_GU]
	   ,@asOfDate AS [BEGIN_DATE]
	   ,NULL AS [END_DATE]
	   ,@asOfDate AS [ADD_DATE_TIME_STAMP]
	   ,'135699EF-FBEF-494C-8A2B-048EEAA1ADF7' AS [ADD_ID_STAMP]
	   ,'N' AS [ADDED_BY_RULE]
	   ,NULL AS [RULE_GU]
    FROM
	   [APS].[PrimaryEnrollmentsAsOf](GETDATE()) AS [Enroll]

	   INNER JOIN --join it back to student
	   [rev].[EPC_STU] AS [Student]
	   ON
	   [Enroll].[STUDENT_GU]=[Student].[STUDENT_GU]

	   INNER JOIN
	   [rev].[REV_NOT_CFG] AS [Config]
	   ON
	   [Config].[SHORT_DESCRIPTION]='Retained'

	   INNER JOIN
	   [APS].[LookupTable]('K12','Grade') AS [Grades]
	   ON
	   [Enroll].[GRADE]=[Grades].[VALUE_CODE]

	   LEFT JOIN
	   [rev].[REV_PERSON_NOT] AS [NoteCheck]
	   ON
	   [Student].[STUDENT_GU]=[NoteCheck].[PERSON_GU]
	   AND
	   [NoteCheck].[NOT_CFG_GU]=[Config].[NOT_CFG_GU]
	   AND
	   [NoteCheck].[END_DATE] IS NULL

    WHERE
	   [Grades].[VALUE_DESCRIPTION] BETWEEN '09' AND '12'
	   AND
	   [Student].[EXPECTED_GRADUATION_YEAR]<@StartYear+(12-[Grades].[VALUE_DESCRIPTION])
	   AND
	   [NoteCheck].[PERSON_GU] IS NULL

SELECT
    [Student].[SIS_NUMBER]
    ,[Person].*
    ,[Config].*
FROM
    [rev].[REV_PERSON_NOT] AS [Person]

    INNER JOIN
    [rev].[REV_NOT_CFG] AS [Config]
    ON
    [Person].[NOT_CFG_GU]=[Config].[NOT_CFG_GU]

    INNER JOIN
    [rev].[EPC_STU] AS [Student]
    ON
    [Person].[PERSON_GU]=[Student].[STUDENT_GU]

WHERE
    [Config].[SHORT_DESCRIPTION]='Retained'


ROLLBACK