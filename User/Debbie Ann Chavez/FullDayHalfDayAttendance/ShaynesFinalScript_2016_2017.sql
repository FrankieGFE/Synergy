
SELECT
		[SIS Number]
		,[School Code]
		,[School Name]
		,Grade
		,Gender
		,[Hispanic Indicator]
		,Race1
		,Race2
		,Race3
		,Race4
		,Race5
		,[Half-Day Unexcused]
		,[Full-Day Unexcused]
		,[Total Unexcused]
		,[Half-Day Excused]
		,[Full-Day Excused]
		,[Total Excused]
		,MEMBER_DAYS
	,SUM([Total Unexcused] + [Total Excused]) AS Total_Exc_Unex
 FROM 
(
SELECT 
	ATT.[SIS Number]
	,ATT.[School Code]
	,ORG.ORGANIZATION_NAME AS [School Name]
	,ENR.GRADE AS [Grade]
	,ENR.GENDER AS [Gender]
	, ENR.HISPANIC_INDICATOR AS [Hispanic Indicator]
	, ENR.RACE_1 AS Race1
	, ENR.RACE_2 AS Race2
	, ENR.RACE_3 AS Race3
	, ENR.RACE_4 AS Race4
	, ENR.RACE_5 AS Race5
	,CASE WHEN ATT.[Half-Day Unexcused] IS NULL THEN 0 ELSE ATT.[Half-Day Unexcused] END AS [Half-Day Unexcused]
	,CASE WHEN ATT.[Full-Day Unexcused] IS NULL THEN 0 ELSE ATT.[Full-Day Unexcused] END AS [Full-Day Unexcused]
	,CASE WHEN ATT.[Total Unexcused] IS NULL THEN 0 ELSE ATT.[Total Unexcused] END AS [Total Unexcused]
	,CASE WHEN ATT.[Half-Day Excused] IS NULL THEN 0 ELSE ATT.[Half-Day Excused] END AS [Half-Day Excused]
	,CASE WHEN ATT.[Full-Day Excused] IS NULL THEN 0 ELSE ATT.[Full-Day Excused] END AS [Full-Day Excused]
	,CASE WHEN ATT.[Total Excused] IS NULL THEN 0 ELSE ATT.[Total Excused] END AS [Total Excused]
	,CASE WHEN  MEMBER_DAYS IS NULL THEN 0 ELSE MEMBER_DAYS END AS MEMBER_DAYS

FROM 
APS.ShayneAttendanceExcUnexTotalsAsOf('20150522') AS ATT
LEFT JOIN 
STUDENT_SCHOOL_MEMBERDAYS AS MEMDAYS
ON 
ATT.[SIS NUMBER] = MEMDAYS.STUID
AND ATT.[SCHOOL CODE] = MEMDAYS.SCHOOL_CODE

LEFT JOIN 
rev.EPC_SCH AS SCH
ON
SCH.SCHOOL_CODE = ATT.[School Code]

LEFT JOIN 
rev.REV_ORGANIZATION AS ORG
ON
ORG.ORGANIZATION_GU = SCH.ORGANIZATION_GU

LEFT JOIN 
(
SELECT MAX(VALUE_DESCRIPTION) AS GRADE,SIS_NUMBER, STU.GENDER, STU.HISPANIC_INDICATOR, STU.RACE_1, STU.RACE_2, STU.RACE_3, STU.RACE_4, STU.RACE_5
FROM 
APS.EnrollmentsForYear('26F066A3-ABFC-4EDB-B397-43412EDABC8B') AS ENR
INNER JOIN 
APS.LookupTable('K12','GRADE') AS LU
ON
ENR.GRADE = LU.VALUE_CODE
INNER JOIN 
APS.BasicStudentWithMoreInfo AS STU
ON
STU.STUDENT_GU = ENR.STUDENT_GU
GROUP BY SIS_NUMBER, STU.GENDER, STU.HISPANIC_INDICATOR, STU.RACE_1, STU.RACE_2, STU.RACE_3, STU.RACE_4, STU.RACE_5
) AS ENR
ON
ENR.SIS_NUMBER = ATT.[SIS Number]

) AS T1

GROUP BY 
		[SIS Number]
		,[School Code]
		,[School Name]
		,Grade
		,Gender
		,[Hispanic Indicator]
		,Race1
		,Race2
		,Race3
		,Race4
		,Race5
		,[Half-Day Unexcused]
		,[Full-Day Unexcused]
		,[Total Unexcused]
		,[Half-Day Excused]
		,[Full-Day Excused]
		,[Total Excused]
		,MEMBER_DAYS