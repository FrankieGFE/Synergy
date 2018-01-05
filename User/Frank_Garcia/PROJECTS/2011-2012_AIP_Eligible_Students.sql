/**
 * 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 2/22/2013 $
 *
 * Request By: Debbie Chavez
 * InitialRequestDate: 2/13/2013
 * 
 * Initial Request:
 * All AIP eligible students for 2011-2012 school year
 *
 * Tables Referenced: 
 *
 * Notes: AIP eligibility is a first grade through 8th grade program. Students, grades 1-8, that score Beginning Steps on the 
 * spring DBA (or DRA in 1st, 2nd, or 3rd grade) are AIP eligible for the following school year. First grade student that score 
 * Begining Steps on the fall DBA (or DRA) are AIP eligible for the first grade.
 */


SELECT
	DISTINCT[STUDENT ID] AS ID_NBR
	,'2012' AS 'SCH_YR'
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
	,Grade.fld_ProficiencyLevelText
	,Grade.fld_TestWindow
FROM
	-- DBA database does not contain student grade level or location. Using STARS History to get that info.
	[046-WS02].[db_STARS_History].[dbo].[STUDENT] AS Student
	LEFT JOIN 
	[046-WS02].[db_DBA].[dbo].[tbl_DBA_Student_Results_2010-2011] AS Grade
	ON 
	Student.[ALTERNATE STUDENT ID] = Grade.fld_StudentID

WHERE 
	Student.SY = '2011'
	AND Student.[DISTRICT CODE] = '001'
	AND Student.[Period] = '2011-06-01'
	AND Grade.fld_TestWindow = 'Form 3'
	AND Student.[CURRENT GRADE LEVEL]  BETWEEN '01' AND '08'
	AND Grade.fld_ProficiencyLevelText = 'Beginning Steps'
)AS Spring_DBA_AIP	

	
UNION

SELECT
	DISTINCT fld_ID_NBR AS ID_NBR
	,'2012' AS 'SCH_YR'
FROM	
	
(
SELECT
	-- Current year(2011-2012) DRA fall Beginning Step 1st grade students are AIP eligible
	-- Based on Fall assessment
	DRA.fld_ID_NBR
	,DRA.fld_GRDE
	,DRA.fld_TestLoc
	,DRA.fld_Performance_Lvl
	,DRA.fld_AssessmentWindow
FROM
	[046-WS02].[db_DRA].[dbo].[Results_1112] AS DRA
WHERE
	DRA.fld_GRDE = '01' 
	AND DRA.fld_Performance_Lvl = 'BS'
	AND DRA.fld_TestLoc > '46'  
	AND DRA.fld_AssessmentWindow = 'Fall'	
) AS Fall_DRA_AIP	

UNION

SELECT
	DISTINCT fld_ID_NBR AS ID_NBR
	,'2012' AS 'SCH_YR'
FROM	
	
(
SELECT
	-- Previous year(2010-2011) DRA Spring Beginning Step 1st - 3rd grade students are AIP eligible
	-- Based on Spring assessment

	DRA.fld_ID_NBR
	,DRA.fld_GRDE
	,DRA.fld_TestLoc
	,DRA.fld_Performance_Lvl
	,DRA.fld_AssessmentWindow
FROM
	[046-WS02].[db_DRA].[dbo].[Results_1011] AS DRA
WHERE
	DRA.fld_GRDE BETWEEN '01' AND '03'
	AND DRA.fld_Performance_Lvl = 'BS'
	AND DRA.fld_TestLoc > '46'
	AND DRA.fld_AssessmentWindow = 'Spring' 	
) AS Spring_DRA_AIP		


