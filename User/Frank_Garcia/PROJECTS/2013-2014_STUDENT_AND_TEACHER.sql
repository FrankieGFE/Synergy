USE db_STARS_History
GO
SELECT
	CAST([ALTERNATE STUDENT ID] AS INT) AS ID_NUMBER
	,[00] AS ELEMENTARY_TEACHER
	,[10] AS ELA_TEACHER
	,[20] AS MATH_TEACHER
	,[17] AS SCIENCE_TEACHER
FROM
(
SELECT 
	  CE.[STUDENT ID]
	  ,STUD.[ALTERNATE STUDENT ID]
      ,LEFT (CI.[COURSECODELONG],2) AS CCL
	  ,CI.STAFFNAME
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

PIVOT
	(max ([STAFFNAME]) for CCL IN ([00],[10],[17],[20])) AS P1
WHERE [ALTERNATE STUDENT ID] IS NOT NULL
ORDER BY [ALTERNATE STUDENT ID]