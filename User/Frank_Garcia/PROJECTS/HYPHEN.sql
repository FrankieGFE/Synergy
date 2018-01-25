SELECT
	*
FROM
(
SELECT
	LST_NME
	,SCH_NBR
	,COUNT(*)AS [Count]
FROM
	APS.CurrentPrimaryEnrollments
	INNER JOIN
	APS.BasicStudent
	ON
	CurrentPrimaryEnrollments.DST_NBR=BasicStudent.DST_NBR
	AND CurrentPrimaryEnrollments.ID_NBR = BasicStudent.ID_NBR
WHERE
	CurrentPrimaryEnrollments.DST_NBR = 1 AND BasicStudent.LST_NME LIKE '%-%'
GROUP BY
	 LST_NME, SCH_NBR

)AS t1

ORDER BY 
	[Count]