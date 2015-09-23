--Created by: e207878/Sean McMurray
--Purpose: Data extract to pull parent information for SPED students
--Note: Created stored procedure for SSIS job to run nightly




Select
  rev.EPC_PARENT.ADULT_ID AS [Adult ID]
  ,rev.REV_PERSON.LAST_NAME AS [Last Name]
  ,rev.REV_PERSON.FIRST_NAME AS [First Name]
  ,rev.REV_PERSON.MIDDLE_NAME AS [Middle Name]
  ,rev.REV_ADDRESS.ADDRESS AS [Address]
  ,rev.REV_ADDRESS.CITY AS [City]
  ,rev.REV_ADDRESS.STATE AS [State]
  ,rev.REV_ADDRESS.ZIP_5 AS [Zip Code]
  ,rev.REV_PERSON.EMAIL AS [Email]
  ,'2015' AS [School Year]
  ,rev.EPC_STU_PARENT.RELATION_TYPE AS [Relation Type]
  ,[SIS_NUMBER] AS [Student ID]
From

  rev.EPC_PARENT 
  Inner Join
  rev.REV_PERSON On rev.EPC_PARENT.PARENT_GU = rev.REV_PERSON.PERSON_GU
  Inner Join
  rev.REV_ADDRESS On rev.REV_PERSON.HOME_ADDRESS_GU = rev.REV_ADDRESS.ADDRESS_GU
  Inner Join
  rev.EPC_STU_PARENT On rev.EPC_STU_PARENT.PARENT_GU = rev.EPC_PARENT.PARENT_GU
  INNER JOIN
  rev.EPC_STU ON rev.EPC_STU_PARENT.STUDENT_GU = rev.EPC_STU.STUDENT_GU