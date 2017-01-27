--/*
-- * Revision 1
-- * Last Changed By:    JoAnn Smith
-- * Last Changed Date:  1/26/17
-- ******************************************************
-- Hanover will examine the impact of Nspire on students’ attendance.
--	1.	Attendance information for all Highland students between 2011-12 to Present school year
--	Total Membership days
--	Total absences
--	Total Present
--	School year identified

--Pull attendance data for Highland High School
--for Hanover Research (Brenda Martinez Papponi)
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--change members days file to proper year
--change attendance days file to proper year 
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 
-- ******************************************************
-- 1-26-2017 Initial query


with STUDENTCTE(SchoolCode, StudentID, TotalDays)
as
(  

	select
		 SCHOOL_CODE, 
		 SIS_NUMBER,
		 sum(cast(MEMBERDAYS as int)) as MemberDays
	from 
		dbo.Student_School_Memberdays_2014 SM
	where
		SCHOOL_CODE = '520'
	GROUP BY SIS_NUMBER, SCHOOL_CODE
)

,

STUDENTATTCTE(SISNumber, HalfDayUnexcused, FullDayUnexcused, HalfDayExcused, FullDayExcused)
as
(

SELECT
	 SA.[SIS Number] as [Student APS ID],
	 ISNULL(SA.[Half-Day Unexcused],0)  as [1/2-day Unexcused Absences],
	 ISNULL(SA.[Full-Day Unexcused],0) as [Full-day Unexcused Absences],
	 ISNULL(SA.[Half-Day Excused],0) as [1/2-day Excused Absences],
	 ISNULL(SA.[Full-Day Excused],0) as [Full-Day Excused Absences]
	 
FROM 
	dbo.STUDENT_ATTENDANCE_2014 SA
where
	sa.[School Code] = '520'
)

select
	SchoolYear = '2014',
	stu.StudentID,
	stu.SchoolCode,
	att.HalfDayUnexcused,
	att.FullDayUnexcused,
	att.HalfDayExcused,
	att.FullDayExcused,
	stu.TotalDays
from
	studentCTE STU
inner join
	STUDENTATTCTE att
on stu.StudentID = att.SISNumber




	REVERT
	GO	
	 








	 