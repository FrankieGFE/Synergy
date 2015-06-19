/**
 * $Revision: 1 $
 * $LastChangedBy: e104090 $
 * $LastChangedDate: 2015-05-22 $
 */


 /*  
	1.  Must change the last day of school it is hardcoded.


 */


IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[APS].[LCEALS1A]'))
	EXEC ('CREATE VIEW APS.LCEALS1A AS SELECT 0 AS DUMMY')
GO

ALTER VIEW APS.LCEALS1A AS


SELECT 
--SCHOOL_CODE, ORGANIZATION_NAME, K12_STUS 
	*
FROM 

(
SELECT 
	SCHOOL.SCHOOL_CODE AS [School Number]
	,ORG.ORGANIZATION_NAME AS [School Name]
	,CLUSTERNAME.ORGANIZATION_NAME AS Cluster
	,COUNT(*) AS [K12 Stus] 
	,COUNT(PHL.STUDENT_GU) AS PHLOTE 
	,SUM(CASE WHEN HLS.STUDENT_GU IS NULL THEN 1 ELSE 0 END) AS [No HLS]
	
	,SUM(CASE WHEN ELL.STUDENT_GU IS NOT NULL THEN 1 ELSE 0 END) AS [Total ELL]
	,SUM(CASE WHEN KINDERWAPT.STUDENT_GU IS NOT NULL THEN 1 ELSE 0 END) AS ELL

	,SUM(CASE WHEN NEW_PERFORMANCE_LEVEL.STUDENT_GU IS NOT NULL AND NEW_PERFORMANCE_LEVEL.NEW_PERFORMANCE_LEVEL = 'Entering' THEN 1 ELSE 0 END) AS Entering
	,SUM(CASE WHEN NEW_PERFORMANCE_LEVEL.STUDENT_GU IS NOT NULL AND NEW_PERFORMANCE_LEVEL.NEW_PERFORMANCE_LEVEL = 'Emerging' THEN 1 ELSE 0 END) AS Emerging
	,SUM(CASE WHEN NEW_PERFORMANCE_LEVEL.STUDENT_GU IS NOT NULL AND NEW_PERFORMANCE_LEVEL.NEW_PERFORMANCE_LEVEL = 'Developing' THEN 1 ELSE 0 END) AS Developing
	,SUM(CASE WHEN NEW_PERFORMANCE_LEVEL.STUDENT_GU IS NOT NULL AND NEW_PERFORMANCE_LEVEL.NEW_PERFORMANCE_LEVEL = 'Expanding' THEN 1 ELSE 0 END) AS Expanding
	,SUM(CASE WHEN NEW_PERFORMANCE_LEVEL2.STUDENT_GU IS NOT NULL AND NEW_PERFORMANCE_LEVEL2.FEPLEVEL = 'FEP Bridging/Reaching' THEN 1 ELSE 0 END) AS [FEP Bridging/Reaching]

 FROM
APS.PrimaryEnrollmentsAsOf('2015-05-22')AS PE
INNER JOIN
rev.REV_ORGANIZATION_YEAR AS ORGYR
ON
PE.ORGANIZATION_YEAR_GU = ORGYR.ORGANIZATION_YEAR_GU
INNER JOIN
rev.REV_ORGANIZATION AS ORG
ON
ORGYR.ORGANIZATION_GU = ORG.ORGANIZATION_GU
INNER JOIN
rev.EPC_SCH AS SCHOOL
ON
SCHOOL.ORGANIZATION_GU = ORG.ORGANIZATION_GU

------------------------------------------------
INNER JOIN
rev.EPC_SCH AS CLUSTER
ON
SCHOOL.ALT_FUNDING_SCHOOL_CODE = CLUSTER.SCHOOL_CODE

INNER JOIN
rev.REV_ORGANIZATION AS CLUSTERNAME
ON
CLUSTER.ORGANIZATION_GU = CLUSTERNAME.ORGANIZATION_GU
-----------------------------------------------------------

LEFT JOIN
APS.PHLOTEAsOf('2015-05-22') AS PHL
ON
PHL.STUDENT_GU = PE.STUDENT_GU

LEFT JOIN
APS.LCEMostRecentHLSAsOf('2015-05-22') AS HLS
ON
HLS.STUDENT_GU = PE.STUDENT_GU

----------------------COUNT ONLY THE ELL STUDENTS IN THE ESL REPORT----------------------------
LEFT JOIN
(
	SELECT 
		ELLALL.* 
	FROM 
	APS.ELLAsOf('2015-05-22') AS ELLALL
	INNER JOIN
	rev.EPC_STU AS STU
	ON
	ELLALL.STUDENT_GU = STU.STUDENT_GU

	INNER JOIN
	(
	SELECT 
			*
	FROM 
	(
	SELECT 
			*
			,ROW_NUMBER() OVER (PARTITION BY SIS_NUMBER ORDER BY STATUS DESC) AS RN
	 FROM 
	APS.LCEStudentsAndProvidersAsOf('2015-05-22')

	) AS T1
	WHERE RN =1
	) AS ESLNODUPS
	ON
	STU.SIS_NUMBER = ESLNODUPS.SIS_NUMBER
) AS ELL

ON
ELL.STUDENT_GU = PE.STUDENT_GU

-------------------------------------------------------------------------------------------------
--GET KINDER WAPTS
LEFT JOIN

		(SELECT 
			SIS_NUMBER
			,GRADE
			,TEST_NAME
			,STUDENT_GU
		FROM
		(
		SELECT 
			ORG.ORGANIZATION_NAME
			,GRADES.VALUE_DESCRIPTION AS GRADE
			,STU.SIS_NUMBER
			,PERS.LAST_NAME
			,PERS.FIRST_NAME
			,TESTS.TEST_NAME
			,TESTS.PERFORMANCE_LEVEL
			,SCORES.TEST_SCORE
			,SCORETDEF.SCORE_DESCRIPTION
			,STU.STUDENT_GU
	
		FROM
			APS.LCELatestEvaluationAsOf ('2015-06-30') AS TESTS
			INNER JOIN
			rev.EPC_STU AS STU
			ON
			STU.STUDENT_GU = TESTS.STUDENT_GU
			------------------------------------------------------------------------------------
			--GET ONLY KINDER WAPTS IN THE ESL REPORT
			INNER JOIN
			(
						SELECT 
					*
			FROM 
			(
			SELECT 
					*
					,ROW_NUMBER() OVER (PARTITION BY SIS_NUMBER ORDER BY STATUS DESC) AS RN
			 FROM 
			APS.LCEStudentsAndProvidersAsOf('2015-05-22')

			) AS T1
			WHERE RN =1
			) AS ESL
			ON
			ESL.SIS_NUMBER = STU.SIS_NUMBER
			----------------------------------------------------------------------------------------

			INNER JOIN
			rev.REV_PERSON AS PERS
			ON
			PERS.PERSON_GU = STU.STUDENT_GU
			INNER JOIN
			APS.PrimaryEnrollmentsAsOf ('2015-05-22') AS PRIM
			ON
			PRIM.STUDENT_GU = TESTS.STUDENT_GU
			INNER JOIN
			rev.REV_ORGANIZATION_YEAR AS ORGYR
			ON
			ORGYR.ORGANIZATION_YEAR_GU = PRIM.ORGANIZATION_YEAR_GU
			INNER JOIN
			rev.REV_ORGANIZATION AS ORG
			ON
			ORG.ORGANIZATION_GU = ORGYR.ORGANIZATION_GU

			INNER JOIN
			APS.LookupTable ('K12','Grade') AS GRADES
			ON
			GRADES.VALUE_CODE = PRIM.GRADE

			INNER JOIN
			rev.EPC_STU_TEST_PART AS PARTS
			ON
			PARTS.STUDENT_TEST_GU = TESTS.STUDENT_TEST_GU

			INNER JOIN
			rev.EPC_STU_TEST_PART_SCORE AS SCORES
			ON
			SCORES.STU_TEST_PART_GU = PARTS.STU_TEST_PART_GU

			LEFT JOIN
			rev.EPC_TEST_SCORE_TYPE AS SCORET
			ON
			SCORET.TEST_GU = TESTS.TEST_GU
			AND SCORES.TEST_SCORE_TYPE_GU = SCORET.TEST_SCORE_TYPE_GU

			LEFT JOIN
			rev.EPC_TEST_DEF_SCORE AS SCORETDEF
			ON
			SCORETDEF.TEST_DEF_SCORE_GU = SCORET.TEST_DEF_SCORE_GU
	
			WHERE
			IS_ELL = 1

		) AS T1

		WHERE
			GRADE = 'K'
			AND TEST_NAME = 'WAPT'
		) AS KINDERWAPT

ON
PE.STUDENT_GU = KINDERWAPT.STUDENT_GU


----------------------------------------------------------------------------------------------------------
LEFT JOIN
		(
		SELECT 
			STU.STUDENT_GU
			,CASE WHEN VALUE_DESCRIPTION = 'Beginning' THEN 'Entering'
				  WHEN VALUE_DESCRIPTION = 'Early Intermediate' THEN 'Emerging'
				  WHEN VALUE_DESCRIPTION = 'ELL' THEN 'Entering'
				  WHEN VALUE_DESCRIPTION = 'Intermediate' THEN 'Expanding'
				  WHEN VALUE_DESCRIPTION = 'LEP' THEN 'Emerging'
				  WHEN VALUE_DESCRIPTION = 'NEP' THEN 'Entering'
			ELSE VALUE_DESCRIPTION END AS NEW_PERFORMANCE_LEVEL

		 FROM
		APS.LCELatestEvaluationAsOf('2015-05-22') AS LCE
		INNER JOIN
		APS.LookupTable('K12.TestInfo', 'PERFORMANCE_LEVELS') AS LEVEL
		ON
		LCE.PERFORMANCE_LEVEL = LEVEL.VALUE_CODE

		-----------------------------------------GIVE ME ONLY STUDENTS ON ESL REPORT--------------------
		INNER JOIN
		rev.EPC_STU AS STU
		ON
		LCE.STUDENT_GU = STU.STUDENT_GU

		INNER JOIN
		(
		SELECT 
		*
			FROM 
			(
			SELECT 
					*
					,ROW_NUMBER() OVER (PARTITION BY SIS_NUMBER ORDER BY STATUS DESC) AS RN
			 FROM 
			APS.LCEStudentsAndProvidersAsOf('2015-05-22')

			) AS T1
			WHERE RN =1
		 ) AS ESL


		ON
		ESL.SIS_NUMBER = STU.SIS_NUMBER
		--------------------------------------------------------------------------------------------------
		
		) AS NEW_PERFORMANCE_LEVEL
ON
PE.STUDENT_GU = NEW_PERFORMANCE_LEVEL.STUDENT_GU

----------------------------------------------------------------------------------------------------------
LEFT JOIN
		(
		SELECT 
			STUDENT_GU
			,CASE WHEN VALUE_DESCRIPTION = 'Advanced' THEN 'FEP Bridging/Reaching'
				  WHEN VALUE_DESCRIPTION = 'Bridging' THEN 'FEP Bridging/Reaching'
				  WHEN VALUE_DESCRIPTION = 'FEP' THEN 'FEP Bridging/Reaching'
				  WHEN VALUE_DESCRIPTION = 'Proficient' THEN 'FEP Bridging/Reaching'
				  WHEN VALUE_DESCRIPTION = 'Reaching' THEN 'FEP Bridging/Reaching'
			ELSE VALUE_DESCRIPTION END AS FEPLEVEL

		 FROM
		APS.LCELatestEvaluationAsOf('2015-05-22') AS LCE
		INNER JOIN
		APS.LookupTable('K12.TestInfo', 'PERFORMANCE_LEVELS') AS LEVEL
		ON
		LCE.PERFORMANCE_LEVEL = LEVEL.VALUE_CODE
		
		) AS NEW_PERFORMANCE_LEVEL2
ON
PE.STUDENT_GU = NEW_PERFORMANCE_LEVEL2.STUDENT_GU
--------------------------------------------------------------------------------------------------------------


--DO NOT COUNT PRESCHOOL - K-12 ONLY
--'050' = P1, '070' = P2, '090' = PK
WHERE
	PE.GRADE NOT IN ('050', '070', '090')

GROUP BY 
	SCHOOL.SCHOOL_CODE
	,ORG.ORGANIZATION_NAME
	,CLUSTERNAME.ORGANIZATION_NAME
		
		
) AS K12STUS


UNION ALL

SELECT * FROM 
APS.LCEALS1ADISTRICT

--ORDER BY [School Name]
