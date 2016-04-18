

EXECUTE AS LOGIN='QueryFileUser'
GO

SELECT * FROM
(
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
) AS T2

INNER JOIN 
(SELECT 
	*
	,ROW_NUMBER() OVER (PARTITION BY [First], [Last] ORDER BY DOB DESC) AS RN
	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from Approvals.csv'
                ) AS [T3]
) AS T4

ON
T2.[First]= T4.[First]
AND T2.[Last] = T4.[Last]


WHERE
	T2.[APP School] != T4.[APP School]

REVERT 
GO