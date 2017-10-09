/*
Date:		2017-10-09
Written by:	JoAnn Smith

I need some data from last 4 years of high school summer school.  Can you help me with the following:
•	All SPED students enrolled from 2014-2017
•	All courses taken by summer SPED students
2013S -AA26EA9A-B72D-45B6-8D7F-F1078FB756EA
2014S -6D367A0B-966E-46C0-981F-94F6503784E0
2015S -9CF3D2D1-99A3-4892-9A72-BE911D339601
2016S -C501E5D9-1742-4ABC-9E84-0E46C28D2A05

*/

declare @SchoolYearGu uniqueidentifier = 'C501E5D9-1742-4ABC-9E84-0E46C28D2A05'

;with SPED_Students
as
(
select
	SED.EXTENSION,
	SED.SCHOOL_YEAR,
	SED.SIS_NUMBER,
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
	s.LAST_NAME,
	s.FIRST_NAME,
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
	row_number() over(partition by sis_number, course_id order by sis_number) as rn,
	s.SIS_NUMBER,
	s.LAST_NAME,
	s.FIRST_NAME,
	s.SCHOOL_NAME,
	s.SCHOOL_YEAR, 
	s.SPED_STATUS,
	--sed.COURSE_GU,
	c.COURSE_ID,
	c.COURSE_TITLE
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
where
	sed.YEAR_GU = @SchoolYearGu
)
select * from SUMMER_SPED_WITH_CLASSES_FOR_YEAR
where rn = 1
order by SIS_NUMBER, course_id

	