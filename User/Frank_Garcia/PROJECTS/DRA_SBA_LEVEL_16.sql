BEGIN TRAN

SELECT
	DRA.fld_ID_NBR AS [Student ID]
	,DRA.fld_Level AS [DRA Level]
	,DRA.fld_GRDE AS [DRA Grade Level]
	,DRA.fld_AssessmentWindow AS [DRA Window]
	,DRA.fld_Performance_Lvl AS [DRA Performance Level]
	,SBA.score_group_name AS [SBA Performance Level]
	,SBA.scaled_score AS [SBA Scaled Score]
	,SBA.test_level_name AS [SBA Grade Level]
FROM
	[180-SMAXODS-01].[SchoolNet].[dbo].[SBA] AS SBA	
	INNER JOIN
	[046-WS02].[db_DRA].[dbo].[Results_0910] AS DRA
	ON
	SBA.student_code = DRA.fld_ID_NBR
	WHERE
	DRA.fld_GRDE = 'K'
	AND DRA.fld_Level = '16'
	AND SBA.test_section_name = 'READING'
	ORDER BY fld_ID_NBR
	
ROLLBACK