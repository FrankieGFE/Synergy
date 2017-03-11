/*
Pull 2013 SBA Data for UNM EDLEAD request
for Wendy Kappy
Uses CTEs for Reading and Math and
then joins them together for the final
results

Change the date for primaryenrollmentdetailsasof
to the last day of school for that school year
Change the cast(datepart(year, studenttest.admin_date) as int) -1 
to the school year you want
Change the .csv file name to reflect the year you want

*/

EXECUTE AS LOGIN='QueryFileUser'
GO


;with ReadingCTE
AS

(

SELECT 
    ROW_NUMBER () OVER (PARTITION BY SIS_NUMBER ORDER BY TEST_SCORE DESC) AS RN
    ,PERSON.FIRST_NAME as [First Name]
    ,PERSON.LAST_NAME as [Last Name]
    ,CAST (SIS_NUMBER AS INT) AS [Student APS ID]
	,STUDENT.STATE_STUDENT_NUMBER as [State Student ID]
    ,TEST.TEST_NAME as [Test Name]
    ,STU_PART.PERFORMANCE_LEVEL AS [PARCC ELA Proficiency Level]
	,part.PART_DESCRIPTION as [ELA]
    ,SCORES.TEST_SCORE as [PARCC ELA Scaled Score]
	,scoretdef.SCORE_DESCRIPTION
    ,STUDENTTEST.ADMIN_DATE as [ELA Admin Date]
	,Enroll.SCHOOL_CODE AS [School Code]
	,Enroll.GRADE as [Grade]
	,cast(datepart(year, studenttest.admin_date) as int) -1 as [School Year]
FROM
    rev.EPC_STU_TEST AS StudentTest

JOIN
    rev.EPC_TEST_PART AS PART
    ON StudentTest.TEST_GU = PART.TEST_GU

JOIN
    rev.EPC_STU_TEST_PART AS STU_PART
    ON PART.TEST_PART_GU = STU_PART.TEST_PART_GU
    AND STU_PART.STUDENT_TEST_GU = StudentTest.STUDENT_TEST_GU

INNER JOIN
	rev.EPC_STU_TEST_PART_SCORE AS SCORES
ON
	SCORES.STU_TEST_PART_GU = STU_PART.STU_TEST_PART_GU

LEFT JOIN
	rev.EPC_TEST_SCORE_TYPE AS SCORET
ON
	SCORET.TEST_GU = StudentTest.TEST_GU
	AND SCORES.TEST_SCORE_TYPE_GU = SCORET.TEST_SCORE_TYPE_GU

LEFT JOIN
	rev.EPC_TEST_DEF_SCORE AS SCORETDEF
ON
	SCORETDEF.TEST_DEF_SCORE_GU = SCORET.TEST_DEF_SCORE_GU

LEFT JOIN
	rev.EPC_TEST AS TEST
ON
	TEST.TEST_GU = StudentTest.TEST_GU
INNER JOIN
	rev.EPC_STU AS Student
ON
	Student.STUDENT_GU = StudentTest.STUDENT_GU
INNER JOIN
	rev.REV_PERSON AS Person
ON
	Person.PERSON_GU = StudentTest.STUDENT_GU
LEFT JOIN
	APS.PrimaryEnrollmentDetailsAsOf('2016-05-25') AS Enroll
ON
	StudentTest.STUDENT_GU = Enroll.STUDENT_GU	
LEFT JOIN
	rev.REV_ORGANIZATION_YEAR AS OrgYear
ON
	Enroll.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU
LEFT JOIN
	rev.REV_ORGANIZATION AS Org
ON
	OrgYear.ORGANIZATION_GU = Org.ORGANIZATION_GU
LEFT JOIN
	APS.LookupTable('K12','Grade') AS GradeLevel
ON
	Enroll.GRADE = GradeLevel.VALUE_CODE
WHERE
	1 = 1
	and test_name = 'PARCC MS ELA 06-08'
	and SCORE_DESCRIPTION = 'Raw'
	and cast(datepart(year, STUDENTTEST.ADMIN_DATE) as int) -1 = 2015
	and PART_DESCRIPTION = 'ELA 06-08'
)
--select * from readingCTE
,MathCTE
AS

