
SELECT 
	COHORT.*, 
	T1.SCHOOL,
	T1.	BEG_ENR_DT,
	T1.END_ENR_DT,
	LEAVE_CODE,
	CASE WHEN END_STAT IN (52,13) THEN 'Y' ELSE 'N' END AS NOSHOW
	,ID_NBR 
	,TO_CITY
	,TO_STATE
	,TO_ST_SCH
	,TO_SCH_NME
	,XCOMMENT
	,VERIF_DT
	,REASON
	,CASE WHEN ID_NBR IS NULL THEN 'NOT FOUND IN EITHER SYSTEM' ELSE 'SMAX' END AS [SYSTEM]

 FROM 
	OPENROWSET ('MSDASQL', 'Driver={Microsoft Access Text Driver (*.txt, *.csv)};DBQ=D:\SQLWorkingFiles;', 'SELECT * from "COHORT.csv"')
		AS COHORT

LEFT JOIN
(SELECT * FROM (
	SELECT
	SCH.SCH_YR,
	SCH.SCH_NBR,
	SCHOOL.SCH_NME_27 AS SCHOOL,
	SCH.ID_NBR,
	SCH.BEG_ENR_DT,
	END_ENR_DT,
	NONADA_SCH
	,SCH.END_STAT
	,STATE_ID
	,CAST(CODES.END_STAT AS VARCHAR) + '-'+ CODES.STAT_ABBR AS LEAVE_CODE
	,ROW_NUMBER() OVER (PARTITION BY SCH.DST_NBR, SCH.ID_NBR ORDER BY SCH.SCH_YR DESC, NONADA_SCH ASC, SCH.BEG_ENR_DT DESC, END_ENR_DT DESC ) AS RN

	,TO_CITY
	,TO_SCH_NME
	,TO_ST_SCH
	,TO_STATE
	,VERIF_DT
	,XCOMMENT
	,TRANSFERS.STAT_ABBR AS REASON
	
FROM
	DBTSIS.ST010 AS SCH WITH (NOLOCK)
	INNER JOIN
	DBTSIS.SY010 AS SCHOOL
	ON
	SCH.DST_NBR = SCHOOL.DST_NBR
	AND 	SCH.SCH_NBR = SCHOOL.SCH_NBR
	INNER JOIN
	DBTSIS.ST080_V AS CODES
	ON
	SCH.DST_NBR = CODES.DST_NBR
	AND SCH.SCH_YR = CODES.SCH_YR
    AND SCH.END_STAT = CODES.END_STAT
	INNER JOIN
	DBTSIS.CE020_V AS STATEID
	ON
	SCH.ID_NBR = STATEID.ID_NBR
	LEFT JOIN

	(
	SELECT DISTINCT 
			
			TRF.DST_NBR
			,TRF.SCH_YR
			,TRF.SCH_NBR
			,TRF.BEG_ENR_DT
			,TRF.ID_NBR
			,TRF.TO_CITY
			,TRF.TO_SCH_NME
			,TRF.TO_ST_SCH
			,TRF.TO_STATE
			,TRF.VERIF_DT
			,TRF.XCOMMENT
			,CODE.STAT_ABBR
	
	 FROM
	DBTSIS.ST016_V AS TRF
	INNER JOIN
	DBTSIS.ST081_V AS CODE
	ON
	TRF.DST_NBR = CODE.DST_NBR
	AND TRF.REASON = CODE.END_STAT
	AND TRF.SCH_YR = CODE.SCH_YR

	) AS TRANSFERS

	ON
	TRANSFERS.DST_NBR = SCH.DST_NBR
	AND TRANSFERS.SCH_YR = SCH.SCH_YR
	AND TRANSFERS.SCH_NBR = SCH.SCH_NBR
	AND TRANSFERS.BEG_ENR_DT = SCH.BEG_ENR_DT
	AND TRANSFERS.ID_NBR = SCH.ID_NBR

WHERE
SCH.DST_NBR = 1
) AS T1
WHERE
RN = 1
) AS T1
ON
StudentID =  STATE_ID COLLATE DATABASE_DEFAULT

--WHERE SCHOOL IS NULL

ORDER BY 
SCHOOL
,SchoolType
