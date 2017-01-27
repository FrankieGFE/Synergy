
declare @SM as table
(
	STUID nvarchar(20),
	TOTAL_DAYS int
)

-- TEMP TABLE FOR ATTENDANCE DAY TOTALS
insert into @SM (STUID, TOTAL_DAYS)  

	 (select STUID, sum(cast(MEMBER_DAYS as int)) from dbo.Student_School_Memberdays SM  GROUP BY STUID)


-- TEMP TABLE FOR STUDENT ATTENDANCE DETAIL
declare @SA as table
(
	SIS_Number nvarchar(20),
	SchoolYear numeric(4,0),
	Grade nvarchar(600),
	HalfDayUnexcused decimal(5,2),
	FullDayUnexcused decimal(5,2),
	HalfDayExcused decimal(5,2),
	FullDayExcused decimal(5,2)
)

INSERT INTO @SA
(
SIS_Number,
SchoolYear,
Grade,
HalfDayUnexcused,
FullDayUnexcused,
HalfDayExcused,
FullDayExcused
)


SELECT

	 SA.[SIS Number] as [Student APS ID],
	 SchoolYear = '2016',
	 SA.Grade  as [Grade Level],
	 SA.[Half-Day Unexcused] as [1/2-day Unexcused Absences],
	 SA.[Full-Day Unexcused] as [Full-day Unexcused Absences],
	 SA.[Half-Day Excused] as [1/2-day Excused Absences],
	 SA.[Full-Day Excused] as [Full-Day Excused Absences]
	 
FROM 
	dbo.STUDENT_ATTENDANCE SA

WHERE
	SA.GRADE IN ('P1', 'P2', 'PK', 'K', '01', '02', '03', '04', '05', '06', '07', '08')
	
select distinct
	 A.SIS_Number, a.SchoolYear, A.Grade, sum([HalfDayUnexcused]) as HalfDayUnexcused, SUM([FullDayUnexcused]) as FullDayUnexcused, SUM([HalfDayExcused])as HalfDayExcused, SUM([FullDayExcused]) as FullDayExcused, TOTAL_DAYS
	
FROM
	 @SA A
INNER JOIN @SM B on A.SIS_Number = B.STUID
	 
group by
	SIS_Number, SchoolYear, Grade, TOTAL_DAYS







	 