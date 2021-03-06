/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [assessment_id]
      ,[assessment_name]
      ,[student_id]
      ,[student_name]
      ,[proficiency_measure]
      ,[proficiency_score]
  FROM [SchoolNet].[dbo].[assessment_data]
  WHERE 
  
	(assessment_name = '2012-2013 APS Benchmark Assessment Grade 1 CCSS Math Form 3'
	 OR assessment_name = '2012-2013 (SPANISH) APS Benchmark Assessment Grade 1 CCSS Math Form 3'
	 
		OR assessment_name = '2012-2013 (SPANISH) APS Benchmark Assessment Grade 2 CCSS Math Form 3'
		OR assessment_name = '2012-2013 APS Benchmark Assessment Grade 2 CCSS Math Form 3'
		
		OR assessment_name = '2012-2013 APS Benchmark Assessment Grade 3 CCSS Math Form 3'
		OR assessment_name = '2012-2013 ( SPANISH) APS Benchmark Assessment Grade 3 CCSS Math Form 3'
		
		OR assessment_name = '2012-2013 APS Benchmark Assessment Grade 4 Math Form 3'
		OR assessment_name = '2012-2013 (SPANISH) APS Benchmark Assessment Grade 4 Math Form 3'

		OR assessment_name = '2012-2013 APS Benchmark Assessment Grade 5 Math Form 3'
		OR assessment_name = '2012-2013 (SPANISH) APS Benchmark Assessment Grade 5 Math Form 3'


		OR assessment_name = '2012-2013 APS Benchmark Assessment Grade 3 CCSS Reading Form 3'
		OR assessment_name = '2012-2013 APS Benchmark Assessment Grade 4 CCSS Reading Form 3'
		OR assessment_name = '2012-2013 APS Benchmark Assessment Grade 4 Reading Form 3'
		OR assessment_name = '2012-2013 APS Benchmark Assessment Grade 5 Reading Form 3')
		
		AND proficiency_measure = 'Overall Exam Proficiency Level Text'
		

  order by student_id
  