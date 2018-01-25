BEGIN TRAN
SELECT 
	*
FROM
(
SELECT 
	ROW_NUMBER () OVER (PARTITION BY Questions.fld_Assessment, Questions.fld_CategoryName, Questions.fld_Level, Questions.fld_LevelTitles ORDER BY Questions.fld_Category_SortOrder)AS RN
	,*
FROM
	Question_Dropdowns_DRA AS Questions
	INNER JOIN 
	Story AS Story
	ON
	Questions.fld_Level = Story.fld_Level
	AND Questions.fld_LevelTitles = Story.fld_LevelTitles

)AS rowNumbers	
ROLLBACK

			

