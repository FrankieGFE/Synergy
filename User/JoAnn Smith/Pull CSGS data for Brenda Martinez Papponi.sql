/*
Pull data for Brenda Martinez Papponi
Council of the Great City Schools CGCS
ELL Data Request
*/

declare @AsofDate datetime2 = '2015-10-01'
declare @SchoolYear nvarchar(4) = '2015'

--pull Proficiency of ELLs by Grade Band for a specific year

SELECT 
	SY = '2013-2014',
	[CURRENT GRADE LEVEL],
	COUNT([CURRENT GRADE LEVEL]) AS [COUNT],
	[ENGLISH PROFICIENCY]
FROM 
	[RDAVM.APS.EDU.ACTD].db_STARS_History.dbo.STUD_SNAPSHOT
WHERE
	[DISTRICT CODE] = '001' AND 
	[PERIOD] = '2013-10-01' 
AND
	[ENGLISH PROFICIENCY] = '6'
AND
	[CURRENT GRADE LEVEL] != 'PK'

GROUP BY
	[CURRENT GRADE LEVEL],
	SY,
	[ENGLISH PROFICIENCY]
ORDER BY
	[CURRENT GRADE LEVEL]


--****************************************************************
--pull count of ELLS greater than six years for 2013, 2014, 2015

select
	count(*) as [Student Count]
from 
	aps.ellasof('2015-10-01')	
--*****************************************************************

--*****************************************************************
--this is from Synergy and pulls special ed/Ell (who are special ed) students
--with IEPs (no data in RDAVM for 2015)
--special ed students should have an IEP but ELL students don't necessarily
--gifted students have an IEP (they're considered special ed)
select
	@SchoolYear as [School Year],
	CASE
		WHEN e.grade = '100' THEN 'Kindergarten'
		when e.grade = '110' then 'Grade 1'
		when e.grade = '120' then 'Grade 2'
		when e.grade = '130' then 'Grade 3'
		when e.grade = '140' then 'Grade 4'
		when e.grade = '150' then 'Grade 5'
		when e.grade = '160' then 'Grade 6'
		when e.grade = '170' then 'Grade 7'
		when e.grade = '180' then 'Grade 8'
		when e.grade = '190' then 'Grade 9'
		when e.grade = '200' then 'Grade 10'
		when e.grade = '210' then 'Grade 11'
		when e.grade = '220' then 'Grade 12'
	end as [Grade Level],
	--bs.SIS_NUMBER,
	count(E.GRADE) as [Count]
	--[IEP End Date]
from
	aps.EnrollmentsAsOf(@AsofDate) e
inner join
	aps.BasicStudentWithMoreInfo bs
on
	bs.STUDENT_GU = e.STUDENT_GU
INNER join
	aps.MedicaidImport1 i
on
	bs.SIS_NUMBER = i.[Student ID]
where
	E.GRADE >= 100 and E.grade <= 220
and
	SPED_STATUS = 'Y'
and
	ELL_STATUS = 'y'
AND 
	i.[IEP End Date] > @AsofDate
group by
	E.grade
	
order by E.GRADE

--********************************************************************
--enrollments 
/*
this is from RDAVM and pulls special ed/Ell (who are special ed) students with IEPs
no data for 2015
*/

SELECT
	[SY] AS [School Year], 
	Field9 as [Grade],
	COUNT([FIELD9]) as [SPED/ELLs With IEP]	
FROM 
	[RDAVM.APS.EDU.ACTD].db_STARS_History.dbo.SPECIAL_ED_SNAP 
WHERE
	[DISTRICT CODE] = '001'
and 
	Field9 is not null
AND 
	[PERIOD] = '2012-10-01'
and
	Field9 in ('K', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12')
group by
	Field9,	SY
order by
	Grade

--******************************************************************************

--enrollments of SPED students

select
	@SchoolYear as [School Year],
	CASE
		WHEN e.grade = '100' THEN 'Kindergarten'
		when e.grade = '110' then 'Grade 1'
		when e.grade = '120' then 'Grade 2'
		when e.grade = '130' then 'Grade 3'
		when e.grade = '140' then 'Grade 4'
		when e.grade = '150' then 'Grade 5'
		when e.grade = '160' then 'Grade 6'
		when e.grade = '170' then 'Grade 7'
		when e.grade = '180' then 'Grade 8'
		when e.grade = '190' then 'Grade 9'
		when e.grade = '200' then 'Grade 10'
		when e.grade = '210' then 'Grade 11'
		when e.grade = '220' then 'Grade 12'
	end as [Grade Level],
	count(E.GRADE) as [Count]
from
	aps.EnrollmentsAsOf(@AsofDate) e
INNER join
	aps.BasicStudentWithMoreInfo bs
on
	bs.STUDENT_GU = e.STUDENT_GU
where
	E.GRADE >= 100 and E.grade <= 220
and
	SPED_STATUS = 'Y'
group by
	E.grade
order by E.GRADE

--*********************************************************
-- total student enrollments by school year
select
	@SchoolYear as [School Year],
	CASE
		WHEN e.grade = '100' THEN 'Kindergarten'
		when e.grade = '110' then 'Grade 1'
		when e.grade = '120' then 'Grade 2'
		when e.grade = '130' then 'Grade 3'
		when e.grade = '140' then 'Grade 4'
		when e.grade = '150' then 'Grade 5'
		when e.grade = '160' then 'Grade 6'
		when e.grade = '170' then 'Grade 7'
		when e.grade = '180' then 'Grade 8'
		when e.grade = '190' then 'Grade 9'
		when e.grade = '200' then 'Grade 10'
		when e.grade = '210' then 'Grade 11'
		when e.grade = '220' then 'Grade 12'
	end as [Grade Level],
	count(E.GRADE) as [Count]
from
	aps.EnrollmentsAsOf(@AsofDate) e
INNER join
	aps.BasicStudentWithMoreInfo bs
on
	bs.STUDENT_GU = e.STUDENT_GU
where
	E.GRADE >= 100 and E.grade <= 220
group by
	E.grade
order by E.GRADE

--***********************************************************
--ELL enrollments
select
	@SchoolYear as [School Year],
	CASE
		WHEN e.grade = '100' THEN 'Kindergarten'
		when e.grade = '110' then 'Grade 1'
		when e.grade = '120' then 'Grade 2'
		when e.grade = '130' then 'Grade 3'
		when e.grade = '140' then 'Grade 4'
		when e.grade = '150' then 'Grade 5'
		when e.grade = '160' then 'Grade 6'
		when e.grade = '170' then 'Grade 7'
		when e.grade = '180' then 'Grade 8'
		when e.grade = '190' then 'Grade 9'
		when e.grade = '200' then 'Grade 10'
		when e.grade = '210' then 'Grade 11'
		when e.grade = '220' then 'Grade 12'
	end as [Grade Level],
	count(E.GRADE) as [Count]
from
	aps.EnrollmentsAsOf(@AsofDate) e
INNER join
	aps.BasicStudentWithMoreInfo bs
on
	bs.STUDENT_GU = e.STUDENT_GU
where
	E.GRADE >= 100 and E.grade <= 220
and
	ELL_STATUS = 'Y'
group by
	E.grade
order by E.GRADE

