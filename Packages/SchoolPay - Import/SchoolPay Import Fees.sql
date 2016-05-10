

-- THIS IS NOT NEEDED IN THE PACKAGE

--EXECUTE AS LOGIN='QueryFileUser'
--GO


BEGIN TRAN

DECLARE @SynFees AS TABLE([PayeeID] VARCHAR(255), [StudentID] INT, [SynergyFeeID] UNIQUEIDENTIFIER, [Amount] DECIMAL(10,2), [StudentName] TEXT, [FeeDate] DATE, [CreditCardType] VARCHAR(20), [CreditCardLastFour] VARCHAR(4),[TransID] UNIQUEIDENTIFIER);

INSERT INTO
	@SynFees

	SELECT
		[SynergyFees].*
		,NEWID() AS [TransID]
	FROM
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\syntempssis.aps.edu.actd\Files\TempQuery\SchoolPay;HDR=NO;', 
			'SELECT * from synergy_fees.csv'
		) AS [SynergyFees]

INSERT INTO
	[rev].[EPC_STU_FEE_PAY_TRANS]

	SELECT
		[SynergyFees].[TransID] AS [STU_FEE_PAY_TRANS_GU]
		,LEFT([SynergyFees].[PayeeID],20) AS [TRANSACTION_ID]
		,[SynergyFees].FeeDate AS [PAYMENT_DATE]
		,3 AS [PAYMENT_METHOD]
		,[SynergyFees].[CreditCardLastFour] AS [PAYMENT_NOTE]
		,CAST([SynergyFees].[Amount] AS DECIMAL(8,2)) AS [AMOUNT]
		,LEFT([SynergyFees].[CreditCardType],5) AS [PAYMENT_PROVIDER]
		,'SUC' AS [PAYMENT_STATUS]
		,NULL AS [ERROR_MESSAGE]
		,'MPN-'+[SynergyFees].[PayeeID] AS [PROVIDER_TRANSACTION_ID]
		,NULL AS [IMPORT_TRANS_ID]
		,CAST(GETDATE() AS TIME) AS [PAYMENT_TIME]
		,NULL AS [CHECK_NUMBER]
	FROM
		@SynFees as [SynergyFees]

	LEFT JOIN
	(
	SELECT
		[Fees].[STUDENT_FEE_GU]
		,[Fees].[DESCRIPTION]
		,ISNULL([Categories].[VALUE_DESCRIPTION],[Fees].[FEE_CATEGORY]) AS [FEE_CATEGORY]
		,[Fees].[FEE_STATUS]
		,[Student].[SIS_NUMBER]
		,[Person].[LAST_NAME]
		,[Person].[FIRST_NAME]
		,[Fees].[CREDIT_AMOUNT]
		,[Fees].[CREDIT_AMOUNT]-ISNULL(SUM([Payment].[AMOUNT]),0.00) AS [BALANCE]
		,[FeeTypes].[FEE_CODE]
		,ISNULL(CAST([Fees].[NOTE] AS NVARCHAR(4000)),'') AS [NOTE]
	FROM
		[rev].[EPC_STU_FEE] AS [Fees]

		LEFT JOIN
		[rev].[EPC_STU_FEE_PAYMENT] AS [Payment]
		ON
		[Fees].[STUDENT_FEE_GU]=[Payment].[STU_FEE_GU]

		INNER JOIN
		[rev].[REV_PERSON] AS [Person]
		ON
		[Fees].[STUDENT_GU]=[Person].[PERSON_GU]

		INNER JOIN
		[rev].[EPC_STU] AS [Student]
		ON
		[Fees].[STUDENT_GU]=[Student].[STUDENT_GU]

		INNER JOIN
		[rev].[EPC_STU_SCH_YR] AS [SSY]
		ON
		[Fees].[STUDENT_SCHOOL_YEAR_GU]=[SSY].[STUDENT_SCHOOL_YEAR_GU]

		INNER JOIN
		[rev].[EPC_SCH_YR_FEE] AS [FeeTypes]
		ON
		[Fees].[FEE_CODE_GU]=[FeeTypes].[FEE_CODE_GU]

		LEFT JOIN
		[APS].[LookupTable]('K12.FeeInfo','FEE_CATEGORY') AS [Categories]
		ON
		[Fees].[FEE_CATEGORY]=[Categories].[VALUE_CODE]

	WHERE
		[Fees].[FEE_STATUS] NOT IN (1,3)
				
	GROUP BY
		[Fees].[STUDENT_FEE_GU]
		,[Fees].[DESCRIPTION]
		,ISNULL([Categories].[VALUE_DESCRIPTION],[Fees].[FEE_CATEGORY])
		,[Fees].[FEE_STATUS]
		,[Student].[SIS_NUMBER]
		,[Person].[LAST_NAME]
		,[Person].[FIRST_NAME]
		,[Fees].[CREDIT_AMOUNT]
		,[FeeTypes].[FEE_CODE]
		,CAST([Fees].[NOTE] AS NVARCHAR(4000))

	) AS [Fee]
	ON
	[SynergyFees].[SynergyFeeID]=[Fee].[STUDENT_FEE_GU]
	AND [Fee].[BALANCE]>0

