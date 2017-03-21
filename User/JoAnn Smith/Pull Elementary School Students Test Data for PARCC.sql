/*
Written by:  JoAnn Smith
             3-21-2017
Southwest Creations Collaborative Evaluation
Data Request

Pull PARCC data for Elementary School Students
enrolled during 2015-2016 SY
for Wendy Kappy
Uses CTEs for Reading and Math and
then joins them together for the final
results

PARCC tests for elemetary are given in the spring
so need to subtract 1 from admin date
Change the @AsOfDate to the last day of school for that school year
Change the @TestYear to the school year you want

*/

declare @AsOfDate datetime2 = '2016-05-25'
declare @TestYear varchar(4) = '2015'



;with StudentCTE
as
(
select
	ped.SCHOOL_YEAR,
	bs.SIS_NUMBER,
	bs.STATE_STUDENT_NUMBER
	
from
	aps.PrimaryEnrollmentDetailsAsOf(@AsOfDate) PED
inner join
	aps.BasicStudentWithMoreInfo bs
on
	bs.student_gu = ped.student_gu
where
	GRADE in ('P1','K', '01', '02', '03', '04', '05')

)
,ESELA
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
	APS.PrimaryEnrollmentDetailsAsOf(@AsOfDate) AS Enroll
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
	and test_name = 'PARCC ES ELA'
	and SCORE_DESCRIPTION = 'Raw'
	and cast(datepart(year, STUDENTTEST.ADMIN_DATE) as int) -1 = @TestYear
	and PART_DESCRIPTION = 'PARCC ES ELA'
)
,ESMath
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
	APS.PrimaryEnrollmentDetailsAsOf(@AsOfDate) AS Enroll
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
	and test_name = 'PARCC ES Math'
	and SCORE_DESCRIPTION = 'Raw'
	and cast(datepart(year, STUDENTTEST.ADMIN_DATE) as int) -1 = @TestYear
	and PART_DESCRIPTION = 'PARCC ES Math'
)
,ResultsCTE
as
	(
		select
			 s.SCHOOL_YEAR as [School Year],
			 S.SIS_NUMBER as [Student APS ID],			 
			 s.[STATE_STUDENT_NUMBER] as [State Student ID],
			 --ESE.[ELA Admin Date] as [ES ELA Admin Date],
			 --ESE.[PARCC ELA Proficiency Level] as [ES ELA Proficiency Level],
			 ESE.[Score Group Code] as [ES ELA Score Group Code],
			 ESE.[Score Group Name] as [ES ELA Score Group Name],
			 ESE.[PARCC ELA Scaled Score] as [ES ELA Scaled Score],
			 --ESM.[ELA Admin Date] as [ES Math Admin Date],
			 --ESM.[PARCC ELA Proficiency Level] as [ES Math Proficiency Level],
			 ESM.[Score Group Code] as [ES Math Score Group Code],
			 ESM.[Score Group Name] as [ES Math Score Group Name],
			 ESM.[PARCC ELA Scaled Score] as [ES Math Scaled Score]
 
		FROM
			StudentCTE S
		left outer join
			ESELA ESE 
		on
			ESE.[Student APS ID] = s.SIS_NUMBER
		left outer join
			ESMath ESM
		on
			ESM.[Student APS ID] = s.SIS_NUMBER
)
select
	*
from
	ResultsCTE
order by
	[Student APS ID]
	
