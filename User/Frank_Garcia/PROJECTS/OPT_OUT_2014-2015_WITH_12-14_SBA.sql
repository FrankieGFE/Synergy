SELECT
	PARCC.[STUDENT NAME]
	,PARCC.[STUDENT ID]
	,CONVERT (CHAR(10), PARCC.[DATE of Birth], 110) AS DOB
	,PARCC.[2014-15 Grade Level]
	,PARCC.[2014-15 School]
	,PARCC.[2014-15 Exemption(s)]
	,PARCC.[2013-14 SBA Math Overall Proficiency Lvl]
	,PARCC.[2013-14 SBA Reading Overall Proficiency Lvl]
	,BS.RESOLVED_RACE
	,BS.SPED_STATUS
	,BS.ELL_STATUS
	,BS.LUNCH_STATUS
FROM
	APS.BasicStudentWithMoreInfo AS BS			
		
		RIGHT OUTER JOIN
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
			'SELECT * from FRANK.csv' 
		)AS PARCC
		ON
		BS.[SIS_NUMBER] = PARCC.[Student ID]

