USE [ST_Production]
GO
/****** Object:  UserDefinedFunction [APS].[StudentTestPARCC]    Script Date: 2/17/2016 11:09:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**
 * FUNCTION APS.StudentTestPARCC
 * 
 * This function pulls the highest PARCC score.  
 *		ENTER IN WHICH PARCC TEST NAME:  'PARCC HS ELA/L English 11'
 *
 *
 */
 



/*************************************************************
--PULL PARCC, JUST CHANGE TEST_NAME
TEST_NAME = 
'PARCC HS ELA/L English 11'
'PARCC HS Geometry'
'PARCC HS Algebra II'

*************************************************************/
DECLARE @PARCC_CNTS
	TABLE
		(
		SIS_NUMBER VARCHAR (50)
		,MATH VARCHAR (50)
		--,SCIENCE VARCHAR (50)
		,READING VARCHAR (50)
		)
INSERT INTO @PARCC_CNTS

SELECT 
		STUD_ID AS SIS_NUMBER
	   ,[PARCC HS Geometry] + [PARCC HS ALGEBRA II] AS MATH
       ,[ELA/L English 11] AS READING
	
FROM
(
SELECT 
       CAST (SIS_NUMBER AS INT) AS SIS_NUMBER
	   ,SIS_NUMBER AS STUD_ID
	   ,PART.PART_DESCRIPTION

FROM
       rev.EPC_STU_TEST AS StudentTest

       JOIN
       rev.EPC_TEST_PART AS PART
       ON StudentTest.TEST_GU = PART.TEST_GU

       JOIN
       rev.EPC_STU_TEST_PART AS STU_PART
       ON PART.TEST_PART_GU = STU_PART.TEST_PART_GU
       AND STU_PART.STUDENT_TEST_GU = StudentTest.STUDENT_TEST_GU

		INNER JOIN
		rev.EPC_STU_TEST_PART_SCORE AS SCORES
		ON
		SCORES.STU_TEST_PART_GU = STU_PART.STU_TEST_PART_GU

		LEFT JOIN
		rev.EPC_TEST_SCORE_TYPE AS SCORET
		ON
		SCORET.TEST_GU = StudentTest.TEST_GU
		AND SCORES.TEST_SCORE_TYPE_GU = SCORET.TEST_SCORE_TYPE_GU

		LEFT JOIN
		rev.EPC_TEST_DEF_SCORE AS SCORETDEF
		ON
		SCORETDEF.TEST_DEF_SCORE_GU = SCORET.TEST_DEF_SCORE_GU

       LEFT JOIN
       rev.EPC_TEST AS TEST
       ON TEST.TEST_GU = StudentTest.TEST_GU

       INNER JOIN
       rev.EPC_STU AS Student
       ON Student.STUDENT_GU = StudentTest.STUDENT_GU

       INNER JOIN
       rev.REV_PERSON AS Person
       ON Person.PERSON_GU = StudentTest.STUDENT_GU

WHERE
       TEST_NAME IN ('PARCC HS ELA/L English 11','PARCC HS Geometry','PARCC HS ALGEBRA II')

) AS T1
PIVOT
	(COUNT (SIS_NUMBER) FOR PART_DESCRIPTION IN ([PARCC HS Geometry],[PARCC HS Algebra II],[ELA/L English 11])) AS PARCC_CNT
--WHERE high = 1
--ORDER BY SIS_NUMBER

SELECT * FROM @PARCC_CNTS