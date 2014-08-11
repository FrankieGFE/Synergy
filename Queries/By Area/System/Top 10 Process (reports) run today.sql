/* Brian Rieb
 * 8/1//2014
 *
 * Top Ten Processes Run today.
 */
SELECT
	TOP 10 
	*
FROM
	(
	SELECT
		CONVERT(DATE, PROCESS_DT) AS TheDate
		,JOB_ID + ' - ' + DESCRIPTION AS Job
		,COUNT(*) AS TheCount
	FROM
		rev.REV_PROCESS_QUEUE
	WHERE
		CONVERT(DATE, PROCESS_DT)  = CONVERT(DATE, GETDATE())
	GROUP BY
		CONVERT(DATE, PROCESS_DT)
		,JOB_ID + ' - ' + DESCRIPTION
	)TheQueue
ORDER BY
	TheDate,
	TheCount DESC
