EXECUTE AS LOGIN='QueryFileUser'
GO

with STUDENTCTE(StudentID, TotalDays)
as
(  

	 select STUID, sum(cast(MEMBER_DAYS as int)) from dbo.Student_School_Memberdays SM  GROUP BY STUID
)

,

STUDENTATTCTE(SISNumber, SchoolYear, Grade, HalfDayUnexcused, FullDayUnexcused, HalfDayExcused, FullDayExcused)
as
(

SELECT

	 SA.[SIS Number] as [Student APS ID],
	 SchoolYear = '2016',
	 SA.Grade  as [Grade Level],
	 ISNULL(SA.[Half-Day Unexcused],0)  as [1/2-day Unexcused Absences],
	 ISNULL(SA.[Full-Day Unexcused],0) as [Full-day Unexcused Absences],
	 ISNULL(SA.[Half-Day Excused],0) as [1/2-day Excused Absences],
	 ISNULL(SA.[Full-Day Excused],0) as [Full-Day Excused Absences]
	 
FROM 
	dbo.STUDENT_ATTENDANCE SA
)

SELECT
	 SchoolYear = '2016',
	 T1.APS_ID,
	 bsm.LAST_NAME,
	 bsm.FIRST_NAME,
	 BSM.STATE_STUDENT_NUMBER,
	 ISNULL(sum([HalfDayUnexcused]),0) as HalfDayUnexcused,
	 ISNULL(SUM([FullDayUnexcused]),0) as FullDayUnexcused,
	 ISNULL(SUM([HalfDayExcused]),0)as HalfDayExcused,
	 ISNULL(SUM([FullDayExcused]),0) as FullDayExcused,
	 TotalDays
	

	 --ROWNUM, FIRSTNAME, LASTNAME, SISNUMBER, TESTNAME,  PERFLEVEL, TESTSCORE, ADMINDATE           
FROM
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
		'SELECT * from LutheranFamilyServicesRequest.csv'
                ) AS [T1]

LEFT JOIN
	STUDENTCTE
	ON STUDENTCTE.StudentID = T1.APS_ID
LEFT JOIN
	STUDENTATTCTE
	ON STUDENTATTCTE.SISNumber = T1.APS_ID
INNER JOIN
	APS.BasicStudentWithMoreInfo BSM
	ON STUDENTCTE.StudentID = BSM.SIS_NUMBER
group by
	T1.APS_ID, BSM.FIRST_NAME, BSM.LAST_NAME, STUDENTATTCTE.SchoolYear, STUDENTATTCTE.Grade, STUDENTCTE.TotalDays, BSM.STATE_STUDENT_NUMBER
ORDER BY
	LAST_NAME, FIRST_NAME

	REVERT
	GO	
	 








	 