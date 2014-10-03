/**
 * $Revision$
 * $LastChangedBy$
 * $LastChangedDate$
 *
 * Pulls sections that have kids in them for a given date that are tagged
 * But are not considered ELL calasses (due mostly to bad licensures or incorrect tagging) 
 *
 * It returns one record per section, student and ELL student counts and basic course/primary staff info
 */

DECLARE @AsOfDate DATE = GETDATE()

SELECT
	*
FROM
	(
	SELECT
		Sections.SECTION_GU
		,Sections.ORGANIZATION_GU
		,School.ORGANIZATION_NAME
		,Sections.TERM_CODE
		,Sections.COURSE_ID
		,Sections.COURSE_TITLE
		,Sections.SECTION_ID
		,Sections.StudentCount
		,Sections.ELLStudentCount
		,Staff.BADGE_NUM 
		,Person.LAST_NAME
		,Person.FIRST_NAME
		,Tag.TAG
	FROM
		(
		SELECT
			Schedule.SECTION_GU
			,ORGANIZATION_GU
			,COURSE_GU
			,STAFF_GU
			,YEAR_GU

			,SECTION_ID
			,TERM_CODE
			,ROOM_SIMPLE
			,PERIOD_BEGIN
			,PERIOD_END
			,COURSE_ID
			,COURSE_TITLE
			,CREDIT
			,COUNT(Schedule.STUDENT_GU) AS StudentCount
			,SUM(CASE WHEN ELL.STUDENT_GU IS NULL THEN 0 ELSE 1 END) AS ELLStudentCount
		FROM
			APS.ScheduleAsOf(@asOfDate) AS Schedule
			-- This joins limits this to only sections that have been tagged.
			INNER JOIN
			rev.UD_SECTION_TAG AS Tag
			ON
			Schedule.SECTION_GU = Tag.SECTION_GU
			AND Tag.TAG LIKE 'ALS%'

			LEFT JOIN
			APS.ELLAsOf(@asOfDate) AS ELL
			ON
			Schedule.STUDENT_GU = ELL.STUDENT_GU
		--/*
		GROUP BY
			Schedule.SECTION_GU
			,ORGANIZATION_GU
			,COURSE_GU
			,STAFF_GU
			,YEAR_GU

			,SECTION_ID
			,TERM_CODE
			,ROOM_SIMPLE
			,PERIOD_BEGIN
			,PERIOD_END
			,COURSE_ID
			,COURSE_TITLE
			,CREDIT
		) AS Sections

		INNER JOIN
		rev.REV_ORGANIZATION AS School
		ON
		Sections.ORGANIZATION_GU = School.ORGANIZATION_GU

		LEFT JOIN
		rev.EPC_STAFF AS Staff
		ON
		Sections.STAFF_GU = Staff.STAFF_GU

		LEFT JOIN
		rev.REV_PERSON AS Person
		ON
		Sections.STAFF_GU = PERSON.PERSON_GU
				
		LEFT JOIN
		APS.LCEClassesAsOf(@AsOfDate) AS LCE
		ON
		Sections.SECTION_GU = LCE.SECTION_GU

		INNER JOIN
		REV.UD_SECTION_TAG AS Tag
		ON
		Sections.SECTION_GU = Tag.SECTION_GU
		AND Tag.TAG LIKE 'ALS%'
	WHERE
		LCE.SECTION_GU IS NULL
	) AS SectionsWithTags

	PIVOT
	(
		COUNT(TAG)
		FOR
		TAG
		IN (
			 [ALS2W]
			,[ALSED]
			,[ALSES]
			,[ALSLA]
			,[ALSMA]
			,[ALSMP]
			,[ALSOT]
			,[ALSSC]
			,[ALSSH]
			,[ALSSS]
			,[ALSNV]
		)

	) AS PivotedSectionData
WHERE
	ORGANIZATION_GU LIKE '%' -- Needed if its going to turn into a report.