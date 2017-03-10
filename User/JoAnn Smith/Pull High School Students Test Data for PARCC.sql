/*
Pull PARCC data for High School Students
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

,English9CTE
AS
(
SELECT 
    ROW_NUMBER () OVER (PARTITION BY SIS_NUMBER ORDER BY TEST_SCORE DESC) AS RN
	,CAST (SIS_NUMBER AS INT) AS [Student APS ID]
    ,TEST.TEST_NAME as [Test Name]
    ,STU_PART.PERFORMANCE_LEVEL AS [PARCC ELA Proficiency Level]
	,part.PART_DESCRIPTION as [ELA]
    ,SCORES.TEST_SCORE as [PARCC ELA Scaled Score]
	,scoretdef.SCORE_DESCRIPTION
    ,STUDENTTEST.ADMIN_DATE as [ELA Admin Date]
	,Enroll.SCHOOL_CODE AS [School Code]
	,Enroll.GRADE as [Grade]
	,cast(datepart(year, studenttest.admin_date) as int) -1 as [School Year]
	,test.TEST_NAME_CODE as [Score Group Code]
	,case
		when test_group = '10' 
			then 'Graduation Test'
		when test_group = '20'
			then 'HS SBA'
		when test_group = '50'
			then 'Alternative Lang Assessment'
		when test_group = '60'
			then 'Assessment'
		when test_group = '70'
			then 'CTE Certification Exam'
		when test_group = '80'
			then 'CTE Assessment'
		when test_group = '90'
			then 'Alternative Demonstration of Competency'
	end as [Score Group Name]

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
	and test_name = 'PARCC HS ELA/L English 9'
	and SCORE_DESCRIPTION = 'Raw'
	and cast(datepart(year, STUDENTTEST.ADMIN_DATE) as int) -1 = 2015
	and PART_DESCRIPTION = 'ELA/L English 9'
)
,English10CTE
AS
(
SELECT 
    ROW_NUMBER () OVER (PARTITION BY SIS_NUMBER ORDER BY TEST_SCORE DESC) AS RN
	,CAST (SIS_NUMBER AS INT) AS [Student APS ID]
    ,TEST.TEST_NAME as [Test Name]
    ,STU_PART.PERFORMANCE_LEVEL AS [PARCC ELA Proficiency Level]
	,part.PART_DESCRIPTION as [ELA]
    ,SCORES.TEST_SCORE as [PARCC ELA Scaled Score]
	,scoretdef.SCORE_DESCRIPTION
    ,STUDENTTEST.ADMIN_DATE as [ELA Admin Date]
	,Enroll.SCHOOL_CODE AS [School Code]
	,Enroll.GRADE as [Grade]
	,cast(datepart(year, studenttest.admin_date) as int) -1 as [School Year]
	,test.TEST_NAME_CODE as [Score Group Code]
	,case
		when test_group = '10' 
			then 'Graduation Test'
		when test_group = '20'
			then 'HS SBA'
		when test_group = '50'
			then 'Alternative Lang Assessment'
		when test_group = '60'
			then 'Assessment'
		when test_group = '70'
			then 'CTE Certification Exam'
		when test_group = '80'
			then 'CTE Assessment'
		when test_group = '90'
			then 'Alternative Demonstration of Competency'
	end as [Score Group Name]

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
	and test_name = 'PARCC HS ELA/L English 10'
	and SCORE_DESCRIPTION = 'Raw'
	and cast(datepart(year, STUDENTTEST.ADMIN_DATE) as int) -1 = 2015
	and PART_DESCRIPTION = 'ELA/L English 10'
)
,English11CTE
AS
(
SELECT 
    ROW_NUMBER () OVER (PARTITION BY SIS_NUMBER ORDER BY TEST_SCORE DESC) AS RN
    ,CAST (SIS_NUMBER AS INT) AS [Student APS ID]
    ,TEST.TEST_NAME as [Test Name]
    ,STU_PART.PERFORMANCE_LEVEL AS [PARCC ELA Proficiency Level]
	,part.PART_DESCRIPTION as [ELA]
    ,SCORES.TEST_SCORE as [PARCC ELA Scaled Score]
	,scoretdef.SCORE_DESCRIPTION
    ,STUDENTTEST.ADMIN_DATE as [ELA Admin Date]
	,Enroll.SCHOOL_CODE AS [School Code]
	,Enroll.GRADE as [Grade]
	,cast(datepart(year, studenttest.admin_date) as int) -1 as [School Year]
	,test.TEST_NAME_CODE as [Score Group Code]
	,case
		when test_group = '10' 
			then 'Graduation Test'
		when test_group = '20'
			then 'HS SBA'
		when test_group = '50'
			then 'Alternative Lang Assessment'
		when test_group = '60'
			then 'Assessment'
		when test_group = '70'
			then 'CTE Certification Exam'
		when test_group = '80'
			then 'CTE Assessment'
		when test_group = '90'
			then 'Alternative Demonstration of Competency'
	end as [Score Group Name]

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
	and test_name = 'PARCC HS ELA/L English 11'
	and SCORE_DESCRIPTION = 'Raw'
	and cast(datepart(year, STUDENTTEST.ADMIN_DATE) as int) -1 = 2015
	and PART_DESCRIPTION = 'ELA/L English 11'
)

,ELAReading11
AS
(
SELECT 
    ROW_NUMBER () OVER (PARTITION BY SIS_NUMBER ORDER BY TEST_SCORE DESC) AS RN
	,CAST (SIS_NUMBER AS INT) AS [Student APS ID]
    ,TEST.TEST_NAME as [Test Name]
    ,STU_PART.PERFORMANCE_LEVEL AS [PARCC ELA Proficiency Level]
	,part.PART_DESCRIPTION as [ELA]
    ,SCORES.TEST_SCORE as [PARCC ELA Scaled Score]
	,scoretdef.SCORE_DESCRIPTION
    ,STUDENTTEST.ADMIN_DATE as [ELA Admin Date]
	,Enroll.SCHOOL_CODE AS [School Code]
	,Enroll.GRADE as [Grade]
	,cast(datepart(year, studenttest.admin_date) as int) -1 as [School Year]
	,test.TEST_NAME_CODE as [Score Group Code]
	,case
		when test_group = '10' 
			then 'Graduation Test'
		when test_group = '20'
			then 'HS SBA'
		when test_group = '50'
			then 'Alternative Lang Assessment'
		when test_group = '60'
			then 'Assessment'
		when test_group = '70'
			then 'CTE Certification Exam'
		when test_group = '80'
			then 'CTE Assessment'
		when test_group = '90'
			then 'Alternative Demonstration of Competency'
	end as [Score Group Name]

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
	and test_name = 'PARCC ELA 11 Reading Subscore'
	and SCORE_DESCRIPTION = 'Raw'
	and cast(datepart(year, STUDENTTEST.ADMIN_DATE) as int) -1 = 2015
	and PART_DESCRIPTION = 'Parcc ELA 11 Reading Subtest'
)
,ELAWriting11
AS
(
SELECT 
    ROW_NUMBER () OVER (PARTITION BY SIS_NUMBER ORDER BY TEST_SCORE DESC) AS RN
	,CAST (SIS_NUMBER AS INT) AS [Student APS ID]
    ,TEST.TEST_NAME as [Test Name]
    ,STU_PART.PERFORMANCE_LEVEL AS [PARCC ELA Proficiency Level]
	,part.PART_DESCRIPTION as [ELA]
    ,SCORES.TEST_SCORE as [PARCC ELA Scaled Score]
	,scoretdef.SCORE_DESCRIPTION
    ,STUDENTTEST.ADMIN_DATE as [ELA Admin Date]
	,Enroll.SCHOOL_CODE AS [School Code]
	,Enroll.GRADE as [Grade]
	,cast(datepart(year, studenttest.admin_date) as int) -1 as [School Year]
	,test.TEST_NAME_CODE as [Score Group Code]
	,case
		when test_group = '10' 
			then 'Graduation Test'
		when test_group = '20'
			then 'HS SBA'
		when test_group = '50'
			then 'Alternative Lang Assessment'
		when test_group = '60'
			then 'Assessment'
		when test_group = '70'
			then 'CTE Certification Exam'
		when test_group = '80'
			then 'CTE Assessment'
		when test_group = '90'
			then 'Alternative Demonstration of Competency'
	end as [Score Group Name]

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
	and test_name = 'PARCC ELA 11 Writing Subscore'
	and SCORE_DESCRIPTION = 'Raw'
	and cast(datepart(year, STUDENTTEST.ADMIN_DATE) as int) -1 = 2015
	and PART_DESCRIPTION = 'Parcc ELA 11 Writing Subtest'
)


,Algebra1CTE
AS
(
SELECT 
    ROW_NUMBER () OVER (PARTITION BY SIS_NUMBER ORDER BY TEST_SCORE DESC) AS RN
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
	,test.TEST_NAME_CODE as [Score Group Code]
	,case
		when test_group = '10' 
			then 'Graduation Test'
		when test_group = '20'
			then 'HS SBA'
		when test_group = '50'
			then 'Alternative Lang Assessment'
		when test_group = '60'
			then 'Assessment'
		when test_group = '70'
			then 'CTE Certification Exam'
		when test_group = '80'
			then 'CTE Assessment'
		when test_group = '90'
			then 'Alternative Demonstration of Competency'
	end as [Score Group Name]

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
    AND TEST_NAME = 'PARCC HS Algebra 1'
	and SCORE_DESCRIPTION = 'Raw'
	and cast(datepart(year, STUDENTTEST.ADMIN_DATE) as int) -1 = 2015
	and PART_DESCRIPTION = 'Algebra 1'
)
,AlgebraIICTE
AS
(
SELECT 
    ROW_NUMBER () OVER (PARTITION BY SIS_NUMBER ORDER BY TEST_SCORE DESC) AS RN
    ,CAST (SIS_NUMBER AS INT) AS [Student APS ID]
    ,TEST.TEST_NAME as [Test Name]
    ,STU_PART.PERFORMANCE_LEVEL AS [PARCC Math Proficiency Level]
	,part.PART_DESCRIPTION as [Math]
    ,SCORES.TEST_SCORE as [PARCC Math Scaled Score]
	,scoretdef.SCORE_DESCRIPTION
    ,STUDENTTEST.ADMIN_DATE as [Math Admin Date]
	,Enroll.SCHOOL_CODE AS [School Code]
	,Enroll.GRADE as [Grade]
	,cast(datepart(year, studenttest.admin_date) as int) -1 as [School Year]
	,test.TEST_NAME_CODE as [Score Group Code]
	,case
		when test_group = '10' 
			then 'Graduation Test'
		when test_group = '20'
			then 'HS SBA'
		when test_group = '50'
			then 'Alternative Lang Assessment'
		when test_group = '60'
			then 'Assessment'
		when test_group = '70'
			then 'CTE Certification Exam'
		when test_group = '80'
			then 'CTE Assessment'
		when test_group = '90'
			then 'Alternative Demonstration of Competency'
	end as [Score Group Name]

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
    AND TEST_NAME = 'PARCC HS Algebra II'
	and SCORE_DESCRIPTION = 'Raw'
	and cast(datepart(year, STUDENTTEST.ADMIN_DATE) as int) -1 = 2015
	and PART_DESCRIPTION = 'PARCC HS Algebra II'
)
,GeometryCTE
AS
(
SELECT 
    ROW_NUMBER () OVER (PARTITION BY SIS_NUMBER ORDER BY TEST_SCORE DESC) AS RN
    ,CAST (SIS_NUMBER AS INT) AS [Student APS ID]
    ,TEST.TEST_NAME as [Test Name]
    ,STU_PART.PERFORMANCE_LEVEL AS [PARCC Math Proficiency Level]
	,part.PART_DESCRIPTION as [Math]
    ,SCORES.TEST_SCORE as [PARCC Math Scaled Score]
	,scoretdef.SCORE_DESCRIPTION
    ,STUDENTTEST.ADMIN_DATE as [Math Admin Date]
	,Enroll.SCHOOL_CODE AS [School Code]
	,Enroll.GRADE as [Grade]
	,cast(datepart(year, studenttest.admin_date) as int) -1 as [School Year]
	,test.TEST_NAME_CODE as [Score Group Code]
	,case
		when test_group = '10' 
			then 'Graduation Test'
		when test_group = '20'
			then 'HS SBA'
		when test_group = '50'
			then 'Alternative Lang Assessment'
		when test_group = '60'
			then 'Assessment'
		when test_group = '70'
			then 'CTE Certification Exam'
		when test_group = '80'
			then 'CTE Assessment'
		when test_group = '90'
			then 'Alternative Demonstration of Competency'
	end as [Score Group Name]

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
    AND TEST_NAME = 'PARCC HS Geometry'
	and SCORE_DESCRIPTION = 'Raw'
	and cast(datepart(year, STUDENTTEST.ADMIN_DATE) as int) -1 = 2015
	and PART_DESCRIPTION = 'PARCC HS Geometry'
)
--select * from GeometryCTE
,ResultsCTE
as
	(
		select
			 E9.[School Year] as [School Year], 
			 S.SIS_NUMBER as [Student APS ID],			 
			 s.[STATE_STUDENT_NUMBER] as [State Student ID],
			 E9.[PARCC ELA Proficiency Level] as [English 9 Proficiency Level],
			 E9.[PARCC ELA Scaled Score] as [English 9 Scaled Score],
			 e9.[Score Group Code] as [English 9 Score Group Code],
			 e9.[Score Group Name] as [English 9 Score Group Name],
			 e10.[PARCC ELA Proficiency Level] as [English 10 Proficiency Level],
			 E10.[PARCC ELA Scaled Score] as [English 10 Scaled Score],
			 e10.[Score Group Code] as [English 10 Score Group Code],
			 e10.[Score Group Name] as [English 10 Score Group Name],
			 e11.[PARCC ELA Proficiency Level] as [English 11 Proficiency Level],
			 e11.[PARCC ELA Scaled Score] as [English 11 Scaled Score],
			 e11.[Score Group Code] as [English 11 Score Group Code],
			 e11.[Score Group Name] as [English 11 Score Group Name],
			 e11r.[PARCC ELA Proficiency Level] as [English 11 Reading Subtest Proficiency Level],
			 e11r.[PARCC ELA Scaled Score] as [English 11 Reading Subtest Scaled Score],
			 e11r.[Score Group Code] as [English 11 Reading Score Group Code],
			 e11r.[Score Group Name] as [English 11 Reading Score Group Name],
			 e11w.[PARCC ELA Proficiency Level] as [English 11 Writing Subtest Proficiency Level],
			 e11w.[PARCC ELA Scaled Score] as [English 11 Writing Subtest Scaled Score],
			 e11w.[Score Group Code] as [English 11 Writing Score Group Code],
			 e11w.[Score Group Name] as [English 11 Writing Score Group Name],
			 a1.[PARCC Math Proficiency Level] as [Algebra I Proficiency Level],
			 a1.[PARCC Math Scaled Score] as [Algebra I Scaled Score],
			 a1.[Score Group Code] as [Algebra I Score Group Code],
			 a1.[Score Group Name] as [Algebra I Score Group Name],
			 a2.[PARCC Math Proficiency Level] as [Algebra II Proficiency Level],
			 a2.[PARCC Math Scaled Score] as [Algebra II Scaled Score],
			 a2.[Score Group Code] as [Algebra II Score Group Code],
			 a2.[Score Group Name] as [Algebra II Score Group Name],
			 g.[PARCC Math Proficiency Level] as [Geometry Proficiency Level],
			 g.[PARCC Math Scaled Score] as [Geometry Scaled Score],
			 g.[Score Group Code] as [Geometry Score Group Code],
			 g.[Score Group Name] as [Geometry Score Group Name]

 
			 --ROWNUM, FIRSTNAME, LASTNAME, SISNUMBER, TESTNAME,  PERFLEVEL, TESTSCORE, ADMINDATE           
		FROM
			StudentCTE S
		left outer join
			English9CTE E9
		on
			E9.[Student APS ID] = s.SIS_NUMBER
		left outer join
			English10CTE E10
		on
			e10.[Student APS ID] = s.SIS_NUMBER
		left outer join
			English11CTE E11
		on
			e11.[Student APS ID] = s.SIS_NUMBER
		left outer join
			ELAReading11 E11R 
		on
			E11R.[Student APS ID] = s.SIS_NUMBER
		left outer join
			ELAWriting11 E11W 
		on
			E11W.[Student APS ID] = s.SIS_NUMBER

		left outer join
			Algebra1CTE A1
		on
			a1.[Student APS ID] = s.SIS_NUMBER
		left outer join
			AlgebraIICTE A2
		on
			A2.[Student APS ID] = s.SIS_NUMBER
		left outer join
			GeometryCTE G
		ON
			g.[Student APS ID] = s.SIS_NUMBER
)

select
	*
from
	ResultsCTE
order by
	[Student APS ID]
	

REVERT
GO