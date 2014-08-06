/* Brian Rieb
 * 8/5/2014
 *
 * Projected First Day Enrollments By Type (hardcoded date)
 *
 */
SELECT
	*
FROM
	(
	SELECT
		CASE	EXCLUDE_ADA_ADM
			WHEN 1 THEN 'Home/Charter'
			WHEN 2 THEN 'Concurrent'
			ELSE 'ADA'
		END AS EnrollmentType
		,COUNT(*) AS TheCount
	FROM
		APS.EnrollmentsAsOf('8/13/2014') AS Enrollment
	GROUP BY
		Enrollment.EXCLUDE_ADA_ADM
	) AS Counts
ORDER BY
	EnrollmentType