EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT 
	*
	
	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery\SchoolPay;',
                  'SELECT * from synergy_fees.csv'
                ) AS [T1]
	
REVERT
GO