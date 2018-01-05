USE [Assessments]
GO

SELECT DISTINCT	
	  [State Name Abbreviation]
      ,[District Name]
      ,[District Number]
      ,ORG.ORGANIZATION_NAME AS [School Name]
      ,RIGHT('0'+ SCH.SCHOOL_CODE,3) AS [School Number]
      ,[Student Last Name]
      ,[Student First Name]
      ,[Student Middle Name]
      ,CONVERT (VARCHAR, STUD.BIRTH_DATE, 101) AS [Birth Date]
      ,STUD.GENDER AS [Gender]
      ,STUD.STATE_STUDENT_NUMBER AS [State Student ID]
      ,[District Student ID]
      ,ENR.[Grade]
      ,STUD.HISPANIC_INDICATOR AS [Ethnicity - Hispanic Latino]
      ,CASE WHEN RACE_1 = 'Native American' THEN 'Y' ELSE '' END AS [Race - American Indian Alaskan Native]
      ,CASE WHEN RACE_1 = 'Asian' THEN 'Y' ELSE '' END AS [Race - Asian]
      ,CASE WHEN RACE_1 = 'African-American' THEN 'Y' ELSE '' END AS [Race - Black African American]
      ,CASE WHEN RACE_1 = 'Pacific Islander' THEN 'Y' ELSE '' END AS [Race - Pacific Islander Hawaiian]
      ,CASE WHEN RACE_1 = 'White' THEN 'Y' ELSE '' END AS [Race - White]
      ,STUD.HOME_LANGUAGE AS [Native Language]
      ,[Date First Enrolled US School]
      ,[Length of Time in LEP ELL Program ]
      ,[Title III Status]
      ,ACC.[Migrant]
      ,CASE WHEN STUD.SPED_STATUS ='Y' THEN 'Y' ELSE '' END AS [IEP Status]
      ,CASE WHEN ENR.ACCESS_504 IS NULL THEN '' ELSE ENR.ACCESS_504 END AS [504 Plan]
      ,CASE WHEN STUD.PRIMARY_DISABILITY_CODE IS NULL THEN '' ELSE STUD.PRIMARY_DISABILITY_CODE END AS [Primary Disability ]
      ,CASE WHEN STUD.SECONDARY_DISABILITY_CODE IS NULL THEN '' ELSE STUD.SECONDARY_DISABILITY_CODE END AS [Secondary Disability]
      ,[LIEP Classification]
      ,[LIEP - Parental Refusal]
      ,[LIEP - Optional Data]
      ,[MC - Accommodation]
      ,[RA - Accommodation]
      ,[ES - Accommodation]
      ,[LP - Accommodation]
      ,[BR - Accommodation]
      ,[SD - Accommodation]
      ,[HR - Accommodation]
      ,[RR - Accommodation]
      ,[HI - Accommodation]
      ,[RI - Accommodation]
      ,[SR - Accommodation]
      ,[WD - Accommodation]
      ,[RD - Accommodation]
      ,[NS - Accommodation]
      ,[ET - Accommodation]
      ,[EM - Accommodation]
      ,[State Defined Operational Data]
      ,[District Defined Operational Data]
      ,[Mode of Administration]
      ,[Paper Tier]
      ,[Alternate ACCESS for ELLs Tester]
      ,[Student Type]
      ,[Additional field to be used by a state if needed]
      ,[Future Use 1]
      ,[Future Use 2]
      ,[Future Use 3]
      ,[Future Use 4]
  FROM [dbo].[001_New_ACCESS_StudentFile_16-17] AS ACC
  LEFT JOIN
  [SYNERGYDBDC].ST_PRODUCTION.APS.BasicStudentWithMoreInfo AS STUD
  ON STUD.SIS_NUMBER = ACC.[District Student ID]

       JOIN [SYNERGYDBDC].ST_PRODUCTION.rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stuD.STUDENT_GU
	   join [SYNERGYDBDC].ST_PRODUCTION.rev.EPC_STU_YR AS SOR		   ON SOR.STU_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU  
       JOIN [SYNERGYDBDC].ST_PRODUCTION.rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                              --and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN [SYNERGYDBDC].ST_PRODUCTION.rev.REV_YEAR              yr   ON yr.YEAR_GU          = oyr.YEAR_GU
	                                                              AND YR.SCHOOL_YEAR = '2016'
       JOIN [SYNERGYDBDC].ST_PRODUCTION.rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
       JOIN [SYNERGYDBDC].ST_PRODUCTION.rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
	   LEFT JOIN [SYNERGYDBDC].ST_PRODUCTION.rev.EPC_SCH AS SCHN ON SCHN.SCHOOL_CODE = ACC.[SCHOOL NUMBER]
	   
	   LEFT JOIN [SYNERGYDBDC].ST_PRODUCTION.APS.StudentEnrollmentDetails AS ENR
	   ON ENR.STUDENT_GU = STUD.STUDENT_GU
	   AND ENR.SCHOOL_YEAR = '2016'

ORDER BY [District Student ID]
GO


