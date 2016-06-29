
EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT 
	*
	,'2011-2012' AS SCH_YR
	FROM
            
			
			OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT ID_NBR, COURSE  from 2011.csv'
                ) AS [T1]

			UNION ALL 
SELECT 
	*
	,'2012-2013' AS SCH_YR
	FROM
            
			
			OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT ID_NBR, COURSE  from 2012.csv'
                ) AS [T1]

			UNION ALL 
SELECT 
	*
	,'2013-2014' AS SCH_YR
	FROM
            
			
			OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT ID_NBR, COURSE  from 2013.csv'
                ) AS [T1]


			UNION ALL 
SELECT 
	*
	,'2014-2015' AS SCH_YR	
	FROM
            
			
			OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT SIS_NUMBER, COURSE_ID  from 2014.csv'
                ) AS [T1]
	
REVERT
GO