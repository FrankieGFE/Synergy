EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT * FROM (

SELECT 
	*
	,ROW_NUMBER() OVER (PARTITION BY [First], [Last] ORDER BY DOB DESC) AS RN
	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from Approvals.csv'
                ) AS [T3]
) AS T1
WHERE
RN> 1

REVERT 
GO