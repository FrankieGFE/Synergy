

declare @YearGu uniqueidentifier = 'F7D112F7-354D-4630-A4BC-65F586BA42EC'
;with Main
as
(
select
	row_number() over (partition by bs.sis_number order by bs.sis_number, ped.enter_date) as rn,
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
	CASE	
		WHEN E.ENTER_CODE IN ('TWAPS', 'TWNM', 'TOUT') THEN 'TRANSFER'
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
	per.BIRTH_DATE AS PARENT_BIRTHDATE,
	per.EMAIL AS PARENT_EMAIL,
	up.ACTIVE_MILITARY
	
from
	aps.EnrollmentsForYear(@YearGU) ped
INNER JOIN
	REV.EPC_STU_ENROLL E
ON
	PED.STUDENT_SCHOOL_YEAR_GU = E.STUDENT_SCHOOL_YEAR_GU
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
select
	*
from
	main
where
	1 = 1
and
	rn = 1	
order by
	 SIS_NUMBER


	
