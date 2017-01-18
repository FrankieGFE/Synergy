SELECT
	*
	,CASE
		WHEN GradeLevel IN ('P2','P1','PK') THEN 
'1. SPED Elementary'
		WHEN GradeLevel IN ('K','01','02','03','04','05') THEN '2. Elementary'
		WHEN GradeLevel IN ('06','07','08') THEN '3. Secondary Middle'
		WHEN GradeLevel IN ('09','10','11','12') THEN '4. Secondary High'
		ELSE '5. SPED Secondary'
	END AS GradeGroup
FROM
	(
	SELECT
		Organization.ORGANIZATION_NAME AS School
		,GradeLevel.VALUE_DESCRIPTION AS GradeLevel
		,GradeLevel.LIST_ORDER AS GradeOrder
		,COUNT(Enroll.STUDENT_GU) AS EnrollmentCount
	FROM
		APS.PrimaryEnrollmentsAsOf(@AsOfDate) AS Enroll
		INNER JOIN
		rev.REV_ORGANIZATION_YEAR AS OrgYear
		ON
		Enroll.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

		INNER JOIN
		rev.REV_ORGANIZATION AS Organization
		ON
		OrgYear.ORGANIZATION_GU = Organization.ORGANIZATION_GU

		LEFT JOIN
		APS.LookupTable('K12','Grade') AS GradeLevel
		ON
		Enroll.GRADE = GradeLevel.VALUE_CODE
	WHERE
		Organization.ORGANIZATION_GU LIKE @School
	GROUP BY
		Organization.ORGANIZATION_NAME
		,GradeLevel.VALUE_DESCRIPTION
		,GradeLevel.LIST_ORDER
	) AS Counts