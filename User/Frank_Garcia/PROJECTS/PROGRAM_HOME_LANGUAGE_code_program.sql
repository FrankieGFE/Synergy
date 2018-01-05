USE ST_Production
GO

SELECT 
	CAST(VALUE_CODE AS INT) AS program_code
	,VALUE_DESCRIPTION + ' (H'+ CAST(CAST(VALUE_CODE AS INT)AS VARCHAR(4))+')' AS program_name 
	,'Home' AS program_type_code
	,'N' AS gifted_program_code
	,'N' AS special_ed_program
	,'N' AS lep_program
FROM
	APS.LookupTable ('K12', 'Language')
WHERE VALUE_CODE != 54
ORDER BY VALUE_CODE
