/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	  RIGHT([SchoolNum],3)
	  ,SCH.SCHOOL_CODE
      ,[SchoolName]
      ,[StudentID]
      ,[First]
      ,[last]
      ,[mi]
      ,PARCC.[DOB]
      ,[Testname]
      ,[Subtest]
      ,[SSRead]
      ,[SSWrite]
      ,[ReadingPF]
      ,[WritingPF]
      ,[PL]
      ,[SS]
      ,[SCH_YR]
	  ,YR.SCHOOL_YEAR

  FROM [Assessments].[dbo].[Preliminary_2015_PARCC] AS PARCC
	   LEFT JOIN SYNERGYDBDC.ST_PRODUCTION.rev.EPC_STU stu ON STU.STATE_STUDENT_NUMBER = PARCC.StudentID
       LEFT JOIN SYNERGYDBDC.ST_PRODUCTION.rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
	   LEFT join SYNERGYDBDC.ST_PRODUCTION.rev.EPC_STU_YR AS SOR		   ON SOR.STU_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU  
       LEFT JOIN SYNERGYDBDC.ST_PRODUCTION.rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                              --and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       LEFT JOIN SYNERGYDBDC.ST_PRODUCTION.rev.REV_YEAR              yr   ON yr.YEAR_GU          = oyr.YEAR_GU
       LEFT JOIN SYNERGYDBDC.ST_PRODUCTION.rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
       LEFT JOIN SYNERGYDBDC.ST_PRODUCTION.rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
	   LEFT JOIN SYNERGYDBDC.ST_PRODUCTION.rev.EPC_STU_PGM_ELL_HIS AS ELL ON ELL.STUDENT_GU = stu.STUDENT_GU
  WHERE YR.SCHOOL_YEAR = '2014'
  AND SCH.SCHOOL_CODE = RIGHT([SchoolNum],3)
 



