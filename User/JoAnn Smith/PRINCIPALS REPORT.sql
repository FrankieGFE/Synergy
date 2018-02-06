/*
This query is for the Principals Report for Jude.

Written by:	JoAnn Smith
Date:		a long time ago
Modified:	1/23/2018 - added four more fields - Title 1, Exclude from OLR,
Staff Receving Email, and Email Address
			1/30/2018 - latest year wasn't displaying--added join to
			rev.rev_year on organization_year_gu to fix
*/

declare @School uniqueidentifier = 'CA07DC4C-B218-4298-8562-21DF3606A9B9'

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
--select * from principals order by [School Name]
,Incident_Referral
as
(
select
	row_number() over(partition by Y.SCHOOL_YEAR order by Y.SCHOOL_YEAR DESC) as rn,
	txp_def_inc_entered_by_gu,
	o.TITLE_1,
	o.EXCLUDE_FROM_OLR,
	o.ORGANIZATION_YEAR_GU,
	org.ORGANIZATION_GU,
	p.LAST_NAME as INCIDENT_REFERRAL_LAST_NAME,
	p.FIRST_NAME AS INCIDENT_REFERRAL_FIRST_NAME
from
	rev.epc_sch_yr_opt o
inner join
	rev.epc_staff_sch_yr ssy
on
	o.TXP_DEF_INC_ENTERED_BY_GU = ssy.STAFF_SCHOOL_YEAR_GU
LEFT JOIN
	REV.REV_ORGANIZATION_YEAR OY
ON
	OY.ORGANIZATION_YEAR_GU = O.ORGANIZATION_YEAR_GU
LEFT JOIN
	REV.REV_YEAR Y
ON
	OY.YEAR_GU = Y.YEAR_GU
LEFT JOIN
	REV.REV_ORGANIZATION ORG
ON
	ORG.ORGANIZATION_GU = OY.ORGANIZATION_GU	
inner join
	rev.epc_staff s
on
	s.staff_gu = ssy.STAFF_GU
inner join
	rev.rev_person p
on
	p.person_gu = s.STAFF_GU)
--select * from Incident_Referral where rn = 1 AND ORGANIZATION_GU = 'CA07DC4C-B218-4298-8562-21DF3606A9B9'

,PXP
as
(
select
	px.demo_update_staff_gu,
	s.STAFF_GU,
	isnull(p.LAST_NAME + ', ' + p.FIRST_NAME, '') as [Staff Receiving PVUE Email],
	isnull(p.EMAIL, ' ') AS [Staff Email],
	ssy.STAFF_SCHOOL_YEAR_GU, 
	org.ORGANIZATION_GU
/*
ALTER TABLE [rev].[EPC_SCH_YR_PXP_CFG]  WITH CHECK ADD  CONSTRAINT [EPC_SCH_YR_PXP_CFG_F2] FOREIGN KEY([DEMO_UPDATE_STAFF_GU])
REFERENCES [rev].[EPC_STAFF_SCH_YR] ([STAFF_SCHOOL_YEAR_GU])
*/
from
	rev.EPC_SCH_YR_PXP_CFG px
inner join
	rev.EPC_STAFF_SCH_YR ssy
on
	px.DEMO_UPDATE_STAFF_GU = ssy.STAFF_SCHOOL_YEAR_GU
inner join
	rev.EPC_staff s
on
	ssy.STAFF_GU = s.STAFF_GU
inner join
	rev.rev_person p
on
	s.STAFF_GU = p.PERSON_GU
inner join
	rev.REV_ORGANIZATION_YEAR oy
on
	oy.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
inner join
	rev.rev_organization org
on
	org.ORGANIZATION_GU = oy.ORGANIZATION_GU

)
--select * from PXP
select
	p.[School Name],
	p.[School Code],
	p.Zone,
	p.[Principal Name],
	isnull(r.INCIDENT_REFERRAL_LAST_NAME + ', ' + R.INCIDENT_REFERRAL_FIRST_NAME, ' ') as [Incident Referral Default],
	p.[School Address],
	p.City,
	p.[State],
	p.Zip,
	p.Phone,
	p.[Live in Synergy],
	p.[Alternative School],
	p.[NCES School Number],
	R.TITLE_1,
	R.EXCLUDE_FROM_OLR,
	px.[Staff Receiving PVUE Email],
	px.[Staff Email] 
from
	Principals p
left outer join
	Incident_Referral r
on
	r.ORGANIZATION_GU = p.ORGANIZATION_GU
left join
	PXP px
on
	p.ORGANIZATION_GU = px.ORGANIZATION_GU
where
	rn = 1
and
	P.ORGANIZATION_GU like @School
order by
	p.[School Name]



