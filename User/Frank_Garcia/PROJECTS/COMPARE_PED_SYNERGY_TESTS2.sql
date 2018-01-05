USE [ST_Production]
GO

SELECT
	DISTINCT * 
FROM
(
SELECT 
	  [StudentID]
	  ,STU.SIS_NUMBER
      ,[DistrictCode]
      ,[Schoolcode] AS School_code_from_PED
	  ,PED.SCHOOL_CODE AS School_Code_from_Synergy
      ,[LastName]
      ,[MiddleName]
      ,[FirstName]
      ,[TestLocation]
      ,[Semester]
      ,[TestName]
      ,[Subtest]
      ,[PerformanceLevel]
      ,[ScaledScore]
      ,[Competency]
      ,[ELAwritingScore]
      ,[ELAreadingScore]
      ,[SBAbestReadingScore]
      ,[SBAbestMathScore]
      ,[SBAbestCompositeScore]
  FROM [APS].[PED_Student_Test_History_File] THF

  JOIN
  REV.EPC_STU AS STU
  ON STU.STATE_STUDENT_NUMBER = THF.studentid

  LEFT JOIN
  APS.PrimaryEnrollmentDetailsAsOf (GETDATE()) AS PED
  ON PED.STUDENT_GU = STU.STUDENT_GU
) AS PEDS
WHERE 1 = 1
AND School_Code_from_Synergy IS NOT NULL
AND SEMESTER = '2012 SPRING'
AND TestName = 'SBA' AND SUBTEST = 'MATH'
  ORDER BY TESTNAME


GO


