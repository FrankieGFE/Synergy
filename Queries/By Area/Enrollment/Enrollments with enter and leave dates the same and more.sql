/* Brian Rieb
 * 8/4/2014
 *
 * Pulls all current SSYs where enter and leave dates are the same, or the enrollment starts on the 2nd day of school
 * It includes no show information.  This Query basically identifies bad no-sho enrollments and enrollments
 * affected by these bad no shows.
 */

SELECT
	Organization.ORGANIZATION_NAME
	,Student.SIS_NUMBER
	,SSY.ENTER_DATE
	,SSY.LEAVE_DATE
	,SSY.SUMMER_WITHDRAWL_CODE
	,SSY.SUMMER_WITHDRAWL_DATE
FROM
	rev.REV_ORGANIZATION_YEAR AS OrgYear

	INNER JOIN
	rev.EPC_STU_SCH_YR AS SSY
	ON
	OrgYear.ORGANIZATION_YEAR_GU = SSY.ORGANIZATION_YEAR_GU
	
	INNER JOIN
	rev.EPC_STU AS Student
	ON
	SSY.STUDENT_GU = Student.STUDENT_GU

	INNER JOIN
	rev.REV_ORGANIZATION AS Organization
	ON
	OrgYear.ORGANIZATION_GU = Organization.ORGANIZATION_GU
WHERE
	OrgYear.YEAR_GU = (SELECT year_gu FROM rev.SIF_22_Common_CurrentYearGU)
	AND (
	SSY.ENTER_DATE = SSY.LEAVE_DATE
	OR
	SSY.ENTER_DATE = '2014-08-14'
	)
ORDER BY
	Organization.ORGANIZATION_NAME