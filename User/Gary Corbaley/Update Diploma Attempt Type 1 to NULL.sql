



--SELECT
--	*
UPDATE [STUDENT]
	
	SET [STUDENT].[DIPLOMA_ATTEMPT_TYPE_1] = NULL

FROM
	rev.EPC_STU AS [STUDENT]
	
WHERE
	[STUDENT].[DIPLOMA_ATTEMPT_TYPE_1] IS NOT NULL