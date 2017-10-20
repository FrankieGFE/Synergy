USE [ST_Production]
GO

/****** Object:  UserDefinedFunction [APS].[SectionsWithAdditionalTeachersAsOf]    Script Date: 10/13/2017 1:27:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/**
 * FUNCTION APS.SectionsWithAdditionalTeachersAsOf
 * Pulls additional teachers for a section for a particular year
 * 
 * Tables Used: REV.EPC_SCH_YR_SECT
				REV.EPC_SCH_YR_SECT_STF
				REV.EPC_STAFF_SCH_YR
				REV.REV_PERSON
 *
 * #param DATE @AsOfDate date to look for scheduled classes
 * 
 * #return TABLE school, section id, course ids of classes with additional teachers assigned and their badge numbers
 */

--select * from aps.SectionsWithAdditionalTeachersAsOf('A3F9F1FB-4706-49AA-B3A3-21F153966191') WHERE ORGANIZATION_GU LIKE '%'
CREATE FUNCTION [APS].[SectionsWithAdditionalTeachersAsOf](@Year_Gu UNIQUEIDENTIFIER)
RETURNS TABLE
AS
RETURN	

--DECLARE @YEAR_GU UNIQUEIDENTIFIER = 'A3F9F1FB-4706-49AA-B3A3-21F153966191'

with Main
as
(
select
	row_number() over(partition by sec.section_gu order by sec.section_gu) as rn,
	o.ORGANIZATION_NAME,
	o.ORGANIZATION_GU,
	sec.SECTION_ID,
	c.COURSE_ID,
	c.COURSE_TITLE,
	SEC.STAFF_SCHOOL_YEAR_GU,
	--SCY.STAFF_GU,
	P2.LAST_NAME AS PRIMARY_TEACHER_LAST_NAME,
	P2.FIRST_NAME AS PRIMARY_TEACHER_FIRST_NAME,
	STA2.BADGE_NUM AS PRIMARY_TEACHER_BADGE_NUM,
	P.LAST_NAME AS ADDITONAL_STAFF_LAST_NAME,
	P.FIRST_NAME AS ADDITIONAL_STAFF_FIRST_NAME,
	STA.BADGE_NUM AS ADDITIONAL_STAFF_BADGE_NUM,
	stf.CLASS_ROLE,
	LU.VALUE_DESCRIPTION AS CONTRIBUTION_RESPONSIBILITY,
	stf.EXCLUDE_FROM_STATE_RPT,
	y.SCHOOL_YEAR
from
       --READ ALL SECTIONS
	rev.EPC_SCH_YR_SECT AS sec
                     
       --GET ONLY SECTIONS WITH AN ADDITIONAL TEACHER
inner join
	rev.EPC_SCH_YR_SECT_STF AS stf
ON
	stf.SECTION_GU = sec.SECTION_GU
                     
--NEED TO READ STAFF SCHOOL YEAR TO GET STAFF_GU
inner join
	rev.EPC_STAFF_SCH_YR AS staffyear
ON
	stf.STAFF_SCHOOL_YEAR_GU = staffyear.STAFF_SCHOOL_YEAR_GU
inner join
	REV.REV_PERSON p
ON
	p.PERSON_GU = staffyear.STAFF_GU
inner join
	rev.epc_staff sta
ON
	p.PERSON_GU = sta.STAFF_GU
inner join
	REV.EPC_STAFF_SCH_YR AS staffyear2
ON
	sec.STAFF_SCHOOL_YEAR_GU = staffyear2.STAFF_SCHOOL_YEAR_GU
inner join
	REV.EPC_STAFF sta2
ON
	sta2.STAFF_GU = staffyear2.STAFF_GU
inner join
	REV.REV_PERSON p2
ON
	p2.PERSON_GU = staffyear2.STAFF_GU

inner join
	rev.epc_sch_yr_sect_stf s
on
	sec.SECTION_GU = s.SECTION_GU
inner join	
	rev.EPC_SCH_YR_CRS crs
on
	sec.SCHOOL_YEAR_COURSE_GU = crs.SCHOOL_YEAR_COURSE_GU
inner join
	rev.epc_crs c
on
	crs.course_gu = c.course_gu
left join
	rev.rev_organization_year yr
on
	yr.ORGANIZATION_YEAR_GU = sec.ORGANIZATION_YEAR_GU
left join
	rev.epc_stu_sch_yr ssy
on
	ssy.ORGANIZATION_YEAR_GU = sec.ORGANIZATION_YEAR_GU
left join
	rev.rev_year y
on
	y.YEAR_GU = ssy.YEAR_GU
left join
	rev.epc_sch sch
on
	yr.ORGANIZATION_GU = sch.ORGANIZATION_GU
left join
	rev.REV_ORGANIZATION o 
on
	sch.ORGANIZATION_GU = o.ORGANIZATION_GU
left join
	aps.LookupTable('K12.ScheduleInfo', 'Staff_RESPONSIBILITY') LU
ON
	LU.VALUE_CODE = STF.STAF_CONTR_RESPON
where
	 y.year_gu = @YEAR_GU

)

SELECT
	 M.ORGANIZATION_NAME,
	 M.ORGANIZATION_GU,
	 M.SECTION_ID,
	 M.COURSE_ID,
	 M.COURSE_TITLE,
	 M.PRIMARY_TEACHER_LAST_NAME,
	 M.PRIMARY_TEACHER_FIRST_NAME,
	 M.PRIMARY_TEACHER_BADGE_NUM,
	 M.ADDITONAL_STAFF_LAST_NAME,
	 M.ADDITIONAL_STAFF_FIRST_NAME,
	 M.ADDITIONAL_STAFF_BADGE_NUM,
	 M.CLASS_ROLE,
	 M.CONTRIBUTION_RESPONSIBILITY,
	 M.EXCLUDE_FROM_STATE_RPT,
	 M.SCHOOL_YEAR
FROM
	 MAIN M
WHERE
	 RN = 1


GO

