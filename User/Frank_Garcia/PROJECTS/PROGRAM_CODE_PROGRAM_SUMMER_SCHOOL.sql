USE
SchoolNetDW
GO

SELECT
	DISTINCT 'SS'+[SCHOOL NBR] AS program_code
	,'SS - '+[SCHOOL NBR] AS program_name
	,'SS' AS program_type_code
	,'N' AS gifted_program
	,'N' AS speciel_ed_program
	,'N' AS iep_program

FROM
	SUMMER_SCHOOL_STUDENTS
WHERE [SCHOOL NBR] IS NOT NULL
ORDER BY program_code