USE [ST_Production]
GO

SELECT [studentid]
	  ,STU.SIS_NUMBER
	  --,PED.STUDENT_GU
      ,[Districtcode]
      ,[Schoolcode] AS School_code_from_PED
	  ,PED.SCHOOL_CODE AS School_Code_from_Synergy
      ,[lastname]
      ,[middlename]
      ,[firstname]
      ,[StudentTestLocation]
      ,[semester]
      ,[Testname]
      ,[SUBTEST]
      ,[PL]
      ,[SS]
      ,[competency]
      ,[ELAwritingSS]
      ,[ELAreadingSS]
      ,[SBAbestreadSS]
      ,[SBAbestmathSS]
      ,[sbabestcomposite]
  FROM [APS].[PED_Student_Test_History_File] THF

  JOIN
  REV.EPC_STU AS STU
  ON STU.STATE_STUDENT_NUMBER = THF.studentid

  JOIN
  APS.PrimaryEnrollmentDetailsAsOf (GETDATE()) AS PED
  ON PED.STUDENT_GU = STU.STUDENT_GU

  ORDER BY SCHOOL_CODE, studentid


GO


