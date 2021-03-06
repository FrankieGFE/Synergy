

--2012-2014

--CREATE TABLE dbo.STUDENT_ATTENDANCE_2011

--( [SCHOOL_YEAR]  VARCHAR (9)
--      ,[TOTAL_ABSENCES_DAYS]  VARCHAR (10)
--      ,[IDNBR]  VARCHAR (9)
--      ,[SCHNBR]  VARCHAR (4)
--      ,[MEMBERDAYS]  VARCHAR (4)
--      ,[GRADE]  VARCHAR (2)
--	  )

INSERT INTO dbo.STUDENT_ATTENDANCE_2011

SELECT 
'2011' AS SCHOOL_YEAR
,CASE WHEN TOTAL_ABSENCES IS NULL THEN '0.00' ELSE TOTAL_ABSENCES END AS TOTAL_ABSENCES_DAYS
,IDNBR
--,SCHYR
,SCHNBR
,MEMBERDAYS
,GRDE AS GRADE
 
FROM (

SELECT 

AT14.TOTAL_ABSENCES 
, MEM14.IDNBR
, MEM14.SCHYR
, MEM14.SCHNBR
, MEM14.MEMBERDAYS
, PRIM14.GRDE

FROM 
dbo.ATTENDANCE_2011 AS AT14
RIGHT JOIN 
dbo.MEMBERDAYS_2012 AS MEM14
ON
AT14.ID_NBR = MEM14.IDNBR
AND AT14.SCH_NBR = MEM14.SCHNBR
LEFT JOIN 
--CHANGE HERE
APS.MostRecentPrimaryEnrollBySchYr(2012) AS PRIM14
ON
PRIM14.ID_NBR = MEM14.IDNBR

--WHERE
	--(MEM14.SCHNBR BETWEEN '399' AND '600' 
	-- OR MEM14.SCHNBR = '840')
) AS T1


ORDER BY SCHNBR, IDNBR