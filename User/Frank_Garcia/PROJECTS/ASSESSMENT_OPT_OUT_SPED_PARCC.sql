USE [AIMS]
GO
SELECT
	SCHOOL_CODE
	,program
	,COUNT (STUDENT_CODE) AS SPED_OPT_OUT_PARCC
FROM
(
SELECT
	  ROW_NUMBER () OVER (PARTITION BY [student_code] ORDER BY [student_code]) AS RN
	  ,[student_code]
      ,[school_year]
      ,[school_code]
      ,[program_code]
      ,[date_enrolled]
      ,[date_withdrawn]
      ,[date_iep]
      ,[date_iep_end]
	  ,AE.Assessment
	  ,case when program_code = 'GI' THEN 'GIFTED' ELSE 'SPED'
	  END AS 'Program'
	  --,COUNT (STUDENT_CODE)
  FROM [dbo].[SPED_PROGRAM] AS SPED
  INNER JOIN
  [dbo].[Program_Assessment_Exemptions] AS AE
  ON SPED.student_code = AE.APS_ID
  
  WHERE AE.Assessment LIKE '%PARCC%'
) AS T1
WHERE RN = 1

  GROUP BY school_code, program
  ORDER BY school_code, program
GO


