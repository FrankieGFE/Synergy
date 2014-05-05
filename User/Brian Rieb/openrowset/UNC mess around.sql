-- \\syntempssis\Files\Import\Food Services\FRM\WINSNAPI.TXT
/*
SELECT 
	*
FROM
	OPENROWSET ('MSDASQL',
				 'Driver={Microsoft Access Text Driver (*.txt, *.csv)};DBQ=\\syntempssis\Files\Import\Food Services\FRM\;', 
				 'SELECT * FROM "WINSNAPI.TXT"'
				) AS COUNSELOR
*/				

SELECT * 
FROM OPENROWSET (
  'Microsoft.ACE.OLEDB.12.0', 
    'Text;Database=\\syntempssis\Files\Import\Food Services\FRM; ', 
    'SELECT * from WINSNAPI.TXT'
    )

/*
SELECT * 
FROM OPENROWSET (
  'Microsoft.ACE.OLEDB.12.0', 
    'Text;Database=D:\BrianTest; ', 
    'SELECT * from foo.txt'
    )
*/