USE [ST_Production]
GO

/****** Object:  View [SchoolMessenger].[Guardian]    Script Date: 4/12/2017 8:49:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [SchoolMessenger].[Guardian] AS
--get all students with parent(s) gu for the current school year
with GuardianCTE
as
(
SELECT distinct
	stu.SIS_NUMBER AS [ID Number],
	stupar.parent_gu, 
	stu.student_gu,
	yr.SCHOOL_YEAR
FROM
	 rev.EPC_STU stu
JOIN
	 rev.EPC_STU_SCH_YR ssyr
ON
	 ssyr.STUDENT_GU = stu.STUDENT_GU
JOIN
	 rev.REV_ORGANIZATION_YEAR oyr
ON
	 oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU 
JOIN
	 rev.REV_YEAR yr
ON
	 yr.YEAR_GU = oyr.YEAR_GU
		AND oyr.YEAR_GU IN (SELECT [YEAR_GU] FROM [APS].[YearDates] WHERE CAST(GETDATE() AS DATE) BETWEEN [START_DATE] AND [END_DATE] AND EXTENSION != 'S')
JOIN
	 rev.EPC_STU_PARENT stupar
ON
	 stupar.STUDENT_GU = stu.STUDENT_GU
JOIN
	 rev.REV_PERSON per
ON
	 per.PERSON_GU = stupar.PARENT_GU and stupar.CONTACT_ALLOWED = 'Y'
)
--now get the Guardian Category, First/LastName, Home Language, Phone and Email
,DetailsCTE
as
(
select 
	i.student_gu,
	i.parent_gu,
	stupar.ORDERBY,	
	case
	when stupar.RELATION_TYPE = 'A' then 'Aunt'
	when stupar.RELATION_TYPE = 'AR' then 'Agency Rep'
	when stupar.RELATION_TYPE = 'C' then 'Caregiver'
	when stupar.RELATION_TYPE = 'CA' then 'Court Appointed Guardian'
	when stupar.RELATION_TYPE = 'EC' then 'Emergency Contact'
	when stupar.RELATION_TYPE = 'F' then 'Father'
	when stupar.RELATION_TYPE = 'FA' then 'Family Member'
	when stupar.RELATION_TYPE = 'FEX' then 'Foreign Exchange Guardian'
	when stupar.RELATION_TYPE = 'FF' then 'Foster Father'
	when stupar.RELATION_TYPE = 'FIH' then 'Father in Home'
	when stupar.RELATION_TYPE = 'FM' then 'Foster Mother'
	when stupar.RELATION_TYPE = 'G' then 'Guardian'
	when stupar.RELATION_TYPE = 'GF' then 'Grandfather'
	when stupar.RELATION_TYPE = 'GM' then 'Grandmother'
	when stupar.RELATION_TYPE = 'M' then 'Mother'
	when stupar.RELATION_TYPE = 'MIH' then 'Mother in Home'
	when stupar.RELATION_TYPE = 'RM' then 'Real Father'
	when stupar.RELATION_TYPE = 'RM' then 'Real Mother'
	when stupar.RELATION_TYPE = 'S' then 'SURGTParent IEP'
	when stupar.RELATION_TYPE = 'SELF' then 'Self'
	when stupar.RELATION_TYPE = 'SF' then 'Step-Father'
	when stupar.RELATION_TYPE = 'SM' then 'Step-Mother'
	when stupar.RELATION_TYPE = 'U' then 'Uncle'
	end as [Guardian Category],
	per.FIRST_NAME AS [Parent First Name],
	per.LAST_NAME  AS [Parent Last Name],
	ISNULL([Contact_Language].[VALUE_DESCRIPTION], 'English') AS [Home/Correspondence Language],
	per.EMAIL

from
	GuardianCTE I
inner  join 
	rev.EPC_STU_PARENT stupar
on
	i.parent_gu = stupar.parent_gu
	and i.student_gu = stupar.student_gu
inner join
	rev.rev_person_phone ph 
on
	stupar.parent_gu = ph.person_gu
inner join 
	rev.REV_PERSON per
ON
	per.PERSON_GU = i.PARENT_GU and stupar.CONTACT_ALLOWED = 'Y'
left outer join 
    rev.EPC_STU_PGM_ELL AS ELL
ON
	ELL.STUDENT_GU = i.STUDENT_GU
LEFT JOIN
	APS.LookupTable ('K12', 'Language') AS [Contact_Language]	
ON
	ELL.[LANGUAGE_TO_HOME] = [Contact_Language].[VALUE_CODE]
)
-- get the distinct results from the
,DistinctDetails
as
( 
select * from DetailsCTE
group by student_gu, parent_gu, ORDERBY, [Guardian Category], [Parent First Name], [Parent Last Name], [Home/Correspondence Language], EMAIL
)
--select * from DistinctDetails
--where student_gu = '63C2A378-B235-48CE-8579-9FE6C16A22F9'

,PHONECTE
AS
(
--combine phone numbers in person table
SELECT
	PERSON_GU,
	MAX(CASE WHEN RN = 1 THEN PHONE END) AS PHONE1,
	MAX(CASE WHEN RN = 1 THEN PHONE_TYPE end) as PHONE1TYPE,
	MAX(CASE WHEN RN = 2 THEN PHONE END) AS PHONE2,
	MAX(CASE WHEN RN = 2 THEN PHONE_TYPE END) AS PHONE2TYPE,
	MAX(CASE WHEN RN = 3 THEN PHONE END) AS PHONE3,
	MAX(CASE WHEN RN = 3 THEN PHONE_TYPE END) AS PHONE3TYPE
  FROM
       (
       SELECT 
          PERSON_GU,
		  PHONE,
		  PHONE_TYPE
		  ,ROW_NUMBER() OVER (PARTITION BY PERSON_GU ORDER BY PRIMARY_PHONE DESC, CONTACT_PHONE DESC ) AS RN
       FROM
       REV.REV_PERSON_PHONE 
       ) AS ST
       
	  GROUP BY person_gu) 
--select * from PHONECTE
,DETAILSWITHPHONE
AS
(
SELECT
	PARENT_GU,
	STUDENT_GU,
	D.[Guardian Category],
	D.[Parent First Name],
	D.[Parent Last Name],
	D.[Home/Correspondence Language],
	D.EMAIL as [Email Address],
	PHONE1 as [Phone Number 1],
	PHONE1TYPE as [Phone Number 1 Type],
	CASE
		WHEN [PHONE1TYPE] = 'H' THEN 'Home Phone' 
		WHEN [PHONE1TYPE] = 'C' THEN 'Cell Phone'
		WHEN [PHONE1TYPE] = 'W' THEN 'Work Phone'
	END as [Phone Type 1], 
	PHONE2 as [Phone Number 2],
	PHONE2TYPE as [Phone Number 2 Type],
		CASE
		WHEN [PHONE2TYPE] = 'H' THEN 'Home Phone'
		WHEN [PHONE2TYPE] = 'C' THEN 'Cell Phone'
		WHEN [PHONE2TYPE] = 'W' THEN 'Work Phone'
	END as [Phone Type 2],

	PHONE3 as [Phone Number 3],
	PHONE3TYPE as [Phone Number 3 Type],
			CASE
		WHEN [PHONE3TYPE] = 'H' THEN 'Home Phone'
		WHEN [PHONE3TYPE] = 'C' THEN 'Cell Phone'
		WHEN [PHONE3TYPE] = 'W' THEN 'Work Phone'
	END as [Phone Type 3], 

	row_number() over (partition by parent_gu order by student_gu) as RN
FROM
	PHONECTE PH
INNER JOIN
	DistinctDetails D
on
	D.PARENT_GU = PH.PERSON_GU

)
--select * from DETAILSWITHPHONE	
--now put together Guardian ID which is Adult-ID if the field is not null
--or sis number plus orderby if the adult id is null
,
IDCTE
as
(
select
		d.STUDENT_GU,	
		D.PARENT_GU,
		BS.SIS_NUMBER as [Associated Student ID Number],
		ISNULL(PAR.ADULT_ID, BS.SIS_NUMBER + ISNULL((CAST(ORDERBY AS NVARCHAR(2))),1)) AS [Guardian ID Number],
		d.[Guardian Category],
		D.[Parent First Name] AS [First Name],
		D.[Parent Last Name] as [Last Name],
		d.[Home/Correspondence Language],
		d.EMAIL as [Email Address],
		ph.[Phone Number 1],
		ph.[Phone Type 1],
		ph.[Phone Number 1 Type],
		ph.[Phone Number 2],
		ph.[Phone Type 2],
		ph.[Phone Number 3],
		ph.[Phone Type 3],
		ROW_NUMBER() OVER (PARTITION BY D.PARENT_GU ORDER BY BS.SIS_NUMBER) AS RN
		
from
	DistinctDetails D
inner join
	aps.BasicStudent bs
on
	d.STUDENT_GU = bs.STUDENT_GU
INNER JOIN
	REV.EPC_PARENT PAR
ON PAR.PARENT_GU = D.PARENT_GU
inner join
	DETAILSWITHPHONE PH
on
	PH.PARENT_GU = par.PARENT_GU
)
select
	I.[Associated Student ID Number],
	I.[Guardian ID Number],
	I.[Guardian Category],
	I.[First Name],
	I.[Last Name],
	I.[Home/Correspondence Language],
	I.[Email Address],
	I.[Phone Number 1],
	I.[Phone Type 1],
	I.[Phone Number 2],
	I.[Phone Type 2],
	I.[Phone Number 3],
	I.[Phone Type 3]

from
	IDCTE i
where
	rn = 1



GO


