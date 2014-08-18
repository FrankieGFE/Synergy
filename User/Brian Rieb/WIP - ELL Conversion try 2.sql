;WITH CleanedNM034 AS
(
-- This cleans up status for same student same day and preps row number
-- for a modified version of Ryan's Code
SELECT
	*
	,ROW_NUMBER() OVER (PARTITION BY ID_NBR ORDER BY ELL_DATE ASC) AS StudentRow
FROM
	(
	SELECT
		ID_NBR
		,ELL_STAT
		,ELL_DATE
		,ROW_NUMBER() OVER (PARTITION BY ID_NBR,ELL_DATE ORDER BY ELL_STAT ASC) AS StudentDateRow
	FROM
		DBTSIS.NM034_V
	WHERE
		DST_NBR=1
		AND SCH_YR > 2002
	) AS RawNM34
WHERE
	StudentDateRow = 1 -- This rids of duplicates for a student on the same day
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
)
, SuperCleanNM34 AS (
-- This joins records to previous record (ordered by id, date asc) but only if
-- the status is the same.  It keeps records that DONT match on the join
-- i.e. Only the first record where status changes
SELECT
	MasterNM34.ID_NBR
	,MasterNM34.ELL_STAT
	,MasterNM34.ELL_DATE
FROM
	CleanedNM034 AS MasterNM34
	LEFT JOIN
	CleanedNM034 AS ReferenceNM34
	ON
	MasterNM34.ID_NBR = ReferenceNM34.ID_NBR
	AND MasterNM34.StudentRow = ReferenceNM34.StudentRow -1 -- previous record
	AND MasterNM34.ELL_STAT = ReferenceNM34.ELL_STAT
WHERE
	ReferenceNM34.ID_NBR IS NULL
)
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
,UltraCleanNM34 AS (
SELECT
-- This removes a blank status if it's the first one
	ID_NBR
	,ELL_STAT
	,ELL_DATE
FROM
	(
	SELECT
		*
		,ROW_NUMBER() OVER (PARTITION BY ID_NBR ORDER BY ELL_DATE ASC) AS RN
	FROM
		SuperCleanNM34
	) AS RowNumNM34
WHERE
	NOT (RN=1 AND ELL_STAT = '')
)
, TransformedELL AS (
-- Finally, This one combines the start and exit dates into one record
SELECT
	Starts.ID_NBR
	,Starts.ELL_DATE AS EnterDate
	,Ends.ELL_DATE	AS ExitDate	
FROM
	(
	SELECT
		*
		,ROW_NUMBER() OVER (PARTITION BY ID_NBR ORDER BY ELL_DATE ASC) AS RN
	FROM
		UltraCleanNM34
	WHERE
		ELL_STAT = 'ELL'
	) AS Starts
	
	LEFT JOIN
	
	(
	SELECT
		*
		,ROW_NUMBER() OVER (PARTITION BY ID_NBR ORDER BY ELL_DATE ASC) AS RN
	FROM
		UltraCleanNM34
	WHERE
		ELL_STAT = ''
	) AS Ends
	
	ON
	
	Starts.ID_NBR = Ends.ID_NBR
	AND Starts.RN = Ends.RN
)


-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------

SELECT
	*
FROM
	TransformedELL
/*
-- 15023, distinct=15023
-- This checks ELL as of 15205... off by 2, but probably of certain kids
-- having duplicate records on same day with different statsuses
SELECT
	COUNT(DISTINCT Enroll.ID_NBR)
FROM
	APS.PrimaryEnrollmentsAsOf('2014-05-22') AS Enroll
	INNER JOIN
	TransformedELL
	ON
	Enroll.ID_NBR = TransformedELL.ID_NBR
	AND 20140522 BETWEEN TransformedELL.EnterDate AND COALESCE(TransformedELL.ExitDate, 20140522)
WHERE
	DST_NBR = 1
  
SELECT
	COUNT(*)
FROM
	APS.ELLStudentsAsOf('2014-05-22')
WHERE
	DST_NBR = 1	
	
*/