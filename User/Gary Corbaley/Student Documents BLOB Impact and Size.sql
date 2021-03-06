
SELECT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[BIRTH_DATE]
	,[STUDENT].[GENDER]
	,[STUDENT].[CLASS_OF]
	,[ENROLLMENTS].[GRADE]
	,[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[ENROLLMENTS].[SCHOOL_YEAR]
	,[ENROLLMENTS].[ENTER_DATE]
	,[ENROLLMENTS].[LEAVE_DATE]
	,[PERSON_FILES].*
FROM
	(
	SELECT
		[SOURCE] AS [SOURCE_TABLE]
		,[DOC_TYPE]
		,[PERSON_GU]
		,SUM([COUNT]) AS [COUNT]
		,SUM([BYTES]) AS [MBYTES]
	FROM
		(
		--/*
		SELECT
			'EP_STU_ATTCH_DOC' AS [SOURCE]
			,[DOC].DOC_TYPE
			,[DOC].[STUDENT_GU] AS [PERSON_GU]
			,COUNT([DOC].DOC_FILE_NAME) AS [COUNT]
			,SUM(DATALENGTH([DOC].DOC_CONTENT)/1024) as [BYTES]
			
		FROM
			rev.EP_STU_ATTCH_DOC AS [DOC]
			
		GROUP BY
			[DOC].DOC_TYPE
			,[DOC].[STUDENT_GU]
		--*/	
		UNION ALL
		--/*	
		SELECT
			'EP_STUDENT_DOCUMENT' AS [SOURCE]
			,'PDF' AS [DOC_TYPE]
			,[DOC].[STUDENT_GU] AS [PERSON_GU]
			,COUNT([DOC].DOCUMENT_DATE) AS [COUNT]
			,SUM(DATALENGTH([DOC].PDF)/1024) as BYTES
			
		FROM
			rev.EP_STUDENT_DOCUMENT AS [DOC]
			
		GROUP BY
			[DOC].[STUDENT_GU]
		--*/
		UNION ALL
		--/*
		SELECT
			'REV_PERSON_PHOTO' AS [SOURCE]
			,'GIF' AS [DOC_TYPE]
			,[PHOTO].[PERSON_GU] AS [PERSON_GU]
			,COUNT([PHOTO].CHANGE_DATE_TIME) AS [COUNT]
			,SUM(DATALENGTH([PHOTO].[PHOTO])/1024) AS BYTES
		FROM
			rev.REV_PERSON_PHOTO AS [PHOTO]
			
		GROUP BY
			[PHOTO].[PERSON_GU]
		--*/
		UNION ALL
		--/*
		SELECT
			'EPC_STU_HEALTH_DOC' AS [SOURCE]
			,[DOC].DOC_TYPE
			,[DOC].[STUDENT_GU] AS [PERSON_GU]
			,COUNT([DOC].DOC_FILE_NAME) AS [COUNT]
			,SUM(DATALENGTH([DOC].DOC_CONTENT)/1024) as BYTES
			
		FROM
			rev.EPC_STU_HEALTH_DOC AS [DOC]
			
		GROUP BY
			[DOC].DOC_TYPE
			,[DOC].[STUDENT_GU]
		--*/
		UNION ALL

		--/*
		SELECT
			'REV_PERSON_ATC_DOC' AS [SOURCE]
			,[DOC].DOC_TYPE
			,[DOC].[PERSON_GU] AS [PERSON_GU]
			,COUNT([DOC].DOC_FILE_NAME) AS [COUNT]
			,SUM(DATALENGTH([DOC].DOC_CONTENT)/1024) as BYTES
			
		FROM
			rev.REV_PERSON_ATC_DOC AS [DOC]
			
		GROUP BY
			[DOC].DOC_TYPE
			,[DOC].[PERSON_GU]
		--*/
		) AS [FILES]
		
	GROUP BY
		[SOURCE]
		,[DOC_TYPE]
		,[PERSON_GU]
		
	) AS [PERSON_FILES]
	
	LEFT OUTER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[PERSON_FILES].[PERSON_GU] = [STUDENT].[STUDENT_GU]
	
	LEFT OUTER JOIN
	(
	SELECT
		*
		,ROW_NUMBER() OVER (PARTITION BY [STUDENT_GU] ORDER BY [ENTER_DATE] DESC) AS RN
	FROM
		APS.StudentEnrollmentDetails
		
	WHERE
		EXCLUDE_ADA_ADM IS NULL
		AND [SUMMER_WITHDRAWL_CODE] IS NULL
	) AS [ENROLLMENTS]
	ON
	[STUDENT].[STUDENT_GU] = [ENROLLMENTS].[STUDENT_GU]
	AND [ENROLLMENTS].[RN] = 1
		
	


	