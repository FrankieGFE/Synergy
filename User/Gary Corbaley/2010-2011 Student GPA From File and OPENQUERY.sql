


EXECUTE AS LOGIN='QueryFileUser'
GO

	SELECT
		*
	FROM
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
			'SELECT * from PSM_AVID_MS_STUDENTS.csv' 
		)AS [PREVIOUS_FILE]
	
	--SELECT
	--	*
	--FROM
	LEFT OUTER JOIN
	OPENQUERY([011-SYNERGYDB.APS.EDU.ACTD],'
		SELECT
			--*
			DST_NBR
			,ID_NBR
			,SCH_YR
			,ENR_GRDE
			,CASE WHEN SUM([Attempted Credits]) != 0 THEN
				SUM([FLAT GPA]*[Attempted Credits])/SUM([Attempted Credits])+SUM([Honors Points]) 
			 ELSE 0
			 END AS [Cumulative Weighted GPA]
			 
			,CASE WHEN SUM([Attempted Credits]) != 0 THEN
				SUM([FLAT GPA]*[Attempted Credits])/SUM([Attempted Credits]) 
			 ELSE 0
			 END AS [Cumulative Flat GPA]
			 
		FROM
			[PR].APS.BasicGPA
		WHERE
			--ENR_GRDE = ''06''	
			--AND 
			SCH_YR = 2011
		GROUP BY
			DST_NBR
			,ID_NBR
			,SCH_YR
			,ENR_GRDE	
		') AS [GPA]
		ON
		[PREVIOUS_FILE].[ID_NBR] = [GPA].[ID_NBR]


REVERT
GO
