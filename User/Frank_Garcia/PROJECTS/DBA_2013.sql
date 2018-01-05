
/**
 * 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 2/21/2013 $
 *
 * Request By: Jude Garcia for Carl Macaluso
 *			   This pull is for summer school and has many variables such as test window and grade levels
 * InitialRequestDate: 2/19/2013
 * 
 * Initial Request:
 * Frank could you pull all 6th & 7th grade Fall DBA scores for summer middle school programs?
 *
 * Tables Referenced: All db_DBA, db.STARS_History.[LOCATION CODE] and [CURRENT GRADE LEVEL]
 *
 * Notes: 
 */
 
 -- Proficiency Levels Grades K-3: 1 = Beginning Steps 2 = Emerging 3 = Basic Proficiency 4 = Proficient 5= Advanced
 -- Proficiency Levels Grades 4-12: 1 = Beginning Steps 2 = Emerging 3 = Nearing Proficiency 4 = Advanced
DECLARE @ProficiencyLevel TABLE (Levels INT)
		INSERT INTO @ProficiencyLevel VALUES (1)
		INSERT INTO @ProficiencyLevel VALUES (2) 
		INSERT INTO @ProficiencyLevel VALUES (3) 
		INSERT INTO @ProficiencyLevel VALUES (4) 
		INSERT INTO @ProficiencyLevel VALUES (5) 

	
DECLARE @District VARCHAR(50) = '001'
		-- Test Windows: Fall = Form 1 Winter = Form 2 Spring = Form 3
		,@TestWindow VARCHAR(50) = 'Form 1'
		--If you are looking for a grade range, adjust the variables below for the between range.
		-- For all grade levels use 01 and KF
		,@GradeLevelFrom VARCHAR(2) = '01'
		,@GradeLevelTo VARCHAR (2) = 'KF'
		,@SchoolYear VARCHAR (4) = '2013'


SELECT
	*
FROM
(
	-- Selecting all student data from DBA and getting location and student grade level from STARS_History

SELECT
	-- Using row number over partition to ensure one record per student per assessment
	ROW_NUMBER () OVER (PARTITION BY fld_Student_ID, fld_Test_Name ORDER BY fld_Test_Name DESC) AS RN
	,STARS.[LAST NAME LONG]+', '+STARS.[FIRST NAME LONG] AS [Student Name]
	,DBA.fld_Student_ID AS [APS ID]
	,STARS.[CURRENT GRADE LEVEL] AS [GRADE LEVEL]
	,STARS.[LOCATION CODE] AS [LOCATION]
	,DBA.fld_School_Year AS [SCHOOL YEAR]
	,DBA.fld_Test_Window AS [TEST WINDOW]
	,DBA.fld_Test_Name AS [TEST NAME]	
	,DBA.fld_Total_Score AS [TOTAL SCORE]
	,DBA.fld_Total_Score_Percentage AS [TOTAL SCORE PERCENTAGE]
	,DBA.fld_Proficiency_Level AS [PROFICIENCY LEVEL NUMBER]
	,DBA.fld_Proficiency_Level_Text AS [PROFICIENCY LEVEL]
	
FROM
	[046-WS02].[db_DBA].[dbo].[tbl_DBA_Results] AS DBA
	LEFT JOIN
	[046-WS02].[db_STARS_History].[dbo].[STUDENT] AS STARS
	ON		
	DBA.fld_Student_ID = STARS.[ALTERNATE STUDENT ID]
WHERE 
	-- DBA has school year in the same format as STARS_History. Joining on that
	DBA.fld_School_Year = @SchoolYear
	AND STARS.SY = @SchoolYear
	AND STARS.[DISTRICT CODE] = @District
	--AND DBA.fld_Proficiency_Level IN (SELECT Levels FROM @ProficiencyLevel)
	AND DBA.fld_Test_Window = @TestWindow
	AND STARS.[CURRENT GRADE LEVEL] BETWEEN @GradeLevelFrom AND @GradeLevelTo
)AS DBA_RN
WHERE
	RN = '1'



