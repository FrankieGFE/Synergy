;with Main
as

	(select
		row_number() over (partition by h.student_gu, h.course_id, h.term_code order by h.student_gu) as RN,
		bs.SIS_NUMBER,
		h.student_gu,
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
		H.SCHOOL_YEAR
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
		O.ORGANIZATION_GU = Y.ORGANIZATION_GU
	where 1 = 1
	AND
		h.CREDIT_COMPLETED <> c.CREDIT
	and
		h.credit_completed > 0
	and
		s.grade in ('09', '10', '11', '12') 
)
select
	*
from
	Main m
where
	rn = 1
order by SCHOOL_YEAR, STUDENT_GU