WHERE
	[Fee].[STUDENT_FEE_GU] IS NOT NULL


INSERT INTO
	[rev].[EPC_STU_FEE_PAYMENT]

	SELECT
		NEWID() AS [STU_FEE_PAYMENT_GU]
		,[SynergyFees].[SynergyFeeID] AS [STU_FEE_GU]
		,[SynergyFees].FeeDate AS [PAYMENT_DATE]
		,[SynergyFees].[Amount] AS [AMOUNT]
		,3 AS [PAYMENT_METHOD]
		,[SynergyFees].[CreditCardLastFour] AS [PAYMENT_NOTE]
		,[SynergyFees].[TransID] AS [STU_FEE_PAY_TRANS_GU]
		,CAST(GETDATE() AS TIME) AS [PAYMENT_TIME]
		,NULL AS [FEE_DEPOSIT_GU]
	FROM
		@SynFees AS [SynergyFees]

	LEFT JOIN
	(
	SELECT
		[Fees].[STUDENT_FEE_GU]
		,[Fees].[DESCRIPTION]
		,ISNULL([Categories].[VALUE_DESCRIPTION],[Fees].[FEE_CATEGORY]) AS [FEE_CATEGORY]
		,[Fees].[FEE_STATUS]
		,[Student].[SIS_NUMBER]
		,[Person].[LAST_NAME]
		,[Person].[FIRST_NAME]
		,[Fees].[CREDIT_AMOUNT]
		,[Fees].[CREDIT_AMOUNT]-ISNULL(SUM([Payment].[AMOUNT]),0.00) AS [BALANCE]
		,[FeeTypes].[FEE_CODE]
		,ISNULL(CAST([Fees].[NOTE] AS NVARCHAR(4000)),'') AS [NOTE]
	FROM
		[rev].[EPC_STU_FEE] AS [Fees]

		LEFT JOIN
		[rev].[EPC_STU_FEE_PAYMENT] AS [Payment]
		ON
		[Fees].[STUDENT_FEE_GU]=[Payment].[STU_FEE_GU]

		INNER JOIN
		[rev].[REV_PERSON] AS [Person]
		ON
		[Fees].[STUDENT_GU]=[Person].[PERSON_GU]

		INNER JOIN
		[rev].[EPC_STU] AS [Student]
		ON
		[Fees].[STUDENT_GU]=[Student].[STUDENT_GU]

		INNER JOIN
		[rev].[EPC_STU_SCH_YR] AS [SSY]
		ON
		[Fees].[STUDENT_SCHOOL_YEAR_GU]=[SSY].[STUDENT_SCHOOL_YEAR_GU]

		INNER JOIN
		[rev].[EPC_SCH_YR_FEE] AS [FeeTypes]
		ON
		[Fees].[FEE_CODE_GU]=[FeeTypes].[FEE_CODE_GU]

		LEFT JOIN
		[APS].[LookupTable]('K12.FeeInfo','FEE_CATEGORY') AS [Categories]
		ON
		[Fees].[FEE_CATEGORY]=[Categories].[VALUE_CODE]

	WHERE
		[Fees].[FEE_STATUS] NOT IN (1,3)
				
	GROUP BY
		[Fees].[STUDENT_FEE_GU]
		,[Fees].[DESCRIPTION]
		,ISNULL([Categories].[VALUE_DESCRIPTION],[Fees].[FEE_CATEGORY])
		,[Fees].[FEE_STATUS]
		,[Student].[SIS_NUMBER]
		,[Person].[LAST_NAME]
		,[Person].[FIRST_NAME]
		,[Fees].[CREDIT_AMOUNT]
		,[FeeTypes].[FEE_CODE]
		,CAST([Fees].[NOTE] AS NVARCHAR(4000))

	) AS [Fee]
	ON
	[SynergyFees].[SynergyFeeID]=[Fee].[STUDENT_FEE_GU]
	AND [Fee].[BALANCE]>0

