UPDATE
	summer_school
SET 
	sumemr_school.[Fall_2012_Math_DBA_Score] = db_DBA.dbo.tlbl_DBA_Student_Results.fld_Total_Score

FROM
	summer_school.dbo.SummerSchool AS SS
	LEFT JOIN
	[db_DBA].[dbo].tbl_DBA_Student_Results AS DBA
	ON
	SS.[ID Number] = [DBA].fld_Student_ID
WHERE
	DBA.fld_Test_Window = 'Fall'
	


