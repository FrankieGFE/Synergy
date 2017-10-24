declare @School uniqueidentifier = '5A7A23CB-3B89-4A45-8F78-A08E391B7EEF '
;with Principals as
(
	select
	 org.ORGANIZATION_GU,
	 ORG.ORGANIZATION_NAME as [School Name],
	 isnull(SCH.SCHOOL_CODE, '') as [School Code],
	 isnull(SCH.ALT_ID, '') as [Zone],
	 isnull(per.LAST_NAME + ', ' + per.FIRST_NAME, '') as [Principal Name],
	 ADDR.ADDRESS as [School Address],
	 ADDR.CITY as [City],
	 ADDR.STATE as [State],
	 ADDR.ZIP_5 as [Zip],
	 isnull(org.PHONE, '') as [Phone],
	 isnull(sch.LIVE_IN_GENESIS, '') as [Live in Synergy],
	 sch.ALT_School as [Alternative School],
	 isnull(sch.NCES_SCHOOL_NUM, '') as [NCES School Number]
	 
from
	 rev.REV_ORGANIZATION ORG
inner join
	rev.epc_sch SCH 
on 
	org.ORGANIZATION_GU = sch.ORGANIZATION_GU
left join
	rev.REV_PERSON PER
on 
	PER.PERSON_GU  = sch.PRINCIPAL_STAFF_GU
JOIN
	REV.REV_ADDRESS ADDR
ON
	ADDR.ADDRESS_GU = ORG.ADDRESS_GU
)
--select * from principals
,Incident_Referral
as
(
select
	txp_def_inc_entered_by_gu,
	o.ORGANIZATION_YEAR_GU,
	org.ORGANIZATION_GU,
	p.LAST_NAME,
	p.FIRST_NAME

from
	rev.epc_sch_yr_opt o
inner join
	rev.epc_staff_sch_yr ssy
on
	o.TXP_DEF_INC_ENTERED_BY_GU = ssy.STAFF_SCHOOL_YEAR_GU
inner join
	rev.epc_staff s
on
	s.staff_gu = ssy.STAFF_GU
inner join
	rev.rev_person p
on
	p.person_gu = s.STAFF_GU
inner join
	rev.REV_ORGANIZATION_YEAR oy
on
	oy.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
inner join
	rev.rev_organization org
on
	org.ORGANIZATION_GU = oy.ORGANIZATION_GU
)

select
	p.[School Name],
	p.[School Code],
	p.Zone,
	p.[Principal Name],
	isnull(r.FIRST_NAME + ' ' + LAST_NAME, ' ') as [Incident Referral Default],
	p.[School Address],
	p.City,
	p.[State],
	p.Zip,
	p.Phone,
	p.[Live in Synergy],
	p.[Alternative School],
	p.[NCES School Number]
from
	Principals p
left outer join
	Incident_Referral r
on
	r.ORGANIZATION_GU = p.ORGANIZATION_GU
WHERE
	p.ORGANIZATION_GU LIKE @School
ORDER BY p.[School Name]