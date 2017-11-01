;with Main
as
(
select
	row_number() over (partition by a.staff_gu order by a.staff_gu) as rn,
	a.STAFF_GU,
	st.BADGE_NUM,
	a.PRIMARY_TEACHER,
	p.LAST_NAME,
	p.FIRST_NAME,
	s.DEPARTMENT,
	o.ORGANIZATION_NAME
from 
	aps.SectionsAndAllStaffAssignedAsOf('2017-10-11') a
inner join
	rev.EPC_STAFF_SCH_YR s
on
	a.STAFF_GU = s.STAFF_GU
inner join
	rev.rev_organization_year oy
on
	oy.ORGANIZATION_YEAR_GU = s.ORGANIZATION_YEAR_GU
inner join
	rev.rev_organization o
on
	oy.ORGANIZATION_GU = o.ORGANIZATION_GU
inner join
	rev.epc_staff st
on
	a.STAFF_GU = st.STAFF_GU
inner join
	rev.rev_person p
on
	p.PERSON_GU = st.STAFF_GU
)
select * from Main
where rn = 1
order by ORGANIZATION_NAME, BADGE_NUM