(

SELECT 
    ROW_NUMBER () OVER (PARTITION BY SIS_NUMBER ORDER BY TEST_SCORE DESC) AS RN
    ,PERSON.FIRST_NAME as [First Name]
    ,PERSON.LAST_NAME as [Last Name]
    ,CAST (SIS_NUMBER AS INT) AS [Student APS ID]
	,STUDENT.STATE_STUDENT_NUMBER as [State Student ID]
    ,TEST.TEST_NAME as [Test Name]
    ,STU_PART.PERFORMANCE_LEVEL AS [PARCC Math Proficiency Level]
	,part.PART_DESCRIPTION as [Math]
    ,SCORES.TEST_SCORE as [PARCC Math Scaled Score]
	,scoretdef.SCORE_DESCRIPTION
    ,STUDENTTEST.ADMIN_DATE as [Math Admin Date]
	,Enroll.SCHOOL_CODE AS [School Code]
	,Enroll.GRADE as [Grade]
	,cast(datepart(year, studenttest.admin_date) as int) -1 as [School Year]
FROM
    rev.EPC_STU_TEST AS StudentTest

JOIN
    rev.EPC_TEST_PART AS PART
    ON StudentTest.TEST_GU = PART.TEST_GU

JOIN
    rev.EPC_STU_TEST_PART AS STU_PART
    ON PART.TEST_PART_GU = STU_PART.TEST_PART_GU
    AND STU_PART.STUDENT_TEST_GU = StudentTest.STUDENT_TEST_GU

INNER JOIN
	rev.EPC_STU_TEST_PART_SCORE AS SCORES
ON
	SCORES.STU_TEST_PART_GU = STU_PART.STU_TEST_PART_GU

LEFT JOIN
	rev.EPC_TEST_SCORE_TYPE AS SCORET
ON
	SCORET.TEST_GU = StudentTest.TEST_GU
	AND SCORES.TEST_SCORE_TYPE_GU = SCORET.TEST_SCORE_TYPE_GU

LEFT JOIN
	rev.EPC_TEST_DEF_SCORE AS SCORETDEF
ON
	SCORETDEF.TEST_DEF_SCORE_GU = SCORET.TEST_DEF_SCORE_GU

LEFT JOIN
	rev.EPC_TEST AS TEST
ON
	TEST.TEST_GU = StudentTest.TEST_GU
INNER JOIN
	rev.EPC_STU AS Student
ON
	Student.STUDENT_GU = StudentTest.STUDENT_GU
INNER JOIN
	rev.REV_PERSON AS Person
ON
	Person.PERSON_GU = StudentTest.STUDENT_GU
LEFT JOIN
	APS.PrimaryEnrollmentDetailsAsOf('2016-05-25') AS Enroll
ON
	StudentTest.STUDENT_GU = Enroll.STUDENT_GU	
LEFT JOIN
	rev.REV_ORGANIZATION_YEAR AS OrgYear
ON
	Enroll.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU
LEFT JOIN
	rev.REV_ORGANIZATION AS Org
ON
	OrgYear.ORGANIZATION_GU = Org.ORGANIZATION_GU
LEFT JOIN
	APS.LookupTable('K12','Grade') AS GradeLevel
ON
	Enroll.GRADE = GradeLevel.VALUE_CODE
WHERE
	1 = 1
    AND TEST_NAME = 'PARCC MS Math 06-08'
	and SCORE_DESCRIPTION = 'Raw'
	and cast(datepart(year, STUDENTTEST.ADMIN_DATE) as int) -1 = 2015
	and PART_DESCRIPTION = 'Math 06-08'


)
--select * from MathCTE
,ResultsCTE
as
	(
		select 
			 r.[School Year],
			 --r.[State Student ID],
			 T1.[Student APS ID],
			 --r.[School Code],
			 --r.Grade,
			 --r.[Test Name],
			 r.[PARCC ELA Proficiency Level],
			 r.[PARCC ELA Scaled Score],
			 m.[PARCC Math Proficiency Level],
			 m.[PARCC Math Scaled Score],
			 m.[Math Admin Date] as [Admin Date]
 
			 --ROWNUM, FIRSTNAME, LASTNAME, SISNUMBER, TESTNAME,  PERFLEVEL, TESTSCORE, ADMINDATE           
		FROM
			OPENROWSET (
				'Microsoft.ACE.OLEDB.12.0', 
				'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
				'SELECT * from edlead2015.csv'
						) AS [T1]
		left outer JOIN
			ReadingCTE R
		ON
			T1.[Student APS ID] = R.[Student APS ID] 
		left outer join
			MathCTE M
		ON	T1.[Student APS ID] = M.[Student APS ID] 
		where
			r.[School Year] = '2015'
)

select
	*
from
	ResultsCTE
order by
	[Student APS ID]
	

REVERT
GO