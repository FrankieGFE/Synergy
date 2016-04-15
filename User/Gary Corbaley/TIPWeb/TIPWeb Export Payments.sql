
EXECUTE AS LOGIN='QueryFileUser'
GO

DECLARE @SynFees AS TABLE([PayeeID] VARCHAR(255), [StudentID] INT, [SynergyFeeID] UNIQUEIDENTIFIER, [Amount] DECIMAL(10,2), [StudentName] TEXT, [FeeDate] DATE, [CreditCardType] VARCHAR(20), [CreditCardLastFour] VARCHAR(4),[TransID] UNIQUEIDENTIFIER);

INSERT INTO
	@SynFees

	SELECT
		[SynergyFees].*
		,NEWID() AS [TransID]
	FROM
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\syntempssis.aps.edu.actd\Files\TempQuery\SchoolPay;', 
			'SELECT * from synergy_fees.csv'
		) AS [SynergyFees]
		
SELECT * FROM @SynFees

SELECT
	[ENROLMENT].[SCHOOL_CODE] AS [CampusID]
	,[STUDENT].[SIS_NUMBER] AS [StudentID]
	,LEFT(CONVERT(VARCHAR(256),[FEE].[NOTE]),CHARINDEX(' ',[FEE].[NOTE])) AS [ISBN]
	,RIGHT(LEFT(CONVERT(VARCHAR(256),[FEE].[NOTE]),CHARINDEX(' ',[FEE].[NOTE],CHARINDEX(' ',[FEE].[NOTE])+1)),CHARINDEX(' ',[FEE].[NOTE],CHARINDEX(' ',[FEE].[NOTE])+1) - CHARINDEX(' ',[FEE].[NOTE])) AS [Accession]
	,CASE WHEN [PAYMENT].[AMOUNT] = [FEE].[CREDIT_AMOUNT] OR [FEE].[FEE_STATUS] = 1 THEN 'Paid' ELSE 'Partial' END AS [Status]
	,CONVERT(VARCHAR(10),[PAYMENT].[PAYMENT_DATE],101) AS [TransactionDate]
	,[PAYTRANS].[TRANSACTION_ID] AS [TransReceiptID]
	,[PAYMENT].[AMOUNT] AS [PaymentAmount]
	,'' AS [Notes]
	
FROM
	[SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].[rev].[EPC_STU_FEE] AS [FEE]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[FEE].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	INNER JOIN
	@SynFees AS [SYNFEES]
	ON
	[FEE].[STUDENT_FEE_GU] = [SYNFEES].[SynergyFeeID]
	AND [STUDENT].[SIS_NUMBER] = [SYNFEES].[StudentID]
	
	INNER JOIN
	[SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].[rev].[EPC_STU_FEE_PAYMENT] AS [PAYMENT]
	ON
	[FEE].[STUDENT_FEE_GU] = [PAYMENT].[STU_FEE_GU]
	--AND [SYNFEES].[FeeDate] = [PAYMENT].[PAYMENT_DATE]
	AND [SYNFEES].[Amount] = [PAYMENT].[AMOUNT]
	
	LEFT OUTER JOIN
	[SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].[rev].[EPC_STU_FEE_PAY_TRANS] AS [PAYTRANS]
	ON
	[PAYMENT].[STU_FEE_PAY_TRANS_GU] = [PAYTRANS].[STU_FEE_PAY_TRANS_GU]
	
	INNER JOIN
	[SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].[rev].[EPC_SCH_YR_FEE] AS [FEE_CODE]
	ON
	[FEE].[FEE_CODE_GU] = [FEE_CODE].[FEE_CODE_GU]
	
	LEFT OUTER JOIN
	APS.StudentEnrollmentDetails AS [ENROLMENT]
	ON
	[FEE].[STUDENT_SCHOOL_YEAR_GU] = [ENROLMENT].[STUDENT_SCHOOL_YEAR_GU]
	
WHERE
	[FEE_CODE].[FEE_DESCRIPTION] IN ('Textbook Lost','Textbooks Lost')

------------------------------------------------------------------------------------------------	

SELECT
	[ENROLMENT].[SCHOOL_CODE] AS [CampusID]
	,[STUDENT].[SIS_NUMBER] AS [StudentID]
	,LEFT(CONVERT(VARCHAR(256),[FEE].[NOTE]),CHARINDEX(' ',[FEE].[NOTE])) AS [ISBN]
	,RIGHT(LEFT(CONVERT(VARCHAR(256),[FEE].[NOTE]),CHARINDEX(' ',[FEE].[NOTE],CHARINDEX(' ',[FEE].[NOTE])+1)),CHARINDEX(' ',[FEE].[NOTE],CHARINDEX(' ',[FEE].[NOTE])+1) - CHARINDEX(' ',[FEE].[NOTE])) AS [Accession]
	,CASE WHEN [PAYMENT].[AMOUNT] = [FEE].[CREDIT_AMOUNT] OR [FEE].[FEE_STATUS] = 1 THEN 'Paid' ELSE 'Partial' END AS [Status]
	,CONVERT(VARCHAR(10),[PAYMENT].[PAYMENT_DATE],101) AS [TransactionDate]
	,[PAYTRANS].[TRANSACTION_ID] AS [TransReceiptID]
	,[PAYMENT].[AMOUNT] AS [PaymentAmount]
	,'' AS [Notes]
	
FROM
	[SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].[rev].[EPC_STU_FEE] AS [FEE]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[FEE].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	INNER JOIN
	@SynFees AS [SYNFEES]
	ON
	[FEE].[STUDENT_FEE_GU] = [SYNFEES].[SynergyFeeID]
	AND [STUDENT].[SIS_NUMBER] = [SYNFEES].[StudentID]
	
	INNER JOIN
	[SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].[rev].[EPC_STU_FEE_PAYMENT] AS [PAYMENT]
	ON
	[FEE].[STUDENT_FEE_GU] = [PAYMENT].[STU_FEE_GU]
	--AND [SYNFEES].[FeeDate] = [PAYMENT].[PAYMENT_DATE]
	AND [SYNFEES].[Amount] = [PAYMENT].[AMOUNT]
	
	LEFT OUTER JOIN
	[SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].[rev].[EPC_STU_FEE_PAY_TRANS] AS [PAYTRANS]
	ON
	[PAYMENT].[STU_FEE_PAY_TRANS_GU] = [PAYTRANS].[STU_FEE_PAY_TRANS_GU]
	
	INNER JOIN
	[SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].[rev].[EPC_SCH_YR_FEE] AS [FEE_CODE]
	ON
	[FEE].[FEE_CODE_GU] = [FEE_CODE].[FEE_CODE_GU]
	
	LEFT OUTER JOIN
	APS.StudentEnrollmentDetails AS [ENROLMENT]
	ON
	[FEE].[STUDENT_SCHOOL_YEAR_GU] = [ENROLMENT].[STUDENT_SCHOOL_YEAR_GU]
	
WHERE
	[FEE_CODE].[FEE_DESCRIPTION] IN ('Textbook Damaged','Textbooks Damaged')
	
REVERT
GO