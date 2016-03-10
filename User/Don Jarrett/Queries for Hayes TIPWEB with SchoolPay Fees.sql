EXECUTE AS LOGIN='QueryFileUser'
GO

BEGIN TRAN

DECLARE @FeeCodes TABLE ([FEE_CODE_GU] UNIQUEIDENTIFIER, [FEE_CODE] VARCHAR(256))

INSERT INTO
	@FeeCodes

	SELECT
		[FEE_CODE_GU]
		,[FEE_CODE]
	FROM
		[rev].[EPC_SCH_YR_FEE]
	WHERE
		LEFT([FEE_CODE],3) IN ('540','550','560','576','580')

/* damaged text books */
INSERT INTO
	[rev].[EPC_STU_FEE] 

	([STUDENT_FEE_GU],[STUDENT_SCHOOL_YEAR_GU],[STUDENT_GU],[TRANSACTION_DATE],[DESCRIPTION],[FEE_CATEGORY],[FEE_CODE_GU],[CREDIT_AMOUNT]
	,[NOTE],[REFUND_NEEDED],[FEE_STATUS],[ADD_DATE_TIME_STAMP])

	SELECT
		NEWID() AS [STUDENT_FEE_GU]
		,[ssy].[STUDENT_SCHOOL_YEAR_GU] AS [STUDENT_SCHOOL_YEAR_GU]
		,[stu].[STUDENT_GU] AS [STUDENT_GU]
		,GETDATE() AS [TRANSACTION_DATE]
		,'Damaged Textbook' AS [DESCRIPTION]
		,'ACT' AS [FEE_CATEGORY]
		,CASE --these might be different in live.
			WHEN [Damaged].[CampusID]='540' THEN (SELECT [FEE_CODE_GU] FROM @FeeCodes WHERE [FEE_CODE]='540552')
			WHEN [Damaged].[CampusID]='550' THEN (SELECT [FEE_CODE_GU] FROM @FeeCodes WHERE [FEE_CODE]='550502')
			WHEN [Damaged].[CampusID]='560' THEN (SELECT [FEE_CODE_GU] FROM @FeeCodes WHERE [FEE_CODE]='560204')
			WHEN [Damaged].[CampusID]='576' THEN (SELECT [FEE_CODE_GU] FROM @FeeCodes WHERE [FEE_CODE]='576203')
			WHEN [Damaged].[CampusID]='580' THEN (SELECT [FEE_CODE_GU] FROM @FeeCodes WHERE [FEE_CODE]='580107')
		 END AS [FEE_CODE_GU]
		,[Damaged].[ChargeAmount] AS [CREDIT_AMOUNT]
		,CAST([Damaged].[ISBN] AS VARCHAR(255))+' '+CAST([Damaged].[Accession] AS VARCHAR(255))+' '+[Damaged].[Title] AS [NOTE]
		,'N' AS [REFUND_NEEDED]
		,1 AS [FEE_STATUS]
		,GETDATE() AS [ADD_DATE_TIME_STAMP]
	FROM
		OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SynTempSSIS.aps.edu.actd\Files\TempQuery\;HDR=YES;', 
		'SELECT * from APSDamagedBooks.csv'
		) AS [Damaged]

		INNER JOIN
		[rev].[EPC_STU] as [stu]
		ON
		[Damaged].[StudentID]=[stu].[SIS_NUMBER]

		INNER JOIN
		(
			SELECT 
				*
				,ROW_NUMBER() OVER (PARTITION BY [STUDENT_GU] ORDER BY [ENTER_DATE] DESC) AS [RN]
			FROM
				[rev].[EPC_STU_SCH_YR] AS [ssy]

			WHERE
				[EXCLUDE_ADA_ADM] IS NULL
		) AS [ssy]
		ON
			[stu].[STUDENT_GU]=[ssy].[STUDENT_GU]
			AND [ssy].[RN]=1

		LEFT JOIN
		[rev].[EPC_STU_FEE] AS [fee]
		ON
		CAST([fee].[NOTE] AS VARCHAR(4000))=CAST([Damaged].[ISBN] AS VARCHAR(255))+' '+CAST([Damaged].[Accession] AS VARCHAR(255))+' '+[Damaged].[Title]

