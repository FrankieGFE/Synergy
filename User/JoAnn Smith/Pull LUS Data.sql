/*
Pull LUS History Data for P1, P2, PK Students
Request from Jude

Written by:		JoAnn Smith
Date Written:	9/26/2017
please pull any pre-school PK, P1, P2 students who have LUS questions filled in and send a file to us.
The data is in the table UD_UDLUS_HISTORY table and they show on the Student screen>APS tab.
Please include School, Student ID, Student Name, Grade Level and the LUS data that exists in the file.
Update all these records to null for the Q fields.
*/

begin tran
	update rev.ud_lus_history 
	set
		Q1_Student = null,
		Q2_Student = null,
		Q3_Student = null,
		Q4_Student = null,
		Q5_Student = null,
		Q6_Student = null,
		Q7A_Student = null,
		Q7B_Student = null,
		Q7C_Student = null,
		DATE_ASSIGNED = null
where
	udlus_history_gu in
(
	

select
	luh.udlus_history_gu,
	 esi.SCHOOL_NAME,
	 bs.SIS_NUMBER,
	 bs.LAST_NAME,
	 bs.FIRST_NAME,
	 bs.MIDDLE_NAME,
	 esi.GRADE_LEVEL,
	 luh.Q1_STUDENT,
	 luh.Q2_STUDENT,
	 luh.Q3_STUDENT,
	 luh.Q4_STUDENT,
	 luh.Q5_STUDENT,
	 luh.Q6_STUDENT,
	 luh.Q7A_STUDENT,
	 luh.Q7B_STUDENT,
	 luh.Q7C_STUDENT
from
	 rev.ud_lus_history luh
inner join
	aps.BasicStudentWithMoreInfo bs
on
	luh.STUDENT_GU = bs.STUDENT_GU
left join
	aps.GetExtendedStudentInformation(GETDATE()) esi
on
	esi.student_gu = luh.student_gu
where
	GRADE_LEVEL in ('PK', 'P1', 'P2')
--ORDER BY
--	SCHOOL_NAME, GRADE_LEVEL
)
rollback
--commit

