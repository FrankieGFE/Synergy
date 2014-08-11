/* Brian Rieb
 * 8/8/2014
 *
 * Login activity (unique users) count for the past 7 days 
 *
 */
SELECT
	CONVERT(VARCHAR, CONVERT(DATE, UserActivity.ACCESS_DT), 101) AS AccessDate
	,COUNT(DISTINCT USER_GU)	AS TheCount
FROM 
	[rev].[REV_USER_ACT] AS UserActivity
WHERE
	CONVERT(DATE, UserActivity.ACCESS_DT) > CONVERT(DATE, GETDATE()-7)
GROUP BY
	CONVERT(DATE, UserActivity.ACCESS_DT)
ORDER BY
	CONVERT(DATE, UserActivity.ACCESS_DT)