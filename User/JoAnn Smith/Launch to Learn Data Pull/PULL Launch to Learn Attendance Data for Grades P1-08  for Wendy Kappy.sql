declare @SM16 as table
(
	STUID nvarchar(20),
	TOTAL_DAYS int
)

-- TEMP TABLE FOR ATTENDANCE DAY TOTALS
insert into @SM16 (TOTAL_DAYS, STUID)  

	 (select sum(cast(MEMBER_DAYS as int)), STUID from dbo.Student_School_Memberdays SM  GROUP BY STUID)

-- TEMP TABLE FOR STUDENT ATTENDANCE DETAIL
declare @SA16 as table
(
	SIS_Number nvarchar(20),
	SchoolYear numeric(4,0),
	Grade nvarchar(600),
	HalfDayUnexcused decimal(5,2),
	FullDayUnexcused decimal(5,2),
	HalfDayExcused decimal(5,2),
	FullDayExcused decimal(5,2)
)

INSERT INTO @SA16
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
	 SA16.[SIS Number] as [Student APS ID],
	 SchoolYear = '2016',
	 SA16.Grade as [Grade Level],
	 SA16.[Half-Day Unexcused] as [1/2-day Unexcused Absences],
	 SA16.[Full-Day Unexcused] as [Full-day Unexcused Absences],
	 SA16.[Half-Day Excused] as [1/2-day Excused Absences],
	 SA16.[Full-Day Excused] as [Full-Day Excused Absences]
	 
FROM 
	dbo.STUDENT_ATTENDANCE SA16

WHERE
	SA16.GRADE IN ('P1', 'P2', 'PK', 'K', '01', '02', '03', '04', '05', '06', '07', '08')

--JOIN BOTH TABLES
SELECT DISTINCT A.SIS_Number, A.SchoolYear, A.Grade, A.HalfDayUnexcused, A.FullDayUnexcused, A.HalfDayExcused, A.FullDayExcused, B.TOTAL_DAYS 
	
FROM
	 @SA16 A inner join @SM16 B on A.SIS_Number = B.STUID
ORDER BY 
	 A.GRADE, A.SIS_Number





	 