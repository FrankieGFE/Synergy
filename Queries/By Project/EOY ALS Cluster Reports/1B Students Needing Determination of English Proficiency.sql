/*
	Created By:  Debbie Ann Chavez
	Date:  6/4/2015
*/


IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[APS].[LCEALS1B]'))
	EXEC ('CREATE VIEW APS.LCEALS1B AS SELECT 0 AS DUMMY')
GO

ALTER VIEW APS.LCEALS1B AS




SELECT * FROM 

(
SELECT 
	CLUSTER
	,SCHOOL
	,SCH.SCHOOL_CODE
	
	,CASE WHEN T4.[Current Quarter 5/22/2015 no HLS] IS NULL THEN 0 ELSE T4.[Current Quarter 5/22/2015 no HLS] END AS [Current Quarter 5/22/2015 no HLS]
	,CASE WHEN T2.[Prior Quarter 2/12/2015] IS NULL THEN 0 ELSE T2.[Prior Quarter 2/12/2015] END AS [Prior Quarter 2/12/2015 No HLS]
	,CASE WHEN [LASTYEAR NOHLS] IS NULL THEN 0 ELSE [LASTYEAR NOHLS] END AS [Year Ago 5/22/2014 No HLS]

	,CASE WHEN [Current Quarter 5/22/2014] IS NULL THEN 0 ELSE [Current Quarter 5/22/2014] END AS [Current Quarter 5/22/2015 Needs EPT]
	,CASE WHEN T3.[Prior Quarter 2/12/2015] IS NULL THEN 0 ELSE T3.[Prior Quarter 2/12/2015] END AS [Prior Quarter 2/12/2015 NEEDS EPT]
	,CASE WHEN [LAST YEAR NOTEST] IS NULL THEN 0 ELSE [LAST YEAR NOTEST] END AS [Year Ago 5/22/2014 No EPT]
	

FROM

----------------------------------------------------------------------------------------------
--YEAR AGO TABLE
--NO HLS AND NO TEST

           dbo.[LCE_NO_HLS] AS CLUSTER

			LEFT JOIN
			rev.REV_ORGANIZATION AS ORG
			ON
			ORG.ORGANIZATION_NAME = CLUSTER.SCHOOL

------------------------------------------------------------------------------------------
--STUDENTS THAT HAD NO HLS ON THE LAST DAY
LEFT JOIN
(
SELECT ORG.ORGANIZATION_GU, COUNT(*) AS [Current Quarter 5/22/2015 no HLS] 

FROM 
	APS.PrimaryEnrollmentsAsOf('2015-05-22') AS PRIM
	LEFT JOIN
	(SELECT DISTINCT STUDENT_GU FROM rev.UD_HLS_HISTORY)AS NOHLS
	ON
	PRIM.STUDENT_GU = NOHLS.STUDENT_GU
	INNER JOIN
	rev.REV_ORGANIZATION_YEAR AS ORGYR
	ON
	ORGYR.ORGANIZATION_YEAR_GU = PRIM.ORGANIZATION_YEAR_GU
	INNER JOIN
	rev.REV_ORGANIZATION AS ORG
	ON
	ORGYR.ORGANIZATION_GU = ORG.ORGANIZATION_GU

	WHERE
	NOHLS.STUDENT_GU IS NULL
	AND PRIM.GRADE NOT IN  ('050', '070', '090', '230', '240', '250', '260', '270', '280', '290', '300')

	GROUP BY ORG.ORGANIZATION_GU
) AS T4

ON
T4.ORGANIZATION_GU = ORG.ORGANIZATION_GU

--------------------------------------------------------------------------------------------------

--KIDS THAT NEEDED TESTING AS OF LAST DAY
			LEFT JOIN
			(SELECT 
				SchoolName
				,COUNT (*) AS [Current Quarter 5/22/2014]
			 FROM 
			APS.LCEStudentsNeedingTestingAsOf('2015-05-22')

			GROUP BY 
				SchoolName
			) AS T1

			ON 
			T1.SchoolName = ORG.ORGANIZATION_NAME

			LEFT JOIN
			rev.EPC_SCH AS SCH
			ON
			SCH.ORGANIZATION_GU = ORG.ORGANIZATION_GU
----------------------------------------------------------------------------------------------
--KIDS THAT HAD NO HLS ON THE 120TH DAY
	LEFT JOIN
	(		
	SELECT [LOCATION CODE],COUNT(*) AS [Prior Quarter 2/12/2015]
	--[LOCATION CODE], SIS_NUMBER 
	FROM 

	[046-WS02.APS.EDU.ACTD].[db_STARS_History].[dbo].[STUD_SNAPSHOT] AS STUDENT_SNAPSHOT
	INNER JOIN 
	rev.EPC_STU AS STU
	ON
	STU.SIS_NUMBER = STUDENT_SNAPSHOT.[ALTERNATE STUDENT ID]
	
	LEFT JOIN
	APS.LCEMostRecentHLSAsOf('2015-03-01') AS HLS
	ON
	HLS.STUDENT_GU = STU.STUDENT_GU

	INNER JOIN
	rev.EPC_SCH AS SCHOOL
	ON
	STUDENT_SNAPSHOT.[LOCATION CODE] = SCHOOL.SCHOOL_CODE

WHERE
	[DISTRICT CODE] = '001'
	AND [Period] = '2015-03-01'
	
	AND HLS.STUDENT_GU IS NULL
GROUP BY 
	[LOCATION CODE]
) AS T2

ON 
T2.[LOCATION CODE] = SCH.SCHOOL_CODE


-------------------------------------------------------------------------------------------
--STUDENTS THAT NEED TESTING ON 120TH DAY
LEFT JOIN
(
SELECT [LOCATION CODE],COUNT(*) AS [Prior Quarter 2/12/2015]
	--[LOCATION CODE], SIS_NUMBER 
	FROM 

	[046-WS02.APS.EDU.ACTD].[db_STARS_History].[dbo].[STUD_SNAPSHOT] AS STUDENT_SNAPSHOT
	INNER JOIN 
	rev.EPC_STU AS STU
	ON
	STU.SIS_NUMBER = STUDENT_SNAPSHOT.[ALTERNATE STUDENT ID]
	
	INNER JOIN
	APS.LCEStudentsNeedingTestingAsOf('2015-03-15') AS NPT
	ON
	NPT.STUDENT_GU = STU.STUDENT_GU

	INNER JOIN
	rev.EPC_SCH AS SCHOOL
	ON
	STUDENT_SNAPSHOT.[LOCATION CODE] = SCHOOL.SCHOOL_CODE

WHERE
	[DISTRICT CODE] = '001'
	AND [Period] = '2015-03-01'
		
GROUP BY 
	[LOCATION CODE]
	) AS T3
ON
T3.[LOCATION CODE] = SCH.SCHOOL_CODE



WHERE
	SCHOOL NOT LIKE '%Cluster'

) AS DETAILS


