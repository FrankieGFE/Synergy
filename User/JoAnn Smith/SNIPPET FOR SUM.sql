select * from dbo.STUDENT_SCHOOL_MEMBERDAYS_2014
where stuid = '970040866'

select * from dbo.STUDENT_ATTENDANCE_2014 SA
where SA.[SIS Number]= '100103647'

	 (select sum(cast(MEMBER_DAYS as int)) from dbo.Student_School_Memberdays_2014 SM where sm.STUId = '970040866')

	 select member_days from dbo.STUDENT_SCHOOL_MEMBERDAYS_2014 sm where sm.stuid = '980002971'


