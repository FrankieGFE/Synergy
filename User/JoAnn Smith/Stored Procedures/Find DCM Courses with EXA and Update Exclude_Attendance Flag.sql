/*
Pull DCM Courses with EXA flag
for Patti
Written by:		JoAnn Smith
Date Written:	8/10/2017
*/


CREATE PROC [APS].[FixSectionAttendanceOption]

AS
BEGIN
Begin Tran
;WITH EXA_EXG
AS
(
select distinct
	o.ORGANIZATION_NAME AS SCHOOL_NAME,
	c.COURSE_ID,
	s.SECTION_ID,
	C.COURSE_TITLE,
	L.COURSE_LEVEL,
	s.EXCLUDE_ATTENDANCE,
	s.EXCLUDE_GRADING,
	s.SECTION_GU
FROM
	 rev.EPC_SCH_YR_SECT s
inner JOIN 
	rev.REV_ORGANIZATION_YEAR oy
ON 
	oy.ORGANIZATION_YEAR_GU = s.ORGANIZATION_YEAR_GU
                                        AND oy.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
inner JOIN
	 rev.REV_YEAR  y 
ON
	 y.YEAR_GU = oy.YEAR_GU
inner join	
	rev.rev_organization o
on
	o.ORGANIZATION_GU = oy.ORGANIZATION_GU
inner JOIN
	 rev.EPC_SCH_YR_CRS yc
ON
	 yc.SCHOOL_YEAR_COURSE_GU = s.SCHOOL_YEAR_COURSE_GU
inner JOIN
	 rev.EPC_CRS c           
ON
	 c.COURSE_GU = yc.COURSE_GU
inner join
	rev.EPC_CRS_LEVEL_LST l
on
	c.COURSE_GU = l.COURSe_gu
where
	l.COURSE_LEVEL in ('EXA', 'EXG')
and
	inactive = 'N'
)
--select * from exa_exg 
,Update_Exclude_Attendance
as
(
select
	 SCHOOL_NAME,
	 COURSE_ID,
	 SECTION_ID,
	 section_gu,
	 COURSE_TITLE,
	 COURSE_LEVEL,
	 EXCLUDE_ATTENDANCE
 from
	 EXA_EXG 
 where
	 COURSE_LEVEL = 'EXA' and EXCLUDE_ATTENDANCE = 'Y'
)
--select * from Update_Exclude_Attendance

--Update Exclude_Attendance
Update rev.EPC_SCH_YR_SECT 
	set EXCLUDE_ATTENDANCE = 'N'
where
	section_gu in (select section_gu from Update_Exclude_Attendance)
commit

END
GO

