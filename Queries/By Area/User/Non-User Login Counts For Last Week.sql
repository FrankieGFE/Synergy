/* Brian Rieb
 * 8/11/2014
 *
 * Pulls last seven day counts of unique non-user visitors (parent vue/student vue) 
 *
 */
SELECT
	CONVERT(VARCHAR, SynDate, 101) AS TheDate
	,COUNT(*) AS TheCount
FROM
	(
	-- This narrows down the subselct to one user per day
	SELECT
		DISTINCT
		CONVERT(DATE, NonSysUserActivity.ACCESS_DT) AS SynDate
		,NonSysUserActivity.PERSON_GU
	FROM
		(
		-- I kept this as a subselect, in case we want to reuse ths part by
		-- breaking logins by type/browser/app etc...
		SELECT 
			NonSysUserActivity.PERSON_GU
			,NonSysUserActivity.ACCESS_DT
			,CASE
				WHEN Parent.PARENT_GU IS NOT NULL THEN 'Parent'
				ELSE 'Student'
			END AS AccessType
			,BROWSER_NAME
			,BROWSER_VERSION
			,DEVICE_NAME
			,DEVICE_MAKE
		FROM 
			rev.REV_USER_NON_SYS_ACT AS NonSysUserActivity
			LEFT JOIN
			rev.EPC_PARENT AS Parent
			ON
			NonSysUserActivity.PERSON_GU = Parent.PARENT_GU
		) AS NonSysUserActivity
	) AS ByDay
WHERE
	SynDate >= CONVERT(DATE, GETDATE()-7)
GROUP BY
	SynDate
ORDER BY
	SynDate
