BEGIN TRAN

SELECT
	DISTINCT student_code
	,benchmark_test_code
	,test_score
	,'2013' AS school_year
	,'Form 2' AS test_window
FROM
	Benchmark_Result
ORDER BY
	student_code	
		

ROLLBACK