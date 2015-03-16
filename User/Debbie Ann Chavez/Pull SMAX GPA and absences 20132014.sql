
SELECT 
	SCH_NBR
	,SCH_NME_27
	,ID_NBR
	,GRDE
	,[Cumulative Flat GPA]
	,[Cumulative Weighted GPA]
	,SUM(CORE) AS CORE_PERIOD_ABS_COUNT
	,SUM(ELE) AS ELE_PERIOD_ABS_COUNT
FROM 
(
SELECT 
	ENR.SCH_NBR
	,SCHOOL.SCH_NME_27
	,ENR.ID_NBR
	,ENR.GRDE
	,[Cumulative Flat GPA]
	,[Cumulative Weighted GPA]
	,CASE WHEN DEPARTMENT IN ('MTH','E09', 'E10', 'E11', 'E12', 'ENG', 'SCI', 'SOC', 'WH', 'USH', 'NMH', 'ECON', 'GOV') THEN 1 ELSE 0 END AS CORE
	,CASE WHEN DEPARTMENT IN ('MTH','E09', 'E10', 'E11', 'E12', 'ENG', 'SCI', 'SOC', 'WH', 'USH', 'NMH', 'ECON', 'GOV') THEN 0 ELSE 1 END AS ELE
	/*,ABSENCES.COURSE
	,ABSENCES.XSECTION
	,ABSENCES.REAS_CD
	,DCM.DEPARTMENT
	,ABSENCES.CAL_DT*/

 FROM
APS.CumulativeGPA AS GPA
INNER HASH JOIN
APS.EnrollmentsAsOf('2014-05-22') AS ENR
ON
GPA.DST_NBR = ENR.DST_NBR
AND GPA.ID_NBR = ENR.ID_NBR
INNER JOIN
DBTSIS.SY010_V AS SCHOOL
ON
ENR.DST_NBR = SCHOOL.DST_NBR
AND ENR.SCH_NBR = SCHOOL.SCH_NBR
AND NONADA_SCH = ''

INNER HASH JOIN
DBTSIS.AT030_V AS ABSENCES
ON
ABSENCES.DST_NBR = ENR.DST_NBR
AND ABSENCES.SCH_YR = ENR.SCH_YR
AND ABSENCES.SCH_NBR = ENR.SCH_NBR
AND ABSENCES.ID_NBR = ENR.ID_NBR

INNER JOIN
DBTSIS.SC031_V AS DCM
ON
DCM.DST_NBR = ABSENCES.DST_NBR
AND DCM.SCH_YR = ABSENCES.SCH_YR
AND DCM.SCH_NBR = ABSENCES.SCH_NBR
AND DCM.COURSE = ABSENCES.COURSE
AND DCM.VERSION = '00'


WHERE
--ENR.ID_NBR = 102785458AND 
ENR.SCH_YR = 2014
AND ABSENCES.ATT_STAT != 'T'
AND ABSENCES.REAS_CD != 'AC'
AND ENR.SCH_NBR LIKE '5%'
AND [Cumulative Flat GPA] = '3.1'

) AS T1
GROUP BY
	SCH_NBR
	,SCH_NME_27
	,ID_NBR
	,GRDE
	,[Cumulative Flat GPA]
	,[Cumulative Weighted GPA]

	ORDER BY 
[Cumulative Flat GPA]
,ID_NBR