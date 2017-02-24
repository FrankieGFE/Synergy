/*
 * Revision 1
 * Last Changed By:    JoAnn Smith
 * Last Changed Date:  2/21/17
 * Written by:         JoAnn Smith
 ******************************************************
 Period Attendance Data for Manzano High School for
 SYs 2015 and 2016 (Wendy Kappy) ONLY STUDENTS WHO
 HAVE BEEN ENROLLED ALL YEAR
 ******************************************************
 */
declare @SchoolCode nvarchar(10) = '530'
declare @FirstDay datetime2 = '2016-08-11'
declare @LastDay datetime2 = GETDATE()

--get all students in @SchoolCode in Grades 9-12
;With StudentCTE
as
(
select
     ped.SCHOOL_YEAR,
	 bs.SIS_NUMBER,
	 bs.LAST_NAME,
	 bs.FIRST_NAME,
	 ped.SCHOOL_CODE,
	 ped.SCHOOL_NAME,
	 ped.GRADE,
	 bs.RESOLVED_RACE,
	 bs.gender,
	 bs.ELL_STATUS,
	 bs.LUNCH_STATUS,
	 bs.SPED_STATUS,
	 bs.GIFTED_STATUS,
	 bs.STUDENT_GU
from
	aps.BasicStudentWithMoreInfo bs
inner join
	aps.PrimaryEnrollmentDetailsAsOf(@LastDay) ped
on
	bs.STUDENT_GU = ped.student_gu
where
	ped.SCHOOL_CODE = '530'
and
	ped.grade in ('09', '10', '11', '12')
)
--select * from studentcte 
,
AttendanceCTE
as
(
	SELECT 
	row_number() over (partition by firstday.student_gu order by firstday.student_gu) as Rownum,
	firstday.STUDENT_GU,
	firstday.school_code,
	firstday.school_name,
	firstday.grade,
	attend.PERIOD_BEGIN,
	attend.[Total Count by Period] AS [Absence Count]

FROM 
	APS.PrimaryEnrollmentDetailsAsOf(@FirstDay) AS FIRSTDAY
INNER JOIN 
	APS.PrimaryEnrollmentDetailsAsOf(@LastDay) AS LASTDAY
ON 
	FIRSTDAY.STUDENT_SCHOOL_YEAR_GU = LASTDAY.STUDENT_SCHOOL_YEAR_GU
INNER JOIN 
	rev.EPC_STU AS STU
ON 
	FIRSTDAY.STUDENT_GU = STU.STUDENT_GU
INNER JOIN 
	APS.AttendanceTotalsByPeriod(@LastDay) AS ATTEND
ON
	ATTEND.Student_Gu = FIRSTDAY.STUDENT_GU
where
	firstday.grade in ('09', '10', '11', '12')
and
	firstday.SCHOOL_CODE = '530'
and
	firstday.enter_date = @FirstDay
)

,
ResultsCTE
as
(
select
	 Student.SCHOOL_YEAR as [School Year],
	 Student.SIS_NUMBER as [Student APS ID],
	 Student.LAST_NAME as [Student Last Name],
	 Student.FIRST_NAME as [Student First Name],
	 Attend.School_Code as [School Location Number],
	 Student.SCHOOL_NAME as [School Name],
	 Student.GRADE,
	 Student.RESOLVED_RACE as [Resolved Race],
	 Student.GENDER as [Gender],
	 Student.LUNCH_STATUS as [Free and Reduced Lunch Status],
	 Student.ELL_STATUS as [ELL Status],
	 Student.SPED_STATUS as [SPED Status],
	 Student.GIFTED_STATUS as [Gifted Status],
	 Attend.period_begin as [Period],
	 Attend.[Absence Count] as [Unexcused/Excused Count]
from
	StudentCTE Student
inner join
	AttendanceCTE Attend
on
	student.STUDENT_GU = attend.STUDENT_GU
where
	--ALSO for NONCURRENT SCHOOL YEARS, 8TH AND 7TH GRADERS WERE INCLUDED SO REMOVE THEM
	student.Grade not in ('07', '08', 'C1', 'C2', 'C3', 'C4', 'T1', 'T2', 'T3', 'T4')
group by
	student.SIS_NUMBER,
	STUDENT.LAST_NAME,
	STUDENT.FIRST_NAME,
	STUDENT.GENDER,
	STUDENT.RESOLVED_RACE,
	STUDENT.ELL_STATUS,
	STUDENT.LUNCH_STATUS,
	STUDENT.SPED_STATUS,
	STUDENT.GIFTED_STATUS,
	ATTEND.PERIOD_BEGIN,
	ATTEND.SCHOOL_CODE,
	Student.GRADE,
	ATTEND.[Absence Count],
	Student.SCHOOL_YEAR,
	Student.SCHOOL_NAME

)

--select * from ResultsCTE where [Student APS ID] = 980032071
select *
from (
	select
		[School Year],
		[Student APS ID],
		[Student First Name],
		[Student Last Name],
		[School Location Number],
		[School Name],
		Grade,
		[Resolved Race],
		Gender,
		[Free and Reduced Lunch Status],
		[ELL Status],
		[SPED Status],
		[Gifted Status],
		isnull([Unexcused/Excused Count], 0) as [Unexcused/Excused Count],
		[Period]
	from
		ResultsCTE
		) as R
	PIVOT
	(
		Sum([Unexcused/Excused Count])
		FOR Period in ([1], [2], [3], [4], [5], [6], [7])
	)
	as PIVTABLE

	order by 		
		[Grade],
		[Student APS ID]

GO



	 