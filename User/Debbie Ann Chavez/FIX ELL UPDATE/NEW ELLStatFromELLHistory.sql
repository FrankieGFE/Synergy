USE [ST_Production]
GO

/****** Object:  StoredProcedure [APS].[ELLStatFromELLHistory]    Script Date: 7/10/2017 12:48:15 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/**
 * STORED PROCEDURE APS.ELLStatFromELLHistory
 * Updates (or creates) Student's main ELL record based on their most recent ELL History record
 *
 * Tables Used: EPC_STU_PGM_ELL_HIS, 
 *
 * #param INT @ValidateOnly Whether to commit changes or not. If value = 1 then rollback changes.  
 *                          Any other value commits changes
 */
CREATE PROC [APS].[ELLStatFromELLHistory](
	@ValidateOnly INT
)

AS
BEGIN

BEGIN TRANSACTION
-- If They exist, update their status
UPDATE
	ELL
SET
	ELL.ENTRY_DATE = MostRecentELLHistory.ENTRY_DATE
	,ELL.EXIT_DATE = MostRecentELLHistory.EXIT_DATE
	,ELL.EXIT_REASON = MostRecentELLHistory.EXIT_REASON
	,ELL.PROGRAM_CODE = MostRecentELLHistory.PROGRAM_CODE
	,ELL.PROGRAM_QUALIFICATION = MostRecentELLHistory.PROGRAM_QUALIFICATION
FROM
	-- Most Recent ELL History Record
	(
	SELECT
		STUDENT_GU
		,ENTRY_DATE
		,PROGRAM_CODE
		,PROGRAM_QUALIFICATION
		,EXIT_DATE
		,EXIT_REASON
	FROM
		(
		SELECT
			STUDENT_GU
			,ENTRY_DATE
			,PROGRAM_CODE
			,PROGRAM_QUALIFICATION
			,EXIT_DATE
			,EXIT_REASON
			,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY COALESCE(EXIT_DATE, CONVERT(DATE, GETDATE())) DESC) AS RN
		FROM
			Rev.EPC_STU_PGM_ELL_HIS
		)AS ELLHistory
	WHERE
		RN =1
	) AS MostRecentELLHistory

	INNER JOIN
	rev.EPC_STU_PGM_ELL AS ELL
	ON
	MostRecentELLHistory.STUDENT_GU = ELL.STUDENT_GU
WHERE

	COALESCE(ELL.ENTRY_DATE,'1976-10-20') != COALESCE(MostRecentELLHistory.ENTRY_DATE,'1976-10-20')
	OR COALESCE(ELL.EXIT_DATE,'1976-10-20') != COALESCE(MostRecentELLHistory.EXIT_DATE,'1976-10-20')
	OR COALESCE(ELL.EXIT_REASON,'') != COALESCE(MostRecentELLHistory.EXIT_REASON,'')
	OR COALESCE(ELL.PROGRAM_CODE,'') != COALESCE(MostRecentELLHistory.PROGRAM_CODE,'')

-- ------------------------------------------------------------------------------------------------------------------------------
-- IF They dont exist, create the ELL Record
-- May need to expand this to have better dfaults for other fields, but as of right now, the insert
-- does not fail
INSERT INTO
	rev.EPC_STU_PGM_ELL
	(
	STUDENT_GU
	,ENTRY_DATE
	,PROGRAM_CODE
	,PROGRAM_QUALIFICATION
	,EXIT_DATE
	,EXIT_REASON
	)
SELECT
	MostRecentELLHistory.STUDENT_GU
	,MostRecentELLHistory.ENTRY_DATE
	,MostRecentELLHistory.PROGRAM_CODE
	,MostRecentELLHistory.PROGRAM_QUALIFICATION
	,MostRecentELLHistory.EXIT_DATE
	,MostRecentELLHistory.EXIT_REASON
FROM
	-- Most Recent ELL History Record
	(
	SELECT
		STUDENT_GU
		,ENTRY_DATE
		,PROGRAM_CODE
		,PROGRAM_QUALIFICATION
		,EXIT_DATE
		,EXIT_REASON
	FROM
		(
		SELECT
			STUDENT_GU
			,ENTRY_DATE
			,PROGRAM_CODE
			,PROGRAM_QUALIFICATION
			,EXIT_DATE
			,EXIT_REASON
			,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY COALESCE(EXIT_DATE, CONVERT(DATE, GETDATE())) DESC) AS RN
		FROM
			Rev.EPC_STU_PGM_ELL_HIS
		)AS ELLHistory
	WHERE
		RN =1
	) AS MostRecentELLHistory

	LEFT JOIN
	rev.EPC_STU_PGM_ELL AS ELL
	ON
	MostRecentELLHistory.STUDENT_GU = ELL.STUDENT_GU
WHERE
	-- record does not match
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
END -- END SPROC
GO


