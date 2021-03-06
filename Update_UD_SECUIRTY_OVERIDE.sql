USE 
ST_Production
GO

BEGIN TRAN

EXECUTE AS LOGIN='QueryFileUser'
GO

SELECT TOP 1000 [UDSECURITYOVERRIDE_GU]
      ,[ADD_DATE_TIME_STAMP]
      ,[ADD_ID_STAMP]
      ,[CHANGE_DATE_TIME_STAMP]
      ,[CHANGE_ID_STAMP]
      ,[EFFECTIVE_FROM]
      ,[EFFECTIVE_TO]
      ,[GROUP]
      ,[LOGIN]
      ,USO.[NOTE]
      ,[SCROLL_COMPOSITE_KEY]
      ,[SOUNDEX_KEY]
  --UPDATE ST_Production.rev.UD_SECURITY_OVERRIDE
  --SET EFFECTIVE_TO = '2017-06-30 00:00:00'
  FROM [ST_Production].[rev].[UD_SECURITY_OVERRIDE] AS USO

    	INNER JOIN
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
			'SELECT * FROM SecurityOverride_Update_07142016.csv'  
		)AS [FILE]
		ON [FILE].[User LOGIN] = USO.LOGIN
		--AND [FILE].NOTE = USO.NOTE
		AND [FILE].[SECURITY GROUP] = USO.[GROUP]


ROLLBACK
REVERT
GO