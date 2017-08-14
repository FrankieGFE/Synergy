declare @AsOfDate datetime2 = '2017-08-14'

;with Main
as

	(select
		row_number() over (partition by bs.sis_number, h.course_id, h.term_code order by bs.sis_number) as RN,
		bs.SIS_NUMBER,
		o.ORGANIZATION_NAME,	
		bs.LAST_NAME,
		bs.FIRST_NAME,
		lu.VALUE_DESCRIPTION as Grade,
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
		aps.PrimaryEnrollmentsAsOf(@AsOfDate) s
	on
		s.student_gu = bs.student_gu
	inner join
		rev.REV_ORGANIZATION_YEAR y
	on
		s.ORGANIZATION_YEAR_GU = y.ORGANIZATION_YEAR_GU
	INNER JOIN
		REV.REV_ORGANIZATION O
	ON
		O.ORGANIZATION_GU = Y.ORGANIZATION_GU
	left join
		aps.LookupTable('K12', 'Grade') lu
	on
		lu.VALUE_CODE = s.GRADE	
	where 1 = 1
	AND
		h.CREDIT_COMPLETED<> c.CREDIT
	and
		h.credit_completed > 0
	and
		s.grade in ('190','200', '210', '220') 
)
select
	*
from
	Main m
where
	rn = 1
order by
	SIS_NUMBER

