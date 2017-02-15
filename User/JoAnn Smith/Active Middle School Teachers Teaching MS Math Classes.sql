/*
 * Revision 1
 * Last Changed By:    JoAnn Smith
 * Last Changed Date:  2/13/17
 * Written by:         JoAnn Smith
 ******************************************************
 Active middle school teachers teaching MS math
 Pull test data for all MS teachers teaching MS
 math (MthMs) and LA (EngMs) class in SY 2016
 ******************************************************
 */

;
with SUBJ_CTE
as
(
select
	row_number() over(partition by staff_gu order by last_name, first_name) as Rownum,
	 p.LAST_NAME, p.FIRST_NAME, sao.COURSE_TITLE, sao.ORGANIZATION_NAME
from
	aps.ScheduleDetailsAsOf(getdate()) sao
inner join
	 aps.TermDatesAsOf(getdate()) tda
on 
	tda.ORGANIZATION_GU = sao.ORGANIZATION_GU
	AND sao.TERM_CODE = tda.TermCode
left join
	rev.rev_person p
	on p.PERSON_GU = sao.STAFF_GU
where 
	--MthMs = Math classes EngMs = Language Arts classes
	SUBJECT_AREA_1 = ('MthMs')
	and sao.ENROLLMENT_GRADE_LEVEL in ('160', '170', '180')
)

--SELECT ALL THE RECORDS
--select * from SUBJ_cte
--where rownum = 1
--order by ORGANIZATION_NAME, LAST_NAME, first_name


--FINALLY COUNT THE RECORDS
SELECT
	ORGANIZATION_NAME as [School Name],
	COUNT(*) as [Teacher Count]

FROM
	SUBJ_CTE cte
where 
	Rownum = 1
group by
	ORGANIZATION_NAME




