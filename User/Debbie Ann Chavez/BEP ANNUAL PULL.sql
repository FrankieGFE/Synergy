/*
SELECT 

	ORGANIZATION_NAME
	,TEST_NAME
	,ADMIN_DATE
	,PROGRAM_MODEL 
	,GRADE
	,Beginning
	,CONVERT(INT,ROUND(COALESCE(CAST(Beginning AS DECIMAL)/NULLIF(CAST(Beginning + [Intermediate] + Proficient AS DECIMAL),0),0) * 100,0)) AS BPercentage
	,[Intermediate]
	,CONVERT(INT,ROUND(COALESCE(CAST([Intermediate] AS DECIMAL)/NULLIF(CAST(Beginning + [Intermediate] + Proficient AS DECIMAL),0),0) * 100,0)) AS IPercentage
	,Proficient
	,CONVERT(INT,ROUND(COALESCE(CAST(Proficient AS DECIMAL)/NULLIF (CAST(Beginning + [Intermediate] + Proficient AS DECIMAL),0),0) * 100,0)) AS PPercentage

FROM
(
*/
SELECT 
*
	FROM
(
SELECT 
	GRADEL.VALUE_DESCRIPTION AS GRADE 
	,GRADEL.VALUE_CODE
	,SIS_NUMBER
	,MODEL.VALUE_DESCRIPTION AS PROGRAM_MODEL
	,TEST_NAME
	,ADMIN_DATE

	,CASE	WHEN PL.VALUE_DESCRIPTION = 'FSP' THEN 'Proficient'
			WHEN PL.VALUE_DESCRIPTION = 'LSP' THEN 'Intermediate'
			WHEN PL.VALUE_DESCRIPTION = 'NSP' THEN 'Beginning'
			WHEN PL.VALUE_DESCRIPTION = 'Early Intermediate' THEN 'Intermediate'
			WHEN PL.VALUE_DESCRIPTION = 'Above Proficient' THEN 'Proficient'
	ELSE PL.VALUE_DESCRIPTION
	END AS PERFORMANCE_LEVEL
	
	,ORGANIZATION_NAME
	

FROM

	(
	SELECT DISTINCT
		STUDENT_GU
		,PROGRAM_CODE
	FROM
		REV.EPC_STU_PGM_ELL_BEP
	) AS BEP

	INNER JOIN
	rev.EPC_STU AS STU
	ON
	BEP.STUDENT_GU = STU.STUDENT_GU
	LEFT JOIN
	APS.LCELatestSpanishEvaluationAsOf(GETDATE()) AS TESTS
	ON
	STU.STUDENT_GU = TESTS.STUDENT_GU
	LEFT JOIN
	APS.LookupTable ('K12.TestInfo','PERFORMANCE_LEVELS') AS PL
	ON
	PL.VALUE_CODE = TESTS.PERFORMANCE_LEVEL

	INNER JOIN
	rev.EPC_STU_YR AS SSY
	ON
	SSY.STUDENT_GU = STU.STUDENT_GU
	AND SSY.YEAR_GU = (SELECT * FROM rev.SIF_22_Common_CurrentYearGU)

	INNER JOIN
	rev.EPC_STU_SCH_YR AS SSY2
	ON
	SSY2.STUDENT_SCHOOL_YEAR_GU = SSY.STU_SCHOOL_YEAR_GU

	INNER JOIN
	APS.LookupTable ('K12', 'GRADE') AS GRADEL
	ON
	GRADEL.VALUE_CODE = SSY2.GRADE

	INNER JOIN
	rev.REV_ORGANIZATION_YEAR AS ORGYR
	ON
	SSY2.ORGANIZATION_YEAR_GU = ORGYR.ORGANIZATION_YEAR_GU

	INNER JOIN
	rev.REV_ORGANIZATION AS ORG
	ON
	ORGYR.ORGANIZATION_GU = ORG.ORGANIZATION_GU

	INNER JOIN
	APS.LookupTable ('K12.ProgramInfo', 'BEP_PROGRAM_CODE') AS MODEL
	ON
	BEP.PROGRAM_CODE = MODEL.VALUE_CODE

WHERE
	ADMIN_DATE > '2014-08-01'

--ORDER BY SIS_NUMBER

) AS T1
/*
PIVOT 
(
COUNT(SIS_NUMBER)
FOR PERFORMANCE_LEVEL IN ([Beginning], [Intermediate], [Proficient])
) AS
PVT

--GROUP BY ORGANIZATION_NAME, PROGRAM_MODEL, GRADE, PERFORMANCE_LEVEL 

) AS T2

*/
ORDER BY ORGANIZATION_NAME, PROGRAM_MODEL, VALUE_CODE