/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	 [assessment_id]
      ,[assessment_name]
      
      --,[student_name]
      ,[question_number]
      ,[answer]
	  ,COUNT ([student_id]) TOTALS
  FROM [SchoolNet].[dbo].[EOC_exam_data]
  GROUP BY assessment_id, assessment_name, question_number, assessment_id, answer
  ORDER BY assessment_id, question_number, answer