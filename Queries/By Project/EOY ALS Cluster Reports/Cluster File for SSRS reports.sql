

SELECT
	*
FROM
	OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\ALS EOY\;',
			'SELECT [Cluster] from ClusterFile.csv' 
		)AS [PREVIOUS_FILE]