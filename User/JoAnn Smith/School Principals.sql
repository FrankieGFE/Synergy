
select
	 ORG.ORGANIZATION_NAME as [School Name],
	 isnull(SCH.SCHOOL_CODE, '') as [School Code],
	 isnull(per.LAST_NAME + ', ' + per.FIRST_NAME, '') as [Principal Name],
	 ADDR.ADDRESS as [School Address],
	 ADDR.CITY as [City],
	 ADDR.STATE as [State],
	 ADDR.ZIP_5 as [Zip],
	 isnull(org.PHONE, '') as [Phone],
	 sch.LIVE_IN_GENESIS as [Live in Synergy]
	 
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
--WHERE
--	ORG.ORGANIZATION_GU LIKE @School

ORDER BY ORGANIZATION_NAME