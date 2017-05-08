USE [ST_Production]
GO

/****** Object:  StoredProcedure [APS].[UpdateHomeLanguage]    Script Date: 5/5/2017 11:59:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER PROC [APS].[UpdateHomeLanguage]

(
	@ValidateOnly INT
)


AS
BEGIN

BEGIN TRANSACTION

	UPDATE rev.EPC_STU
		SET HOME_LANGUAGE = UPDATESELECT.HOME_LANGUAGE, HOME_LANGUAGE_DATE = UPDATESELECT.DATE_ASSIGNED
			,CHANGE_DATE_TIME_STAMP = GETDATE() , CHANGE_ID_STAMP = '27CDCD0E-BF93-4071-94B2-5DB792BB735F'


	FROM
	(
	
	SELECT 
		STUDENT.STUDENT_GU
		,STURECORD.LANGUAGE_CODE AS HOME_LANGUAGE
		,DATE_ASSIGNED
	FROM
		rev.EPC_STU AS STUDENT

		/*********************************************************************************************************************************************
		--THIS PULLS STUDENTS WITH ALL ENGLISH HLS QUESTIONS AND IF THEY ANSWERED MORE THAN ONE QUESTION A DIFFERENT LANGUAGE, THE HIGHER COUNT WINS
		**********************************************************************************************************************************************/
		LEFT JOIN
		(
		SELECT
			ALLHLS.STUDENT_GU
			,ALLHLS.LANGUAGE_CODE 
			,DATE_ASSIGNED
		FROM

		--THIS PULLS ALL STUDENTS THAT HAVE NON ENGLISH RECORDS FOR THEIR MOST RECENT HLS RECORD
		--, AND PULLS THE GREATER OF THE ANSWERS TO DETERMINE HOME LANGUAGE FOR THE ** OLDPHLOTE AND NEW PHLOTE **
		(

		SELECT STUDENT_GU
				 ,LANGUAGE_CODE
				 ,DATE_ASSIGNED FROM (
			SELECT
				STUDENT_GU
				 ,LANGUAGE_CODE
				 ,DATE_ASSIGNED
				,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY STUDENT_GU) AS RN
			 FROM
				(

					SELECT
                           STUDENT_GU
                           ,LANGUAGE_CODE
                           ,COUNT(*) AS LANGCOUNT
						   ,DATE_ASSIGNED
                     FROM
									
									--READS MOST RECENT HLS OLDPHLOTE AND NEWPHLOTE
									------------------------------------------------------------------
									(
									   SELECT
											  *
									   FROM
											(                                  
											SELECT
												STUDENT_GU
												,Q1
												,Q2
												,Q3
												,Q4
												,Q5
												,Q6
													,Q7A
													,Q7B
													,Q7C
        										,DATE_ASSIGNED
											FROM
												APS.LCEMostRecentHLSAsOf(GETDATE())
											) AS HLS
                           			  UNPIVOT
											  (LANGUAGE_CODE FOR QUESTIONS IN 
													(Q1
													 ,Q2
													 ,Q3
													 ,Q4
													 ,Q5
													 ,Q6
													 ,Q7A
													 ,Q7B
													 ,Q7C)
											  ) AS T1
										) AS UNPIVOTS
										    GROUP BY
											   STUDENT_GU
											   ,LANGUAGE_CODE
											   ,DATE_ASSIGNED
										 ) AS GROUPS
										----------------------------------------------------------------
                           WHERE
                                LANGUAGE_CODE != '00' AND LANGUAGE_CODE != '') AS T21
								WHERE RN = 1
			--THIS PULLS THE STUDENTS THAT ANSWERED ALL QUESTIONS ENGLISH - OLD PHLOTE AND NEW PHLOTE
			UNION
			
              SELECT
                     STUDENT_GU
                     ,'00' 
					 ,DATE_ASSIGNED
              FROM
                     (
							 SELECT
								* 
							FROM
							APS.LCEMostRecentHLSAsOf(GETDATE())
					 
							WHERE
							 Q1 + Q2 + Q3 + Q4 + Q5 = '0000000000' OR
							( Q1  = 'N' AND
							 Q2 = 'N' AND
							 Q3 = 'N' AND
							 Q4 = 'N' AND
							 Q5 = 'N' AND
							 Q6 = 'N' AND
							 Q7A = '00' AND
							 Q7B = '00' AND
							 Q7C = '00'
							 )
					) AS WHY
		) AS ALLHLS


) STURECORD


ON
STUDENT.STUDENT_GU = STURECORD.STUDENT_GU

)UPDATESELECT

WHERE
UPDATESELECT.STUDENT_GU = rev.EPC_STU.STUDENT_GU
AND
( rev.EPC_STU.HOME_LANGUAGE IS NULL
OR rev.EPC_STU.HOME_LANGUAGE != UPDATESELECT.HOME_LANGUAGE)

----------------------------------------------------------------------------------------------------------------------------------------------
UPDATE rev.EPC_STU
	SET HOME_LANGUAGE = '54',CHANGE_DATE_TIME_STAMP = GETDATE() , CHANGE_ID_STAMP = '27CDCD0E-BF93-4071-94B2-5DB792BB735F'

FROM 
APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
LEFT JOIN
APS.LCEMostRecentHLSAsOf(GETDATE()) AS HLS
ON
PRIM.STUDENT_GU = HLS.STUDENT_GU
LEFT JOIN
APS.BasicStudent AS BS
ON
PRIM.STUDENT_GU = BS.STUDENT_GU

WHERE
HLS.DATE_ASSIGNED IS NULL
AND PRIM.STUDENT_GU = rev.EPC_STU.STUDENT_GU
------------------------------------------------------------------------------------------------------------------------------------------------


--Validation Check to see how many records will be processed, 0 = INSERT-WILL UPDATE, 1 = ROLLBACK-WILL NOT UPDATE
IF @ValidateOnly = 0
	BEGIN
		PRINT 'UPDATED HOME LANGUAGE'
		COMMIT 

	END
ELSE
	BEGIN
		PRINT 'HOME LANGUAGE NOT UPDATED'
		ROLLBACK
	END

/*
SELECT SIS_NUMBER, HOME_LANGUAGE, HOME_LANGUAGE_DATE FROM
rev.EPC_STU
WHERE HOME_LANGUAGE_DATE > CAST(LEFT(GETDATE(),11)AS DATE) 
*/

END


GO


