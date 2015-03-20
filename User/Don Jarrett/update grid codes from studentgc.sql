EXECUTE AS LOGIN='QueryFileUser'
GO

BEGIN TRAN

UPDATE
    [Student]

    SET
    [Student].[GRID_CODE]=CASE WHEN [GC].[CMP_GridCode]='UNABLE TO LOCATE ADDRESS-CONTACT PARENT TO CORRECT OR VERIFY ADDRESS' THEN '99999' 
	WHEN ISNUMERIC([GC].[CMP_GridCode])=1 THEN [CMP_GridCode]
	ELSE 'OUT OF DST' 
     END
FROM
	OPENROWSET('Microsoft.ACE.OLEDB.12.0', 
			 'Excel 12.0;Database=\\syntempssis.aps.edu.actd\Files\TempQuery\studentgc.xlsx;', 
			 'SELECT * from [99999 Fixes to send to Andy$]') AS [GC]

    INNER JOIN
    [rev].[EPC_STU] AS [Student]
    ON
    [GC].[Student ID Number]=[Student].[SIS_NUMBER]


SELECT
    [Student].[SIS_NUMBER]
    ,[GC].[CMP_GridCode]
    ,[Student].[GRID_CODE]
FROM
	OPENROWSET('Microsoft.ACE.OLEDB.12.0', 
			 'Excel 12.0;Database=\\syntempssis.aps.edu.actd\Files\TempQuery\studentgc.xlsx;', 
			 'SELECT * from [99999 Fixes to send to Andy$]') AS [GC]

    INNER JOIN
    [rev].[EPC_STU] AS [Student]
    ON
    [GC].[Student ID Number]=[Student].[SIS_NUMBER]

ROLLBACK

REVERT
GO