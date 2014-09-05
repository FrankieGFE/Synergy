/* Brian Rieb
 * 9/4/2014
 *
 * Initial Request: Christine Cervantes
 * We need to clean up 2nd semester schedules.  Delete dropped courses in 2nd Semester
 * Delete any 2nd semester ecademy classes, and adjust enter dates for remaining 
 * classes.
 */
BEGIN TRANSACTION

-- Ecadamy should have nothing scheduled for 2nd semester
DELETE 
	Class
--SELECT
--	COUNT(*)
FROM
	rev.EPC_STU_CLASS AS Class
	INNER JOIN
	rev.EPC_STU_SCH_YR AS SSY
	ON
	Class.STUDENT_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU

	INNER JOIN
	rev.REV_ORGANIZATION_YEAR AS OrgYear
	ON
	SSY.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

	INNER JOIN
	rev.REV_ORGANIZATION AS Org
	ON
	OrgYear.ORGANIZATION_GU = Org.ORGANIZATION_GU
WHERE
	Class.ENTER_DATE > '2015-01-01'
	AND Org.ORGANIZATION_NAME = 'ecademy virtual'

-- remove future classes that are dropped
DELETE
--SELECT
--	COUNT(*)
FROM
	rev.EPC_STU_CLASS
WHERE
	LEAVE_DATE > '2015-01-01'


-- fix enter_dates taht were put in AFTER 1/5 (for january's)
UPDATE
	rev.EPC_STU_CLASS
SET
	ENTER_DATE = '2015-01-05'
WHERE
	ENTER_DATE BETWEEN '2015-01-06' AND '2015-01-20'


ROLLBACK