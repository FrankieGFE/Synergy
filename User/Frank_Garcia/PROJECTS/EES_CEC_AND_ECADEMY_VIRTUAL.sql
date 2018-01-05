USE [SchoolNet]
GO

SELECT 
	  DISTINCT 
	  SECT.[student_code]
	  --,ENR.STUDENT_CODE
	  --,ENR.date_enrolled
	  --,ENR.date_withdrawn
	  ,EES.[Student Name]
	  ,EES.[Grad Standard Year]
	  ,EES.[Passed All Required Tests]
	  ,EES.[SCIENCE SBA ATTEMPTS]
	  ,EES.[MATH SBA ATTEMPTS]
	  ,EES.[READING SBA ATTEMPTS]
	  ,EES.[SCIENCE FINAL DETERMINATION]
	  ,EES.[SBA Requirements Remaining]
	  ,EES.[EOC Requirements Remaining]
	  ,EES.[EOC Social Studies Attempts]
	  ,EES.[EOC Writing Attempts]
      --,[school_year]
      --,[term_code]
      --,[school_code]
      --,[staff_code]
      --,[course_code]
      --,[section_code]
      --,[mark_code]
      --,[date_enrolled]
      --,[date_withdrawn]
      --,[section_name]
      --,[period_code]
  FROM [dbo].[Section_result]  SECT
  JOIN
  Enrollment AS ENR
  ON SECT.student_code = ENR.student_code

  JOIN
  [14-15_EES_CurrentEnrollment_4_21_15] AS EES
  ON SECT.student_code = EES.[Student ID]
  WHERE SECT.SCHOOL_CODE = '592'
  AND ENR.date_withdrawn = ''
GO