WHERE
	[Damaged].[CampusID] IN ('540','550','560','576','580')
	AND [fee].[STUDENT_FEE_GU] IS NULL

/* lost text books */
INSERT INTO
	[rev].[EPC_STU_FEE] 

	([STUDENT_FEE_GU],[STUDENT_SCHOOL_YEAR_GU],[STUDENT_GU],[TRANSACTION_DATE],[DESCRIPTION],[FEE_CATEGORY],[FEE_CODE_GU],[CREDIT_AMOUNT]
	,[NOTE],[REFUND_NEEDED],[FEE_STATUS],[ADD_DATE_TIME_STAMP])

	SELECT
		NEWID() AS [STUDENT_FEE_GU]
		,[ssy].[STUDENT_SCHOOL_YEAR_GU] AS [STUDENT_SCHOOL_YEAR_GU]
		,[stu].[STUDENT_GU] AS [STUDENT_GU]
		,GETDATE() AS [TRANSACTION_DATE]
		,'Lost Textbook' AS [DESCRIPTION]
		,'ACT' AS [FEE_CATEGORY]
		,CASE --these might be different in live.
			WHEN [Lost].[CampusID]='540' THEN (SELECT [FEE_CODE_GU] FROM @FeeCodes WHERE [FEE_CODE]='540551')
			WHEN [Lost].[CampusID]='550' THEN (SELECT [FEE_CODE_GU] FROM @FeeCodes WHERE [FEE_CODE]='550501')
			WHEN [Lost].[CampusID]='560' THEN (SELECT [FEE_CODE_GU] FROM @FeeCodes WHERE [FEE_CODE]='560203')
			WHEN [Lost].[CampusID]='576' THEN (SELECT [FEE_CODE_GU] FROM @FeeCodes WHERE [FEE_CODE]='576204')
			WHEN [Lost].[CampusID]='580' THEN (SELECT [FEE_CODE_GU] FROM @FeeCodes WHERE [FEE_CODE]='580110')
		 END AS [FEE_CODE_GU]
		,[Lost].[Price] AS [CREDIT_AMOUNT]
		,CAST([Lost].[ISBN] AS VARCHAR(255))+' '+CAST([Lost].[Accession] AS VARCHAR(255))+' '+[Lost].[Title] AS [NOTE]
		,'N' AS [REFUND_NEEDED]
		,1 AS [FEE_STATUS]
		,GETDATE() AS [ADD_DATE_TIME_STAMP]
	FROM
		OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SynTempSSIS.aps.edu.actd\Files\TempQuery\;HDR=YES;', 
		'SELECT * from APSLostBooks.csv'
		) AS [Lost]

		INNER JOIN
		[rev].[EPC_STU] as [stu]
		ON
		[Lost].[StudentID]=[stu].[SIS_NUMBER]

		INNER JOIN
		(
			SELECT
				*
				,ROW_NUMBER() OVER (PARTITION BY [STUDENT_GU] ORDER BY [ENTER_DATE] DESC) AS [RN]
			FROM
				[rev].[EPC_STU_SCH_YR]
			WHERE
				[EXCLUDE_ADA_ADM] IS NULL
		) AS [ssy]
		ON
			[stu].[STUDENT_GU]=[ssy].[STUDENT_GU]
			AND [ssy].[RN]=1

		LEFT JOIN
		[rev].[EPC_STU_FEE] AS [fee]
		ON
		CAST([fee].[NOTE] AS VARCHAR(4000))=CAST([Lost].[ISBN] AS VARCHAR(255))+' '+CAST([Lost].[Accession] AS VARCHAR(255))+' '+[Lost].[Title]

WHERE
	[Lost].[CampusID] IN ('540','550','560','576','580')
	AND [fee].[STUDENT_FEE_GU] IS NULL

ROLLBACK

REVERT
GO
