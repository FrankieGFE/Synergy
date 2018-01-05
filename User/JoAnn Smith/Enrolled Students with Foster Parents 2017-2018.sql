/*
Written by:	JoAnn Smith
Date:		1/5/2018
Frank – first thing after the break, please work on pulling the data for this request as soon as possible.  Please pull a file of active 17-18 students who have any Parent/Guardian that has a Relation=Foster Father or Mother (see my screen shot further below).
Please include the fields listed below and also include the Foster Parent Name.  Thanks - Andy
*/

;with Students
as
(
select
	BS.SIS_NUMBER,
	bs.FIRST_NAME,
	bs.LAST_NAME,
	bs.BIRTH_DATE,
	lu.VALUE_DESCRIPTION as GRADE,
	e.student_gu,
	E.ORGANIZATION_YEAR_GU,
	o.ORGANIZATION_NAME
from
	aps.PrimaryEnrollmentsAsOf(getdate()) e
left join
	aps.BasicStudentWithMoreInfo bs
on
	bs.STUDENT_GU = e.STUDENT_GU
left join
	rev.REV_ORGANIZATION_YEAR oy
on
	oy.ORGANIZATION_YEAR_GU = E.ORGANIZATION_YEAR_GU
left join
	rev.rev_organization o
on
	oy.ORGANIZATION_GU = o.ORGANIZATION_gu
LEFT JOIN
	APS.LookupTable('K12', 'Grade') lu
on
	lu.VALUE_CODE = e.GRADE
)
--select * from Students
,Details
as
(
select
	s.*,
	lu.VALUE_DESCRIPTION as RELATION_TYPE,
	pe.first_name as PARENT_FIRST_NAME,
	pe.last_name AS PARENT_LAST_NAME
from
	Students S
left join
	rev.EPC_STU_PARENT sp
on
	sp.STUDENT_GU = s.STUDENT_GU
left join
	rev.epc_parent p
on
	sp.PARENT_GU = p.PARENT_GU
left join
	rev.rev_person pe
on
	sp.PARENT_GU = pE.PERSON_GU
left join
	APS.LookupTable('K12','RELATION_TYPE') AS lu
on	
	sp.RELATION_type = lu.value_code
where
	lu.VALUE_DESCRIPTION like '%Foster%'
)
select * from dETAILS
order by ORGANIZATION_NAME, SIS_NUMBER