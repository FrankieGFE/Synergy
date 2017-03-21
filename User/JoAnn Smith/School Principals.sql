declare @school uniqueidentifier = '725E6DD0-62B7-40AD-9ADE-63793563E8EC'



	select
	org.ORGANIZATION_GU,
	 ORG.ORGANIZATION_NAME as [School Name],
	 isnull(SCH.SCHOOL_CODE, '') as [School Code],
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
WHERE
	ORG.ORGANIZATION_GU LIKE @School
ORDER BY ORGANIZATION_NAME

