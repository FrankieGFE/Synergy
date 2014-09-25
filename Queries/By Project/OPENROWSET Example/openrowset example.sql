/* Brian Rieb
 * 9/25/2014
 *
 * Example of using openrowset to read from a file.
 */

-- Add the next to lines to simulate running as a non-ad account
EXECUTE AS LOGIN='QueryFileUser'
GO

SELECT 
	* 
FROM 
	-- This openrowset uses the ACE OLEDB
	-- to use it, sepcify the UNC share in the database parameter (2nd line)
	-- AND the file name in the "select" portion
	-- PLACE YOUR FILE IN \\SynTempSSIS\Files\TempQuery\
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
		'SELECT * from IDsForQuery.txt'
	    )

-- Always conclude your statement with these last two lines so it reverts back
-- to your user
REVERT
GO
