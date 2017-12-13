/*

Andy—

Here is the final student list for the data request from Catholic Charities. This request is very similar to what we’ve recently done for Lutheran Family Services but the requested data is for less elements. For CC we need the following data for the listed students:

•	Attendance data for 2016-17 and 2017-18 to date (counts of excused and unexcused absences, half and full day).
•	Final course grades for 2016-17 classes.
•	Grades for courses taken in 2017-18.

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
select
	row_number() over(partition by s.STUDENT_GU, COURSE_ID, TERM_CODE ORDER BY S.STUDENT_GU, TERM_CODE DESC) AS RN,
	s.STUDENT_GU,
	h.MARK,
	h.TERM_CODE,
	h.SCHOOL_YEAR,
	h.COURSE_ID,
	h.COURSE_TITLE
from
	All_Students s
INNER join
	rev.epc_stu_crs_his h
on
	S.STUDENT_GU = H.STUDENT_GU	
WHERE

	SCHOOL_YEAR = '2016'
AND
	TERM_CODE = 'S2'
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
	row_number() over(partition by a.SIS_NUMBER, course_id,	TERM_CODE order by a.SIS_NUMBER, TERM_CODE DESC) as rn,
	a.SIS_NUMBER,
	a.STUDENT_GU,
	a.LAST_NAME,
	a.FIRST_NAME,
	A.GENDER,
	A.BIRTH_DATE,
	ISNULL(G.SCHOOL_YEAR, 2016) AS SCHOOL_YEAR,
	S.SCHOOL_NAME,
	S.GRADE_LEVEL,
	g.COURSE_ID,
	g.COURSE_TITLE,
	g.MARK,
	g.TERM_CODE

from
	All_Students s
left join
	aps.BasicStudent a
on
	a.STUDENT_GU = s.STUDENT_GU
FULL OUTER join
	 Student_Grades G
on
	g.STUDENT_GU = s.STUDENT_GU
)
select * from Final_Results WHERE RN = 1 
ORDER BY SIS_NUMBER

