



EXECUTE AS LOGIN='QueryFileUser'
GO


	SELECT
		[FILE].*
		,[STUDENT].[ELL_STATUS]
		,CASE WHEN [ELL_History].[STUDENT_GU] IS NOT NULL THEN 'Y' ELSE 'N' END AS [EVER_ELL]
	FROM
		OPENROWSET (
				'Microsoft.ACE.OLEDB.12.0', 
				'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
				'SELECT * from Term2_students_unique.csv' 
			)AS [FILE]
			
		INNER JOIN
		APS.BasicStudentWithMoreInfo AS [STUDENT]
		ON
		[FILE].[Perm ID] = [STUDENT].[SIS_NUMBER]
		
		LEFT OUTER JOIN
		(
		SELECT DISTINCT
			STUDENT_GU
		FROM
			rev.EPC_STU_PGM_ELL_HIS
		) AS [ELL_History]
		ON
		[STUDENT].[STUDENT_GU] = [ELL_History].[STUDENT_GU]
			
			
REVERT
GO