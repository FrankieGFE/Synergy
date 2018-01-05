BEGIN TRAN
--SELECT
--	*


UPDATE
	[META Schools without ESL services may 2014]
	--SET SBA = SBA.scaled_score
	SET DRA = DRA.FLD_PERFORMANCE_LVL

	FROM [META Schools without ESL services may 2014] AS META
	--JOIN
	--	SBA
	--	ON META.ID_NBR = SBA.student_code
	--	--WHERE META.GRDE IN ('3','4','5')
	--	WHERE SBA.test_section_name = 'READING'
	--	AND school_year = '2012'
	--	AND META.SBA = ''
	JOIN
		[046-WS02].DB_DRA.DBO.Results_1314 AS DRA
		ON DRA.FLD_ID_NBR = META.ID_NBR
		WHERE DRA.FLD_ASSESSMENTWINDOW = 'SPRING'
		AND META.GRDE IN ('K','1','2')


ROLLBACK
