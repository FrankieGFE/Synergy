/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 2014-12-18
 *
 * Updates "Access 504" student field from most recent SSY
 * 
 * Initial Request: Andy Gutierrez
 * please create an update script to populate the Access 504 field in Synergy 
 *
 */


EXECUTE AS LOGIN='QueryFileUser'
GO

UPDATE
	[StudentSchoolYear]

SET
	[ACCESS_504] = 10

--SELECT
--	[StudentSchoolYear].[ACCESS_504]
	
FROM
	OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
			'SELECT DISTINCT * from 2013_2014Access504lists.csv'
		    ) AS [FILE]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[FILE].[ID_NBR] = [STUDENT].[SIS_NUMBER]    
	
	INNER JOIN
	APS.PrimaryEnrollmentsAsOf(GETDATE()) AS [ENROLLMENTS]
	ON
	[STUDENT].[STUDENT_GU] = [ENROLLMENTS].[STUDENT_GU]
	
	INNER JOIN
	rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
	ON
	[ENROLLMENTS].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]

REVERT
GO