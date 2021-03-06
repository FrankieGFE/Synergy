SELECT * FROM (
SELECT DISTINCT

EMPLOYEE, LAST_NAME, FIRST_NAME
	,ADDR1, ADDR2, T1.CITY, T1.STATE, ZIP

		, CASE WHEN (LOCAT_CODE BETWEEN '0400' AND '0500' ) THEN 'M'
					WHEN (LOCAT_CODE BETWEEN '0500' AND '0600' ) THEN 'H'
					WHEN (LOCAT_CODE BETWEEN '0200' AND '0400' ) THEN 'E'
		ELSE '' END AS TEACHER_LEVEL

	,SIS_NUMBER
	, GRADE
	, PARENT_LAST_NAME
	, PARENT_FIRST_NAME
	,ADDRESS
	,T2.CITY AS CITY2
	,T2.STATE AS STATE2
	,ZIP_5
		
	, CASE WHEN (LOCAT_CODE BETWEEN '0400' AND '0500' ) AND (GRADE BETWEEN '06' AND '08') THEN 'M' 
					WHEN (LOCAT_CODE BETWEEN '0500' AND '0600' ) AND (GRADE BETWEEN '09' AND '12') THEN 'H' 
					WHEN (LOCAT_CODE BETWEEN '0200' AND '0400' ) AND (GRADE IN ('PK', 'P1', 'P2', '01', '02', '03', '04', '05')) THEN 'E' 
	ELSE '' 	END AS  STATUS

 FROM
(
SELECT DISTINCT  
	EMPLOYEE.EMPLOYEE, EMPLOYEE.LAST_NAME, EMPLOYEE.FIRST_NAME, DESCRIPTION, CAE.LOCAT_CODE
	,EMPLOYEE.ADDR1, EMPLOYEE.ADDR2, EMPLOYEE.CITY, EMPLOYEE.STATE, EMPLOYEE.ZIP
 FROM
	[180-SMAXODS-01.APS.EDU.ACTD].Lawson.APS.CurrentActiveTeachers AS CAE
	INNER JOIN
	[180-SMAXODS-01.APS.EDU.ACTD].Lawson.dbo.Paposition AS POSITION
	ON
	CAE.POSITION = POSITION.POSITION
	INNER JOIN
	[180-SMAXODS-01.APS.EDU.ACTD].Lawson.dbo.Employee AS EMPLOYEE
	ON
	CAE.EMPLOYEE = EMPLOYEE.EMPLOYEE

	WHERE
	CAE.LOCAT_CODE BETWEEN '0200' AND '0600'

	) AS T1

	INNER JOIN

(
SELECT 
	SIS_NUMBER
	,LE.VALUE_DESCRIPTION AS GRADE
	,ORGANIZATION_NAME
	,PARENTS.[Parent Last Name] AS PARENT_LAST_NAME
	,PARENTS.[Parent First Name] AS PARENT_FIRST_NAME
	,ADDRESS
	,CITY
	,STATE
	,ZIP_5
	
 FROM
APS.PrimaryEnrollmentsAsOf (GETDATE()) AS PE
INNER JOIN
rev.EPC_STU AS STU
ON
PE.STUDENT_GU = STU.STUDENT_GU
INNER JOIN
(SELECT DISTINCT
  stu.SIS_NUMBER AS [ID Number]
, par.FIRST_NAME AS [Parent First Name]
, par.LAST_NAME  AS [Parent Last Name]
,addr.ADDRESS
,addr.CITY
,addr.STATE
,addr.ZIP_5
,ORGANIZATION_NAME

FROM rev.EPC_STU               stu
JOIN rev.EPC_STU_SCH_YR        ssyr   ON ssyr.STUDENT_GU = stu.STUDENT_GU
JOIN rev.REV_ORGANIZATION_YEAR oyr    ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU 
JOIN rev.REV_YEAR              yr     ON yr.YEAR_GU = oyr.YEAR_GU and yr.SCHOOL_YEAR = (SELECT SCHOOL_YEAR FROM rev.SIF_22_Common_CurrentYear)
JOIN rev.EPC_STU_PARENT        stupar ON stupar.STUDENT_GU = stu.STUDENT_GU
JOIN rev.REV_PERSON            par    ON par.PERSON_GU = stupar.PARENT_GU and stupar.CONTACT_ALLOWED = 'Y'
INNER JOIN rev.REV_ADDRESS  addr ON par.HOME_ADDRESS_GU = addr.ADDRESS_GU
INNER JOIN REV.REV_ORGANIZATION AS ORG
ON


OYR.ORGANIZATION_GU = ORG.ORGANIZATION_GU

) AS PARENTS
ON
STU.SIS_NUMBER = PARENTS.[ID Number]

INNER JOIN
APS.LookupTable ('K12', 'Grade') AS LE
ON
PE.GRADE = LE.VALUE_CODE

) AS T2

ON

T1.LAST_NAME = T2.PARENT_LAST_NAME
AND 
T1.FIRST_NAME = T2.PARENT_FIRST_NAME
AND
LEFT(T1.ADDR1,10) = LEFT(T2.ADDRESS,10)


) AS ALLOFIT



