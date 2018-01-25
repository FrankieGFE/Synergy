/**
 * 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 2/21/2013 $
 *
 * Request By: Debbie Chavez
 * InitialRequestDate: 2/13/2013
 * 
 * Initial Request:
 * All AIP eligible students for 2012-2013 school year
 *
 * Tables Referenced: 
 *
 * Notes: AIP eligibility is a first grade through 8th grade program. Students, grades 1-8, that score Beginning Steps on the 
 * spring DBA (or DRA in 1st, 2nd, or 3rd grade) are AIP eligible for the following school year. First grade student that score 
 * Begining Steps on the fall DBA (or DRA) are AIP eligible for the first grade.
 */


SELECT
	DISTINCT[STUDENT ID] AS ID_NBR
	,'2013' AS 'SCH_YR'
FROM
(	
SELECT	
	-- Students in grades 1-8 previous years' DBA at Beginning Steps
	Student.SY
	,Student.[DISTRICT CODE]
	,Student.[Period]
	,Student.[LOCATION CODE]
	,Student.[STUDENT ID]
	,Student.[CURRENT GRADE LEVEL]
	,Student.[SCHOOL YEAR DATE]
	,Grade.fld_Proficiency_Level_Text
	,Grade.fld_Test_Window
FROM
	-- DBA database does not contain student grade level or location. Using STARS History to get that info.
	db_STARS_History.dbo.STUDENT AS Student
	LEFT JOIN 
	db_DBA.dbo.tbl_DBA_Student_Results_2011_2012 AS Grade
	ON 
	Student.[ALTERNATE STUDENT ID] = Grade.fld_Student_ID

WHERE 
	Student.SY = '2012'
	AND Student.[DISTRICT CODE] = '001'
	AND Student.[Period] = '2012-06-01'
	AND Grade.fld_Test_Window = 'Form 3'
	AND Student.[CURRENT GRADE LEVEL]  BETWEEN '01' AND '08'
	AND Grade.fld_Proficiency_Level_Text = 'Beginning Steps'
)AS Spring_DBA_AIP	

	
UNION

SELECT
	DISTINCT fld_ID_NBR AS ID_NBR
	,'2013' AS 'SCH_YR'
FROM	
	
(
SELECT
	-- Current year(2012-2013) DRA fall Beginning Step 1st grade students are AIP eligible
	-- Based on Fall assessment
	DRA.fld_ID_NBR
	,DRA.fld_GRDE
	,DRA.fld_TestLoc
	,DRA.fld_Performance_Lvl
	,DRA.fld_AssessmentWindow
FROM
	db_DRA.dbo.Results AS DRA
WHERE
	DRA.fld_GRDE = '01' 
	AND DRA.fld_Performance_Lvl = 'BS'
	AND DRA.fld_TestLoc > '46'  
	AND DRA.fld_AssessmentWindow = 'Fall'	
) AS Fall_DRA_AIP	

UNION

SELECT
	DISTINCT fld_ID_NBR AS ID_NBR
	,'2013' AS 'SCH_YR'
FROM	
	
(
SELECT
	-- Previous year(2011-2012) DRA Spring Beginning Step 1st - 3rd grade students are AIP eligible
	-- Based on Spring assessment

	DRA.fld_ID_NBR
	,DRA.fld_GRDE
	,DRA.fld_TestLoc
	,DRA.fld_Performance_Lvl
	,DRA.fld_AssessmentWindow
FROM
	db_DRA.dbo.Results_1112 AS DRA
WHERE
	DRA.fld_GRDE BETWEEN '01' AND '03'
	AND DRA.fld_Performance_Lvl = 'BS'
	AND DRA.fld_TestLoc > '46'
	AND DRA.fld_AssessmentWindow = 'Spring' 	
) AS Spring_DRA_AIP		


