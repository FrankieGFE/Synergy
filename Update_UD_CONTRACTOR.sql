USE
ST_Production
GO

EXECUTE AS LOGIN='QueryFileUser'
GO
--BEGIN TRAN



--SELECT 
--	   [UDCONTRACTOR_GU]
--      ,[ADD_DATE_TIME_STAMP]
--      ,[ADD_ID_STAMP]
--      ,[CHANGE_DATE_TIME_STAMP]
--      ,[CHANGE_ID_STAMP]
--      ,[EFFECTIVE_FROM]
--      ,[EFFECTIVE_TO]
--      ,[GENDER]
--      ,[IN_SYNERGY]
--      ,UDC.[LOGIN]
--      ,[NAME]
--      ,UDC.[REASON]
--      ,[STAFF_TYPE]
--      ,[SCROLL_COMPOSITE_KEY]
--      ,[SOUNDEX_KEY]
--      ,[BADGE_NUM]

  UPDATE
	[ST_Production].[rev].[UD_CONTRACTOR]
	SET EFFECTIVE_TO = '2017-06-30 00:00:00'
  FROM [ST_Production].[rev].[UD_CONTRACTOR] UDC

  		INNER JOIN
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
			'SELECT * FROM Contractor_Update_07142016.csv'  
		)AS [FILE]
		ON [FILE].LOGIN = UDC.LOGIN
--ROLLBACK

REVERT
GO