

EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT 
	T1.*
	, CASE WHEN 
			T3.[PARENT NAME] IS NOT NULL OR T5.[PARENT NAME] IS NOT NULL OR T7.[PARENT NAME] IS NOT NULL THEN 'AIMS' ELSE T1.[GRANT] END AS NEW_GRANT
		
	
	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from IMPACTAID.csv'
                ) AS [T1]
	
	LEFT JOIN 

	(


	SELECT 
	*
	
	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from IMPACTAIDSANDIABASE.csv'
                ) AS [T2]
	) AS T3
	ON

	T1.[PARENT NAME] = T3.[PARENT NAME]
	AND T1.[LAST NAME] = T3.[LAST NAME]
	AND T1.[FIRST NAME] = T3.[FIRST NAME]


	LEFT JOIN 

	(


	SELECT 
	*
	
	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from IMPACTAIDSANANTONITO.csv'
                ) AS [T4]
	) AS T5
	ON

	T1.[PARENT NAME] = T5.[PARENT NAME]
	AND T1.[LAST NAME] = T5.[LAST NAME]
	AND T1.[FIRST NAME] = T5.[FIRST NAME]


		LEFT JOIN 

	(


	SELECT 
	*
	
	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from IMPACTAIDROOSEVELT.csv'
                ) AS [T6]
	) AS T7
	ON

	T1.[PARENT NAME] = T7.[PARENT NAME]
	AND T1.[LAST NAME] = T7.[LAST NAME]
	AND T1.[FIRST NAME] = T7.[FIRST NAME]


	WHERE 
		T3.[PARENT NAME] IS NOT NULL OR
		T5.[PARENT NAME] IS NOT NULL OR
		T7.[PARENT NAME] IS NOT NULL


REVERT
GO