
EXECUTE AS LOGIN='QueryFileUser'
GO


--INSERT INTO [LCE_NO_HLS]

SELECT * 
FROM

            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                  'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
                  'SELECT * from CLUSTER_NOHLS.csv'
                ) AS CLUSTER


REVERT
GO


/*
USE ST_Production
GO

CREATE TABLE [LCE_NO_HLS]
	
	(
		CLUSTER VARCHAR (100)
	,	SCHOOL VARCHAR (100)
	,	[LASTYEAR NOHLS] INT
	,	[PQ] INT
	,	[YA] INT	
	,	[LAST YEAR NOTEST] INT
	,	[PQ2] INT
	,	[YA2] INT
	
)
*/	