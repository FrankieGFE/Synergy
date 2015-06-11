

EXECUTE AS LOGIN='QueryFileUser'
GO


INSERT INTO [LCE_REQ_ESL]

SELECT * 
FROM

           OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                  'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
                  'SELECT * from 2A_ALS.csv'
                ) AS ALS


REVERT
GO


/*
USE ST_Production
GO

CREATE TABLE [LCE_REQ_ESL]
	
	(
		CLUSTER VARCHAR (100)
	,	SCHOOL VARCHAR (100)
	,	[CREQ] INT
	,	[CREC] INT
	,	[CURP] VARCHAR (10)	
	,	[PREQ] INT
	,	[PREC] INT
	,	[PRIORP] VARCHAR (10)	
	,	[YAREQ] INT
	,	[YAREC] INT
	,	[YAPER] VARCHAR (10)	
	
)
*/	