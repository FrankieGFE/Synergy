SELECT
NEW.[State Student Identifier] AS 'FROM NEW FILE'
,MATH.Student_ID AS 'FROM MATH FILE'
FROM
[SchoolNet].[dbo].[New_StudentRegisrationFile_14_15] AS NEW
LEFT JOIN
[Math no ID at 40 day 2015] AS MATH
ON NEW.[State Student Identifier] = MATH.Student_ID
WHERE Student_ID IS NULL
--ORDER BY Student_ID
