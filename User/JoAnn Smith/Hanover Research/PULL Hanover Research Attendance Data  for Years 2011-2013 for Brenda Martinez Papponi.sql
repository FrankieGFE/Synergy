--/*
-- * Revision 1
-- * Last Changed By:    JoAnn Smith
-- * Last Changed Date:  1/26/17
-- ******************************************************
-- Hanover will examine the impact of Nspire on students’ attendance.
--	1.	Attendance information for all Highland students between 2011-12 to Present school year
--	Total Membership days
--	Total absences
--	Total Present
--	School year identified

--Pull attendance data for Highland High School
--for Hanover Research (Brenda Martinez Papponi)
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--change members days file to proper year
--change attendance days file to proper year 
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

-- This data comes from School Max (180-smaxods-01.aps.edu.actd)
-- and contains data for years 2011-2013
 
-- ******************************************************
-- 1-26-2017 Initial query


with AttendanceCTE(StudentID, SchoolCode, HalfDay, FullDay, TotalAbsences)
as
(
select
	ATT.ID_NBR,
	ATT.SCH_NBR,
	ATT.HALF_DAY,
	ATT.FULL_DAY,
	case
		 when ATT.TOTAL_ABSENCES = '0.0' then 0
		 ELSE
		 SUM (CAST(CAST(ATT.TOTAL_ABSENCES AS numeric(5,2)) as real)) 
	end AS TOTAL_ABSENCES

from dbo.ATTENDANCE_2013 ATT

WHERE
	ATT.SCH_NBR = '520'


GROUP BY
	ATT.ID_NBR,
	ATT.SCH_NBR,
	ATT.HALF_DAY,
	ATT.FULL_DAY,
	ATT.TOTAL_ABSENCES

)
,

 StudentCTE(Rownum, SchoolYear, StudentID, SchoolCode, MemberDays)
as
(
select 
	ROW_NUMBER() over(PARTITION BY SA.IDNBR ORDER BY SA.IDNBR) as ROWNUM,
	SA.SCHOOL_YEAR,
	SA.IDNBR,
	SA.SCHNBR,
	SA.MEMBERDAYS

from
	dbo.STUDENT_ATTENDANCE_2013 SA
WHERE
	SA.SCHNBR = '520' 	

)

SELECT
	STU.SchoolYear,
	STU.StudentID,
	STU.SchoolCode,
	ATT.HalfDay,
	ATT.FullDay,
	ATT.TotalAbsences,
	STU.MemberDays
FROM
	AttendanceCTE ATT
INNER JOIN
	StudentCTE STU
on
	ATT.StudentID = STU.StudentID
where 
	Rownum = 1 
order by
	STU.StudentID






