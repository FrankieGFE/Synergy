--Created by e207878/Sean McMurray
--Created on 11/13/15
--Pulls Student Information ALL 8th graders

SELECT

    DISTINCT SIS_NUMBER AS [ID Number]
	,LAST_NAME AS [Last Name]
	,FIRST_NAME AS [First Name]
	,MIDDLE_NAME AS [Middle Name]
	,ADDRESS AS [Home Address]
	,CITY AS [City]
	,STATE AS [State]
	,ZIP_5 AS [Zip Code]
	,GRADE AS [Grade]
	,SCHOOL_NAME AS [School Name]

 
FROM
APS.PrimaryEnrollmentDetailsAsOf ('10-29-15')   --Change this date based on how many days to pull (This pulled for the 120th day)
INNER JOIN 
rev.REV_PERSON ON APS.PrimaryEnrollmentDetailsAsOf.STUDENT_GU = rev.REV_PERSON.PERSON_GU
INNER JOIN
rev.REV_ADDRESS ON rev.REV_PERSON.HOME_ADDRESS_GU = rev.REV_ADDRESS.ADDRESS_GU
INNER JOIN
rev.EPC_STU ON APS.PrimaryEnrollmentDetailsAsOf.STUDENT_GU = rev.EPC_STU.STUDENT_GU

--//*Change this to include different schools and grades*//

WHERE

	(GRADE = '08')
		

ORDER BY SCHOOL_NAME;