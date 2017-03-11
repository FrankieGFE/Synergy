/*
 * Revision 1
 * Last Changed By:    JoAnn Smith
 * Last Changed Date:  3/8/17
 * Written by:         JoAnn Smith
 ******************************************************
 Pull Attendance Data for Middle School Students in
 Schools 410, 413, 416, 420, 427, 440, 448, 470


 ******************************************************
 */
EXECUTE AS LOGIN='QueryFileUser'
GO

;with StudentCTE
as
(
SELECT 
		t1.[Student APS ID],
		t1.[School Location Number]

		FROM
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
		'SELECT * from edlead2014.csv'
                ) AS [T1]
)
--select * from StudentCTE

,StuAttendDetail
as
(

SELECT
	row_number() over (partition by [Student APS ID] order by md.Enter_Date desc) as Rownum,
	att.SCHYR as [School Year],
	 att.IDNBR as [Student APS ID],
	 case 
		when sa.[SIS Number] is null then 0.00 else
			sa.[Half-Day Unexcused] end as [1/2-day Unexcused Absences],
	 case 
		when sa.[SIS Number] is null then 0.00 else SA.[Full-Day Unexcused] end as [Full-day Unexcused Absences],
	 case 
		when sa.[SIS Number] is null then 0.00 else SA.[Half-Day Excused] end as [1/2-day Excused Absences],
	 case 
		when sa.[SIS Number] is null then 0.00 else SA.[Full-Day Excused] end as [Full-Day Excused Absences],
	 att.SCHNBR,
	 att.grade,
	 att.MEMBERDAYS as [Member Days],
	 md.ENTER_DATE

	 
FROM 	
	dbo.ATTENDANCE_2014 ATT
left join
	dbo.STUDENT_SCHOOL_MEMBERDAYS_2014 as md
on
	 md.SIS_NUMBER = att.IDNBR
	 and md.SCHOOL_CODE = att.SCHNBR
left hash join
	(select [SIS Number], [School Code], sum([Half-Day Excused]) as[Half-Day Excused] , sum([Full-Day Excused]) as [Full-Day Excused], sum([Total Excused]) as [Total Excused], sum([Half-Day UnExcused]) as [Half-Day UnExcused], sum([Full-Day UnExcused]) as [Full-Day UnExcused], sum([Total UnExcused]) as [Total UnExcused] from 
		dbo.STUDENT_ATTENDANCE_2014 ATT 
		group by [SIS Number], [School Code]) as SA
on
	att.IDNBR = sa.[SIS Number]
	and att.SCHNBR = sa.[School Code]
inner join
	StudentCTE Stu
on
	stu.[Student APS ID] = att.IDNBR
	and stu.[School Location Number ] = att.SCHNBR
)
select
	 *
from
	StuAttendDetail SD
where 
	Rownum = 1 
order by
	SCHNBR, GRADE, [Student APS ID]

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

