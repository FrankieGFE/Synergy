/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 03/11/2015
 *
 * Request By: Andy Gutierrez
 * InitialRequestDate: 02/23/2015
 * 
 * Description: This script sets students primary race indicator with the race codes from STARS EOY template when the student has more than 1 race code.
 */


--SELECT --TOP 100
	--[STARS].[Period]
	--,[STARS].[STUDENT ID]
	--,[STARS].[LOCATION CODE]
	--,[STARS].[FIRST NAME LONG]
	--,[STARS].[LAST NAME LONG]
	--,[STARS].[GENDER CODE]
	--,[STARS].[HISPANIC INDICATOR]
	--,[STARS].[ETHNIC CODE SHORT]
	--,CASE 
	--	WHEN [STARS].[ETHNIC CODE SHORT] = 'C' THEN 1
	--	WHEN [STARS].[ETHNIC CODE SHORT] = 'I' THEN 100
	--	WHEN [STARS].[ETHNIC CODE SHORT] = 'B' THEN 600
	--	WHEN [STARS].[ETHNIC CODE SHORT] = 'A' THEN 299
	--	WHEN [STARS].[ETHNIC CODE SHORT] = 'P' THEN 399
	--END AS [PRIMARY_RACE]
	--,''
	--,[STUDENT].*
	
UPDATE [PERSON]
	
SET [PRIMARY_RACE_INDICATOR] = CASE 
			WHEN [STARS].[ETHNIC CODE SHORT] = 'C' THEN 1
			WHEN [STARS].[ETHNIC CODE SHORT] = 'I' THEN 100
			WHEN [STARS].[ETHNIC CODE SHORT] = 'B' THEN 600
			WHEN [STARS].[ETHNIC CODE SHORT] = 'A' THEN 299
			WHEN [STARS].[ETHNIC CODE SHORT] = 'P' THEN 399
		END	
	
FROM
	APS.BasicStudent AS [STUDENT]
	
	INNER JOIN
	rev.REV_PERSON AS [PERSON]
	ON
	[STUDENT].[STUDENT_GU] = [PERSON].[PERSON_GU]
	
	INNER JOIN
	(
	SELECT
		*
	FROM
		[046-WS02.APS.EDU.ACTD].[db_STARS_History].[dbo].[STUDENT]
	WHERE
		[Period] LIKE '2014-06-01%'
	) AS [STARS]	
	ON
	[STARS].[STUDENT ID] = [STUDENT].[STATE_STUDENT_NUMBER]
	
WHERE
	[PERSON].[PRIMARY_RACE_INDICATOR] IS NULL