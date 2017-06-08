;with Main
as

	(select
		row_number() over (partition by bs.sis_number, h.course_id, h.term_code order by bs.sis_number) as RN,
		bs.SIS_NUMBER,
		s.ORGANIZATION_NAME,
		bs.LAST_NAME,
		bs.FIRST_NAME,
		h.GRADE,
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
		aps.BasicStudentWithMoreInfo bs
	on
		h.student_gu = bs.student_gu
	inner join
		aps.ScheduleAsOf(getdate()) s
	on
		s.student_gu = bs.student_gu
	where
		h.CREDIT_COMPLETED<> c.CREDIT
	and
		h.credit_completed > 0
	AND
		SCHOOL_YEAR = '2016') 
select
	*
from
	Main m
where
	rn = 1
order by
	SIS_NUMBER