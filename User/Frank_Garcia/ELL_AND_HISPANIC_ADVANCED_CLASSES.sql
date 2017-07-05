
SELECT 
	SIS_NUMBER
	,GIFTED_STATUS
	,ORGANIZATION_NAME
	,COURSE_ID
	,COURSE_TITLE
	,AP_INDICATOR
	,DUAL_CREDIT
	,SECTION_ID
	,DEPARTMENT
	,COURSE_DURATION
	,ACADEMIC_TYPE
	,HISPANIC_INDICATOR
	,RESOLVED_RACE
	,[Articulation course (SPED)]
	,[Basic or remedial course]
	,[Industry/occupational certification course]
	,[Dual credit course]
	,[Elective course]
	,[General/Basic course]
	,Gifted
	,[Honors course]
	,[Intervention course]
	,Lab
	,[No credit]
	,[Not applicable]
	,ESL
	,BEP
	,Placeholder
FROM 
(

select distinct
	sch.SIS_NUMBER
	,bs.GIFTED_STATUS
	,sch.ORGANIZATION_NAME
	,sch.COURSE_ID
	,sch.COURSE_TITLE
	,sch.AP_INDICATOR
	,lu.VALUE_DESCRIPTION
	,sch.DUAL_CREDIT
	,sch.SECTION_ID
	,sch.DEPARTMENT
	,sch.COURSE_DURATION
	,sch.ACADEMIC_TYPE
	,bs.HISPANIC_INDICATOR
	,bs.RESOLVED_RACE
	,sch.COURSE_GU

 from APS. ELLAsOf (GETDATE()) ell

join APS.ScheduleDetailsAsOf (GETDATE()) sch
on sch.STUDENT_GU = ell.STUDENT_GU
and sch.STUDENT_SCHOOL_YEAR_GU = ell.STUDENT_SCHOOL_YEAR_GU

joIN REV.EPC_CRS_LEVEL_LST LVL
ON LVL.COURSE_GU = SCH.COURSE_GU

join APS.BasicStudentWithMoreInfo bs
on bs.STUDENT_GU = ell.STUDENT_GU

join rev.SIF_22_Common_GetLookupValues('K12.CourseInfo', 'Sced_Course_Level') lu 
on lu.VALUE_CODE = LVL.COURSE_LEVEL
) T1
PIVOT
	(
	MAX(COURSE_GU) FOR VALUE_DESCRIPTION IN ([Articulation course (SPED)],[Basic or remedial course],[Industry/occupational certification course],[Dual credit course],[Elective course],[General/Basic course],[Gifted],[Honors course],[Intervention course],[Lab],[No credit],[Not applicable],[ESL],[BEP],[Placeholder])
	) P1
--where (AP_INDICATOR = 'Y' OR ACADEMIC_TYPE = 'HON')

--order by sch.SIS_NUMBER