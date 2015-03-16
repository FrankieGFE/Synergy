

SELECT 
	
	ID1
	,ID
	,[DistrictName]
	,[Location ID]
	,SchoolName
	,StudentID
	,[Last Name]
	,[First Name]
	,Grade
	,[CoDe Reason For Leaving]
	,[Description Reason For Leaving]
	,[Withdrawal Code]
	,[Last Attended]
	,Comments1
	,Comments2
	,Comments3
	
	,[Cumulative Flat GPA]
	,[Cumulative Weighted GPA]
	,SUM(CORE) AS CORE_PERIOD_ABS_COUNT
	,SUM(ELE) AS ELE_PERIOD_ABS_COUNT
FROM 
(
SELECT 

	ENR.*
	
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
OPENROWSET ('MSDASQL', 'Driver={Microsoft Access Text Driver (*.txt, *.csv)};DBQ=D:\SQLWorkingFiles;', 'SELECT * from "Dropout.csv"')
		AS ENR
LEFT HASH JOIN
APS.CumulativeGPA AS GPA
ON
GPA.DST_NBR = 1 AND
GPA.ID_NBR = ENR.StudentID

LEFT HASH JOIN
DBTSIS.AT030_V AS ABSENCES
ON
ABSENCES.DST_NBR = 1
AND ABSENCES.SCH_YR = 2014
AND ABSENCES.SCH_NBR = ENR.[Location ID]
AND ABSENCES.ID_NBR = ENR.StudentID
AND ABSENCES.ATT_STAT != 'T'
AND ABSENCES.REAS_CD != 'AC'

LEFT JOIN
DBTSIS.SC031_V AS DCM
ON
DCM.DST_NBR = ABSENCES.DST_NBR
AND DCM.SCH_YR = ABSENCES.SCH_YR
AND DCM.SCH_NBR = ABSENCES.SCH_NBR
AND DCM.COURSE = ABSENCES.COURSE
AND DCM.VERSION = '00'

INNER JOIN
DBTSIS.CE020_V AS STATEID
ON
STATEID.DST_NBR = 1
AND STATEID.ID_NBR = ENR.StudentID

--WHERE
--ENR.StudentID = 102785458AND 

) AS T1
GROUP BY
		ID1
	,ID
	,[DistrictName]
	,[Location ID]
	,SchoolName
	,StudentID
	,[Last Name]
	,[First Name]
	,Grade
	,[CoDe Reason For Leaving]
	,[Description Reason For Leaving]
	,[Withdrawal Code]
	,[Last Attended]
	,Comments1
	,Comments2
	,Comments3
	
	
	,[Cumulative Flat GPA]
	,[Cumulative Weighted GPA]

	ORDER BY 
	[Cumulative Flat GPA]
	,Grade
	,[Last Name]
	,[First Name]

