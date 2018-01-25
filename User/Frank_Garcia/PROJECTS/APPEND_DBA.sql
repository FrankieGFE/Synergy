
/*BEGIN TRANSACTION
USE db_DBA
GO
INSERT INTO tbl_DBA_Results (fld_Student_Name, fld_Student_ID, fld_Total_Score, fld_Total_Score_Percentage, fld_Proficiency_Level, fld_Proficiency_Level_Text, fld_School_Year, fld_Test_Window, fld_Test_Name)
*/

SELECT
	fld_Student_Name
	,fld_Student_ID
	,fld_Total_Score
	,fld_Total_Score_Percentage
	,fld_Proficiency_Level
	,fld_Proficiency_Level_Text
	,fld_School_Year
	,fld_Test_Window
	,fld_Test_Name
FROM
	[tbl_DBA_Student_Results]
	
---COMMIT
