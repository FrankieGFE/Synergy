/* Brian Rieb
 * 9/5/2014
 *
 * Pull active course with Cours Level Pivoted
 */
SELECT
	ID
	,Name
	,CreditValue
	,StateCourseNumber
	,DualCredit
	,OnlineDistance
	,Department
	,CourseHistoryType
	,Subject1
	,Subject2
	,Subject3
	,Subject4
	,Subject5
	,CASE WHEN [Basic or remedial course] IS NOT NULL THEN 'Y' ELSE 'N' END AS [CL Remedial]
	,CASE WHEN [General or regular course] IS NOT NULL THEN 'Y' ELSE 'N' END AS [CL Regular]
	,CASE WHEN [Enriched or advanced course] IS NOT NULL THEN 'Y' ELSE 'N' END AS [CL Enriched]
	,CASE WHEN [Honors course] IS NOT NULL THEN 'Y' ELSE 'N' END AS [CL Honors]
	,CASE WHEN [Dual/concurrent enrollment course] IS NOT NULL THEN 'Y' ELSE 'N' END AS [CL Dual]
	,CASE WHEN [Articulation agreement course] IS NOT NULL THEN 'Y' ELSE 'N' END AS [CL Articulation]
	,CASE WHEN [Industry/occupational certification course] IS NOT NULL THEN 'Y' ELSE 'N' END AS [CL Industry]
	,CASE WHEN [Lab] IS NOT NULL THEN 'Y' ELSE 'N' END AS [CL Lab]
	,CASE WHEN [Gifted] IS NOT NULL THEN 'Y' ELSE 'N' END AS [CL Gifted]
	,CASE WHEN [No credit] IS NOT NULL THEN 'Y' ELSE 'N' END AS [CL No Credit]
	,CASE WHEN [Not Applicable] IS NOT NULL THEN 'Y' ELSE 'N' END AS [CL N/A]
FROM
	(
	SELECT
		Course.COURSE_ID AS ID
		,Course.COURSE_TITLE AS Name
		,Course.STATE_COURSE_CODE AS StateCourseNumber
		,Course.CREDIT AS CreditValue
		,Course.DUAL_CREDIT As DualCredit
		,Course.ONLINE_COURSE AS OnlineDistance
		,Department.VALUE_DESCRIPTION AS Department
		,Subject1.VALUE_DESCRIPTION AS Subject1
		,Subject2.VALUE_DESCRIPTION AS Subject2
		,Subject3.VALUE_DESCRIPTION AS Subject3
		,Subject4.VALUE_DESCRIPTION AS Subject4
		,Subject5.VALUE_DESCRIPTION AS Subject5
		
		,CourseHistoryType.VALUE_DESCRIPTION AS CourseHistoryType
		,CourseLevelDescription.VALUE_DESCRIPTION AS CourseLevel
	FROM
		rev.EPC_CRS AS Course

		LEFT JOIN
		APS.LookupTable('k12.courseinfo','department') AS Department
		ON
		Course.DEPARTMENT = Department.VALUE_CODE

		LEFT JOIN
		APS.LookupTable('k12.coursehistoryinfo','course_history_type') AS CourseHistoryType
		ON
		Course.COURSE_HISTORY_TYPE = CourseHistoryType.VALUE_CODE

		LEFT JOIN
		rev.EPC_CRS_LEVEL_LST As CourseLevel
		ON
		Course.COURSE_GU = CourseLevel.COURSE_GU

		LEFT JOIN
		APS.LookupTable('k12.CourseInfo','Sced_course_level') AS CourseLevelDescription
		ON
		CourseLevel.COURSE_LEVEL = CourseLevelDescription.VALUE_CODE

		LEFT JOIN
		APS.LookupTable('k12.CourseInfo','Subject_Area') AS Subject1
		ON
		Course.SUBJECT_AREA_1 = Subject1.VALUE_CODE

		LEFT JOIN
		APS.LookupTable('k12.CourseInfo','Subject_Area') AS Subject2
		ON
		Course.SUBJECT_AREA_2 = Subject2.VALUE_CODE

		LEFT JOIN
		APS.LookupTable('k12.CourseInfo','Subject_Area') AS Subject3
		ON
		Course.SUBJECT_AREA_3 = Subject3.VALUE_CODE

		LEFT JOIN
		APS.LookupTable('k12.CourseInfo','Subject_Area') AS Subject4
		ON
		Course.SUBJECT_AREA_4 = Subject4.VALUE_CODE

		LEFT JOIN
		APS.LookupTable('k12.CourseInfo','Subject_Area') AS Subject5
		ON
		Course.SUBJECT_AREA_5 = Subject5.VALUE_CODE

	WHERE
		Course.INACTIVE = 'N'
	) AS MainPull

	PIVOT
	(
		Max(CourseLevel)
		FOR CourseLevel IN ([Basic or remedial course], [General or regular course], [Enriched or advanced course], [Honors course], [Dual/concurrent enrollment course],[Articulation agreement course],[Industry/occupational certification course],[Lab],[Gifted],[No credit],[Not Applicable])
	) AS PivotTable
