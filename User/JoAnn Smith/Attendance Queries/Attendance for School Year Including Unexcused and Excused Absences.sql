select distinct SA14.[SIS Number] as [Student APS ID],
	 SchoolYear = '2014',
	 SA14.Grade as [Grade Level],
	 SA14.[Half-Day Unexcused] as [1/2-day Unexcused Absences],
	 SA14.[Full-Day Unexcused] as [Full-day Unexcused Absences],
	 SA14.[Half-Day Excused] as [1/2-day Excused Absences],
	 SA14.[Full-Day Excused] as [Full-Day Excused Absences],
	 (select sum(cast(MEMBER_DAYS as int)) from dbo.Student_School_Memberdays_2014 SM where SA14.[SIS Number] = SM14.STUID) as MemberDays
	 
 from 
	dbo.STUDENT_ATTENDANCE_2014 SA14  inner join dbo.STUDENT_SCHOOL_MEMBERDAYS_2014 SM14 on SA14.[SIS Number] = SM14.STUID
 
 where 
	SA14.GRADE IN ('P1', 'P2', 'PK', 'K', '01', '02', '03', '04', '05', '06', '07', '08')
	and SA14.[SIS Number] = '100103647'

group by
		 SA14.[SIS Number], sa14.Grade, sa14.[Half-Day Unexcused], sa14.[Full-Day Unexcused], sa14.[Half-Day Excused], sa14.[Full-Day Excused], sm14.MEMBER_DAYS, sm14.STUID

