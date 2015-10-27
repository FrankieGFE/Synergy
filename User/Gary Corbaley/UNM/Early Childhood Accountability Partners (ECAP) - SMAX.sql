

DECLARE @SCHOOLYEAR INT = 2014


SELECT
	CONVERT(VARCHAR(4),@SCHOOLYEAR-1) + '-' + CONVERT(VARCHAR(4),@SCHOOLYEAR) AS [SCHOOL YEAR]
	,[Student].[ID_NBR]
	,[Enrollments].[SCH_NBR]
	,[School].[SCH_NME]
	,[Enrollments].[BEG_ENR_DT]
	,[Enrollments].[END_ENR_DT]
	,[Enrollments].[END_STAT]
	,[Enrollments].[GRDE]
	
FROM
	(
	SELECT DISTINCT
		_Id,
		DST_NBR,
		SCH_YR,
		SCH_NBR,
		GRDE,
		ID_NBR,
		BEG_ENR_DT,
		END_ENR_DT,
		END_STAT
	FROM 
		(
		SELECT
			ST010._Id,
			ST010.DST_NBR,
			ST010.SCH_NBR,
			ST010.GRDE,
			ST010.ID_NBR,
			ST010.SCH_YR,
			ST010.BEG_ENR_DT,
			ST010.END_ENR_DT,
			ST010.END_STAT,
			ROW_NUMBER() OVER (PARTITION BY ST010.DST_NBR, ST010.ID_NBR ORDER BY ST010.BEG_ENR_DT DESC) AS RN
		FROM
			DBTSIS.ST010 WITH(NOLOCK) 
		WHERE
			  SCH_YR = @SCHOOLYEAR
			  AND NONADA_SCH != 'X'
			  AND END_ENR_DT > BEG_ENR_DT

		) AS ST010CURR
	--WHERE RN = 1
	) AS [Enrollments]
	
	-- Get Student Details
	INNER JOIN
	[DBTSIS].[CE020_V] AS [Student]	
	ON
	[Enrollments].[DST_NBR] = [Student].[DST_NBR]
	AND [Enrollments].[ID_NBR] = [Student].[ID_NBR]
	
	INNER JOIN
	APS.School AS [School]	
	ON
	[Enrollments].[SCH_NBR] = [School].[SCH_NBR]
	
WHERE
	[Enrollments].[GRDE] = 'K'