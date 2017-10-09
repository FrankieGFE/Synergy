EXECUTE AS LOGIN='QueryFileUser'
GO

;
WITH STUDENT_CTE
AS
(
SELECT 
	APS_ID AS APS_ID,
	[STUDENT LAST NAME] AS STUDENT_LAST_NAME,
	[STUDENT FIRST NAME] AS STUDENT_FIRST_NAME

FROM
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
		'SELECT * from Lutheran_Family_Services_2016.csv'
                ) 
)
--SELECT * FROM STUDENT_CTE
,MEMBERDAYS_CTE
as
(  

select
	SIS_NUMBER as APS_ID,
	sum(cast(MEMBERDAYS as int)) MEMBER_DAYS
from
	 dbo.Student_School_Memberdays SM
GROUP BY SIS_NUMBER
)

--select * from MEMBERDAYS_CTE
,STUDENTATTCTE
as
(

SELECT

	 SA.[SIS Number] as [Student APS ID],
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
	dbo.STUDENT_ATTENDANCE_2016 SA
)
--SELECT * FROM STUDENTATTCTE
,RESULTS
AS
(
SELECT
ROW_NUMBER() over (partition by S.APS_ID ORDER BY S.APS_ID, TOTAL_DAYS DESC) AS RN,
	 SchoolYear = '2016',
	 S.APS_ID,
	 STUDENT_LAST_NAME,
	 STUDENT_FIRST_NAME,
	 ISNULL(sum([1/2-day Unexcused Absences]),0) as HalfDayUnexcused,
	 ISNULL(SUM([Full-day Unexcused Absences]),0) as FullDayUnexcused,
	 ISNULL(SUM([1/2-day Excused Absences]),0)as HalfDayExcused,
	 ISNULL(SUM([Full-Day Excused Absences]),0) as FullDayExcused,
	 isnull(SUM([Total Excused]),0) as TotalExcused,
	 ISNULL(SUM([Total Unexcused]),0) as TotalUnexcused,
	 isnull(sum([Total Excused/Unexcused]),0) as TotalExcusedUnexcused,
	 TOTAL_DAYS AS [Total Days]
FROM
	STUDENT_CTE S
LEFT JOIN
	MEMBERDAYS_CTE M
ON 
	S.APS_ID = M.APS_ID
LEFT JOIN
	STUDENTATTCTE SA
	ON SA.[Student APS ID] = S.APS_ID
group by
	S.APS_ID, S.STUDENT_FIRST_NAME, S.STUDENT_LAST_NAME, SA.SchoolYear, SA.[1/2-day Excused Absences], m.MEMBER_DAYS, sa.TOTAL_DAYS
)
SELECT * FROM RESULTS WHERE RN =1  ORDER BY APS_ID

	 








	 