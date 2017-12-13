/*

Andy—

Here is the final student list for the data request from Catholic Charities. This request is very similar to what we’ve recently done for Lutheran Family Services but the requested data is for less elements. For CC we need the following data for the listed students:

•	Attendance data for 2016-17 and 2017-18 to date (counts of excused and unexcused absences, half and full day).
•	Final course grades for 2016-17 classes.
•	Grades for courses taken in 2017-18.

*/

EXECUTE AS LOGIN='QueryFileUser'
GO

;
;with All_Students
as
(
SELECT 
	T1.[student ID] as SIS_NUMBER,
	t1.[First name] as FIRST_NAME,
	t1.[Last name] as LAST_NAME
FROM
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
		'SELECT * from CCDataRequest.csv'
                ) AS T1
)
--select * from All_Students
,Student_Details
as
(
select
	s.SIS_NUMBER,
	s.LAST_NAME,
	s.FIRST_NAME,
	bs.GENDER AS GENDER,
	BS.BIRTH_DATE AS BIRTH_DATE,
	O.ORGANIZATION_NAME AS SCHOOL_NAME,
	LU.VALUE_DESCRIPTION AS GRADE_LEVEL,
	bs.STUDENT_GU

from
	All_Students S
left JOIN
	APS.BasicStudent BS
on
	BS.SIS_NUMBER = s.SIS_NUMBER
left JOIN
	REV.EPC_STU ST
ON
	BS.STUDENT_GU = ST.STUDENT_GU
left JOIN
	APS.PrimaryEnrollmentsAsOf(getdate()) E
ON
	ST.STUDENT_GU = E.STUDENT_GU
left JOIN
	REV.REV_ORGANIZATION_YEAR OY
ON
	E.ORGANIZATION_YEAR_GU = OY.ORGANIZATION_YEAR_GU

left JOIN
	REV.REV_ORGANIZATION O
ON
	OY.ORGANIZATION_GU = O.ORGANIZATION_GU
LEFT JOIN
	APS.LookupTable('K12', 'Grade') as LU
on
	E.GRADE = LU.VALUE_CODE
)
--select * from Student_Details
,Student_Grades
as
(
select
	row_number() over(partition by s.STUDENT_GU, COURSE_ID, grade_period ORDER BY S.STUDENT_GU, grade_period DESC) AS RN,
	s.SIS_NUMBER,
	g.mark,
	g.GRADE_PERIOD,
	g.COURSE_ID

from
	Student_Details s
left join
	aps.StudentGrades g
on
	S.STUDENT_GU = g.STUDENT_GU	
--WHERE
--	GRADE_period = '2nd 6 Wk'

)
--select * from Student_Grades WHERE STUDENT_GU = '74C443B4-A953-41B7-B7C7-80F2428B85F2'
,Grade_Results
as
(
select
	*
from
	 Student_Grades g
WHERE
	 RN = 1
)
--select * from Grade_Results
,Final_Results
as
(
select
	row_number() over(partition by a.SIS_NUMBER, G.course_id,	GRADE_PERIOD order by a.SIS_NUMBER, GRADE_PERIOD DESC) as rn,
	a.SIS_NUMBER,
	a.STUDENT_GU,
	a.LAST_NAME,
	a.FIRST_NAME,
	A.GENDER,
	A.BIRTH_DATE,
	'2017' as SCHOOL_YEAR,
	S.SCHOOL_NAME,
	S.GRADE_LEVEL,
	g.COURSE_ID,
	C.COURSE_TITLE,
	G.GRADE_PERIOD,
	g.MARK

from
	Student_Details S
left join
	aps.BasicStudent a
on
	a.STUDENT_GU = s.STUDENT_GU
FULL OUTER join
	 Student_Grades G
on
	g.SIS_NUMBER = s.SIS_NUMBER
INNER JOIN
	REV.EPC_CRS C
ON
	G.COURSE_ID = C.COURSE_ID
)
select * from Final_Results WHERE RN = 1 
ORDER BY SIS_NUMBER

