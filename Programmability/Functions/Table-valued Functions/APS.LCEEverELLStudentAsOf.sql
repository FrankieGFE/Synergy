/*
 * Debbie Ann Chavez
 * 9/3/2014
 * 
 */
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[LCEEverELLStudentAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.LCEEverELLStudentAsOf()RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

/**
*	Reads rev.EPC_STU_PGM_ELL_HIS tables
*
*	If a record exists for a student in the ELL History table, then they were an ELL student at some point in time.
*	Can left join to this table to pull students that have NEVER been ELL.
*
 */
 
ALTER FUNCTION APS.LCEEverELLStudentAsOf(@asOfDate DATETIME)
RETURNS TABLE
AS
RETURN

			SELECT DISTINCT
				STUDENT_GU
			FROM
				rev.EPC_STU_PGM_ELL_HIS AS History
			WHERE
				History.ENTRY_DATE <= @asOfDate

	