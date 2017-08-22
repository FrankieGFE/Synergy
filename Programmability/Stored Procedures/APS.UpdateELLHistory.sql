USE [ST_Production]
GO

/****** Object:  StoredProcedure [APS].[UpdateELLHistory]    Script Date: 8/17/2017 11:38:17 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/**
 * STORED PROCEDURE APS.UpdateELLHistory
 * Creates or closes ELL History based on ELL Calculated As OF (most recent assessments
 * Also updates or creates a main ell record based on this new history.
 *
 * NOTE: This does not CLOSE OUT ANY ELL RECORDS OR CREATE EXIT YEAR RECORDS.
 *
 * 
 * #param INT @ValidateOnly Whether to commit changes or not. If value = 1 then rollback changes.  
 *                          Any other value commits changes
 */
ALTER PROC [APS].[UpdateELLHistory](
	@ValidateOnly INT
)

AS
BEGIN


-- Create ELL Record if it does not exist, students enroll nightly and some may be ELL because of their last WAPT/SCREENER/PRE-LAS assessment
-- ------------------------------------------------------------------------------------------------------------------------------------------

BEGIN TRANSACTION

INSERT INTO
	rev.EPC_STU_PGM_ELL_HIS
	(
	STU_PGM_ELL_HIS_GU
	,STUDENT_GU
	,PROGRAM_CODE
	,PROGRAM_QUALIFICATION
	,ENTRY_DATE
	,ELL_GRADE
	,ADD_DATE_TIME_STAMP
	,ADD_ID_STAMP
	)

SELECT
	NEWID() AS STU_PGM_ELL_HIS_GU
	,CalculatedELL.STUDENT_GU
	,'1' AS PROGRAM_CODE
	,'1' AS PROGRAM_QUALIFICATION
	,ADMIN_DATE AS ENTRY_DATE
	,CalculatedELL.GRADE AS ELL_GRADE
	,GETDATE() ADD_DATE_TIME_STAMP
	,'96870498-10C3-4D16-8B11-27BA3651C2CE' AS ADD_ID_STAMP
FROM
	APS.ELLCalculatedAsOf(GETDATE()) As CalculatedELL
	LEFT JOIN
	(SELECT DISTINCT STUDENT_GU FROM REV.EPC_STU_PGM_ELL_HIS) AS ELL
	ON
	CalculatedELL.STUDENT_GU = ELL.STUDENT_GU

WHERE
	ELL.STUDENT_GU IS NULL
	


--Validation Check to see how many records will be processed, 0 = INSERT AND UPDATE, 1 = ROLLBACK - WILL NOT - UPDATE/INSERT
IF @ValidateOnly = 0
	BEGIN
		COMMIT 
	END
ELSE
	BEGIN
		ROLLBACK
	END
	
		
-- These 2 STORED PROCEDURES NEED TO BE RUN AFTER ELL RECORD HAS BEEN CREATED 
--need to be done outside other transaction (can't have transactions within transactions.


--  Update Participation Status for ELL Students
EXEC APS.UpdateELLParticipationStatus @ValidateOnly


-- Lastly, update or create ELL table with most recent record from ELL History
-- ----------------------------------------------------------------------------------
EXEC APS.ELLStatFromELLHistory @ValidateOnly


END -- END SPROC

GO


