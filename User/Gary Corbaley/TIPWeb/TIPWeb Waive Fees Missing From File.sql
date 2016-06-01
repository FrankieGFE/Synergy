

EXECUTE AS LOGIN='QueryFileUser'
GO

BEGIN TRAN

DECLARE @FeeCodes TABLE ([FEE_CODE_GU] UNIQUEIDENTIFIER, [FEE_CODE] VARCHAR(256), [FEE_DESCRIPTION] VARCHAR(256), [START_DATE] DATETIME, [END_DATE] DATETIME )

INSERT INTO
	@FeeCodes

	SELECT
		[FEE_CODE_GU]
		,[FEE_CODE]
		,[FEE_DESCRIPTION]
		,[CalendarOptions].[START_DATE]
		,[CalendarOptions].[END_DATE]
	FROM
		[rev].[EPC_SCH_YR_FEE]
		
		INNER JOIN 
		rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
		ON 
		[EPC_SCH_YR_FEE].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
		
		INNER JOIN 
		rev.REV_YEAR AS [RevYear] -- Contains the School Year
		ON 
		[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
		
		INNER JOIN
		rev.EPC_SCH_ATT_CAL_OPT AS [CalendarOptions]
		ON
		[OrgYear].[ORGANIZATION_YEAR_GU] = [CalendarOptions].[ORG_YEAR_GU]		
		
	WHERE
		LEFT([FEE_CODE],3) IN ('525','540','550','560','570','576','580','998')
		
--------------------------------------------------------------------------------------------------------------------------------------
DECLARE @NOT_IN_FILE TABLE 
	(
	[STUDENT_FEE_GU] [uniqueidentifier] NOT NULL,
	[STUDENT_SCHOOL_YEAR_GU] [uniqueidentifier] NOT NULL,
	[STUDENT_GU] [uniqueidentifier] NOT NULL,
	[TRANSACTION_DATE] [smalldatetime] NOT NULL,
	[DESCRIPTION] [nvarchar](50) NULL,
	[FEE_CATEGORY] [nvarchar](5) NULL,
	[FEE_CODE_GU] [uniqueidentifier] NOT NULL,
	[CREDIT_AMOUNT] [numeric](9, 2) NULL,
	[DEBIT_AMOUNT] [numeric](9, 2) NULL,
	[NOTE] [ntext] NULL,
	[REFUND_NEEDED] [char](1) NOT NULL,
	[FEE_STATUS] [nvarchar](5) NOT NULL,
	[ADD_DATE_TIME_STAMP] [smalldatetime] NULL,
	[STU_FEE_PAYMENT_GU] [uniqueidentifier] NULL,
	[TransID] [uniqueidentifier] NULL
	)
	
	INSERT INTO @NOT_IN_FILE
	SELECT TOP 1
		[FEE].[STUDENT_FEE_GU]
		,[FEE].[STUDENT_SCHOOL_YEAR_GU]
		,[FEE].[STUDENT_GU]
		,[FEE].[TRANSACTION_DATE]
		,[FEE].[DESCRIPTION]
		,[FEE].[FEE_CATEGORY]
		,[FEE].[FEE_CODE_GU]
		,[FEE].[CREDIT_AMOUNT]
		,[FEE].[DEBIT_AMOUNT]
		,[FEE].[NOTE]
		,[FEE].[REFUND_NEEDED]
		,[FEE].[FEE_STATUS]
		,[FEE].[ADD_DATE_TIME_STAMP]
		-- CHECK IF STUDENT ALREADY HAS A PAYMENT OR WAIVER
		,CASE WHEN [PAYMENT].[STU_FEE_PAYMENT_GU] IS NULL THEN [WAIVER].[STU_FEE_WAIVER_GU] ELSE [PAYMENT].[STU_FEE_PAYMENT_GU] END AS [STU_FEE_PAYMENT_GU]
		,NEWID() AS [TransID]
	FROM
		[rev].[EPC_STU_FEE] AS [FEE]
		
		LEFT OUTER JOIN
		@FeeCodes AS [FEECODES_CURRENT]
		ON
		[FEE].[FEE_CODE_GU] = [FEECODES_CURRENT].[FEE_CODE_GU]
		
		LEFT OUTER JOIN
		rev.[EPC_STU_FEE_PAYMENT] AS [PAYMENT]
		ON
		[FEE].[STUDENT_FEE_GU] = [PAYMENT].[STU_FEE_GU]
		--AND [SYNFEES].[FeeDate] = [PAYMENT].[PAYMENT_DATE]
		--AND [SYNFEES].[Amount] = [PAYMENT].[AMOUNT]
		
		LEFT OUTER JOIN
		rev.[EPC_STU_FEE_WAIVER] AS [WAIVER]
		ON
		[FEE].[STUDENT_FEE_GU] = [WAIVER].[STUDENT_FEE_GU]
			
		LEFT JOIN
		(
		SELECT
			CASE WHEN CampusID = 999 THEN 998 ELSE CampusID END AS CampusID
			,StudentID,ISBN,Title,Accession,Status,Price,ModifiedDate,Notes
		FROM
			OPENROWSET (
				'Microsoft.ACE.OLEDB.12.0', 
				'Text;Database=\\SynTempSSIS.aps.edu.actd\Files\TempQuery\;HDR=YES;', 
				'SELECT * FROM APSLostBooks.csv'
				) AS [FILE]
		) AS [Lost]
		ON
		CAST([FEE].[NOTE] AS VARCHAR(4000))=CAST([Lost].[ISBN] AS VARCHAR(255))+' '+CAST([Lost].[Accession] AS VARCHAR(255))+' '+[Lost].[Title] + ' LST'
		
	WHERE
		[FEECODES_CURRENT].[FEE_DESCRIPTION] = 'Textbooks Lost'
		AND [Lost].[Accession] IS NULL
		--AND [FEE].[FEE_STATUS] = 0
		
SELECT
	*
FROM
	@NOT_IN_FILE
		
--------------------------------------------------------------------------------------------
INSERT INTO	rev.[EPC_STU_FEE_WAIVER_TRANS]
SELECT
	--[STUDENT].[SIS_NUMBER]
	--,[STUDENT].[FIRST_NAME]
	--,[STUDENT].[LAST_NAME]
	--,[FEECODES_CURRENT].[FEE_CODE]
	--,[FEE].[TRANSACTION_DATE]
	--,[FEE].[DESCRIPTION]
	--,[FEE].[NOTE]
	--,[FEE].[FEE_STATUS]
	--,[FEE].[CREDIT_AMOUNT]
	[FEE].[TransID] AS [STU_FEE_WAIVER_TRANS_GU]
	,9999 AS [TRANSACTION_ID]
	,GETDATE() AS [WAIVER_DATE]
	,GETDATE() AS [WAIVER_TIME]
	,[FEE].[CREDIT_AMOUNT] AS [WAIVER_AMOUNT]
	,0 AS [WAIVER_TYPE]
	,'RETN' AS [WAIVER_REASON]
	,'Item Returned' AS [WAIVER_NOTE]
	,NULL AS [WAIVER_TRANSACTION_TYPE]
FROM
	@NOT_IN_FILE [FEE]
	
WHERE
	[STU_FEE_PAYMENT_GU] IS NULL
	OR [FEE].[FEE_STATUS] = 0

INSERT INTO rev.[EPC_STU_FEE_WAIVER]
SELECT
	NEWID() AS [STU_FEE_WAIVER_GU]
	,[FEE].[STUDENT_FEE_GU]
	,[FEE].[TransID] AS [STU_FEE_WAIVER_TRANS_GU]
	,GETDATE() AS [WAIVER_DATE]
	,GETDATE() AS [WAIVER_TIME]
	,[FEE].[CREDIT_AMOUNT] AS [WAIVER_AMOUNT]
	,'RETN' AS [WAIVER_REASON]
	,0 AS [WAIVER_TYPE]
	,'Item Returned' AS [WAIVER_NOTE]
	,0 AS [WAIVER_TRANSACTION_TYPE]
FROM
	@NOT_IN_FILE [FEE]
	
WHERE
	[STU_FEE_PAYMENT_GU] IS NULL
	OR [FEE].[FEE_STATUS] = 0
	
UPDATE [FEE]
	SET [FEE_STATUS] = 1
FROM
	[rev].[EPC_STU_FEE] AS [FEE]
	
	INNER JOIN
	@NOT_IN_FILE AS [NIF_FEE]
	ON
	[FEE].[STUDENT_FEE_GU] = [NIF_FEE].[STUDENT_FEE_GU]
	
--/*	
SELECT
	*
FROM
	[rev].[EPC_STU_FEE] AS [FEE]
	
	LEFT OUTER JOIN
	rev.[EPC_STU_FEE_PAYMENT] AS [PAYMENT]
	ON
	[FEE].[STUDENT_FEE_GU] = [PAYMENT].[STU_FEE_GU]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[FEE].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
WHERE
	--[FEE].[DESCRIPTION] LIKE '%return%'
	--[STUDENT].[SIS_NUMBER] = '102860152'
	[STUDENT].[STUDENT_GU] = '883D0BF8-F7AB-4711-9741-1F0F2BE7ED9C'
--*/
	
--ROLLBACK
COMMIT
		
REVERT
GO