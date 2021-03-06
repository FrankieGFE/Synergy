
SELECT 
	  [SIS Number]
      ,[School Code]
      ,[Exclude_Ada_Adm]
      ,[School Name]
      ,[Grade]
      ,[Gender]
      ,[Hispanic Indicator]
      ,[Race1]
      ,[Race2]
      ,[Race3]
      ,[Race4]
      ,[Race5]
	  ,ACCESS_504
      ,[ELL Status]
      ,[Sped Status]
      ,[Gifted Status]
      ,[Full-Day Unexcused]
      ,[Full-Day Excused]
      ,[ORGANIZATION_GU]
	 ,[Full-Day Unexcused] + [Full-Day Excused]  AS TOTAL
FROM [ST_Production].[dbo].[STUDENT_ATTENDANCE_2015] AS STU
LEFT JOIN 
	(SELECT DISTINCT
		SIS_NUMBER, 
		ACCESS_504
	FROM 
		APS.StudentEnrollmentDetails AS SSY
	WHERE
		SCHOOL_YEAR = '2015'
		AND EXTENSION = 'R'
		AND ACCESS_504 IS NOT NULL) AS ACCESS504

ON STU.[SIS Number] = ACCESS504.SIS_NUMBER

WHERE
[Full-Day Unexcused] + [Full-Day Excused] >= '15.00'
ORDER BY [School Code]
