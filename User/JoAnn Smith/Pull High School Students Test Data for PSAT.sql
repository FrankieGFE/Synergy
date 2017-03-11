/*
Pull PSAT data for High School Students
enrolled during 2015-2016 SY
for Wendy Kappy
Uses CTEs for Reading and Math and
then joins them together for the final
results

Change the date for primaryenrollmentdetailsasof
to the last day of school for that school year
Change the cast(datepart(year, studenttest.admin_date) as int) -1 
to the school year you want

*/

;with StudentCTE
as
(
select
	ped.SCHOOL_YEAR,
	bs.SIS_NUMBER,
	bs.STATE_STUDENT_NUMBER
	
from
	aps.PrimaryEnrollmentDetailsAsOf('2016-05-25') PED
inner join
	aps.BasicStudentWithMoreInfo bs
on
	bs.student_gu = ped.student_gu
where
	GRADE in ('09', '10', '11', '12')
)

,CRITICALREADING
AS
(
SELECT 
    ROW_NUMBER () OVER (PARTITION BY SIS_NUMBER ORDER BY ADMIN_DATE DESC) AS RN
	,CAST (SIS_NUMBER AS INT) AS [Student APS ID]
    ,TEST.TEST_NAME as [Test Name]
    ,STU_PART.PERFORMANCE_LEVEL AS [Proficiency Level]
	,part.PART_DESCRIPTION as [Reading]
    ,SCORES.TEST_SCORE as [Scaled Score]
	,scoretdef.SCORE_DESCRIPTION
    ,STUDENTTEST.ADMIN_DATE as [Admin Date]
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
	and test_name = 'PSAT Critical Reading'
	--and SCORE_DESCRIPTION = 'Raw'
	and cast(datepart(year, STUDENTTEST.ADMIN_DATE) as int) -1 = 2015
	and PART_DESCRIPTION = 'CRITICAL READING'
)
,MATH
AS
(
SELECT 
    ROW_NUMBER () OVER (PARTITION BY SIS_NUMBER ORDER BY ADMIN_DATE DESC) AS RN
	,CAST (SIS_NUMBER AS INT) AS [Student APS ID]
    ,TEST.TEST_NAME as [Test Name]
    ,STU_PART.PERFORMANCE_LEVEL AS [Proficiency Level]
	,part.PART_DESCRIPTION as [Math]
    ,SCORES.TEST_SCORE as [Scaled Score]
	,scoretdef.SCORE_DESCRIPTION
    ,STUDENTTEST.ADMIN_DATE as [Admin Date]
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
	and test_name = 'PSAT Math'
	--and SCORE_DESCRIPTION = 'Raw'
	and cast(datepart(year, STUDENTTEST.ADMIN_DATE) as int) -1 = 2015
	and PART_DESCRIPTION = 'MATH'
)
,WRITING
AS
(
SELECT 
    ROW_NUMBER () OVER (PARTITION BY SIS_NUMBER ORDER BY ADMIN_DATE DESC) AS RN
	,CAST (SIS_NUMBER AS INT) AS [Student APS ID]
    ,TEST.TEST_NAME as [Test Name]
    ,STU_PART.PERFORMANCE_LEVEL AS [Proficiency Level]
	,part.PART_DESCRIPTION as [Writing]
    ,SCORES.TEST_SCORE as [Scaled Score]
	,scoretdef.SCORE_DESCRIPTION
    ,STUDENTTEST.ADMIN_DATE as [Admin Date]
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
	and test_name = 'PSAT Writing'
	--and SCORE_DESCRIPTION = 'Raw'
	and cast(datepart(year, STUDENTTEST.ADMIN_DATE) as int) -1 = 2015
	and PART_DESCRIPTION = 'WRITING'
)
--select * from GeometryCTE
,ResultsCTE
as
	(
		select
			 S.SIS_NUMBER as [Student APS ID],			 
			 s.[STATE_STUDENT_NUMBER] as [State Student ID],
			 CR.[Proficiency Level] as [Critical Reading Performance Level],
			 CR.[Scaled Score] as [English 9 Scaled Score],
			 m.[Proficiency Level] as [Math Performance Level],
			 m.[Scaled Score] as [Math Scaled Score],
			 w.[Proficiency Level] as [Writing Proficiency Level],
			 w.[Scaled Score] as [Writing Scaled Score]

 
			 --ROWNUM, FIRSTNAME, LASTNAME, SISNUMBER, TESTNAME,  PERFLEVEL, TESTSCORE, ADMINDATE           
		FROM
			StudentCTE S
		left outer join
			CRITICALREADING CR
		on
			CR.[Student APS ID] = s.SIS_NUMBER
		left outer join
			MATH M
		on
			M.[Student APS ID] = s.SIS_NUMBER
		left outer join
			WRITING W
		on
			W.[Student APS ID] = s.SIS_NUMBER
)

select
	*
from
	ResultsCTE
order by
	[Student APS ID]
	

REVERT
GO