/*
 *
 *
 *
 * 170427
 * 70,980
 * 15145 start > end
 */

 ;WITH
	CleanedELLStat 
AS
(
SELECT
	*
FROM
	(
	SELECT
		ID_NBR
		,ELL_DATE
		,ELL_STAT
		,ROW_NUMBER() OVER (PARTITION BY DST_NBR, ID_NBR ORDER BY ELL_DATE ASC) AS DateRN
		,ROW_NUMBER() OVER (PARTITION BY DST_NBR, ID_NBR ORDER BY ELL_STAT DESC, ELL_DATE ASC) AS FirstELLRN
	FROM
		DBTSIS.NM034_V
	WHERE
		DST_NBR = 1
		AND SCH_YR > 2002
	) AS RAWELL

WHERE
	FirstELLRN <= DateRN
	OR (
	FirstELLRN = 1 
	AND DateRN = 1
	)
)

SELECT
	Starts.ID_NBR
	,Starts.StartDate
	,Ends.ExitDate
FROM
	(
	SELECT
		ID_NBR
		,ELL_DATE AS StartDate
		,ROW_NUMBER() OVER (PARTITION BY ID_NBR ORDER BY ELL_DATE ASC) AS RN
	FROM
		CleanedELLStat AS ELLHistory
	WHERE
		ELL_STAT = 'ELL'
	) AS Starts

	LEFT JOIN

	(
	SELECT
		ID_NBR
		,ELL_DATE AS ExitDate
		,ROW_NUMBER() OVER (PARTITION BY ID_NBR ORDER BY ELL_DATE ASC) AS RN
	FROM
		CleanedELLStat AS ELLHistory
	WHERE
		ELL_STAT = ''
	) AS Ends

	ON
	Starts.ID_NBR = Ends.ID_NBR
	AND Starts.RN = Ends.RN
WHERE
	Ends.ExitDate IS NOT NULL
ORDER BY
	Starts.ID_NBR