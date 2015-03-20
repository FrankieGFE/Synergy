BEGIN TRAN

DECLARE @StartYear AS INT = (SELECT [SCHOOL_YEAR] FROM [rev].[SIF_22_Common_CurrentYear])+1
DECLARE @asOfDate AS DATE=GETDATE()

--uncomment this to delete all the notification records
/*DELETE FROM 
    [rev].[REV_PERSON_NOT]

WHERE
    [NOT_CFG_GU]='0C130D5B-1FBA-4C56-BC51-A8623A7A7D62'*/

--update records where the student is now on track.
UPDATE
    [rev].[REV_PERSON_NOT]

    SET
    [END_DATE]=@asOfDate

FROM
    (
    SELECT
	   [Enroll].[STUDENT_GU] 
	   ,[Config].[NOT_CFG_GU] AS [ConfigGU]
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

		  LEFT JOIN
		  [rev].[REV_PERSON_NOT] AS [NoteCheck]
		  ON
		  [Student].[STUDENT_GU]=[NoteCheck].[PERSON_GU]
		  AND
		  [NoteCheck].[NOT_CFG_GU]=[Config].[NOT_CFG_GU]
		  AND
		  [NoteCheck].[END_DATE] IS NULL

	   WHERE
		  [Enroll].[GRADE] BETWEEN 190 AND 220
		  AND
		  [Student].[EXPECTED_GRADUATION_YEAR]=2015+(12-
			 CASE
				WHEN [Enroll].[GRADE]=190 THEN 9
				WHEN [Enroll].[GRADE]=200 THEN 10
				WHEN [Enroll].[GRADE]=210 THEN 11
				WHEN [Enroll].[GRADE]=220 THEN 12
			 END)
		  AND
		  [NoteCheck].[PERSON_GU] IS NOT NULL
    ) AS [Students]

WHERE
    [NOT_CFG_GU]=[Students].[ConfigGU]
    AND [PERSON_GU]=[Students].[STUDENT_GU]


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
	   ,'135699EF-FBEF-494C-8A2B-048EEAA1ADF7' AS [ADD_ID_STAMP] --e204042
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

	   LEFT JOIN
	   [rev].[REV_PERSON_NOT] AS [NoteCheck]
	   ON
	   [Student].[STUDENT_GU]=[NoteCheck].[PERSON_GU]
	   AND
	   [NoteCheck].[NOT_CFG_GU]=[Config].[NOT_CFG_GU]
	   AND
	   [NoteCheck].[END_DATE] IS NULL

    WHERE
	   [Enroll].[GRADE] BETWEEN 190 AND 220
	   AND
	   [Student].[EXPECTED_GRADUATION_YEAR]<2015+(12-
		  CASE
			 WHEN [Enroll].[GRADE]=190 THEN 9
			 WHEN [Enroll].[GRADE]=200 THEN 10
			 WHEN [Enroll].[GRADE]=210 THEN 11
			 WHEN [Enroll].[GRADE]=220 THEN 12
		  END)
	   AND
	   [NoteCheck].[PERSON_GU] IS NULL

ROLLBACK