
BEGIN TRANSACTION 

INSERT INTO
rev.EPC_STU_PGM_ELL_HIS 

([STU_PGM_ELL_HIS_GU]
      ,[STUDENT_GU]
      ,[PROGRAM_CODE]
      ,[ENTRY_DATE]
      ,[PARTICIPATION_STATUS]
      ,[EXIT_DATE]
      ,[EXIT_REASON]
      ,[ELL_GRADE]
      ,[LANGUAGE_ABILITY]
      ,[DES_CURRENT_CODE]
      ,[DES_CURRENT_DATE]
      ,[DOCUMENT_DATE]
      ,[DOCUMENT_NUMBER]
      ,[MAINSTREAM_ELIGIBILITY]
      ,[CHANGE_ID_STAMP]
      ,[CHANGE_DATE_TIME_STAMP]
      ,[ADD_DATE_TIME_STAMP]
      ,[ADD_ID_STAMP]
      ,[PROGRAM_QUALIFICATION]
	  )

SELECT 
	
	
	NEWID() AS STU_PGM_ELL_HIS_GU
	,STU.STUDENT_GU AS STUDENT_GU
	,1 AS PROGRAM_CODE
	,'2015-07-01' AS ENTRY_DATE
	,NULL AS PARTICAPATION_STATUS
	,'2015-08-13' AS EXIT_DATE
	,'EY1' AS EXIT_REASON
	,NULL AS ELL_GRADE
	,NULL AS LANGUAGE_ABILITY
	,NULL AS DES_CURRENT_CODE
	,NULL AS DES_CURRENT_DATE
	,NULL AS DOCUMENT_DATE
	,NULL AS DOCUMENT_NUMBER
	,NULL AS MAINSTREAM_ELIGIBILITY
	,NULL AS CHANGE_ID_STAMP
	,NULL AS CHANGE_DATE_TIME_STAMP
	,GETDATE() AS [ADD_DATE_TIME_STAMP]
    ,'27CDCD0E-BF93-4071-94B2-5DB792BB735F' AS [ADD_ID_STAMP]
	,1 AS PROGRAM_QUALIFICATION
		

--SELECT 
	--SIS_NUMBER, LASTTEST.PERFORMANCE_LEVEL, LASTTEST.TEST_NAME, LASTTEST.ADMIN_DATE
 
FROM 
APS.LCELatestEvaluationAsOf(GETDATE()) AS LASTTEST
INNER JOIN 
rev.EPC_STU AS STU 
ON
LASTTEST.STUDENT_GU = STU.STUDENT_GU
LEFT JOIN
rev.EPC_STU_PGM_ELL_HIS AS HISTORY
ON
STU.STUDENT_GU = HISTORY.STUDENT_GU

WHERE 
IS_ELL = 0
AND ADMIN_DATE BETWEEN '2014-07-01' AND '2015-07-01'
--AND HISTORY.STUDENT_GU IS NULL


ROLLBACK

/*
SELECT STU.SIS_NUMBER, HISTORY.*

 FROM 
rev.EPC_STU_PGM_ELL_HIS AS HISTORY
INNER JOIN 
rev.EPC_STU AS STU
ON
HISTORY.STUDENT_GU = STU.STUDENT_GU

WHERE 
	EXIT_DATE IS NOT NULL AND EXIT_REASON = 'EY1'
	AND HISTORY.ADD_ID_STAMP = '27CDCD0E-BF93-4071-94B2-5DB792BB735F'
*/