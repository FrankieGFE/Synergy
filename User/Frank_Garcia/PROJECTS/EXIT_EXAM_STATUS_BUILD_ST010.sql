USE SchoolNet
GO


DROP TABLE ST010 

/* gets students (active and inactive) for the current school year */
SELECT student_code AS ID_NBR, 
       last_name AS LAST_NAME,
	   first_name AS FIRST_NAME, 
       school_code AS SCH_NBR, 
       grade_code AS GRDE 
INTO   ST010 
FROM   ALLSTUDENTS
WHERE  grade_code IN ( '09', '10', '11', '12','C1', 'C2', 'C3', 'C4', 'T1', 'T2', 'T3', 'T4','H0','H1','H2','H3','H4','H5','H6','H7','H8','H9') 



