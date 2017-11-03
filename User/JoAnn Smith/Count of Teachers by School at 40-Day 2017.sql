

CREATE FUNCTION [APS].[TeacherCountsAsOf](@AsOfDate DATETIME2)
RETURNS TABLE
AS
RETURN



/* school code, job title, primary teachers only */
/* 15-16, 16-17, 17-18 */

with Teachers
as
(
select
	row_number() over (partition by a.staff_gu order by a.staff_gu) as rn,
	a.STAFF_GU,
	p.LAST_NAME,
	p.FIRST_NAME,
	s.BADGE_NUM,
	o.ORGANIZATION_NAME,
	sch.SCHOOL_CODE,
	--s.type,
	--SUBSTRING(POSITION,4,7) as POSITION_CODE,
	--CAT.POSITION,
	CAT.JOB_CODE,
	J.DESCRIPTION
from 
	aps.SectionsAndAllStaffAssignedAsOf(@AsOfDate) a
inner join
	rev.epc_staff s
on
	a.STAFF_GU = s.STAFF_GU
inner join
	rev.epc_staff_sch_yr ssy
on
	a.STAFF_SCHOOL_YEAR_GU = ssy.STAFF_SCHOOL_YEAR_GU
inner join	
	rev.REV_ORGANIZATION_YEAR oy
on
	ssy.ORGANIZATION_YEAR_GU = oy.ORGANIZATION_YEAR_GU
inner join
	rev.rev_year yr
on
	oy.YEAR_GU = yr.YEAR_GU
inner join
	rev.REV_ORGANIZATION o
on
	o.ORGANIZATION_GU = oy.ORGANIZATION_GU
inner join
	rev.epc_sch sch
on
	sch.ORGANIZATION_GU = o.ORGANIZATION_GU
inner join
	rev.rev_person p
on
	p.PERSON_GU = s.STAFF_GU
inner join
	[180-smaxods-01.aps.edu.actd].Lawson.aps.CurrentActiveTeachers CAT
on
	CAST(SUBSTRING(S.BADGE_NUM, 2,6) AS INT) = cat.EMPLOYEE
inner join
	[180-smaxods-01.aps.edu.actd].Lawson.dbo.Jobcode j
on
	j.JOB_CODE = CAT.JOB_CODE
where
	s.TYPE = 'TE'
AND
	BADGE_NUM != 'Dup203561'
)
select
	*
from
	Teachers
where
	rn = 1


go
