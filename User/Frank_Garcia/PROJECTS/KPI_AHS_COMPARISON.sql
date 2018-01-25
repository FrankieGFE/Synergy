SELECT
	AIMS.[Student ID] AS AIMS_ID
	,SYN.ID_NBR AS SYN_ID
	,AIMS.[Student Name]
	,AIMS.[Most Recent  Grade Level] AS AIMS_GRADE
	,SYN.GRADE AS SYN_GRADE
	,AIMS.[Most Recent  Enrollment School]
	,SYN.[No Appropriate Course Assigned]
FROM
	TRASH_AIMS_AHS_Students_not_served AS AIMS
RIGHT JOIN
	TRASH_Synergy_AHS_Students_Not_Served AS SYN
	ON AIMS.[Student ID] = SYN.ID_NBR
WHERE AIMS.[Student ID] IS NOT NULL
