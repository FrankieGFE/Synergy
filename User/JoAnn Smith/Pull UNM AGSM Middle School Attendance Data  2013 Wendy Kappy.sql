/*
 * Revision 1
 * Last Changed By:    JoAnn Smith
 * Last Changed Date:  3/2/17
 * Written by:         JoAnn Smith
 ******************************************************
 Pull Attendance Data for Middle School Students in
 Schools 410, 413, 416, 420, 427, 440, 448, 470
 ******************************************************
 */
declare @AsOfDate datetime2 = getdate()
;
with StudentData
as
(
select
	bs.SIS_NUMBER as [Student APS ID],
	ped.SCHOOL_CODE as [School Location Number],
	ped.grade as [Student Grade Level],
	ped.SCHOOL_YEAR	
from
	aps.BasicStudentWithMoreInfo bs
inner join
	aps.PrimaryEnrollmentDetailsAsOf(@AsOfDate) ped
on
	ped.STUDENT_GU = bs.STUDENT_GU
where
	ped.SCHOOL_CODE in ('410', '413', '416', '420', '427', '440', '448', '470')
)
--select * from studentData --where [Student APS ID] = 828321125
--order by [School Location Number], [Student Grade Level], [Student APS ID]
,TotalDays
as

(
select
	sm.SCHOOL_YEAR as [School Year],
	sm.grade,
	sm.SCHOOL_CODE,
	sm.SIS_NUMBER as [Student APS ID],
	min(sm.ENTER_DATE) as [Enter Date],
	max(sm.leave_date) as [Leave Date],
	sum(cast(MEMBERDAYS as int)) as [Member Days]
from
	 dbo.Student_School_Memberdays SM
INNER JOIN
	StudentData SD
on
	sd.[Student APS ID] = sm.SIS_NUMBER
	AND SD.[School Location Number] = SM.SCHOOL_CODE
GROUP BY
	 sm.SIS_NUMBER,
	MEMBERDAYS,
	sm.SCHOOL_YEAR,
	sm.SCHOOL_CODE,
	sm.GRADE 
)
--select * from TotalDays where [Student APS ID] = 828321125
--order by SCHOOL_CODE, GRADE, [Student APS ID]

, IntCTE
as
(

select 	row_number() over (partition by td.[Student APS ID] order by [Leave Date] desc) as Rownum, td.*

from TotalDays td
)

--select * from IntCTE where Rownum = 1

--************************************************************************

,StuAttendDetail
as
(

SELECT
	td.[School Year],
	 att.SIS_NUMBER as [Student APS ID],
	 case 
		when sa.[SIS Number] is null then 0.00 else
			sa.[Half-Day Unexcused] end as [1/2-day Unexcused Absences],
	 case 
		when sa.[SIS Number] is null then 0.00 else SA.[Full-Day Unexcused] end as [Full-day Unexcused Absences],
	 case 
		when sa.[SIS Number] is null then 0.00 else SA.[Half-Day Excused] end as [1/2-day Excused Absences],
	 case 
		when sa.[SIS Number] is null then 0.00 else SA.[Full-Day Excused] end as [Full-Day Excused Absences],
	 att.SCHOOL_CODE,
	 att.grade,
	 td.[Member Days],
	 row_number() over (partition by int.[Student APS ID] order by int.[Student APS ID]) as Rownum

	 
FROM 
	dbo.ATTENDANCE_2016 ATT
LEFT join
	dbo.STUDENT_ATTENDANCE SA
on
	sa.[SIS Number] = att.SIS_NUMBER
	and sa.[School Code]= att.SCHOOL_CODE
inner join
	TotalDays TD
on
	att.SIS_NUMBER = td.[Student APS ID]
	and att.SCHOOL_CODE= td.SCHOOL_CODE
inner join
	intCTE INT
on
	int.[Student APS ID] = att.SIS_NUMBER

)
select
	 *
from
	StuAttendDetail SD
where
	Rownum = 1 
order by
	school_code, GRADE, [Student APS ID]

--where
--	[Student APS ID] = 828321125


--where [Student APS ID] in (479958340,
--712347392,
--970026085,
--970027434,
--970035272)

--where [Student APS ID] in 
--('733222897',
--'970030706',
--'970034023',
--'970024406',
--'970026059',
--'980006444',
--'645919333',
--'970088968',
--'104493499',
--'970018433',
--'970021577',
--'970041914',
--'970049821',
--'828321125',
--'970025032',
--'970026006',
--'970027440',
--'970031545',
--'970061699',
--'165513771',
--'814313110',
--'592191183',
--'970038541',
--'970025228',
--'897383121',
--'970019043',
--'583478177',
--'970033940',
--'151561578',
--'980025881',
--'103445243')

