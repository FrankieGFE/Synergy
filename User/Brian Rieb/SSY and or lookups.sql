
SELECT
	*
FROM
	rev.epc_stu_sch_yr AS SSY
	INNER JOIN
	rev.EPC_STU_ENROLL AS Enroll
	ON
	SSY.STUDENT_SCHOOL_YEAR_GU = Enroll.STUDENT_SCHOOL_YEAR_GU
WHERE
	SSY.ORGANIZATION_YEAR_GU = '1E7B264C-337A-4DFB-A37E-FAC2F5FBDD60'
	AND SSY.GRADE = '110'
--	AND Enroll.STUDENT_SCHOOL_YEAR_GU IS NULL

--1E7B264C-337A-4DFB-A37E-FAC2F5FBDD60
/*
SELECT
	OrgYear.ORGANIZATION_YEAR_GU
FROM
	rev.REV_YEAR AS SynYear
	INNER JOIN
	rev.REV_ORGANIZATION_YEAR As OrgYear
	ON
	SynYear.YEAR_GU = OrgYear.YEAR_GU
	INNER JOIN
	Rev.REV_ORGANIZATION AS Organization
	ON
	OrgYear.ORGANIZATION_GU = Organization.ORGANIZATION_GU
WHERE
	SynYear.SCHOOL_YEAR = '2014'
	AND SynYear.EXTENSION = 'R'
	AND Organization.ORGANIZATION_NAME LIKE 'Apache%'
*/