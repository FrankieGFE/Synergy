USE Assessments
GO
--BEGIN TRAN

TRUNCATE TABLE [EXIT_EXAM_STATUS_SBA_COUNTS]
INSERT INTO [EXIT_EXAM_STATUS_SBA_COUNTS]

SELECT 
	  [ID_NBR]
      ,[DST_NBR]
      ,[GRDE]
      ,[SCH_NBR]
      ,[SCH_YR]
      ,[SCORE_11]
      ,[SCORE_2]
      ,[TEST_DT]
      ,[TEST_ID]
      ,[TEST_SUB]



FROM
(
SELECT 
	student_code AS ID_NBR
	,'1' AS DST_NBR 
	,test_level_name AS GRDE
	,school_code AS SCH_NBR
	,school_year + 1 AS SCH_YR
	,score_group_name AS SCORE_11
	,scaled_score AS SCORE_2
	,test_date_code AS TEST_DT
	,'SBA' AS TEST_ID
	,CASE WHEN test_section_name = 'MATH' THEN 'MATE'
		  WHEN test_section_name = 'READING' THEN 'REAE'
		  WHEN test_section_name = 'READING(S)' THEN 'REAE'
		  WHEN test_section_name = 'SCIENCE' THEN 'SCIE'
		  WHEN test_section_name = 'SOCIAL STUDIES' THEN 'SOCE'
		  WHEN test_section_name = 'WRITING' THEN 'WRIE'
	END AS TEST_SUB
--INTO   GS055 
FROM   SBA
WHERE  student_code IN (SELECT ID_NBR 
                  FROM   ST010) 
       AND test_level_name IN ('09', '10', '11', '12', 
                     'C1', 'C2', 'C3', 'C4', 
                     'T1', 'T2', 'T3', 'T4', 'H1', 'H2','H3','H4','H5','H6','H7','H8','H9','H0') 
	  AND test_section_name IN ('MATH','READING','READING(S)','SCIENCE','SOCIAL STUDIES','WRITING')
	  AND scaled_score > '1' 
	  AND scaled_score NOT LIKE '99%'
) AS T1
--ROLLBACK