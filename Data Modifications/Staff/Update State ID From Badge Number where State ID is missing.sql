BEGIN TRAN

SELECT
	[Person].[LAST_NAME]+', '+[Person].[FIRST_NAME] AS [Staff Name]
	,[BADGE_NUM]
	,[STATE_ID]
FROM
	[rev].[EPC_STAFF] AS [Staff]

	INNER JOIN
	[rev].[REV_PERSON] AS [Person]
	ON
	[Staff].[STAFF_GU]=[Person].[PERSON_GU]

WHERE
	[BADGE_NUM] IS NOT NULL
	AND ISNULL([STATE_ID],'')=''


UPDATE
	[rev].[EPC_STAFF]

	SET
		[STATE_ID]=[BADGE_NUM]

	WHERE
		[BADGE_NUM] IS NOT NULL
		AND ISNULL([STATE_ID],'')=''

ROLLBACK