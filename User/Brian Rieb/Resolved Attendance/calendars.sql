-- We need to have a meeting days (at least one) FOr a calendar to get built out.

SELECT
	*
FROM
	rev.EPC_SCH_ATT_CAL SchoolCal
	INNER JOIN
	rev.REV_ORGANIZATION_YEAR OrgYear
	ON
	OrgYear.ORGANIZATION_YEAR_GU = SchoolCal.SCHOOL_YEAR_GU
	INNER JOIN
	rev.EPC_SCH School
	ON
	School.ORGANIZATION_GU = OrgYear.ORGANIZATION_GU
	
WHERE
	--School.SCHOOL_CODE = '203'
	SCHOOL_YEAR_GU = 'AF9D7E74-A790-4E36-9035-AA075E6ADDD9' -- Parajito 13,14
	--SCHOOL_YEAR_GU = '3F1673D7-3255-4E67-A875-A7352688F3F0' -- Prajrito 14,15 333
	--SCHOOL_YEAR_GU = '41B0EF9C-4A26-4607-827D-39B3CF61BFA4' -- Dennis Chavez 13-14
ORDER BY
	CAL_DATE