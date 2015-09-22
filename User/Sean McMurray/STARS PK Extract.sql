//*Pulls PK, P1, P2 students in specific schools*//

SELECT

    DISTINCT SIS_NUMBER AS [ID Number]
	,LAST_NAME AS [Last Name]
	,FIRST_NAME AS [First Name]
	,MIDDLE_NAME AS [Middle Name]
	,GRADE AS [Grade]
	,SCHOOL_NAME AS [School Name]
	,ADDRESS AS [Home Address]
	,CITY AS [City]
	,STATE AS [State]
	,ZIP_5 AS [Zip Code]
 
FROM
APS.PrimaryEnrollmentDetailsAsOf ('02-11-15')   --Change this date based on how many days to pull (This pulled for the 120th day)
INNER JOIN 
rev.REV_PERSON ON APS.PrimaryEnrollmentDetailsAsOf.STUDENT_GU = rev.REV_PERSON.PERSON_GU
INNER JOIN
rev.REV_ADDRESS ON rev.REV_PERSON.HOME_ADDRESS_GU = rev.REV_ADDRESS.ADDRESS_GU
INNER JOIN
rev.EPC_STU ON APS.PrimaryEnrollmentDetailsAsOf.STUDENT_GU = rev.EPC_STU.STUDENT_GU

//*Change this to include different schools and gradese*//

WHERE

    (GRADE LIKE 'P%' AND SCHOOL_NAME LIKE 'Pajarito%')
	OR
	(GRADE LIKE 'P%' AND SCHOOL_NAME LIKE 'Alameda%')
	OR
	(GRADE LIKE 'P%' AND SCHOOL_NAME LIKE 'A. Montoya%')
	OR
	(GRADE LIKE 'P%' AND SCHOOL_NAME LIKE 'Adobe%')
	OR
	(GRADE LIKE 'P%' AND SCHOOL_NAME LIKE 'Armijo%')
	OR
	(GRADE LIKE 'P%' AND SCHOOL_NAME LIKE 'Barcelona%')
	OR
	(GRADE LIKE 'P%' AND SCHOOL_NAME LIKE 'Bel%')
	OR
	(GRADE LIKE 'P%' AND SCHOOL_NAME LIKE 'Cochiti%')
	OR
	(GRADE LIKE 'P%' AND SCHOOL_NAME LIKE 'Emerson%')
	OR
	(GRADE LIKE 'P%' AND SCHOOL_NAME LIKE 'Eubank%')
	OR
	(GRADE LIKE 'P%' AND SCHOOL_NAME LIKE 'Eugene%')
	OR
	(GRADE LIKE 'P%' AND SCHOOL_NAME LIKE 'Hawthorne%')
	OR
	(GRADE LIKE 'P%' AND SCHOOL_NAME LIKE 'Helen%')
	OR
	(GRADE LIKE 'P%' AND SCHOOL_NAME LIKE 'Kit%')
	OR
	(GRADE LIKE 'P%' AND SCHOOL_NAME LIKE 'Lava%')
	OR
	(GRADE LIKE 'P%' AND SCHOOL_NAME LIKE 'Los Padillas%')
	OR
	(GRADE LIKE 'P%' AND SCHOOL_NAME LIKE 'Los Ranchos%')
	OR
	(GRADE LIKE 'P%' AND SCHOOL_NAME LIKE 'Mission%')
	OR
	(GRADE LIKE 'P%' AND SCHOOL_NAME LIKE 'Navajo%')
	OR
	(GRADE LIKE 'P%' AND SCHOOL_NAME LIKE 'Sierra%')
	OR
	(GRADE LIKE 'P%' AND SCHOOL_NAME LIKE 'Valle%')

ORDER BY SCHOOL_NAME, GRADE, [Last Name];