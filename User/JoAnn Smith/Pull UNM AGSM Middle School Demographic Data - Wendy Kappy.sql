/*
 * Revision 1
 * Last Changed By:    JoAnn Smith
 * Last Changed Date:  2/27/17
 * Written by:         JoAnn Smith
 ******************************************************
 Pull Demographic Data for Middle School Students in
 Schools 410, 413, 416, 420, 427, 440, 448, 470
 ******************************************************
 */
declare @AsOfDate datetime2 = '2016-05-25'
select
	ped.SCHOOL_YEAR as [School Year],
	bs.SIS_NUMBER as [Student APS ID],
	bs.LAST_NAME + ', ' + bs.FIRST_NAME as [Student Name],
	ped.SCHOOL_CODE as [School Location Number],
	ped.SCHOOL_NAME as [School Name],
	ped.grade as [Student Grade Level],	
	bs.RESOLVED_RACE as [Resolved Race],
	bs.GENDER as [Gender],
	bs.LUNCH_STATUS as [Free and Reduced Lunch Status],
	bs.ELL_STATUS as [ELL Status],
	bs.SPED_STATUS as [SPED Status],
	bs.GIFTED_STATUS as [Gifted Status]
from
	aps.BasicStudentWithMoreInfo bs
inner join
	aps.PrimaryEnrollmentDetailsAsOf(@AsOfDate) ped
on
	ped.STUDENT_GU = bs.STUDENT_GU
where
	ped.SCHOOL_CODE in ('410', '413', '416', '420', '427', '440', '448', '470')
order by
	[School Location Number], [Student Grade Level], [Student APS ID]

