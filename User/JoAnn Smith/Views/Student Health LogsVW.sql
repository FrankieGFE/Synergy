--USE [ST_Production]
--GO

--/****** Object:  View [APS].[StudentHealthLogs]    Script Date: 6/19/2017 10:42:54 AM ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO



--alter VIEW [APS].[StudentHealthLogs] AS

with Health 
as
(
SELECT
	ROW_NUMBER() OVER(PARTITION BY HEALTH.STUDENT_GU, HEALTH.EFFECTIVE_DATE ORDER BY HEALTH.STUDENT_GU, HEALTH.EFFECTIVE_DATE) AS ROWNUM
	,health.HEALTH_GU
	,health.student_gu
	,health.STUDENT_SCHOOL_YEAR_GU
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	,Organization.ORGANIZATION_GU
	,OrgYear.YEAR_GU
	,convert(char(10), health.EFFECTIVE_DATE, 126) AS LOG_DATE
	,[HEALTH].[HEALTH_CODE]
	,[HEALTH_CODES].[VALUE_DESCRIPTION] as HEALTH_CODE_DESCRIPTION
	,CONVERT(CHAR(5), health.TIME_IN, 108) AS TIME_IN
	,CONVERT(CHAR(5), health.TIME_OUT, 108) AS TIME_OUT
	,health.DISPOSITION as DISPOSITON_CODE
	,DISPOSITION.VALUE_DESCRIPTION AS DISPOSITION
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
		
FROM
	rev.epc_staff_sch_yr stf
left join
	rev.epc_staff staff
on
	stf.STAFF_GU = staff.STAFF_GU
left join
	rev.rev_person per
on
	staff.staff_gu = per.person_gu
left join
	rev.epc_stu_health health
on
	STAFF_SCHOOL_YEAR_GU = health.ENTERED_BY_GU
left join
	rev.epc_stu_health_assess A
on
	health.HEALTH_GU = a.HEALTH_GU	
left JOIN
	rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
ON
	[HEALTH].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
	
left JOIN 
	rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
ON 
	[StudentSchoolYear].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
	
left JOIN 
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
	 ,health.STUDENT_SCHOOL_YEAR_GU
	,[Organization].[ORGANIZATION_NAME]	
	,Organization.ORGANIZATION_GU
	,OrgYear.YEAR_GU
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
)
--select * from health where student_gu = 'D9967CE2-189D-474A-8235-68125ABA6356'
,COMMENTS 
AS
(	
select
       HEALTH.STUDENT_GU,
       health.ENTERED_BY_GU,
       per.last_name + ', ' + per.FIRST_NAME as COMMENT_ENTERED_BY,
       HEALTH.COMMENT,
       convert(char(10), health.COMMENT_DATE, 126) AS COMMENT_DATE,
       health.STUDENT_SCHOOL_YEAR_GU
FROM
 
 health h

INNER join
       rev.epc_stu_health_private health
on
       h.STUDENT_GU = health.STUDENT_GU 
inner join 
       rev.epc_staff_sch_yr stf
on
	   health.ENTERED_BY_GU = stf.STAFF_SCHOOL_YEAR_GU
left join
       rev.epc_staff staff
on
       stf.STAFF_GU = staff.STAFF_GU
LEFT join
       rev.rev_person per
on
       staff.staff_gu = per.person_gu 

)
--select * from comments where student_gu = 'D9967CE2-189D-474A-8235-68125ABA6356' --shows up
,Results
as
(
SELECT
	--ROW_NUMBER() over(partition by h.student_gu order by h.student_gu, log_date, time_in desc) as RN,
	h.*,
	C.COMMENT,
	C.COMMENT_DATE,
	C.COMMENT_ENTERED_BY,
	bs.first_name + ' ' + bs.last_name as STUDENT_NAME,
	bs.sis_number AS SIS_NUMBER
FROM
	comments c
full outer JOIN
	health h
ON
	h.STUDENT_GU = c.STUDENT_GU
AND
	h.STUDENT_SCHOOL_YEAR_GU = c.STUDENT_SCHOOL_YEAR_GU
and
	h.ENTERED_BY_GU = c.ENTERED_BY_GU
inner join
	aps.basicstudent bs
on
	bs.student_gu = h.STUDENT_GU
)
select
	*
from
	Results 
where 1 =1 
--and
--	rn = 1
and
	 student_gu = 'D9967CE2-189D-474A-8235-68125ABA6356'



GO