/*
-------------------------------------------------------------------------------------------------------------------------
--CLUSTER TOTALS

UNION ALL 
(
SELECT 
	CLUSTER
	,CLUSTER AS SCHOOL_FILLER
	,'1' AS SCHOOL_CODE_FILLER

	,SUM(T4.[Current Quarter 5/22/2015 no HLS]) AS CURRTOT
	,SUM(T2.[Prior Quarter 2/12/2015]) AS PRIORTOT
	,SUM([LASTYEAR NOHLS]) AS YAGOTOT

	,SUM([Current Quarter 5/22/2014]) AS CURRTOT1
	,SUM(T3.[Prior Quarter 2/12/2015]) AS PRIORTOT1
	,SUM([LAST YEAR NOTEST]) AS YAGOTOT1


FROM

            dbo.[LCE_NO_HLS] AS CLUSTER

			LEFT JOIN
			rev.REV_ORGANIZATION AS ORG
			ON
			ORG.ORGANIZATION_NAME = CLUSTER.SCHOOL

			LEFT JOIN
			(SELECT 
				SchoolName
				,COUNT (*) AS [Current Quarter 5/22/2014]
			 FROM 
			APS.LCEStudentsNeedingTestingAsOf('2015-05-22')
			GROUP BY 
				SchoolName
			) AS T1

			ON 
			T1.SchoolName = ORG.ORGANIZATION_NAME

			LEFT JOIN
			rev.EPC_SCH AS SCH
			ON
			SCH.ORGANIZATION_GU = ORG.ORGANIZATION_GU

	LEFT JOIN
	(		
	SELECT [LOCATION CODE],COUNT(*) AS [Prior Quarter 2/12/2015]
	--[LOCATION CODE], SIS_NUMBER 
	FROM 

	[046-WS02.APS.EDU.ACTD].[db_STARS_History].[dbo].[STUD_SNAPSHOT] AS STUDENT_SNAPSHOT
	INNER JOIN 
	rev.EPC_STU AS STU
	ON
	STU.SIS_NUMBER = STUDENT_SNAPSHOT.[ALTERNATE STUDENT ID]
	
	LEFT JOIN
	APS.LCEMostRecentHLSAsOf('2015-03-01') AS HLS
	ON
	HLS.STUDENT_GU = STU.STUDENT_GU

	INNER JOIN
	rev.EPC_SCH AS SCHOOL
	ON
	STUDENT_SNAPSHOT.[LOCATION CODE] = SCHOOL.SCHOOL_CODE

WHERE
	[DISTRICT CODE] = '001'
	AND [Period] = '2015-03-01'
	
	AND HLS.STUDENT_GU IS NULL
GROUP BY 
	[LOCATION CODE]
) AS T2

ON 
T2.[LOCATION CODE] = SCH.SCHOOL_CODE

LEFT JOIN
(
SELECT [LOCATION CODE],COUNT(*) AS [Prior Quarter 2/12/2015]
	--[LOCATION CODE], SIS_NUMBER 
	FROM 

	[046-WS02.APS.EDU.ACTD].[db_STARS_History].[dbo].[STUD_SNAPSHOT] AS STUDENT_SNAPSHOT
	INNER JOIN 
	rev.EPC_STU AS STU
	ON
	STU.SIS_NUMBER = STUDENT_SNAPSHOT.[ALTERNATE STUDENT ID]
	
	INNER JOIN
	APS.LCEStudentsNeedingTestingAsOf('2015-03-15') AS NPT
	ON
	NPT.STUDENT_GU = STU.STUDENT_GU

	INNER JOIN
	rev.EPC_SCH AS SCHOOL
	ON
	STUDENT_SNAPSHOT.[LOCATION CODE] = SCHOOL.SCHOOL_CODE

WHERE
	[DISTRICT CODE] = '001'
	AND [Period] = '2015-03-01'
		
GROUP BY 
	[LOCATION CODE]
	) AS T3
ON
T3.[LOCATION CODE] = SCH.SCHOOL_CODE


LEFT JOIN
(SELECT ORGANIZATION_GU, COUNT(*) AS [Current Quarter 5/22/2015 no HLS] FROM 
APS.PrimaryEnrollmentsAsOf('2015-05-22') AS PRIM
LEFT JOIN
APS.LCEMostRecentHLSAsOf('2015-05-22') AS NOHLS
ON
PRIM.STUDENT_GU = NOHLS.STUDENT_GU
INNER JOIN
rev.REV_ORGANIZATION_YEAR AS ORGYR
ON
ORGYR.ORGANIZATION_YEAR_GU = PRIM.ORGANIZATION_YEAR_GU


WHERE
NOHLS.STUDENT_GU IS NULL

GROUP BY ORGANIZATION_GU
) AS T4

ON
T4.ORGANIZATION_GU = ORG.ORGANIZATION_GU
GROUP BY
CLUSTER

) 
*/
--------------------------------------------------------------------------------------------------------------------------------------

--WHERE
  --  [Cluster]=REPLACE(@Cluster,' High School','')

