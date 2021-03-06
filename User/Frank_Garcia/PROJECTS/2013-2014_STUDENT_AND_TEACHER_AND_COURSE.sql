USE db_STARS_History
GO
SELECT
	[LAST NAME LONG] AS LAST_NAME
	,[FIRST NAME LONG] AS FIRST_NAME
	,[CURRENT GRADE LEVEL] AS GRADE_LEVEL
	,[SPECIAL EDUCATION] AS SPED
	,CASE WHEN [ENGLISH PROFICIENCY] = '1' THEN 'Y' ELSE '' END AS ELL
	,[ECONOMIC STATUS /FOOD PGM PARTICIPATION/] AS FRPL
	,[ETHNIC CODE SHORT] AS ETHNICITY
	,[HISPANIC INDICATOR] AS HISPLAT
	,CAST([ALTERNATE STUDENT ID] AS INT) AS ID_NUMBER
	,[00] AS ELEMENTARY_COURSE
	,[10] AS ELA
	,[20] AS MATH
	,[17] AS SCIENCE
FROM
(
SELECT 
	  CE.[STUDENT ID]
	  ,[ECONOMIC STATUS /FOOD PGM PARTICIPATION/]
	  ,[HISPANIC INDICATOR]
	  ,[ETHNIC CODE SHORT]
	  ,[ENGLISH PROFICIENCY]
	  ,[SPECIAL EDUCATION]
	  ,STUD.[ALTERNATE STUDENT ID]
	  ,STUD.[CURRENT GRADE LEVEL]
	  ,[LAST NAME LONG]
	  ,[FIRST NAME LONG]
      ,LEFT (CI.[COURSECODELONG],2) AS CCL
	  ,CRS.COURSENAME
  FROM [db_STARS_History].[dbo].[CRSE_INSTRUCT] AS CI

  LEFT JOIN
  [COURSE_ENROLL] AS CE
  ON CI.[SECTIONCODELONG] = CE.[SECCODELONG]
  AND CI.[LOCATION CODE] = CE.[LOCATION CODE]
  AND CI.PERIOD = CE.PERIOD
  AND CI.SY = CE.SY
  AND CI.[DISTRICT CODE] = CE.[DISTRICT CODE]

  LEFT JOIN
  [COURSE] AS CRS
  ON LEFT(CRS.COURSECODELONG,4) = LEFT(CI.COURSECODELONG,4)
  AND CRS.PERIOD = CI.PERIOD
  AND CRS.SY = CI.SY
  AND CRS.[DISTRICT CODE] = '001'

  LEFT JOIN
  STUDENT AS STUD
  ON CE.[STUDENT ID] = STUD.[STUDENT ID]
  AND STUD.PERIOD = CE.PERIOD
  AND STUD.PERIOD = '2014-06-01'
  AND STUD.[DISTRICT CODE] = '001'


  WHERE CI.SY = '2014'
  AND CI.PERIOD = '2014-06-01'
  AND CE.[DISTRICT CODE] ='001'
  --AND CRS.COURSENAME NOT IN ('1ST GRADE BIL','Reg - 5th','Gomez-4th','Reg - 4th','Reg - 3rd','Reg - 2nd','Reg - 1st','Kinder Special ed','PE - K','Drennan-Kinder','Kinder','KINDER BIL','Reg - K','PowersK 2','2ND GRADE BIL','3RD GRADE BIL')
  
) T1

 -- LEFT JOIN
	--(SELECT
	--	DISTINCT
	--	STAFFNAME
	--	,SECTIONCODELONG
	--FROM [CRSE_INSTRUCT] AS CRSI
	--WHERE CRSI.SY = '2014'
	--AND CRSI.PERIOD = '2014-06-01'
	--AND CRSI.[DISTRICT CODE] = '001'
	--) AS INST
 -- ON T1.SECL = INST.SECTIONCODELONG 

PIVOT
	(max ([coursename]) for CCL IN ([00],[10],[17],[20])) AS P1
WHERE [ALTERNATE STUDENT ID] IS NOT NULL
ORDER BY [ALTERNATE STUDENT ID]