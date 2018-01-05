USE Assessments
GO


SELECT * FROM

(
SELECT 

--DISTINCT ID_NBR
            
            student_code AS ID_NBR
            ,'20170601' TEST_DT
            ,school_code AS SCH_NBR
            ,CASE WHEN TEST_LEVEL_NAME = '00' THEN 'K' ELSE test_level_name 
			END AS GRDE
			,scaled_score AS SCORE_2
            ,score_3 SCORE_1
            ,score_group_name AS Level
            ,test_type_name AS TEST_SUB
			--,SCH_YR
            ,ROW_NUMBER () OVER (PARTITION BY student_code ORDER BY test_date_code) AS RN

FROM TEST_RESULT_ACCESS AS TESTS

WHERE test_type_name IN ('ACCESS')
AND school_year = '2016'
AND score_group_label = 'Overall Composite'

--AND TEST_DT LIKE '%2014%'
--ORDER BY SCORE_3 DESC

) AS ACCESS
--where ID_NBR IN ('100004936','100013572')
--WHERE SCH_NBR = '425'
--where SCORE_1 = '6.0'
ORDER BY SCH_NBR

