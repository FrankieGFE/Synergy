

EXECUTE AS LOGIN='QueryFileUser'
GO


DECLARE @SynFees2 AS TABLE

([PayeeID] VARCHAR(255), [StudentID] INT
, [SynergyFeeID] UNIQUEIDENTIFIER, [Amount] DECIMAL(10,2), [StudentName] TEXT
, [FeeDate] DATE, [CreditCardType] VARCHAR(20), [CreditCardLastFour] VARCHAR(4),[TransID] UNIQUEIDENTIFIER);


INSERT INTO
	@SynFees2

	SELECT
		[SynergyFees].*	
		,NEWID() AS [TransID]
		FROM
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\syntempssis.aps.edu.actd\Files\TempQuery\SchoolPay;HDR=NO;', 
			'SELECT * from synergy_fees.csv'
		) AS [SynergyFees]


SELECT 
*
FROM 

@SynFees2 AS T1

LEFT JOIN 
	[rev].[EPC_STU_FEE_PAY_TRANS] AS PAYTRANS
	ON
	PAYTRANS.TRANSACTION_ID = T1.[PayeeID] 
	--AND PAYTRANS.AMOUNT = T1.Amount

WHERE
	PAYTRANS.TRANSACTION_ID IS NULL

REVERT
GO