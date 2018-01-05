BEGIN TRAN

UPDATE
	[db_DRA].[dbo].[Assessment_Windows]
	SET ---fld_Start_Date = '2016-04-25 00:00:00'
	fld_End_Date = '2016-03-11 00:00:00'
	--where fld_End_Date = '201-02-27 00:00:00'
	WHERE fld_Assessment_Window = 'Winter'
	--AND fld_Test_Loc != '315'

ROLLBACK