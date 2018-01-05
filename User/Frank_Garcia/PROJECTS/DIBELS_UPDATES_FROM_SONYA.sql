BEGIN TRAN


--UPDATE
--	DIBBLES_Summary
--	SET [Student ID (District ID)] = UPDATES.[Student ID (District ID)]
--	,[Student ID (School ID)] = UPDATES.[Student ID (School ID)]


SELECT
	DIBS.[Student ID (District ID)] DIBS_ID
	,UPDATES.[Student ID (District ID)] UPDATED_ID
	,DIBS.[School Name]
	,DIBS.[Student Primary ID]
	,UPDATES.[Student Primary ID]
FROM
	DIBBLES_Summary DIBS
	 JOIN
	[TRASH_DIBELS_MOY_2-9-2015] AS UPDATES
	ON
		DIBS.[Student First Name] = UPDATES.[Student First Name]
		AND DIBS.[Student Last Name] = UPDATES.[Student Last Name]
		AND DIBS.[Student Middle Name] = UPDATES.[Student Middle Name]
		--AND DIBS.[Date of Birth] = UPDATES.[Date of Birth]
		AND DIBS.[Benchmark Period] = UPDATES.[Benchmark Period]
		AND DIBS.[School Name] = UPDATES.[School Name]
		AND DIBS.GENDER = UPDATES.GENDER
		--AND DIBS.[Student Primary ID] = UPDATES.[Student Primary ID]
		AND DIBS.RACE = UPDATES.RACE

WHERE
	DIBS.[Benchmark Period] = 'MOY'
	AND DIBS.[School Name] != 'El Camino Real Academy'
	--AND UPDATES.[Student ID (District ID)] IS NULL

--ORDER BY DIBS.[Student ID (District ID)]


ROLLBACK