--read from text file
EXECUTE AS LOGIN='QueryFileUser'
GO

;WITH STUDENTS_WITH_BALANCES
AS
(
SELECT 
            *
			
FROM
       OPENROWSET (
              'Microsoft.ACE.OLEDB.12.0', 
              'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
              'SELECT * FROM SummerSchoolBalanceDue.csv')
)
,Currently_Enrolled
as
(
select
	e.STUDENT_GU,
	e.SIS_NUMBER,
	'Y' as CURRENTLY_ENROLLED,
	ssy.LEAVE_DATE
from
	rev.epc_stu e
inner join
	rev.epc_stu_sch_yr ssy
on
	e.STUDENT_GU= ssy.STUDENT_GU
inner join
	rev.REV_ORGANIZATION_YEAR oy
on
	ssy.ORGANIZATION_YEAR_GU = oy.ORGANIZATION_YEAR_GU
inner join
	rev.rev_year yr
on
	oy.YEAR_GU = yr.YEAR_GU
where
	yr.SCHOOL_YEAR = '2017' and EXTENSION = 'R'
and
	ssy.LEAVE_DATE is null
AND
	EXCLUDE_ADA_ADM IS NULL
)
--select * from Currently_Enrolled 
,Results
as
(
SELECT
	ROW_NUMBER() over (partition by S.[Perm Id] order by S.[Perm Id]) as rn,
	S.[Student Name],
	s.[Perm ID],
	s.Gender,
	s.Grade,
	s.[Total Fees],
	s.[Total Payments],
	s.Credits,
	s.Refunds,
	s.Debits,
	s.Balance,
	s.[Refund Needed],
	C.CURRENTLY_ENROLLED
FROM
	STUDENTS_WITH_BALANCES S
left join
	Currently_Enrolled c
on
	s.[Perm ID] = c.SIS_NUMBER
)
select * from Results where rn = 1  
--select * from aps.PrimaryEnrollmentsAsOf(getdate()) where STUDENT_GU = 'BD865CE5-01D6-4E0D-AB6D-C9B2DC72A202'