SELECT
	*
FROM
	-- Enrollments
	APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enroll
	-- PHLOTE Students
	INNER JOIN
	APS.PHLOTEAsOf(GETDATE()) AS PHLOTE
	ON
	Enroll.STUDENT_GU = PHLOTE.STUDENT_GU
	-- Latest Assessment
	INNER JOIN
	APS.LCELatestEvaluationAsOf(GETDATE()) AS Assessment
	ON
	Enroll.STUDENT_GU = Assessment.STUDENT_GU
WHERE
	-- Only those where performance level qualifies them for ELL
	Assessment.IS_ELL = 1