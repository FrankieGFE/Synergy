

--14-15 - '26F066A3-ABFC-4EDB-B397-43412EDABC8B'
--15-16 - 'BCFE2270-A461-4260-BA2B-0087CB8EC26A'

/*

DROP TABLE dbo.ATTENDANCE_2014
CREATE TABLE dbo.ATTENDANCE_2014

( 
	SCHOOL_YEAR VARCHAR (4)
	  ,[SIS_NUMBER]  VARCHAR (9)
      ,[SCHOOL_CODE]  VARCHAR (4)
      ,[GRADE]  VARCHAR (2)
	  ,[MEMBERDAYS]  VARCHAR (4)
	  ,[Total Excused] VARCHAR (9)
	  ,[Total Unexcused] VARCHAR (9)
,[TOTAL_ABSENCES]  VARCHAR (9)
) 
*/
INSERT INTO dbo.ATTENDANCE_2014


SELECT 
'2014' AS SCHOOL_YEAR
,SIS_NUMBER
,SCHOOL_CODE 
,GRADE
,MEMBERDAYS
,[Total Excused]
,[Total Unexcused]
,CASE WHEN Total_Exc_Unex IS NULL THEN '0.00' ELSE Total_Exc_Unex END AS TOTAL_ABSENCES

 
FROM (

SELECT 

AT14.Total_Exc_Unex
,[Total Excused]
,[Total Unexcused]
, MEM14.SIS_NUMBER
, MEM14.SCHOOL_CODE
, MEM14.MEMBERDAYS
, ENR14.GRADE
  
  
  FROM [STUDENT_ATTENDANCE_2014] AS AT14
  RIGHT JOIN 
   (SELECT 
	SIS_NUMBER
	,FIRST_NAME
	,LAST_NAME
	,GRADE
	,SCHOOL_YEAR
	,SCHOOL_CODE
	,EXCLUDE_ADA_ADM
	,MEMBERDAYS
	,MIN(CAST(ENTER_DATE AS DATE)) AS ENTER_DATE
	,MAX(CAST(LEAVE_DATE AS DATE)) AS LEAVE_DATE

 FROM 
STUDENT_SCHOOL_MEMBERDAYS_2014 AS MEM

GROUP BY
	SIS_NUMBER
	,FIRST_NAME
	,LAST_NAME
	,GRADE
	,SCHOOL_YEAR
	,SCHOOL_CODE
	,EXCLUDE_ADA_ADM
	,MEMBERDAYS
	) AS MEM14
  ON
AT14.[SIS Number] = MEM14.SIS_NUMBER
AND AT14.[School Code] = MEM14.SCHOOL_CODE

  LEFT JOIN 
  (SELECT GRADE,SIS_NUMBER FROM 
APS.LatestPrimaryEnrollmentInYear('26F066A3-ABFC-4EDB-B397-43412EDABC8B')
) AS ENR14
ON
ENR14.SIS_NUMBER = MEM14.SIS_NUMBER


) AS T1
  ORDER BY SCHOOL_CODE, SIS_NUMBER

  ----------------------------------------------------------------------------------------
 
/*
 DROP TABLE dbo.ATTENDANCE_2015
CREATE TABLE dbo.ATTENDANCE_2015

( 
	SCHOOL_YEAR VARCHAR (4)
	  ,[SIS_NUMBER]  VARCHAR (9)
      ,[SCHOOL_CODE]  VARCHAR (4)
      ,[GRADE]  VARCHAR (2)
	  ,[MEMBERDAYS]  VARCHAR (4)
	  ,[Total Excused] VARCHAR (9)
	  ,[Total Unexcused] VARCHAR (9)
,[TOTAL_ABSENCES]  VARCHAR (9)
) 
*/
INSERT INTO dbo.ATTENDANCE_2015


SELECT 
'2015' AS SCHOOL_YEAR
,SIS_NUMBER
,SCHOOL_CODE 
,GRADE
,MEMBERDAYS
,[Total Excused]
,[Total Unexcused]
,CASE WHEN Total_Exc_Unex IS NULL THEN '0.00' ELSE Total_Exc_Unex END AS TOTAL_ABSENCES

 
FROM (

SELECT 

AT15.Total_Exc_Unex
,[Total Excused]
,[Total Unexcused]
, MEM15.SIS_NUMBER
, MEM15.SCHOOL_CODE
, MEM15.MEMBERDAYS
, ENR15.GRADE
  
  
  FROM [STUDENT_ATTENDANCE_2015] AS AT15
  RIGHT JOIN 
   (SELECT 
	SIS_NUMBER
	,FIRST_NAME
	,LAST_NAME
	,GRADE
	,SCHOOL_YEAR
	,SCHOOL_CODE
	,EXCLUDE_ADA_ADM
	,MEMBERDAYS
	,MIN(CAST(ENTER_DATE AS DATE)) AS ENTER_DATE
	,MAX(CAST(LEAVE_DATE AS DATE)) AS LEAVE_DATE

 FROM 
STUDENT_SCHOOL_MEMBERDAYS_2015 AS MEM

GROUP BY
	SIS_NUMBER
	,FIRST_NAME
	,LAST_NAME
	,GRADE
	,SCHOOL_YEAR
	,SCHOOL_CODE
	,EXCLUDE_ADA_ADM
	,MEMBERDAYS
	) AS MEM15
  ON
AT15.[SIS Number] = MEM15.SIS_NUMBER
AND AT15.[School Code] = MEM15.SCHOOL_CODE

  LEFT JOIN 
  (SELECT GRADE,SIS_NUMBER FROM 
APS.LatestPrimaryEnrollmentInYear('26F066A3-ABFC-4EDB-B397-43412EDABC8B')
) AS ENR15
ON
ENR15.SIS_NUMBER = MEM15.SIS_NUMBER


) AS T1
  ORDER BY SCHOOL_CODE, SIS_NUMBER