/*

Andy�

Here is the final student list for the data request from Catholic Charities. This request is very similar to what we�ve recently done for Lutheran Family Services but the requested data is for less elements. For CC we need the following data for the listed students:

�	Attendance data for 2016-17 and 2017-18 to date (counts of excused and unexcused absences, half and full day).
�	Final course grades for 2016-17 classes.
�	Grades for courses taken in 2017-18.

Revision I - include all course grades for 2016 --- redid the Student_Grades CTE

*/

EXECUTE AS LOGIN='QueryFileUser'
GO

;with All_Students
as
(
SELECT 
	T1.[student ID] as SIS_NUMBER,
	t1.[First name] as FIRST_NAME,
	t1.[Last name] as LAST_NAME,
	t1.GENDER AS GENDER,
	t1.[date of birth] AS BIRTH_DATE,
	O.ORGANIZATION_NAME AS SCHOOL_NAME,
	LU.VALUE_DESCRIPTION AS GRADE_LEVEL,
	bs.STUDENT_GU
FROM
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
		'SELECT * from CCDataRequest.csv'
                ) AS T1
LEFT JOIN
	APS.BasicStudent BS
on
	BS.SIS_NUMBER = t1.[Student ID]
INNER JOIN
	REV.EPC_STU ST
ON
	BS.STUDENT_GU = ST.STUDENT_GU
INNER JOIN
	APS.PrimaryEnrollmentsAsOf('2017-05-25') E
ON
	ST.STUDENT_GU = E.STUDENT_GU
INNER JOIN
	REV.REV_ORGANIZATION_YEAR OY
ON
	E.ORGANIZATION_YEAR_GU = OY.ORGANIZATION_YEAR_GU
INNER JOIN
	REV.REV_ORGANIZATION O
ON
	OY.ORGANIZATION_GU = O.ORGANIZATION_GU
LEFT JOIN
	APS.LookupTable('K12', 'Grade') as LU
on
	E.GRADE = LU.VALUE_CODE
)
,Student_Grades
as
(
SELECT
	A.STUDENT_GU,
	A.SIS_NUMBER,
	SSYGRD.SCHOOL_YEAR_COURSE_GU,
	PERIOD.SECTION_GU,
	PERIODMK.MARK,
	GRADEPDMK.MARK_NAME AS GRADE_PERIOD,
	COURSE.COURSE_ID,
	COURSE.COURSE_TITLE
FROM
	ALL_STUDENTS A
INNER JOIN
	REV.EPC_STU S
ON
	A.STUDENT_GU = S.STUDENT_GU 
INNER JOIN
	rev.EPC_STU_SCH_YR AS SSY
ON
	SSY.STUDENT_GU = S.STUDENT_GU
INNER JOIN
	rev.EPC_STU_SCH_YR_GRD AS SSYGRD
ON
	SSYGRD.STUDENT_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU
INNER JOIN
	REV.EPC_STU_SCH_YR_GRD_PRD PERIOD
ON
	PERIOD.STU_SCHOOL_YEAR_GRD_GU = SSYGRD.STU_SCHOOL_YEAR_GRD_GU
INNER JOIN
	REV.EPC_STU_SCH_YR_GRD_PRD_MK PERIODMK
ON
	PERIOD.STU_SCHOOL_YEAR_GRD_PRD_GU= PERIODMK.STU_SCHOOL_YEAR_GRD_PRD_GU
INNER JOIN
	rev.EPC_SCH_YR_GRD_PRD_MK GRADEPDMK
ON
	GRADEPDMK.SCHOOL_YEAR_GRD_PRD_MK_GU = PERIODMK.SCHOOL_YEAR_GRD_PRD_MK_GU
INNER JOIN
	rev.EPC_SCH_YR_CRS AS CRSYR
ON
	SSYGRD.SCHOOL_YEAR_COURSE_GU = CRSYR.SCHOOL_YEAR_COURSE_GU
INNER JOIN
	rev.EPC_CRS AS COURSE
ON
	CRSYR.COURSE_GU = COURSE.COURSE_GU
INNER JOIN
	rev.REV_YEAR AS YEARS
ON
	SSY.YEAR_GU = YEARS.YEAR_GU
	AND SCHOOL_YEAR = '2016' and extension = 'R'
INNER JOIN
	rev.EPC_STU AS STUDENT
ON
	SSY.STUDENT_GU = STUDENT.STUDENT_GU
WHERE
GRADEPDMK.MARK_NAME  NOT IN ('S1 Exam', 'S2 Exam') 
)
--select * from Student_Grades  where sis_number = 970034776 order by SIS_NUMBER, course_ID, GRADE_PERIOD
,Final_Results
as
(
select
	row_number() over(partition by a.SIS_NUMBER, course_id,	GRADE_PERIOD order by a.SIS_NUMBER, COURSE_ID, GRADE_PERIOD DESC) as rn,
	a.SIS_NUMBER,
	a.STUDENT_GU,
	a.LAST_NAME,
	a.FIRST_NAME,
	A.GENDER,
	A.BIRTH_DATE,
	'2016' as SCHOOL_YEAR,
	S.SCHOOL_NAME,
	S.GRADE_LEVEL,
	g.COURSE_ID,
	g.COURSE_TITLE,
	g.MARK,
	g.GRADE_PERIOD

from
	All_Students s
INNER join
	aps.BasicStudent a
on
	a.STUDENT_GU = s.STUDENT_GU
FULL OUTER join
	 Student_Grades G
on
	g.STUDENT_GU = s.STUDENT_GU
)
select * from Final_Results 
ORDER BY SIS_NUMBER, COURSE_ID, GRADE_PERIOD
