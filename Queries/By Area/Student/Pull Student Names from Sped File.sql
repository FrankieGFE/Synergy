
/*
*	Created By:  Debbie Ann Chavez
*	Date:  6/30/2014
*
*	Sped provides a file and we need to pull the names as they are in Synergy and replace them in the file.
*/

USE ST_Production
GO

SELECT 

/*
	PERSON.LAST_NAME
	,PERSON.FIRST_NAME
	,PERSON.MIDDLE_NAME
	,SPED.*
	,STUDENT_GU 
	*/
	ISNULL(SPED.PermID,'') AS PermID
	,ISNULL(PERSON.LAST_NAME,'') AS LastName
	,ISNULL(PERSON.FIRST_NAME,'') AS FirstName
	,ISNULL(PERSON.MIDDLE_NAME,'') AS MiddleInitial
	,ISNULL(SPED.AnnualReviewDate,'') AS AnnualReviewDate
	,ISNULL(SPED.ReEvalDate,'') AS ReEvalDate
	,ISNULL(SPED.PrimaryDisability,'') AS PrimaryDisability
	,ISNULL(SPED.SecDisability1,'') AS SecDisability1
	,ISNULL(SPED.SecDisability2,'') AS SecDisability2
	,ISNULL(SPED.SecDisability3,'') AS SecDisability3
	,ISNULL(SPED.CaseManagerID,'') AS CaseManagerID

	FROM
	OPENROWSET ('MSDASQL', 'Driver={Microsoft Access Text Driver (*.txt, *.csv)};DBQ=D:\SQLWorkingFiles;', 'SELECT * from "SPED.csv"')
		AS SPED

LEFT JOIN
REV.EPC_STU AS STUDENT
ON
SPED.PermID = STUDENT.SIS_NUMBER

INNER JOIN
REV.REV_PERSON AS PERSON
ON
STUDENT.STUDENT_GU = PERSON.PERSON_GU

