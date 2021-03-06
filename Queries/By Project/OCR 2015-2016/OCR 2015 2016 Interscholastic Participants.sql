
/*
	-- Calculated participants based on courses
		,SUM(CASE WHEN GENDER = 'M' THEN 1 ELSE 0 END) AS M_ONLY_PARTICIPANTS
		,SUM(CASE WHEN GENDER = 'F' THEN 1 ELSE 0 END) AS F_ONLY_PARTICIPANTS
		,COUNT(*) AS TOT_PARTICIPANTS
*/


SELECT 
	-- Calculated participants based on courses
		
		SCHOOL_CODE		
		,SUM(CASE WHEN GENDER = 'M' THEN 1 ELSE 0 END) AS M_ONLY_PARTICIPANTS
		,SUM(CASE WHEN GENDER = 'F' THEN 1 ELSE 0 END) AS F_ONLY_PARTICIPANTS
		,COUNT(*) AS TOT_PARTICIPANTS
FROM(

SELECT DISTINCT SIS_NUMBER, SCHOOL_CODE, GENDER

FROM(

--GET DETAILS 
SELECT SCHOOL_CODE, ORGANIZATION_NAME, SIS_NUMBER, GENDER, COURSE_ID, COURSE_TITLE FROM 
APS.BasicSchedule AS BS
INNER JOIN 
APS.BasicStudent AS STU
ON
BS.STUDENT_GU = STU.STUDENT_GU
INNER JOIN 
REV.EPC_CRS AS CRS
ON
BS.COURSE_GU = CRS.COURSE_GU
INNER JOIN 
REV.REV_ORGANIZATION AS ORG
ON
BS.ORGANIZATION_GU = ORG.ORGANIZATION_GU
INNER JOIN 
REV.EPC_SCH AS SCH
ON
BS.ORGANIZATION_GU = SCH.ORGANIZATION_GU
INNER JOIN 
REV.UD_CRS_GROUP AS GRP
ON
GRP.COURSE_GU = BS.COURSE_GU
INNER JOIN 
REV.REV_YEAR AS YRS
ON
YRS.YEAR_GU = BS.YEAR_GU
AND YRS.YEAR_GU = 'BCFE2270-A461-4260-BA2B-0087CB8EC26A'

WHERE
GRP.[GROUP] = '006'
AND YRS.SCHOOL_YEAR = '2015'

) AS GETUNIQUEPERSCHOOL

) AS COUNTS
GROUP BY SCHOOL_CODE

