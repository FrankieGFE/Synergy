USE db_DRA
GO

UPDATE [db_DRA].[dbo].[Assessment_Windows]
      --SET [fld_Start_Date] = '2014-08-13'
      SET [fld_End_Date] = '2015-06-01'
WHERE
	FLD_ASSESSMENT_WINDOW = 'SPRING'
	--AND FLD_TEST_LOC NOT IN ('237','249','261','227','327','364','250','280','46','47')