/* Brian Rieb
 * 8/20/2014
 *
 * Pulls ELL History Records for students that have multiple ELL History records
 */
SELECT
	Student.SIS_NUMBER AS [Student ID]
	,CONVERT(VARCHAR, ELLHistory.ENTRY_DATE, 101) AS [Entry Date]
	,CONVERT(VARCHAR, ELLHistory.EXIT_DATE, 101) AS [Exit Date]
	,ELLHistory.EXIT_REASON AS [Exit Reason Code]
FROM
	(
	SELECT
		DISTINCT STUDENT_GU
	FROM
		(
		SELECT
			*
			,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY ENTRY_DATE) AS RN
		FROM
			rev.EPC_STU_PGM_ELL_HIS AS ELLHistory
		) AS ELLHistRN
	WHERE
		RN >1
	) AS DupStudents

	INNER JOIN
	rev.EPC_STU AS Student
	ON
	DupStudents.STUDENT_GU = Student.STUDENT_GU
	
	INNER JOIN
	rev.EPC_STU_PGM_ELL_HIS AS ELLHistory
	ON
	DupStudents.STUDENT_GU = ELLHistory.STUDENT_GU

	INNER JOIN
	APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enroll
	ON
	DupStudents.STUDENT_GU = Enroll.STUDENT_GU

ORDER BY
	[Student ID]
	,ENTRY_DATE