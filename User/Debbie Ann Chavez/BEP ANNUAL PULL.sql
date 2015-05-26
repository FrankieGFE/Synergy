
/*
	CREATED BY:  DEBBIE ANN CHAVEZ
	DATE:  5/7/2015

	--
*/

EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT 
	THEWHOLEENCHILADA.ORGANIZATION_NAME
	,TEST_NAME
	,ADMIN_DATE
	,THEWHOLEENCHILADA.PROGRAM_MODEL
	,GRADE
	,Beginning
	,BPercentage
	,[Intermediate]
	,IPercentage
	,Proficient
	,PPercentage
	,Total_Proficient
	,THEWHOLEENCHILADA.ORDERME
FROM
		(
		SELECT 
			ORGANIZATION_NAME
			,TEST_NAME
			,ADMIN_DATE
			,PROGRAM_MODEL
			,GRADE
			,CASE WHEN Beginning IS NULL THEN 0 ELSE Beginning END AS Beginning
			,CASE WHEN BPercentage IS NULL THEN 0 ELSE BPercentage END AS  BPercentage
			,CASE WHEN [Intermediate] IS NULL THEN 0 ELSE [Intermediate] END AS [Intermediate]
			,CASE WHEN IPercentage IS NULL THEN 0 ELSE IPercentage END AS IPercentage
			,CASE WHEN Proficient IS NULL THEN 0 ELSE Proficient END AS Proficient
			,CASE WHEN PPercentage IS NULL THEN 0 ELSE PPercentage END AS PPercentage
			,ORDERME
		 FROM
		(
		SELECT 
			FILLERJOIN.ORGANIZATION_NAME
			,'SP-LAS-LINKS' AS TEST_NAME
			,ADMIN_DATE
			,FILLERJOIN.PROGRAM_MODEL 
			,FILLERJOIN.GRADE
			,Beginning
			,CONVERT(INT,ROUND(COALESCE(CAST(Beginning AS DECIMAL)/NULLIF(CAST(Beginning + [Intermediate] + Proficient AS DECIMAL),0),0) * 100,0)) AS BPercentage
			,[Intermediate]
			,CONVERT(INT,ROUND(COALESCE(CAST([Intermediate] AS DECIMAL)/NULLIF(CAST(Beginning + [Intermediate] + Proficient AS DECIMAL),0),0) * 100,0)) AS IPercentage
			,Proficient
			,CONVERT(INT,ROUND(COALESCE(CAST(Proficient AS DECIMAL)/NULLIF (CAST(Beginning + [Intermediate] + Proficient AS DECIMAL),0),0) * 100,0)) AS PPercentage
			,FILLERJOIN.ORDERME
		FROM
		(

		SELECT 
		*
			FROM
		(
		SELECT 
			GRADEL.VALUE_DESCRIPTION AS GRADE 
			,GRADEL.VALUE_CODE AS ORDERME
			,SIS_NUMBER
			,MODEL.VALUE_DESCRIPTION AS PROGRAM_MODEL
			,TEST_NAME
			,'2014-2015'

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
			SELECT 
			STUDENT_GU
			,PROGRAM_CODE 
			FROM(
			SELECT 
				STUDENT_GU
				,PROGRAM_CODE
				,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY ENTER_DATE DESC) AS RN
			FROM
				REV.EPC_STU_PGM_ELL_BEP
			)AS MOSTRECENTBEP
			WHERE
			RN = 1
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


		PIVOT 
		(
		COUNT(SIS_NUMBER)
		FOR PERFORMANCE_LEVEL IN ([Beginning], [Intermediate], [Proficient])
		) AS
		PVT

		) AS T2

		/*--------------------------------------------------------------------------------------------------------------------------------------

		DO FILLERS

		---------------------------------------------------------------------------------------------------------------------------------------*/
		RIGHT JOIN 

		(
		SELECT 
			ORGANIZATION_NAME
			,PROGRAM_MODEL
			,GRADE
			,ORDERME
		FROM

					OPENROWSET (
						  'Microsoft.ACE.OLEDB.12.0', 
						  'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
						  'SELECT * from DISTINCTBEPSCHOOLS.csv'
						) AS BEP

		RIGHT JOIN
		(SELECT VALUE_DESCRIPTION AS GRADE, 1 AS ONE, VALUE_CODE AS ORDERME	
		 FROM
		APS.LookupTable ('K12', 'GRADE')
		WHERE
		VALUE_CODE BETWEEN '100' AND '220'
		) AS GOODGRADES

		ON
		BEP.TWO = GOODGRADES.ONE
		) AS FILLERJOIN

		ON
		T2.ORGANIZATION_NAME = FILLERJOIN.ORGANIZATION_NAME
		AND T2.PROGRAM_MODEL = FILLERJOIN.PROGRAM_MODEL
		AND T2.GRADE = FILLERJOIN.GRADE
		) AS THEWHOLEENCHILAD
		) AS THEWHOLEENCHILADA




