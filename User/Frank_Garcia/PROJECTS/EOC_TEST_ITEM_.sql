USE SchoolNet
GO
/****
 
 * $LastChangedBy: Terri Christiansen
 * $LastChangedDate: 8/19/2013 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * SAT test
 * Tables Referenced:  Experiment with a Standardized test layout.
	In this case, EOC 
****/
TRUNCATE TABLE test_item_EOC
--GO
INSERT INTO test_item_EOC

SELECT
		[ID Number] AS student_code
		,CASE WHEN GRADE IS NULL THEN ''
			ELSE GRADE
		END AS test_level_name
		,EOC.[School Year] AS school_year
		,[test Date] AS test_date_code
		,[Test ID] AS test_type_code
		,'0' AS parent_test_section_code
		,CS.SM_name AS test_section_code
		,EXAM.question_number AS question_code
		,CASE
			WHEN KEYS.question_type = 'multiple_choice' THEN '0'
		END AS question_type_code
		,KEYS.answer AS correct_response_code
		,EXAM.answer AS actual_response_code
		,KEYS.points AS points_attempted
		,CASE	
			WHEN KEYS.answer = EXAM.answer THEN '1' ELSE '0'
		END AS points_achieved
		,Last_Name AS last_name
		,First_Name AS first_name
		,DOB AS DOB
		,'' AS version_code
		,KEYS.guid AS standard_code

	FROM [SPRING_EOC_] AS EOC
	LEFT JOIN
		Riverside_Exam_Data AS EXAM
		ON EXAM.student_id = EOC.[ID Number]
		AND EXAM.assessment_id = EOC.assessment_id

	LEFT JOIN
		Riverside_Answer_Key AS KEYS
		ON EOC.assessment_id = KEYS.assessment_id
		AND EXAM.question_number = KEYS.SEQUENCE

	LEFT JOIN
		EoC_Cut_Scores AS CS
		ON EXAM.assessment_id = CS.assessment_id

	WHERE KEYS.guid IS NOT NULL
	AND (EOC.Grade IS NOT NULL OR EOC.GRADE != '')
	AND EOC.[ID Number] > '1'
	--AND student_id = '100003714'
	--WHERE assessment_id IN ('8193', '8195', '8201', '8202', '8362','8363','8365','8367','8368','8371','8373','8374','8375','8376')
	--WHERE [ID Number] = 970099433 -- test student
	--AND [ID Number] = '100074988'
	order by standard_code




