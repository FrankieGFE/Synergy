USE Assessments
GO


DROP TABLE ST010 

/* gets students (active and inactive) for the current school year */
SELECT
	ID_NBR
	,LAST_NAME
	,FIRST_NAME
	,SCH_NBR
	,GRDE
INTO   ST010 
FROM
(
SELECT 
	   ROW_NUMBER () OVER (PARTITION BY student_code ORDER BY school_code) AS RN,
	   student_code AS ID_NBR, 
       last_name AS LAST_NAME,
	   first_name AS FIRST_NAME, 
       school_code AS SCH_NBR, 
       grade_code AS GRDE 
FROM   ALLSTUDENTS
WHERE  grade_code IN ( '09', '10', '11', '12', 
                     'C1', 'C2', 'C3', 'C4', 
                     'T1', 'T2', 'T3', 'T4' ) 
	  --AND school_code NOT IN ('517', '701','702','901','910')
) AS T1
WHERE RN = 1




 



