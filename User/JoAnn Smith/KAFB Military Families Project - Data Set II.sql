

declare @YearGu uniqueidentifier = 'A3F9F1FB-4706-49AA-B3A3-21F153966191'
;with Main
as
(
select
	row_number() over (partition by bs.sis_number, SP.PARENT_GU order by bs.sis_number, ped.enter_date) as ROWNUM,
	PED.STUDENT_GU,
	p.PARENT_GU,
	sp.PARENT_GU as sp_parent_gu,
	bs.SIS_NUMBER,
	bs.LAST_NAME,
	bs.FIRST_NAME,
	bs.MIDDLE_NAME,
	convert(varchar(10), bs.BIRTH_DATE, 112) AS BIRTH_DATE,
	bs.HOME_ADDRESS,
	lu.VALUE_DESCRIPTION as GRADE,
	o.organization_name as SCHOOL_NAME,
	PED.EXCLUDE_ADA_ADM,
	--ssy.ATTEND_PERMIT_CODE,
	CASE	
		WHEN ssy.ATTEND_PERMIT_CODE = 'TRAN' then 'TRANSFER'
		ELSE ' '
	END AS TRANSFER_FLAG,
	--ped.SCHOOL_NAME,
	bs.GENDER,
	bs.HISPANIC_INDICATOR,
	bs.RESOLVED_RACE,
	bs.LUNCH_STATUS,
	bs.ELL_STATUS,
	bs.SPED_STATUS,
	per.LAST_NAME as PARENT_LAST_NAME,
	per.FIRST_NAME as PARENT_FIRST_NAME,
	per.MIDDLE_NAME as PARENT_MIDDLE_NAME,
	p.EMPLOYER AS PARENT_EMPLOYER,
	convert(nvarchar(10), per.BIRTH_DATE,112) AS PARENT_BIRTHDATE,
	per.EMAIL AS PARENT_EMAIL,
	isnull(up.ACTIVE_MILITARY, 'N') as ACTIVE_MILITARY
	
from
	aps.EnrollmentsForYear(@YearGU) ped
INNER JOIN
	REV.EPC_STU_ENROLL E
ON
	PED.STUDENT_SCHOOL_YEAR_GU = E.STUDENT_SCHOOL_YEAR_GU
inner join
	rev.epc_stu_sch_yr ssy
on
	e.student_school_year_gu = ssy.student_school_year_gu
inner join
	aps.BasicStudentWithMoreInfo bs
on
	ped.STUDENT_GU = bs.STUDENT_GU
inner join
	rev.EPC_STU_PARENT SP
on
	ped.STUDENT_GU = sp.STUDENT_GU
left join
	rev.EPC_PARENT p
on
	sp.PARENT_GU = p.PARENT_GU
left join
	rev.REV_PERSON per
on
	p.PARENT_GU = per.PERSON_GU
inner join
	rev.rev_organization o
on
	ped.organization_gu = o.organization_gu
left join
	rev.ud_parent up
on
	sp.PARENT_GU = up.PARENT_GU
left join
	aps.LookupTable('K12', 'Grade') LU
on
	ped.grade = lu.value_code
where
	PED.EXCLUDE_ADA_ADM is null
)
--SELECT * FROM MAIN WHERE ROWNUM  = 1

select
	*
from
	main M
where
	1 = 1
and
	ROWNUM = 1	
order by
	 M.SIS_NUMBER

	

