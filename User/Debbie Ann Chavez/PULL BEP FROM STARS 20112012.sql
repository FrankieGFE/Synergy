
--PULL BEP
SELECT PROG.[STUDENT ID], STU.[ALTERNATE STUDENT ID] 
,PROG.[Field9] AS PROGRAM_HOURS
,CASE WHEN PROG.[Field18] = 1 THEN 'Dual Language Immersion'
	  WHEN PROG.[Field18] = 2 THEN 'Developmental/Maintenance Bilingual'
	  WHEN PROG.[Field18] = 3 THEN 'Enrichment'
	  WHEN PROG.[Field18] = 4 THEN 'Transitional Bilingual'
	  WHEN PROG.[Field18] = 5 THEN 'Heritage/Indigenous Language'
	  WHEN PROG.[Field18] = 6 THEN 'Parent Refusal of Services'
END AS PROGRAM_MODEL
,MIN(PROG.[Field6]) AS ENTER_DATE

 FROM 
	[046-WS02].[db_STARS_History].dbo.PROGRAMS_FACT AS PROG
	INNER JOIN 
	(
	SELECT DISTINCT [STUDENT ID], [ALTERNATE STUDENT ID]
	FROM 
	[046-WS02].[db_STARS_History].dbo.STUD_SNAPSHOT AS STU
	
	WHERE
	[DISTRICT CODE] = '001'
	AND SY = '2012'
	) AS STU

	ON
	PROG.[STUDENT ID] = STU.[STUDENT ID] 

WHERE
	PROG.[DISTRICT CODE] = '001'
	AND PROG.SY = '2012'
	--AND [Field6] = '2015-06-01'
	AND PROG.[Field5] = 'BEP'

GROUP BY 
PROG.[STUDENT ID], STU.[ALTERNATE STUDENT ID] 
,PROG.[Field9] 
,CASE WHEN PROG.[Field18] = 1 THEN 'Dual Language Immersion'
	  WHEN PROG.[Field18] = 2 THEN 'Developmental/Maintenance Bilingual'
	  WHEN PROG.[Field18] = 3 THEN 'Enrichment'
	  WHEN PROG.[Field18] = 4 THEN 'Transitional Bilingual'
	  WHEN PROG.[Field18] = 5 THEN 'Heritage/Indigenous Language'
	  WHEN PROG.[Field18] = 6 THEN 'Parent Refusal of Services'
END

/*	
-- PULL ALL ELL, AND EXIT YEAR
SELECT 
	[STUDENT ID], [LOCATION CODE], [Period], [ALTERNATE STUDENT ID], [ENGLISH PROFICIENCY]  FROM 
	[046-WS02].[db_STARS_History].dbo.STUD_SNAPSHOT
WHERE
	[DISTRICT CODE] = '001'
	AND [Period] = '2015-06-01'
*/
