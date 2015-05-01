
SELECT 
       [LOCATION CODE] AS SchoolNumber,CodeCategory AS SubjectArea, CodeDescription AS CourseDescription, Category_1 AS BegGradeRange, Category_2 AS EndGradeRange, 
	   SECTIONCODELONG AS Crs_Sec_TeacherID, STAFFNAME AS TeacherName
FROM
OPENROWSET('Microsoft.ACE.OLEDB.12.0', 
'Text;Database=\\180-SMAXODS-01\SQLWorkingFiles\;', 
'SELECT * from tblCommon_Codes2.csv')
AS T1

INNER JOIN
(
SELECT 
	SY, Period, [LOCATION CODE], LEFT(COURSECODELONG,4)AS COURSELONG, SECTIONCODELONG, STAFFNAME
FROM
	[046-WS02].[db_STARS_History].[dbo].[CRSE_INSTRUCT] AS CRSINSTRUCT

WHERE
	[Period] = '2014-12-15'
	AND [LOCATION CODE] IN ('339', '450', '285', '300', '315', '376', '379', '270')
) AS T2

ON
T2.COURSELONG = T1.Code

WHERE 
	[CodeType] = 'Courses'

ORDER BY 
SchoolNumber, TeacherName, Crs_Sec_TeacherID