WHERE
	[Fee].[STUDENT_FEE_GU] IS NOT NULL

UPDATE
	[StuFees]

	SET
	[StuFees].[FEE_STATUS]=CASE WHEN [Fee].[BALANCE]=0.00 THEN 1
	                            WHEN [Fee].[BALANCE]<0.00 THEN 3
		                        ELSE [StuFees].[FEE_STATUS] END

FROM
	[rev].[EPC_STU_FEE] AS [StuFees]

	INNER JOIN
	@SynFees AS [SynergyFees]

	ON
	[StuFees].[STUDENT_FEE_GU]=[SynergyFees].[SynergyFeeID]

	LEFT JOIN
	(
	SELECT
		[Fees].[STUDENT_FEE_GU]
		,[Fees].[DESCRIPTION]
		,ISNULL([Categories].[VALUE_DESCRIPTION],[Fees].[FEE_CATEGORY]) AS [FEE_CATEGORY]
		,[Fees].[FEE_STATUS]
		,[Student].[SIS_NUMBER]
		,[Person].[LAST_NAME]
		,[Person].[FIRST_NAME]
		,[Fees].[CREDIT_AMOUNT]
		,[Fees].[CREDIT_AMOUNT]-ISNULL(SUM([Payment].[AMOUNT]),0.00) AS [BALANCE]
		,[FeeTypes].[FEE_CODE]
		,ISNULL(CAST([Fees].[NOTE] AS NVARCHAR(4000)),'') AS [NOTE]
	FROM
		[rev].[EPC_STU_FEE] AS [Fees]

		LEFT JOIN
		[rev].[EPC_STU_FEE_PAYMENT] AS [Payment]
		ON
		[Fees].[STUDENT_FEE_GU]=[Payment].[STU_FEE_GU]

		INNER JOIN
		[rev].[REV_PERSON] AS [Person]
		ON
		[Fees].[STUDENT_GU]=[Person].[PERSON_GU]

		INNER JOIN
		[rev].[EPC_STU] AS [Student]
		ON
		[Fees].[STUDENT_GU]=[Student].[STUDENT_GU]

		INNER JOIN
		[rev].[EPC_STU_SCH_YR] AS [SSY]
		ON
		[Fees].[STUDENT_SCHOOL_YEAR_GU]=[SSY].[STUDENT_SCHOOL_YEAR_GU]

		INNER JOIN
		[rev].[EPC_SCH_YR_FEE] AS [FeeTypes]
		ON
		[Fees].[FEE_CODE_GU]=[FeeTypes].[FEE_CODE_GU]

		LEFT JOIN
		[APS].[LookupTable]('K12.FeeInfo','FEE_CATEGORY') AS [Categories]
		ON
		[Fees].[FEE_CATEGORY]=[Categories].[VALUE_CODE]

	WHERE
		[Fees].[FEE_STATUS] NOT IN (1,3)
				
	GROUP BY
		[Fees].[STUDENT_FEE_GU]
		,[Fees].[DESCRIPTION]
		,ISNULL([Categories].[VALUE_DESCRIPTION],[Fees].[FEE_CATEGORY])
		,[Fees].[FEE_STATUS]
		,[Student].[SIS_NUMBER]
		,[Person].[LAST_NAME]
		,[Person].[FIRST_NAME]
		,[Fees].[CREDIT_AMOUNT]
		,[FeeTypes].[FEE_CODE]
		,CAST([Fees].[NOTE] AS NVARCHAR(4000))

	) AS [Fee]
	ON
	[StuFees].[STUDENT_FEE_GU]=[Fee].[STUDENT_FEE_GU]

WHERE
	[Fee].[STUDENT_FEE_GU] IS NOT NULL


-- THE PACKAGE RUNS THIS WITH COMMIT
--COMMIT

--ROLLBACK
--REVERT
--GO