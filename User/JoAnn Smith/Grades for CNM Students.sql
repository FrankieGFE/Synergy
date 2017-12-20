/*JoAnn, I need some data added to the attached template ‘StudentGrades’ please.  These grades have to be in Synergy by 1/3, but Debbie or I can do the final grade load using the StudentGrades import file you’ll be populating and the SIS Data Import screen if we can get this data finalized.  Please prioritize working on this request as your top priority before you leave for winter break.  Please let me know if you have any questions and we can meet an go over.

1.	Use the STARS_ID (Col. F) in the attached file ‘DCFinalGrade_APS_Fall 2017’ to lookup the student’s SIS_NUMBER in Synergy.
2.	Use the SUBJ_CODE (Col. I) and COURSE_NUM (Col. J) from the file ‘DCFinalGrade_APS_Fall 2017’ together to match to the same COURSE_ID in the student’s Synergy schedule.
3.	Populate the attached ‘StudentGrades’ file with the matched SIS_NUMBER from Synergy, the same static values in the file for columns B – E, the SECTION_ID from Synergy for the matched course and the letter grade from the CNM file ‘‘DCFinalGrade_APS_Fall 2017’ in Column P GRADE_MARK in the ‘StudentGrades’ file.
*/

EXECUTE AS LOGIN='QueryFileUser'
GO



SELECT
	ST.SIS_NUMBER,
	students.STARS_ID,
	students.LAST_NAME,
	STUDENTS.FIRST_NAME,
	'701' as SCHOOL_CODE,
	--'2017.R' AS SCHOOL_YEAR,
	Y.SCHOOL_YEAR,
	Y.EXTENSION,
	'3RD 6 WEEKS' AS GRADING_TERM,
	'S1 GRADE' AS MARK_NAME,
	C.COURSE_ID,
	C.COURSE_TITLE,
	SECT.SECTION_ID,
	'' AS ABS1,
	'' AS ABS2,
	'' AS ABS3,
	'' AS ABS4,
	'' AS ABS5,
	'' AS ABS6,
	'' AS CONDUCT,
	'' AS CITIZENSHIP,
	'' AS WORKHABITS,
	FINAL_GRADE AS GRADE_MARK,
	'' AS COMMENT_1,
	'' AS COMMENT_2,
	'' AS COMMENT_3,
	'' AS COMMENT_4,
	'' AS COMMENT_5,
	'' AS COMMENT_6,
	'' AS COMMENT_7,
	'' AS COMMENT_8,
	'' AS COMMENT_9,
	'' AS TEACHER_AD_HOC_COMMENT
FROM
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
		'SELECT * from DCFinalGradeAPSFall2017WithChanges.csv') STUDENTS
LEFT JOIN
	REV.EPC_STU ST
ON
	STUDENTS.STARS_ID = ST.STATE_STUDENT_NUMBER
LEFT JOIN
	REV.EPC_CRS C
ON
	cast(STUDENTS.SUBJ_CODE as nvarchar(10)) + cast(STUDENTS.COURSE_NUM AS NVARCHAR(10)) = C.COURSE_ID
LEFT JOIN
	REV.EPC_SCH_YR_CRS SSYC
ON
	SSYC.COURSE_GU = C.COURSE_GU
LEFT JOIN
	REV.EPC_SCH_YR_SECT SECT
ON
	SECT.SCHOOL_YEAR_COURSE_GU = SSYC.SCHOOL_YEAR_COURSE_GU
LEFT JOIN
	REV.REV_ORGANIZATION_YEAR OY
ON
	OY.ORGANIZATION_YEAR_GU = SSYC.ORGANIZATION_YEAR_GU
LEFT JOIN
	REV.REV_YEAR Y
ON
	Y.YEAR_GU = OY.YEAR_GU
WHERE
	SCHOOL_YEAR IN (SELECT SCHOOL_YEAR FROM rev.SIF_22_Common_CurrentYear) 
order by 
STUDENTS.STARS_ID





