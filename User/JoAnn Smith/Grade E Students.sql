; with Grade_E
as
(
SELECT
--row_number() over(partition by h.STUDENT_GU order by h.student_gu) as RN,
	h.STUDENT_GU,
	h.GRADE AS GRADE_LEVEL,
	 --h.SECTION_ID,
	 h.COURSE_ID,
	 h.COURSE_TITLE,
	 h.TERM_CODE,
	 h.MARK,
	 h.SCHOOL_YEAR
	,h.SECTION_GU
	,H.SECTION_ID
	,ORG.ORGANIZATION_NAME
	,ORG2.NAME 

from
    rev.epc_stu_crs_his h
inner join
    rev.rev_year yr
on
    h.SCHOOL_YEAR = yr.SCHOOL_YEAR
    AND EXTENSION = 'R'
LEFT JOIN 
	REV.REV_ORGANIZATION AS ORG
ON 
	ORG.ORGANIZATION_GU = H.SCHOOL_IN_DISTRICT_GU

LEFT JOIN 
	REV.EPC_SCH_NON_DST AS ORG2
ON 
	ORG2.SCHOOL_NON_DISTRICT_GU = H.SCHOOL_NON_DISTRICT_GU

INNER JOIN 
	REV.EPC_STU AS S
ON
	H.STUDENT_GU = S.STUDENT_GU     
WHERE
	MARK = 'E'

)
--,Grade_E_Results
--as
--(
--select * from Grade_E where rn = 1 
--)
--select * from Grade_E_Results where student_gu = 'D368498E-E74F-45CC-A28D-35FDC1020F0F'
--SELECT * FROM Grade_E
,Student_Details
as
(
select
	BS.STUDENT_GU,
	bs.SIS_NUMBER,
	G.GRADE_LEVEL,
	bs.LAST_NAME,
	bs.FIRST_NAME,
	g.ORGANIZATION_NAME,
	g.name,
	G.MARK,
	G.COURSE_ID,
	G.SECTION_ID,
	G.COURSE_TITLE,
	G.SCHOOL_YEAR,
	--G.YR_SCHOOL_YEAR,
	--G.YEAR_GU,
	g.TERM_CODE

from
	Grade_E g
left join
	aps.BasicStudent bs
on
	g.STUDENT_GU = bs.STUDENT_GU

)
--SELECT * FROM Student_Details where student_gu = 'D368498E-E74F-45CC-A28D-35FDC1020F0F'

,Final_Results
as
(
select
	row_number() over(partition by d.student_gu order by d.student_gu) as rn,
	d.STUDENT_GU,
	case
		when d.organization_name is null then NAME
		WHEN D.ORGANIZATION_NAME IS NOT NULL THEN ORGANIZATION_NAME
	END AS SCHOOL_NAME,
	--d.ORGANIZATION_NAME,
	--d.name,
	d.LAST_NAME,
	d.FIRST_NAME,
	d.SIS_NUMBER,
	lu.VALUE_DESCRIPTION as GRADE_LEVEL,
	D.SECTION_ID,
	d.COURSE_ID,
	d.COURSE_TITLE,
	d.TERM_CODE,
	d.MARK,
	d.SCHOOL_YEAR
	--D.YR_SCHOOL_YEAR,
	--D.YEAR_GU,
	--SED.YEAR_GU AS SED_YEAR_GU
from
	Student_Details d
LEFT JOIN
	APS.LookupTable('K12', 'Grade') as LU
on
	lu.value_code = d.GRADE_LEVEL
)
select * from Final_Results where rn = 1 



order by SCHOOL_NAME



		
