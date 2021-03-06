

SELECT
	ORGANIZATION_NAME
	,SIS_NUMBER
	,STU_LAST
	,STU_FIRST

 FROM (

SELECT 
	ORGANIZATION_NAME
	,SIS_NUMBER
	,STU_LAST
	,STU_FIRST
	,ROW_NUMBER() OVER (PARTITION BY SIS_NUMBER  ORDER BY CONTACT_ALLOWED DESC ) AS RN
	,CONTACT_ALLOWED
	,COUNT(CONTACT_ALLOWED) THE_COUNT

 FROM (

SELECT 
	ORGANIZATION_NAME
	,SIS_NUMBER
	,PERS.LAST_NAME AS STU_LAST
	,PERS.FIRST_NAME AS STU_FIRST
	,PARENT.ADULT_ID
	,PPARENT.LAST_NAME AS PARENT_LAST
	,PPARENT.FIRST_NAME AS PARENT_FIRST
	,CONTACT_ALLOWED
	,HAS_CUSTODY
	,LIVES_WITH
	


FROM
rev.EPC_STU_PARENT AS PARENTS
INNER JOIN
APS.PrimaryEnrollmentsAsOf (GETDATE()) AS ENR
ON
PARENTS.STUDENT_GU = ENR.STUDENT_GU
INNER JOIN
rev.EPC_STU AS STU
ON
STU.STUDENT_GU = ENR.STUDENT_GU
INNER JOIN
rev.REV_PERSON AS PERS
ON
STU.STUDENT_GU = PERS.PERSON_GU
INNER JOIN
rev.EPC_PARENT AS PARENT
ON
PARENTS.PARENT_GU = PARENT.PARENT_GU
INNER JOIN
rev.REV_PERSON AS PPARENT
ON
PPARENT.PERSON_GU = PARENT.PARENT_GU
INNER JOIN
rev.REV_ORGANIZATION_YEAR AS ORGYR
ON
ORGYR.ORGANIZATION_YEAR_GU = ENR.ORGANIZATION_YEAR_GU
INNER JOIN
rev.REV_ORGANIZATION AS SCH
ON
SCH.ORGANIZATION_GU = ORGYR.ORGANIZATION_GU


) AS T1

GROUP BY 
	ORGANIZATION_NAME
	,SIS_NUMBER
	,STU_LAST
	,STU_FIRST
	,CONTACT_ALLOWED

) AS T2

WHERE
RN = 1 AND CONTACT_ALLOWED = 'N'



ORDER BY ORGANIZATION_NAME, SIS_NUMBER




