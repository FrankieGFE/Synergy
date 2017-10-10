/*
Date:		2017-10-09
Written by:	JoAnn Smith

I need some data from last 4 years of high school summer school.  Can you help me with the following:
•	All SPED students enrolled from 2014-2017
•	All courses taken by summer SPED students
2013S -AA26EA9A-B72D-45B6-8D7F-F1078FB756EA
2014S -6D367A0B-966E-46C0-981F-94F6503784E0 - 2015-05-22 00:00:00
2015S -9CF3D2D1-99A3-4892-9A72-BE911D339601 - 2016-06-30 00:00:00
2016S -C501E5D9-1742-4ABC-9E84-0E46C28D2A05 - 2017-06-30 00:00:00

additionaL requested same day:
1)	Please add Grade Level to all tabs.
2)	For SPED 2013 tab (2013-2014), please only include HS locations (500-599), CNM 701, UNM 702 and any MS location (400-499) where couseID=900001 or 900002.
3)	For SPED 2014-2016 tabs, please only include Location #533 (APS Summer School) students.

additional requested next day:
can we get their home school sites and their final grades for the courses that they took

Two branches exist in this script because the requirements were different for 2013 and the rest
of the years.  Change the year_gu and school_year to get results.

*/

declare @SchoolYearGu uniqueidentifier = 'C501E5D9-1742-4ABC-9E84-0E46C28D2A05'
declare @SchoolYear nvarchar(10) = '2016'
declare @AsOfDate datetime2 = '2017-06-30 00:00:00'

BEGIN
	IF @SchoolYearGu = 'AA26EA9A-B72D-45B6-8D7F-F1078FB756EA' GOTO Branch_One
	IF @SchoolYearGu in ('6D367A0B-966E-46C0-981F-94F6503784E0', '9CF3D2D1-99A3-4892-9A72-BE911D339601', 'C501E5D9-1742-4ABC-9E84-0E46C28D2A05') GOTO Branch_Two

Branch_One:
;with SPED_Students
as
(
select
	SED.EXTENSION,
	SED.SCHOOL_YEAR,
	SED.SIS_NUMBER,
	sed.SCHOOL_CODE,
	bs.STUDENT_GU,
	bs.LAST_NAME,
	bs.FIRST_NAME,
	bs.SPED_STATUS,
	SED.GRADE,
	SED.SCHOOL_NAME,
	sed.YEAR_GU
from
	APS.BasicStudentWithMoreInfo BS
left join
	aps.StudentEnrollmentDetails sed
ON
	SED.STUDENT_GU = BS.STUDENT_GU
WHERE
	BS.SPED_STATUS = 'y'
)
--select * from SPED_Students
,SUMMER_SPED_STUDENTS_FOR_YEAR
AS
(
select
	s.STUDENT_GU,
	s.SIS_NUMBER,
	S.GRADE,
	s.LAST_NAME,
	s.FIRST_NAME,
	s.SCHOOL_CODE,
	s.SCHOOL_NAME,
	s.SCHOOL_YEAR,
	s.SPED_STATUS
from
	SPED_Students s
inner join
	aps.YearDates yd
on yd.YEAR_GU = s.YEAR_GU
and
	yd.extension = 'S'
AND
	s.YEAR_GU = @SchoolYearGu
)
--SELECT * from SUMMER_SPED_STUDENTS_FOR_YEAR
,SUMMER_SPED_WITH_CLASSES_FOR_YEAR
as
(
select
	row_number() over(partition by sis_number, H.course_id order by sis_number) as rn,
	s.SIS_NUMBER,
	s.LAST_NAME,
	s.FIRST_NAME,
	s.SCHOOL_NAME,
	S.SCHOOL_CODE,
	s.SCHOOL_YEAR, 
	S.GRADE,
	s.SPED_STATUS,
	c.COURSE_ID,
	c.COURSE_TITLE,
	h.MARK as LETTER_GRADE,
	H.TERM_CODE
from
	SUMMER_SPED_STUDENTS_FOR_YEAR s
left join
	aps.BasicSchedule sed
on
	s.STUDENT_GU = sed.STUDENT_GU
left join
	rev.epc_crs c
on
	sed.COURSE_gu = c.COURSE_GU
left join
	rev.epc_stu_crs_his h
on
	S.STUDENT_GU = H.STUDENT_GU
AND	
	h.COURSE_GU = c.course_gu
and
	h.SCHOOL_YEAR = @SchoolYear
where
	sed.YEAR_GU = @SchoolYearGu
AND
	H.TERM_CODE = 'SS'
)
,InterimResults 
as
(	
select
	*
from
	SUMMER_SPED_WITH_CLASSES_FOR_YEAR 
WHERE
	SCHOOL_CODE IN (500
,	510
,	511
,	512
,	513
,	514
,	515
,	516
,	517
,	518
,	520
,	521
,	525
,	530
,	533
,	540
,	541
,	542
,	543
,	549
,	550
,	555
,	560
,	570
,	575
,	576
,	580
,	590
,	591
,	592
,	593
,	594
,	596
,	597
,   598
,	701
,	702)
AND TERM_CODE = 'SS'
OR
	SCHOOL_CODE >=400 AND SCHOOL_CODE <= 499 
AND
	COURSE_ID IN ('900001', '900002')
and
	 rn = 1
)
select * from InterimResults where rn = 1
order by SIS_NUMBER, COURSE_ID