/*------------------------------------------------------------------------------------------------------------------------------------------------------------

CALCULATE PROFICIENCY TOTALS
------------------------------------------------------------------------------------------------------------------------------------------------------------*/

INNER JOIN 
(
SELECT 
	--ORGANIZATION_NAME AS 
	ORGNAME
	--,PROGRAM_MODEL  AS 
	,PROGMODEL
	,SUM(Proficient) AS Total_Proficient

FROM
(SELECT 
	ORGANIZATION_NAME AS ORGNAME
	,TEST_NAME
	,ADMIN_DATE
	,PROGRAM_MODEL AS PROGMODEL
	,GRADE
	,CASE WHEN Beginning IS NULL THEN 0 ELSE Beginning END AS Beginning
	,CASE WHEN BPercentage IS NULL THEN 0 ELSE BPercentage END AS  BPercentage
	,CASE WHEN [Intermediate] IS NULL THEN 0 ELSE [Intermediate] END AS [Intermediate]
	,CASE WHEN IPercentage IS NULL THEN 0 ELSE IPercentage END AS IPercentage
	,CASE WHEN Proficient IS NULL THEN 0 ELSE Proficient END AS Proficient
	,CASE WHEN PPercentage IS NULL THEN 0 ELSE PPercentage END AS PPercentage

 FROM
(
SELECT 
	FILLERJOIN.ORGANIZATION_NAME
	,'SP-LAS-LINKS' AS TEST_NAME
	,ADMIN_DATE
	,FILLERJOIN.PROGRAM_MODEL 
	,FILLERJOIN.GRADE
	,Beginning
	,CONVERT(INT,ROUND(COALESCE(CAST(Beginning AS DECIMAL)/NULLIF(CAST(Beginning + [Intermediate] + Proficient AS DECIMAL),0),0) * 100,0)) AS BPercentage
	,[Intermediate]
	,CONVERT(INT,ROUND(COALESCE(CAST([Intermediate] AS DECIMAL)/NULLIF(CAST(Beginning + [Intermediate] + Proficient AS DECIMAL),0),0) * 100,0)) AS IPercentage
	,Proficient
	,CONVERT(INT,ROUND(COALESCE(CAST(Proficient AS DECIMAL)/NULLIF (CAST(Beginning + [Intermediate] + Proficient AS DECIMAL),0),0) * 100,0)) AS PPercentage

FROM
(

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
	,'2014-2015'

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
	SELECT 
	STUDENT_GU
	,PROGRAM_CODE 
	FROM(
	SELECT 
		STUDENT_GU
		,PROGRAM_CODE
		,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY ENTER_DATE DESC) AS RN
	FROM
		REV.EPC_STU_PGM_ELL_BEP
	)AS MOSTRECENTBEP
	WHERE
	RN = 1
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


PIVOT 
(
COUNT(SIS_NUMBER)
FOR PERFORMANCE_LEVEL IN ([Beginning], [Intermediate], [Proficient])
) AS
PVT

) AS T2

/*--------------------------------------------------------------------------------------------------------------------------------------

DO FILLERS

---------------------------------------------------------------------------------------------------------------------------------------*/
RIGHT JOIN 

(
SELECT 
	ORGANIZATION_NAME
	,PROGRAM_MODEL
	,GRADE
	,ORDERME
FROM

            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                  'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
                  'SELECT * from DISTINCTBEPSCHOOLS.csv'
                ) AS BEP

RIGHT JOIN
(SELECT VALUE_DESCRIPTION AS GRADE, 1 AS ONE, VALUE_CODE AS ORDERME	
 FROM
APS.LookupTable ('K12', 'GRADE')
WHERE
VALUE_CODE BETWEEN '100' AND '220'
) AS GOODGRADES

ON
BEP.TWO = GOODGRADES.ONE
) AS FILLERJOIN

ON
T2.ORGANIZATION_NAME = FILLERJOIN.ORGANIZATION_NAME
AND T2.PROGRAM_MODEL = FILLERJOIN.PROGRAM_MODEL
AND T2.GRADE = FILLERJOIN.GRADE

) AS THEWHOLEENCHILADAWITHBEANS

) AS THEWHOLEENCHILADAWITHBEANSANDRICE
GROUP BY 
ORGNAME
,PROGMODEL
) AS THEWHOLEENCHILADADWITHBEANSRICEANDCORN

ON
THEWHOLEENCHILADA.ORGANIZATION_NAME = THEWHOLEENCHILADADWITHBEANSRICEANDCORN.ORGNAME
AND THEWHOLEENCHILADA.PROGRAM_MODEL = THEWHOLEENCHILADADWITHBEANSRICEANDCORN.PROGMODEL


ORDER BY ORGANIZATION_NAME,PROGRAM_MODEL,ORDERME


      REVERT
GO