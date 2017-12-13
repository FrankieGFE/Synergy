/*
Pull attendance data for Catholic Charities
for years 2016-2017 and 2017-2018

*/

EXECUTE AS LOGIN='QueryFileUser'
GO

;
;with All_Students
as
(
SELECT 
	T1.[student ID] as SIS_NUMBER,
	t1.[First name] as FIRST_NAME,
	t1.[Last name] as LAST_NAME
FROM
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
		'SELECT * from CCDataRequest.csv'
                ) AS T1
)
--select * from All_Students
,Student_Details
as
(
select
	s.SIS_NUMBER,
	s.LAST_NAME,
	s.FIRST_NAME,
	bs.GENDER AS GENDER,
	BS.BIRTH_DATE AS BIRTH_DATE,
	O.ORGANIZATION_NAME AS SCHOOL_NAME,
	LU.VALUE_DESCRIPTION AS GRADE_LEVEL,
	bs.STUDENT_GU

from
	All_Students S
left JOIN
	APS.BasicStudent BS
on
	BS.SIS_NUMBER = s.SIS_NUMBER
left JOIN
	REV.EPC_STU ST
ON
	BS.STUDENT_GU = ST.STUDENT_GU
left JOIN
	APS.PrimaryEnrollmentsAsOf('2017-05-25') E
ON
	ST.STUDENT_GU = E.STUDENT_GU
left JOIN
	REV.REV_ORGANIZATION_YEAR OY
ON
	E.ORGANIZATION_YEAR_GU = OY.ORGANIZATION_YEAR_GU

left JOIN
	REV.REV_ORGANIZATION O
ON
	OY.ORGANIZATION_GU = O.ORGANIZATION_GU
LEFT JOIN
	APS.LookupTable('K12', 'Grade') as LU
on
	E.GRADE = LU.VALUE_CODE
)
--SELECT * FROM Student_Details
,MEMBERDAYS_CTE
as
(  

select
	S.SIS_NUMBER,
	sum(cast(MEMBERDAYS as int)) MEMBER_DAYS
from
	All_Students s
LEFT JOIN
	 dbo.Student_School_Memberdays SM
ON
	S.SIS_NUMBER = SM.SIS_NUMBER
GROUP BY S.SIS_NUMBER

)

--select * from MEMBERDAYS_CTE ORDER BY SIS_NUMBER
,STUDENTATTCTE
as
(

SELECT

	 s.SIS_NUMBER,
	 SchoolYear = '2016',
	 SA.Grade  as [Grade Level],
	 ISNULL(SA.[Half-Day Unexcused],0)  as [1/2-day Unexcused Absences],
	 ISNULL(SA.[Full-Day Unexcused],0) as [Full-day Unexcused Absences],
	 ISNULL(SA.[Half-Day Excused],0) as [1/2-day Excused Absences],
	 ISNULL(SA.[Full-Day Excused],0) as [Full-Day Excused Absences],
	 ISNULL(SA.[Total Excused],0) AS [Total Excused],
	 ISNULL(SA.[Total Unexcused],0) as [Total Unexcused],
	 isnull(sa.[Total_Exc_Unex],0) as [Total Excused/Unexcused],
	 isnull(sa.[Member Days] - [Total_Exc_Unex],0)  as TOTAL_DAYS
	 
FROM 
	Student_Details S
LEFT JOIN
	dbo.STUDENT_ATTENDANCE_2016 SA
ON
	S.SIS_NUMBER = SA.[SIS Number]
where
	EXCLUDE_ADA_ADM is null
)
--SELECT * FROM STUDENTATTCTE ORDER BY SIS_NUMBER
,RESULTS
AS
(
SELECT
ROW_NUMBER() over (partition by S.SIS_NUMBER ORDER BY S.SIS_NUMBER, TOTAL_DAYS DESC) AS RN,
	 SchoolYear = '2016',
	 S.SIS_NUMBER,
	 S.LAST_NAME,
	 S.FIRST_NAME,
	 S.GENDER,
	 S.BIRTH_DATE,
	 S.SCHOOL_NAME,
	 S.GRADE_LEVEL,
	 ISNULL(sum([1/2-day Unexcused Absences]),0) as HalfDayUnexcused,
	 ISNULL(SUM([Full-day Unexcused Absences]),0) as FullDayUnexcused,
	 ISNULL(SUM([1/2-day Excused Absences]),0)as HalfDayExcused,
	 ISNULL(SUM([Full-Day Excused Absences]),0) as FullDayExcused,
	 isnull(SUM([Total Excused]),0) as TotalExcused,
	 ISNULL(SUM([Total Unexcused]),0) as TotalUnexcused,
	 isnull(sum([Total Excused/Unexcused]),0) as TotalExcusedUnexcused,
	 TOTAL_DAYS AS [Total Days]
FROM
	Student_Details S
full outer JOIN
	MEMBERDAYS_CTE M
ON 
	S.SIS_NUMBER = M.SIS_NUMBER
full outer JOIN
	STUDENTATTCTE SA
	ON SA.SIS_NUMBER= S.SIS_NUMBER
group by
	S.SIS_NUMBER, S.FIRST_NAME, S.LAST_NAME, S.GENDER, S.BIRTH_DATE, S.SCHOOL_NAME, S.GRADE_LEVEL, SA.SchoolYear, SA.[1/2-day Excused Absences], m.MEMBER_DAYS, sa.TOTAL_DAYS
)
SELECT * FROM RESULTS WHERE RN =1  ORDER BY SIS_NUMBER 

	 








	 