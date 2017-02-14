/*
 * Revision 1
 * Last Changed By:    JoAnn Smith
 * Last Changed Date:  2/13/17
 * Written by:         JoAnn Smith
 ******************************************************
 Active elementary homeroom teachers in SY 2016
 ******************************************************
 */

;with teacherCTE
as
(
select distinct(sao.STAFF_GU), LAST_NAME, FIRST_NAME, sao.PERIOD_BEGIN, sao.ORGANIZATION_NAME
 from aps.ScheduleDetailsAsOf(getdate()) sao
inner join
rev.rev_person per
on per.person_gu = sao.staff_gu

 where 
	----elementary schools
	--sao.ENROLLMENT_GRADE_LEVEL in ('090','100', '110', '120', '130', '140', '150')
	----fourth and fifth only
	sao.ENROLLMENT_GRADE_LEVEL in ('140', '150')
	and period_begin = 1
)
select organization_name as [School Name], count(*) as [Teacher Count] from teacherCTE tea 
group by Organization_name
order by organization_name
--select * from teacherCTE
--order by ORGANIZATION_NAME, LAST_NAME, FIRST_NAME
