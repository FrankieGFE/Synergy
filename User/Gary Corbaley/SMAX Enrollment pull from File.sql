



EXECUTE AS LOGIN='QueryFileUser'
GO

	SELECT
		[FILE].*
		
		,[Enrollment].[DST_NBR]
		,[Enrollment].[ID_NBR]
		,[STUDENT].[STATE_ID]
		,[STUDENT].[LST_NME]
		,[STUDENT].[FRST_NME]
		,[Enrollment].[GRDE]
		,[Enrollment].[SCH_YR]
		,[Enrollment].[SCH_NBR]
		,[School].[SCH_NME]	
		,[Enrollment].[BEG_ENR_DT]
		,[Enrollment].[END_ENR_DT]
		,[Enrollment].[END_STAT]
		,[Withdrawal].[STAT_DESCR]
	FROM
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
			'SELECT * from 201314_JDC_EOY_forAndy.csv' 
		)AS [FILE]
		
		LEFT OUTER JOIN
		[011-SYNERGYDB.APS.EDU.ACTD].[PR].APS.BasicStudent AS [STUDENT]
		ON
		([FILE].[State ID] = [STUDENT].[ID_NBR]
		OR
		[FILE].[State ID] = [STUDENT].[STATE_ID])
		AND [STUDENT].[DST_NBR] = 1
		
		
		LEFT OUTER JOIN
		[011-SYNERGYDB.APS.EDU.ACTD].[PR].[DBTSIS].[ST010_V] AS [Enrollment]
		ON
		[STUDENT].[DST_NBR] = [Enrollment].[DST_NBR]
		AND [STUDENT].[ID_NBR] = [Enrollment].[ID_NBR]
		AND [Enrollment].[SCH_YR] = '2014'

		LEFT OUTER JOIN
		[011-SYNERGYDB.APS.EDU.ACTD].[PR].[DBTSIS].[ST080_V] AS [Withdrawal]
		ON
		[Enrollment].[DST_NBR] = [Withdrawal].[DST_NBR]
		AND [Enrollment].[END_STAT] = [Withdrawal].[END_STAT]
		AND [Enrollment].[SCH_YR] = [Withdrawal].[SCH_YR]		
		
		LEFT OUTER JOIN
		[011-SYNERGYDB.APS.EDU.ACTD].[PR].APS.School AS [School]		
		ON
		[Enrollment].[SCH_NBR] = [School].[SCH_NBR]
		
--WHERE
--	[STUDENT].[S_id] IS NULL

--ORDER BY
--	[Enrollment].[ID_NBR]
		
	
REVERT
GO