EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT DISTINCT ALLOFME.PARENT_GU, NEW_GRANT, PARENT_LAST, PARENT_FIRST, UDPAR.UDPARENT_LOG_GU, UDPAR.PARENT_GU AS UDPARGU, UDPAR.[GRANT]
FROM (
SELECT 
	WOOWH.[SIS NUMBER], WOOWH.[LAST NAME], WOOWH.[FIRST NAME], WOOWH.[PARENT NAME]
	,PERS.LAST_NAME AS PARENT_LAST, PERS.FIRST_NAME AS PARENT_FIRST, PARENTS.PARENT_GU
	,NEW_GRANT
 FROM 
(
SELECT 
	T1.*
	, CASE WHEN 
			T3.[PARENT NAME] IS NOT NULL OR T5.[PARENT NAME] IS NOT NULL OR T7.[PARENT NAME] IS NOT NULL THEN 'AIMS' ELSE T1.[GRANT] END AS NEW_GRANT
		
	
	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from IMPACTAID.csv'
                ) AS [T1]
	
	LEFT JOIN 

	(


	SELECT 
	*
	
	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from IMPACTAIDSANDIABASE.csv'
                ) AS [T2]
	) AS T3
	ON

	T1.[PARENT NAME] = T3.[PARENT NAME]
	AND T1.[LAST NAME] = T3.[LAST NAME]
	AND T1.[FIRST NAME] = T3.[FIRST NAME]


	LEFT JOIN 

	(


	SELECT 
	*
	
	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from IMPACTAIDSANANTONITO.csv'
                ) AS [T4]
	) AS T5
	ON

	T1.[PARENT NAME] = T5.[PARENT NAME]
	AND T1.[LAST NAME] = T5.[LAST NAME]
	AND T1.[FIRST NAME] = T5.[FIRST NAME]


		LEFT JOIN 

	(


	SELECT 
	*
	
	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from IMPACTAIDROOSEVELT.csv'
                ) AS [T6]
	) AS T7
	ON

	T1.[PARENT NAME] = T7.[PARENT NAME]
	AND T1.[LAST NAME] = T7.[LAST NAME]
	AND T1.[FIRST NAME] = T7.[FIRST NAME]


) AS WOOWH

INNER JOIN 
REV.EPC_STU AS STU
ON
WOOWH.[SIS NUMBER] = STU.SIS_NUMBER
INNER JOIN 
REV.EPC_STU_PARENT AS PARENTS
ON
STU.STUDENT_GU = PARENTS.STUDENT_GU
INNER JOIN 
REV.REV_PERSON AS PERS
ON
PARENTS.PARENT_GU = PERS.PERSON_GU
AND LEFT(WOOWH.[PARENT NAME],3) = LEFT(PERS.FIRST_NAME,3) 


WHERE NEW_GRANT IS NOT NULL

) AS ALLOFME

LEFT JOIN 
REV.UD_PARENT_LOG AS UDPAR
ON
UDPAR.PARENT_GU = ALLOFME.PARENT_GU


--WHERE
--UDPARENT_LOG_GU IS NOT NULL 
--AND ( [GRANT] != 'AIMS'
--OR [GRANT] IS NULL)

ORDER BY UDPAR.PARENT_GU