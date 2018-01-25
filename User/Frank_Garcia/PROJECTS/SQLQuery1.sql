SELECT
	*
FROM
(
SELECT
	SCH_NBR
	,Race
	,GENDER
	,COUNT(*)AS [Count]
FROM
	APS.CurrentPrimaryEnrollments
	INNER JOIN
	APS.BasicStudent
	ON
	CurrentPrimaryEnrollments.DST_NBR=BasicStudent.DST_NBR
	AND CurrentPrimaryEnrollments.ID_NBR = BasicStudent.ID_NBR
WHERE
	CurrentPrimaryEnrollments.DST_NBR = 1
GROUP BY
	SCH_NBR, Race, GENDER

)AS t1
WHERE [Count] > 4
ORDER BY 
	[Count]