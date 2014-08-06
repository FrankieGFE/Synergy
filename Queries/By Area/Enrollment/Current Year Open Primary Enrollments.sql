/* Brian Rieb
 * 8/6/2014
 * 
 * This pulls basic enrollment info for current year open primary enrollments
 * It includes future enrollments, only ADA.  
 *
 * This will only pull REGULAR YEAR (no Summer, even if we are in summer school)
 *
 */
SELECT
	StudentYear.YEAR_GU
	,StudentYear.STUDENT_GU
	,SSY.ORGANIZATION_YEAR_GU
	,SSY.STUDENT_SCHOOL_YEAR_GU
	,SSY.ENTER_DATE
	,SSY.LEAVE_DATE
	,SSY.GRADE
FROM
	rev.EPC_STU_YR AS StudentYear -- (SOR)
	INNER JOIN
	rev.EPC_STU_SCH_YR AS SSY
	ON
	StudentYear.STU_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU
WHERE
	StudentYear.YEAR_GU = (SELECT year_gu FROM rev.SIF_22_Common_CurrentYearGU)
	AND SSY.STATUS IS NULL --SSY is not inactive
	AND SSY.EXCLUDE_ADA_ADM IS NULL -- only primarys
	AND (
		-- no "closed" enrollments
		SSY.LEAVE_DATE >= CONVERT(DATE, GETDATE())
		OR 
		SSY.LEAVE_DATE IS NULL
		)
