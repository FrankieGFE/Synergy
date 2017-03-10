USE [ST_Daily]
GO

/****** Object:  View [SchoolMessenger].[Parent]    Script Date: 3/7/2017 8:22:48 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [SchoolMessenger].[Guardian] AS

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

--now get the unique parent gu and student gu combinations
,
InterimCTE
as
(
select
	DISTINCT student_gu, parent_gu

from
	GuardianCTE GD
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
	ph.phone,
	ph.phone_type,
	case	
		when PRIMARY_PHONE_TYPE = 'H'
			then 'Home Phone'
		when PRIMARY_PHONE_TYPE = 'C' 
			then 'Cell Phone'
		when PRIMARY_PHONE_TYPE = 'M'
			then 'Mobile Phone'
		when PRIMARY_PHONE_TYPE = 'P'
			then 'Pager'
		when PRIMARY_PHONE_TYPE = 'W'
			then 'Work Phone'
	end as [Primary Phone Type],

	per.PRIMARY_PHONE_TYPE as [Phone Type],
	ISNULL([Contact_Language].[VALUE_DESCRIPTION], 'English') AS [Home/Correspondence Language],
	per.EMAIL

from
	InterimCTE I
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
--now put together Guardian ID which is Adult-ID if the field is not null
--or sis number plus orderby if the adult id is null
,
IDCTE
as
(
SELECT
	 *
FROM
(
	select
		BS.SIS_NUMBER as [Associated Student ID Number],
		ISNULL(PAR.ADULT_ID, BS.SIS_NUMBER + ISNULL((CAST(ORDERBY AS NVARCHAR(2))),1)) AS [Guardian ID Number],
		d.[Guardian Category],
		D.[Parent First Name] AS [First Name],
		D.[Parent Last Name] as [Last Name],
		d.[Primary Phone Type],
		d.[PHONE] AS Phone,
		d.[Home/Correspondence Language],
		d.EMAIL as [Email Address]			
	from
		DetailsCTE D
	inner join
		aps.BasicStudent bs
	on
		d.STUDENT_GU = bs.STUDENT_GU
	INNER JOIN
		REV.EPC_PARENT PAR
	ON PAR.PARENT_GU = D.PARENT_GU
	) AS s	
	PIVOT(
		MAX(Phone) 
		FOR [Primary Phone Type] IN ([Cell Phone], [Home Phone], [Mobile Phone], [Work Phone], [Pager])
		)
		as pivtable	
)
select * from IDCTE

GO