Branch_Two:
;with SPED_Students
as
(
select
	SED.EXTENSION,
	SED.SCHOOL_YEAR,
	SED.SIS_NUMBER,
	sed.SCHOOL_CODE,
	bs.STUDENT_GU,
	bs.LAST_NAME,
	bs.FIRST_NAME,
	bs.SPED_STATUS,
	SED.GRADE,
	SED.SCHOOL_NAME,
	sed.YEAR_GU
from
	APS.BasicStudentWithMoreInfo BS
left join
	aps.StudentEnrollmentDetails sed
ON
	SED.STUDENT_GU = BS.STUDENT_GU
WHERE
	BS.SPED_STATUS = 'y'
)
--select * from SPED_Students
,SUMMER_SPED_STUDENTS_FOR_YEAR
AS
(
select
	s.STUDENT_GU,
	s.SIS_NUMBER,
	S.GRADE,
	s.LAST_NAME,
	s.FIRST_NAME,
	s.SCHOOL_CODE,
	s.SCHOOL_NAME,
	s.SCHOOL_YEAR,
	s.SPED_STATUS
from
	SPED_Students s
inner join
	aps.YearDates yd
on
	 yd.YEAR_GU = s.YEAR_GU
and
	yd.extension = 'S'
AND
	s.YEAR_GU = @SchoolYearGu
)
--SELECT * from SUMMER_SPED_STUDENTS_FOR_YEAR
,SUMMER_SPED_WITH_CLASSES_FOR_YEAR
as
(
select
	row_number() over(partition by sis_number, H.course_id order by sis_number) as rn,
	s.SIS_NUMBER,
	s.STUDENT_GU,
	s.LAST_NAME,
	s.FIRST_NAME,
	s.SCHOOL_NAME,
	S.SCHOOL_CODE,
	s.SCHOOL_YEAR,
	s.GRADE, 
	s.SPED_STATUS,
	--sed.COURSE_GU,
	c.COURSE_ID,
	c.COURSE_TITLE,
	h.MARK as FINAL_GRADE
from
	SUMMER_SPED_STUDENTS_FOR_YEAR s
left join
	aps.BasicSchedule sed
on
	s.STUDENT_GU = sed.STUDENT_GU
left join
	rev.epc_crs c
on
	sed.COURSE_gu = c.COURSE_GU
left join
	rev.epc_stu_crs_his h
on
	S.STUDENT_GU = H.STUDENT_GU
AND	
	h.COURSE_GU = c.course_gu
and
	h.SCHOOL_YEAR = @SchoolYear
where
	sed.YEAR_GU = @SchoolYearGu
)
,InterimResults
as
(	
select
	*
from
	SUMMER_SPED_WITH_CLASSES_FOR_YEAR 
WHERE
	SCHOOL_CODE = 533
and
	 rn = 1
--AND
--	SIS_NUMBER = 100040054
)
,FinalResults
as
(
select
	ROW_NUMBER() OVER(PARTITION BY SIS_NUMBER, COURSE_ID ORDER BY SIS_NUMBER) AS rn,
	i.SIS_NUMBER,
	i.LAST_NAME,
	i.FIRST_NAME,
	i.SCHOOL_NAME,
	i.SCHOOL_CODE,
	e.ORGANIZATION_YEAR_GU,
	o.ORGANIZATION_NAME as PRIMARY_SCHOOL,
	s.SCHOOL_CODE as PRIMARY_SCHOOL_CODE,
	i.SCHOOL_YEAR,
	i.GRADE,
	i.SPED_STATUS,
	i.COURSE_ID,
	i.COURSE_TITLE,
	i.FINAL_GRADE
	
from
	InterimResults i
left join
	aps.PrimaryEnrollmentsAsOf(@AsOfDate) e
on
	i.STUDENT_GU = e.student_gu
inner join
	rev.REV_ORGANIZATION_YEAR y
on
	e.ORGANIZATION_YEAR_GU = y.ORGANIZATION_YEAR_GU
left join
	rev.rev_organization o
on
	y.ORGANIZATION_GU = o.ORGANIZATION_GU
left join
	rev.epc_sch s
on
	o.ORGANIZATION_GU = s.ORGANIZATION_GU
where
	FINAL_GRADE is not null
and
	s.SCHOOL_CODE != '533'

)
select * from FinalResults where rn = 1
order by
	SIS_NUMBER,
	COURSE_ID
end