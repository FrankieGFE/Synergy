USE
SchoolNetDW
GO

SELECT
	[PERM ID] AS student_code
	,'2014' AS school_year
	,[SCHOOL NBR] AS school_code
	,'SS-'+[SCHOOL NBR] AS program_code
	,'2015-06-21' AS date_enrolled
	,CONVERT(VARCHAR(10), NULL, 120) AS date_withdrawn
	,CONVERT(VARCHAR(10), NULL, 120) AS date_iep
	,CONVERT(VARCHAR(10), NULL, 120) AS date_iep_end
FROM
	SUMMER_SCHOOL_STUDENTS
WHERE [SCHOOL NBR] IS NOT NULL