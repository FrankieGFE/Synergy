BEGIN TRAN

DECLARE @WINDOW NVARCHAR (50)
SET @WINDOW = 'SPRING'

DECLARE @SY NVARCHAR (50)
SET @SY = '2008-2009'

--- UPDATE TABLE FOR VARIOUS YEARS ---


INSERT INTO dbo.DRA_FOR_PASCAL

SELECT
	DISTINCT
	DRA.fld_ID_NBR AS APS_ID
	,DRA.FLD_STATE_ID AS State_ID
	,DRA.fld_LST_NME AS Last_Name
	,DRA.fld_FRST_NME AS First_Name
	,DRA.fld_TestLoc AS Location
	,DRA.fld_GRDE AS Grade_Level
	,@SY AS School_Year
	,DRA.fld_assessmentwindow AS Test_Window
	,DRA.fld_assessment_used AS Test_Type
	,DRA.fld_Level AS Level
	,DRA.fld_Story AS Story
	,DRA.fld_Total_Sect1 AS Reading_Engagement_Total
	,TOTALS_1.fld_Total_Score_Text AS Reading_Engagement_PL
	,DRA.fld_Total_Sect2 AS Oral_Reading_Fluency_Total
	,TOTALS_2.fld_Total_Score_Text AS Oral_Reading_Fluencyt_PL
	,DRA.fld_Total_Sect3 AS Comprehension_Printed_Language_Concepts_Total
	,TOTALS_3.fld_Total_Score_Text AS Comprehension_Printed_Language_Concepts_PL
	,CASE
		WHEN DRA.fld_Performance_Lvl ='PRO' THEN 'Proficient'
		WHEN DRA.fld_Performance_Lvl ='BS'  THEN 'Beginning Steps'
		WHEN DRA.fld_Performance_Lvl = 'NP' THEN 'Nearing Proficient' 
		WHEN DRA.fld_Performance_Lvl = 'ADV' THEN 'Advanced'
	 ELSE 'Not Applicable' 
	 END AS	Overall_Reading_Proficiency
	
FROM
	Results_0809 AS DRA
	INNER JOIN
	[Question_Dropdowns_EDL] AS QDD
	ON
	DRA.fld_Assessment_Used = QDD.fld_Assessment
	AND	DRA.fld_Level = QDD.fld_Level
	AND DRA.fld_story = QDD.fld_levelTitles
	INNER JOIN
	CATEGORIES_DRA_TABLE AS CAT
	ON
	QDD.fld_CategoryName = CAT.fld_CategoryName
	INNER JOIN
	[Total_Scores_EDL] AS TOTALS_1
	ON
	DRA.fld_Level = TOTALS_1.fld_Level
	AND DRA.fld_Total_Sect1 = TOTALS_1.fld_Valid_Total_Score
	AND TOTALS_1.fld_Section_Number = '1'
	AND FLD_ASSESSMENTWINDOW = @WINDOW
	AND
		CASE
			WHEN DRA.fld_Story = 'BRIDGE-Amelia Earhart' THEN 'BRIDGE-Amelia Earhart'
			WHEN DRA.fld_Story = 'BRIDGE-Energy From the Sun' THEN 'BRIDGE-Energy From the Sun'
			WHEN DRA.fld_Story = 'BRIDGE-Hero' THEN 'BRIDGE-Hero'
			WHEN DRA.fld_Story = 'BRIDGE-Incredible Journeys' THEN 'BRIDGE-Incredible Journeys'
			WHEN DRA.fld_Story = 'BRIDGE-The Blasters' THEN 'BRIDGE-The Blasters'
			WHEN DRA.fld_Story = 'BRIDGE-The Flood' THEN 'BRIDGE-The Flood'
			WHEN DRA.fld_Story = 'BRIDGE-The Navajo Way' THEN 'BRIDGE-The Navajo Way'
			WHEN DRA.fld_Story = 'BRIDGE-What Carlos Wants' THEN 'BRIDGE-What Carlos Wants'
			ELSE 'none'
		END	= TOTALS_1.fld_Story	

	
	INNER JOIN
	[Total_Scores_EDL] AS TOTALS_2
	ON
	DRA.fld_Level = TOTALS_2.fld_Level
	AND DRA.fld_Total_Sect2 = TOTALS_2.fld_Valid_Total_Score
	AND TOTALS_2.fld_Section_Number = '2'
	AND FLD_ASSESSMENTWINDOW = @WINDOW
	AND
		CASE
			WHEN DRA.fld_Story = 'BRIDGE-Amelia Earhart' THEN 'BRIDGE-Amelia Earhart'
			WHEN DRA.fld_Story = 'BRIDGE-Energy From the Sun' THEN 'BRIDGE-Energy From the Sun'
			WHEN DRA.fld_Story = 'BRIDGE-Hero' THEN 'BRIDGE-Hero'
			WHEN DRA.fld_Story = 'BRIDGE-Incredible Journeys' THEN 'BRIDGE-Incredible Journeys'
			WHEN DRA.fld_Story = 'BRIDGE-The Blasters' THEN 'BRIDGE-The Blasters'
			WHEN DRA.fld_Story = 'BRIDGE-The Flood' THEN 'BRIDGE-The Flood'
			WHEN DRA.fld_Story = 'BRIDGE-The Navajo Way' THEN 'BRIDGE-The Navajo Way'
			WHEN DRA.fld_Story = 'BRIDGE-What Carlos Wants' THEN 'BRIDGE-What Carlos Wants'
			ELSE 'none'
		END	= TOTALS_2.fld_Story	

	
	INNER JOIN
	[Total_Scores_EDL] AS TOTALS_3
	ON
	DRA.fld_Level = TOTALS_3.fld_Level
	AND DRA.fld_Total_Sect3 = TOTALS_3.fld_Valid_Total_Score
	AND TOTALS_3.fld_Section_Number = '3'
	AND FLD_ASSESSMENTWINDOW = @WINDOW
	AND
		CASE
			WHEN DRA.fld_Story = 'BRIDGE-Amelia Earhart' THEN 'BRIDGE-Amelia Earhart'
			WHEN DRA.fld_Story = 'BRIDGE-Energy From the Sun' THEN 'BRIDGE-Energy From the Sun'
			WHEN DRA.fld_Story = 'BRIDGE-Hero' THEN 'BRIDGE-Hero'
			WHEN DRA.fld_Story = 'BRIDGE-Incredible Journeys' THEN 'BRIDGE-Incredible Journeys'
			WHEN DRA.fld_Story = 'BRIDGE-The Blasters' THEN 'BRIDGE-The Blasters'
			WHEN DRA.fld_Story = 'BRIDGE-The Flood' THEN 'BRIDGE-The Flood'
			WHEN DRA.fld_Story = 'BRIDGE-The Navajo Way' THEN 'BRIDGE-The Navajo Way'
			WHEN DRA.fld_Story = 'BRIDGE-What Carlos Wants' THEN 'BRIDGE-What Carlos Wants'
			ELSE 'none'
		END	= TOTALS_3.fld_Story	

ORDER BY APS_ID	

ROLLBACK