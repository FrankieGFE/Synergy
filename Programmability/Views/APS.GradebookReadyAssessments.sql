
/*************************************************************************************************

Created By Debbie Ann Chavez
Date 1/12/2017

Pull Ready Assessments for Grades 1-8 from GradeBook for Rianne Herrera Special Ed Department
Needs to be an SSRS report so they can run it monthly.

**************************************************************************************************/


IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[APS].[GradebookReadyAssessments]'))
	EXEC ('CREATE VIEW APS.GradebookReadyAssessments AS SELECT 0 AS DUMMY')
GO

ALTER VIEW [APS].[GradebookReadyAssessments] AS


SELECT 
SCHOOLNAME AS School
, STU2.SIS_NUMBER AS SIS_Number
, stu.LASTNAME AS Stu_Last_Name
, stu.FIRSTNAME AS Stu_First_Name
,  MEASURE AS Measure
, GBR.SCORE AS Score
, tch.LASTNAME AS Tch_Last_Name
, tch.FIRSTNAME AS Tch_First_Nasme
, tch.STUDENTID AS TeacherID


FROM rev.EGB_GRADEBOOK gb  --assignments
join rev.EGB_GBRESULT gbr on gbr.GRADEBOOKID = gb.ID  --student results
join rev.EGB_PEOPLE stu on stu.id = gbr.studentid
join rev.EGB_CLASS c on c.id = gb.CLASSID
join rev.EGB_SCHOOL s on s.id = c.SCHOOLID
join rev.EGB_GBSCORETYPES sct on sct.id = gb.SCORETYPEID
join rev.EGB_MEASURETYPE mt on mt.id = gb.MEASURETYPEID
join rev.EPC_STU AS STU2 ON STU2.STUDENT_GU = STU.GENESISID
join rev.EGB_PEOPLE tch ON TCH.ID = C.TEACHERID

WHERE 
(MEASURE LIKE '[G]%Pre' OR 
MEASURE LIKE '[G]%PT' OR
MEASURE LIKE '[G]%Post'
)
AND MEASURE <= 'G8 U5 PT'






