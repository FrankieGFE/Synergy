/*
can you please work on this first thing in the morning as your top priority,
see Patti’s specs below.
I think you’ve worked on accessing this data for SSRS reporting but I could be mistaken.
The new part is probably going to be contribution responsibility data. 
For 2017.R, please include School, Section ID, Course ID, and all the Staff data
including Primary Staff attached to the section.  Please see us with questions.  

I will need a pull asap tomorrow on all school sections that have an additional staff attached.
 I will also need their name, id, class role and their contribution responsibility.

JoAnn, are you able to add employee ID and Contribution Responsibility?
Looks good JoAnn, almost there.  Patti asked if you can please add the value from the
‘Exclude From State Reporting’ flag to the end of the file?
*/



;with Main
as
(
select
	row_number() over(partition by sec.section_gu order by sec.section_gu) as rn,
	o.ORGANIZATION_NAME,
	sec.SECTION_ID,
	c.COURSE_ID,
	c.COURSE_TITLE,
	SEC.STAFF_SCHOOL_YEAR_GU,
	--SCY.STAFF_GU,
	P.LAST_NAME,
	P.FIRST_NAME,
	STA.BADGE_NUM,
	stf.CLASS_ROLE,
	LU.VALUE_DESCRIPTION AS CONTRIBUTION_RESPONSIBILITY,
	stf.EXCLUDE_FROM_STATE_RPT,
	y.SCHOOL_YEAR
from
       --READ ALL SECTIONS
       rev.EPC_SCH_YR_SECT AS Sec
                     
       --GET ONLY SECTIONS WITH AN ADDITIONAL TEACHER
       INNER JOIN
       rev.EPC_SCH_YR_SECT_STF AS STF
       ON
       STF.SECTION_GU = SEC.SECTION_GU
                     
       --NEED TO READ STAFF SCHOOL YEAR TO GET STAFF_GU
       INNER JOIN
       rev.EPC_STAFF_SCH_YR AS StaffYear
       ON
       STF.STAFF_SCHOOL_YEAR_GU = StaffYear.STAFF_SCHOOL_YEAR_GU
		INNER JOIN
		REV.REV_PERSON P
		ON
		P.PERSON_GU = STAFFYEAR.STAFF_GU
		inner join
		rev.epc_staff STA
		ON
		P.PERSON_GU = STA.STAFF_GU
inner join
	rev.epc_sch_yr_sect_stf S
on
	sec.SECTION_GU = S.SECTION_GU
inner join	
	rev.EPC_SCH_YR_CRS crs
on
	sec.SCHOOL_YEAR_COURSE_GU = crs.SCHOOL_YEAR_COURSE_GU
inner join
	rev.epc_crs c
on
	crs.course_gu = c.course_gu
left join
	rev.rev_organization_year yr
on
	yr.ORGANIZATION_YEAR_GU = sec.ORGANIZATION_YEAR_GU
left join
	rev.epc_stu_sch_yr ssy
on
	ssy.ORGANIZATION_YEAR_GU = sec.ORGANIZATION_YEAR_GU
left join
	rev.rev_year y
on
	y.YEAR_GU = ssy.YEAR_GU
left join
	rev.epc_sch sch
on
	yr.ORGANIZATION_GU = sch.ORGANIZATION_GU
left join
	rev.REV_ORGANIZATION o 
on
	sch.ORGANIZATION_GU = o.ORGANIZATION_GU
left join
	aps.LookupTable('K12.ScheduleInfo', 'Staff_RESPONSIBILITY') LU
ON
	LU.VALUE_CODE = STF.STAF_CONTR_RESPON
where
	 y.year_gu = 'A3F9F1FB-4706-49AA-B3A3-21F153966191'
)

SELECT * FROM MAIN WHERE RN = 1
ORDER BY ORGANIZATION_NAME, SECTION_ID





