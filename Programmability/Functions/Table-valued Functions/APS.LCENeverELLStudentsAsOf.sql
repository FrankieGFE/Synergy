/*
 * Debbie Ann Chavez
 * 9/3/2014
 * 
 */
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[LCENeverELLStudentsAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.LCENeverELLStudentsAsOf()RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

/**
*	Reads APS.PrimaryEnrollmentsAsOf AND rev.EPC_STU_PGM_ELL_HIS tables
*
*	For students with a primary enrollment, pull students that have never been ELL
*
 */
 
ALTER FUNCTION APS.LCENeverELLStudentsAsOf(@asOfDate DATETIME)
RETURNS TABLE
AS
RETURN

	SELECT 
		Enroll.ENROLLMENT_GU
		,Enroll.STUDENT_GU
		,Enroll.ORGANIZATION_YEAR_GU
		,Enroll.STUDENT_SCHOOL_YEAR_GU
	 FROM
		APS.PrimaryEnrollmentsAsOf(@asOfDate) AS Enroll
		--read ELL History
		LEFT JOIN
		(
			SELECT
				STUDENT_GU
			FROM
				rev.EPC_STU_PGM_ELL_HIS AS History
			WHERE
				History.ENTRY_DATE <= @asOfDate
		) AS ELL
		ON 
		ELL.STUDENT_GU = Enroll.STUDENT_GU
	--pull students that have never had any kind of ELL History record
	WHERE
		ELL.STUDENT_GU IS NULL

	