 declare @SchoolYear nvarchar(10) = '2016R'
 ;with Main
as

	(select
		row_number() over (partition by h.student_gu, h.course_id, h.term_code order by h.student_gu) as RN,
		bs.SIS_NUMBER,
		h.student_gu,
		
		h.SCHOOL_IN_DISTRICT_GU,
		h.SCHOOL_NON_DISTRICT_GU,
		o.ORGANIZATION_gu,
		o.ORGANIZATION_NAME,	
		bs.LAST_NAME,
		bs.FIRST_NAME,
		s.grade,
		h.course_id AS COURSE_ID,
		h.course_title AS COURSE_TITLE,
		--h.CREDIT_ATTEMPTED as CRS_HIST_CREDIT_ATTEMPTED,
		h.CREDIT_COMPLETED as CRS_HIS_CREDIT_COMPLETED,
		c.CREDIT as DCM_CREDIT,
		H.TERM_CODE,
		H.MARK,
		cast(H.SCHOOL_YEAR as nvarchar(4))  as SCHOOL_YEAR,
		h.calendar_year,
		h.COURSE_HISTORY_TYPE
	from
		rev.epc_stu_crs_his h
	inner join
		rev.epc_crs C
	on
		h.course_gu = c.course_gu
	inner join
		aps.StudentEnrollmentDetails s
	on
		s.student_gu = h.student_gu
	left join
		aps.BasicStudent bs
	on
		bs.STUDENT_GU = h.student_gu
	inner join
		rev.REV_ORGANIZATION_YEAR y
	on
		s.ORGANIZATION_YEAR_GU = y.ORGANIZATION_YEAR_GU 
	INNER JOIN
		REV.REV_ORGANIZATION O
	ON
		(case
			when h.SCHOOL_IN_DISTRICT_GU is not null then h.SCHOOL_IN_DISTRICT_GU
			when h.SCHOOL_NON_DISTRICT_GU is not null then h.SCHOOL_NON_DISTRICT_GU
		end) = o.organization_gu
		
	where 1 = 1
	AND
		h.CREDIT_COMPLETED <> c.CREDIT
	and
		h.credit_completed > 0
	and
		h.course_history_type = 'HIGH'
	and
		s.grade in ('09', '10', '11', '12')			
)
select
	*
from
	Main m
where rn = 1
and
SCHOOL_YEAR LIKE @SchoolYear
and
MARK NOT IN ('N', 'I', 'F', 'W')
order by SCHOOL_YEAR, STUDENT_GU, grade, course_id, term_code