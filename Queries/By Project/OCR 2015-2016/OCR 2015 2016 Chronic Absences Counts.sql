

SELECT 
	
		[School Code]
		,SUM(CASE WHEN [TWO_OR_MORE]='Hispanic' AND Gender = 'M' THEN 1 ELSE 0 END) AS [M_HIS_CHRONIC_ABS]
		,SUM(CASE WHEN [TWO_OR_MORE]='Native American' AND Gender = 'M' THEN 1 ELSE 0 END) AS [M_AME_CHRONIC_ABS]	
		,SUM(CASE WHEN [TWO_OR_MORE]='Asian' AND Gender = 'M' THEN 1 ELSE 0 END) AS [M_ASI_CHRONIC_ABS]
		,SUM(CASE WHEN [TWO_OR_MORE]='Pacific Islander' AND Gender = 'M' THEN 1 ELSE 0 END) AS [M_HI_PAC_CHRONIC_ABS]
		,SUM(CASE WHEN [TWO_OR_MORE]='African-American' AND Gender = 'M' THEN 1 ELSE 0 END) AS [M_BLA_CHRONIC_ABS]
		,SUM(CASE WHEN [TWO_OR_MORE]='White' AND Gender = 'M' THEN 1 ELSE 0 END) AS [M_WHI_CHRONIC_ABS]
		,SUM(CASE WHEN [TWO_OR_MORE]='Two or more races' AND Gender = 'M' THEN 1 ELSE 0 END) AS [M_2_OR_MORE_CHRONIC_ABS]

		,SUM(CASE WHEN Gender = 'M' THEN 1 ELSE 0 END) AS [M_TOT_CHRONIC_ABS]

		,SUM(CASE WHEN Gender = 'M'  AND [Sped Status]='Y' THEN 1 ELSE 0 END) AS [M_DIS_CHRONIC_ABS]
		,SUM(CASE WHEN Gender = 'M'  AND [ELL Status]='Y' THEN 1 ELSE 0 END) AS [M_ELL_CHRONIC_ABS]
		,SUM(CASE WHEN Gender = 'M'  AND [ACCESS_504]='Y' THEN 1 ELSE 0 END) AS [M_504_CHRONIC_ABS]
		
		,SUM(CASE WHEN [TWO_OR_MORE]='Hispanic' AND Gender = 'F' THEN 1 ELSE 0 END) AS [F_HIS_CHRONIC_ABS]
		,SUM(CASE WHEN [TWO_OR_MORE]='Native American' AND Gender = 'F' THEN 1 ELSE 0 END) AS [F_AME_CHRONIC_ABS]	
		,SUM(CASE WHEN [TWO_OR_MORE]='Asian' AND Gender = 'F' THEN 1 ELSE 0 END) AS [F_ASI_CHRONIC_ABS]	
		,SUM(CASE WHEN [TWO_OR_MORE]='Pacific Islander' AND Gender = 'F' THEN 1 ELSE 0 END) AS [F_HI_PAC_CHRONIC_ABS]
		,SUM(CASE WHEN [TWO_OR_MORE]='African-American' AND Gender = 'F' THEN 1 ELSE 0 END) AS [F_BLA_CHRONIC_ABS]
		,SUM(CASE WHEN [TWO_OR_MORE]='White' AND Gender = 'F' THEN 1 ELSE 0 END) AS [F_WHI_CHRONIC_ABS]
		,SUM(CASE WHEN [TWO_OR_MORE]='Two or more races' AND Gender = 'F' THEN 1 ELSE 0 END) AS [F_2_OR_MORE_CHRONIC_ABS]

		,SUM(CASE WHEN Gender = 'F' THEN 1 ELSE 0 END) AS [F_TOT_CHRONIC_ABS]

		,SUM(CASE WHEN Gender = 'F'  AND [Sped Status]='Y' THEN 1 ELSE 0 END) AS [F_DIS_CHRONIC_ABS]
		,SUM(CASE WHEN Gender = 'F'  AND [ELL Status]='Y' THEN 1 ELSE 0 END) AS [F_ELL_CHRONIC_ABS]
		,SUM(CASE WHEN Gender = 'F'  AND [ACCESS_504]='Y' THEN 1 ELSE 0 END) AS [F_504_CHRONIC_ABS]

FROM (
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
	  ,CASE 
			WHEN ([Race1] != '' AND [Race2] != '') THEN 'Two or more races' 
			WHEN Race1 = 'White' AND [Hispanic Indicator] = 'Y' THEN 'Hispanic' 
			ELSE [Race1] END AS TWO_OR_MORE
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
) AS T1

--PIVOT
--(
--MAX(TWO_OR_MORE)
--FOR TWO_OR_MORE IN ([Hispanic], [Native American],[Asian], [Pacific Islander], [African-American], [Two or more races])
--) AS PIVOTME
GROUP BY 
	[School Code]
	ORDER BY [School Code]