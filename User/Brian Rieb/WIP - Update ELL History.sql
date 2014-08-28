/*
 * Brian Rieb
 * 8/28/2014
 */
 
-- Add Procedure if it does not exist
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[UpdateELLHistory]') AND type in (N'P', N'PC'))
	EXEC ('CREATE PROCEDURE [APS].UpdateELLHistory AS SELECT 0')
GO

/**
 * STORED PROCEDURE APS.UpdateELLHistory
 * Creates or closes ELL History based on ELL Calculated As OF (most recent assessments
 * Also updates or creates a main ell record based on this new history.
 *
 * NOTE: This does not update exit year status.  This is something we will **probably* want to do once a year?
 *
 * Tables Used: ELLCalculatedAsOf, ELLAsOf, EPC_STU_PGM_ELL_HIS, PHLOTEAsOf, PrimaryEnrollmentsAsOf
 *
 * #param INT @ValidateOnly Whether to commit changes or not. If value = 1 then rollback changes.  
 *                          Any other value commits changes
 */
ALTER PROC [APS].[UpdateELLHistory](
	@ValidateOnly INT
)

AS
BEGIN

-- (Frank is loading records right now)
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- First, The ones we need to add to ELL Transactions
-- ----------------------------------------------------------------------------------
BEGIN TRANSACTION

INSERT INTO
	rev.EPC_STU_PGM_ELL_HIS
	(
	STU_PGM_ELL_HIS_GU
	,STUDENT_GU
	,PROGRAM_CODE
	,ENTRY_DATE
	,ELL_GRADE
	,ADD_DATE_TIME_STAMP
	)

SELECT
	NEWID() AS STU_PGM_ELL_HIS_GU
	,CalculatedELL.STUDENT_GU
	,1 AS PROGRAM_CODE
	,ADMIN_DATE AS ENTRY_DATE
	,CalculatedELL.GRADE AS ELL_GRADE
	,GETDATE() ADD_DATE_TIME_STAMP
FROM
	-- ALL ELL Kiddos
	APS.ELLCalculatedAsOf(GETDATE()) As CalculatedELL
	LEFT JOIN
	-- Current ELL Status
	APS.ELLAsOf(GETDATE()) AS ELL
	ON
	CalculatedELL.STUDENT_GU = ELL.STUDENT_GU

	LEFT JOIN
	APS.PHLOTEAsOf(GETDATE()) AS PHLOTE
	ON
	CalculatedELL.STUDENT_GU = PHLOTE.STUDENT_GU
WHERE
	(
	ELL.STUDENT_GU IS NULL
	OR ELL.LEAVE_DATE IS NOT NULL
	)
	AND PHLOTE.STUDENT_GU IS NOT NULL

-- Then the onese we need to close. We may need to 
-- join in MostRecent ELL To get the STU_PGM_ELL_HIS_GU (for the record we are actually going to update)
-- ----------------------------------------------------------------------------------

UPDATE 
	EllHistory
SET
	EXIT_DATE = ADMIN_DATE
	,EXIT_REASON = 'EY1' -- Always Exit Year 1
	,CHANGE_DATE_TIME_STAMP = GETDATE()
FROM
	APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enroll
	INNER JOIN
	APS.ELLAsOf(GETDATE()) AS ELL
	ON
	Enroll.STUDENT_GU = ELL.STUDENT_GU

	-- need to re-get that last record, cuz that is the one we will be closing (updating)
	INNER JOIN
	rev.EPC_STU_PGM_ELL_HIS AS ELLHistory
	ON
	ELL.STU_PGM_ELL_HIS_GU = ELLHistory.STU_PGM_ELL_HIS_GU

	LEFT JOIN
	APS.ELLCalculatedAsOf(GETDATE()) AS CalculatedELL
	ON
	Enroll.STUDENT_GU = CalculatedELL.STUDENT_GU


WHERE
	CalculatedELL.STUDENT_GU IS NULL

-- Lastly, need to update(or create) all the ELL records to match most recent ELL History
-- ----------------------------------------------------------------------------------
EXEC APS.ELLStatFromELLHistory @ValidateOnly

--Validation Check to see how many records will be processed, 0 = INSERT AND UPDATE, 1 = ROLLBACK - WILL NOT - UPDATE/INSERT
IF @ValidateOnly = 0
	BEGIN
		COMMIT 
	END
ELSE
	BEGIN
		ROLLBACK
	END
END -- END SPROC