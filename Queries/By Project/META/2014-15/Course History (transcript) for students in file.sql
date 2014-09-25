/* Brian Rieb
 * 9/25/2014
 *
 * Original request by: Jude Garcia
 *
 * For students in a given file, "need the transcript of grades earned" 
 *
 */

-- Add the next to lines to simulate running as a non-ad account
EXECUTE AS LOGIN='QueryFileUser'
GO

SELECT 
	Student.SIS_NUMBER AS [Student ID]
	,Student.STATE_STUDENT_NUMBER AS [Student State ID]
	,CourseHistory.SCHOOL_YEAR AS [School Year]
	,GradeLevel.VALUE_DESCRIPTION AS [Grade Level]
	,COALESCE(School.SCHOOL_CODE,NonDistrictSchool.NAME) AS School
	,CourseHistory.TERM_CODE AS [Term]
	,CourseHistory.COURSE_ID AS [Course #]
	,CourseHistory.COURSE_TITLE AS [Course]
	,CourseHistory.CREDIT_ATTEMPTED AS [Credit Attempted]
	,CourseHistory.CREDIT_COMPLETED AS [Credit Completed]
	,CourseHistory.MARK AS Mark
	,CASE WHEN CourseHistory.REPEAT_TAG_GU IS NOT NULL THEN 'X' ELSE '' END AS [Repeat]
FROM 
	-- List of kids
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
		'SELECT * from META2014Ids.txt'
	    ) AS Kids
	INNER JOIN
	rev.EPC_STU AS Student
	ON
	Kids.ID_NBR = Student.SIS_NUMBER
	
	-- grabbing course history (left join in case a kid does not have it)
	LEFT JOIN
	rev.EPC_STU_CRS_HIS AS CourseHistory
	ON
	Student.STUDENT_GU = CourseHistory.STUDENT_GU

	LEFT JOIN
	APS.LookupTable('K12','Grade') AS GradeLevel
	ON
	CourseHistory.GRADE = GradeLevel.VALUE_CODE

	LEFT JOIN
	rev.EPC_SCH AS School
	ON
	CourseHistory.SCHOOL_IN_DISTRICT_GU = School.ORGANIZATION_GU

	LEFT JOIN
	rev.EPC_SCH_NON_DST AS NonDistrictSchool
	ON
	CourseHistory.SCHOOL_NON_DISTRICT_GU = NonDistrictSchool.SCHOOL_NON_DISTRICT_GU

ORDER BY
	Student.SIS_NUMBER
	,CourseHistory.SCHOOL_YEAR
	,COALESCE(School.SCHOOL_CODE,NonDistrictSchool.NAME)
	,CourseHistory.TERM_CODE

-- Always conclude your statement with these last two lines so it reverts back
-- to your user
REVERT
GO
