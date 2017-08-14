/*
Written by:     JoAnn Smith
Date Written:	6/16/2017
Description:	This script pulls health details for students
for an SSRS report extract


*/
; with Health 
as
(
SELECT 
	health.HEALTH_GU
	,health.student_gu
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	,Organization.ORGANIZATION_GU
	,OrgYear.YEAR_GU
	,convert(char(10), health.EFFECTIVE_DATE, 126) AS LOG_DATE
	,[HEALTH].[HEALTH_CODE]
	,[HEALTH_CODES].[VALUE_DESCRIPTION] as HEALTH_CODE_DESCRIPTION
	,CONVERT(CHAR(5), health.TIME_IN, 108) AS TIME_IN
	,CONVERT(CHAR(5), health.TIME_OUT, 108) AS TIME_OUT
	,health.DISPOSITION
	,DISPOSITION.VALUE_DESCRIPTION AS DISPOSITION_CODE
	,HEALTH.entered_by_gu as ENTERED_BY_GU
	,per.LAST_NAME + ', ' + per.first_name as STAFF_NAME
	,health.REFERRED_BY
	,CONVERT(NVARCHAR(MAX),health.FOLLOW_UP) AS FOLLOW_UP
	,convert(char(5), health.CONTACT_ATT_TIME, 108) as CONTACT_ATTEMPTED_TIME
	,convert(char(5), health.CONTACT_MADE_TIME, 108) as CONTACT_MADE_TIME
	,CONVERT(NVARCHAR(MAX),health.INCIDENT_DESC) AS INCIDENT_DESCRIPTION
	,a.ASSESSMENT
	,health.TEMPERATURE_FAHRENHEIT
	,CONVERT(NVARCHAR(MAX),health.BLOOD_GLUCOSE) as BLOOD_GLUCOSE
	,health.VITAL_SIGN_1_DESC
	,CONVERT(NVARCHAR(MAX),health.VITAL_SIGN_1_VALUE) as VITAL_SIGN_1_VALUE
	,health.VITAL_SIGN_2_DESC
	,CONVERT(NVARCHAR(MAX),health.VITAL_SIGN_2_VALUE) AS VITAL_SIGN_2_VALUE
	,convert(char(10), HP.COMMENT_DATE, 126) AS COMMENT_DATE
	,CONVERT(NVARCHAR(MAX),Hp.COMMENT) AS COMMENT
		
FROM
	rev.epc_staff_sch_yr stf
inner join
	rev.epc_staff staff
on
	stf.STAFF_GU = staff.STAFF_GU
inner join
	rev.rev_person per
on
	staff.staff_gu = per.person_gu
left join
	rev.epc_stu_health health
on
	STAFF_SCHOOL_YEAR_GU = health.ENTERED_BY_GU

LEFT JOIN
	rev.epc_stu_health_private HP
on
	health.student_gu = hp.student_gu
left join
	rev.epc_stu_health_assess A
on
	health.HEALTH_GU = a.HEALTH_GU
	
	INNER JOIN
	rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
	ON
	[HEALTH].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
	ON 
	[StudentSchoolYear].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]

	LEFT OUTER JOIN
	APS.LookupTable ('K12.HealthIncident', 'INCIDENT_CODE') AS [HEALTH_CODES]
	ON
	[HEALTH].[HEALTH_CODE] = [HEALTH_CODES].[VALUE_CODE]
	LEFT OUTER JOIN
	APS.LookupTable('K12.HealthIncident', 'ACTION_TAKEN') AS [DISPOSITION] 
	ON
	HEALTH.DISPOSITION = DISPOSITION.VALUE_CODE
	
GROUP BY
health.health_gu
	 ,health.student_gu
	,[Organization].[ORGANIZATION_NAME]	
	,Organization.ORGANIZATION_GU
	,[HEALTH].[HEALTH_CODE]
	,[HEALTH_CODES].[VALUE_DESCRIPTION]
	,HEALTH.EFFECTIVE_DATE
	,health.TIME_IN
	,health.TIME_OUT
	,health.DISPOSITION
	,DISPOSITION.VALUE_DESCRIPTION
	,health.ENTERED_BY_GU
	,PER.LAST_NAME
	,PER.FIRST_NAME
	,health.REFERRED_BY
	,CONVERT(NVARCHAR(MAX),health.FOLLOW_UP)
	,health.CONTACT_ATT_TIME
	,health.CONTACT_MADE_TIME
	,CONVERT(NVARCHAR(MAX),health.INCIDENT_DESC)
	,a.ASSESSMENT
	,health.TEMPERATURE_FAHRENHEIT
	,CONVERT(NVARCHAR(MAX),health.BLOOD_GLUCOSE)
	,health.VITAL_SIGN_1_DESC
	,CONVERT(NVARCHAR(MAX),health.VITAL_SIGN_1_VALUE)
	,health.VITAL_SIGN_2_DESC
	,CONVERT(NVARCHAR(MAX),health.VITAL_SIGN_2_VALUE)
	,hp.COMMENT_DATE
	,CONVERT(NVARCHAR(MAX),hp.COMMENT)

)
,Commenter

as
(	

select
	health.STUDENT_GU,
	per.last_name + ', ' + per.FIRST_NAME as COMMENT_ENTERED_BY
FROM
	rev.epc_staff_sch_yr stf
inner join
	rev.epc_staff staff
on
	stf.STAFF_GU = staff.STAFF_GU
inner join
	rev.rev_person per
on
	staff.staff_gu = per.person_gu
left join
	rev.epc_stu_health_private health
on
	STAFF_SCHOOL_YEAR_GU = health.ENTERED_BY_GU
)
SELECT
	h.*,
	C.COMMENT_ENTERED_BY
FROM
	HEALTH H
LEFT JOIN
	COMMENTER C
ON
	h.STUDENT_GU = c.STUDENT_GU


