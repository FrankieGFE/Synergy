/*
Pull data for Brenda Martinez Papponi
Council of the Great City Schools CGCS
ELL Data Request
*/

declare @AsofDate datetime2 = '2015-10-01'
declare @SchoolYear nvarchar(4) = '2015'

--pull Proficiency of ELLs by Grade Band for a specific year
-- Tables 2.1, 2.2, 2.3

;WITH PERF1
AS
(
SELECT 
       SY = '2015-2016',
       --[STUDENT ID] AS [STATE_ID],
          --[Field13] AS [SIS NUMBER],
       [CURRENT GRADE LEVEL] AS [GRADE],
       COUNT([CURRENT GRADE LEVEL]) AS [COUNT],
       latest.PERFORMANCE_LEVEL,
       LU.VALUE_DESCRIPTION AS [DESCRIPTION],
	   [ENGLISH PROFICIENCY] AS ell
       --SIS_NUMBER
FROM 
      (
         SELECT * FROM 
          [RDAVM.APS.EDU.ACTD].db_STARS_History.dbo.STUD_SNAPSHOT S
          WHERE 
          [DISTRICT CODE] = '001'
              AND [PERIOD] = '2014-10-01'
			  AND [ENGLISH PROFICIENCY] = '1'
			  AND [CURRENT GRADE LEVEL] IN ('KF', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12')
              ) AS S
inner HASH join
       aps.BasicStudent B 
ON
       s.[ALTERNATE STUDENT ID] = B.SIS_NUMBER

INNER HASH JOIN
APS.LCELatestEvaluationAsOf('2015-10-01') AS LATEST
ON
       LATEST.STUDENT_GU = B.STUDENT_GU
INNER JOIN 
APS.LookupTable('K12.TestInfo','PERFORMANCE_LEVELS') AS LU
ON
LATEST.PERFORMANCE_LEVEL = LU.VALUE_CODE
group by
	 s.[CURRENT GRADE LEVEL], LU.VALUE_DESCRIPTION, PERFORMANCE_LEVEL, [ENGLISH PROFICIENCY]
)
--SELECT * FROM PERF1

, PERF2
AS
(
	SELECT
		SY,
		GRADE,
		[COUNT],
		CASE
			WHEN PERFORMANCE_LEVEL IN ('ENTER', 'NEP', 'BEG', 'ELL') THEN 1 
			WHEN PERFORMANCE_LEVEL IN ('EMERG', 'EARLI') THEN 2 
			WHEN PERFORMANCE_LEVEL IN ('DEVEL', 'LEP', 'IMM') THEN 3
			WHEN PERFORMANCE_LEVEL IN ('EXPAN', 'EARLA') THEN 4
			WHEN PERFORMANCE_LEVEL IN ('BRIDG', 'ADV') THEN 5
			WHEN PERFORMANCE_LEVEL IN ('REACH', 'C-PRO', 'FEP', 'INITIAL FEP') THEN 6

		END AS PERFORMANCE_LEVEL
	FROM
		PERF1
)
	SELECT * FROM PERF2
	PIVOT
	(
		MAX([COUNT])
		FOR PERFORMANCE_LEVEL IN ([1], [2], [3], [4], [5], [6])
	)
		 AS PIVTBL


--****************************************************************
--pull count of ELLS greater than six years for 2013, 2014, 2015
--Table 1.5
SELECT 
        SIS_NUMBER, ADMIN_DATE, TEST_NAME, PERFORMANCE_LEVEL,EVER_ELL,STATE_STUDENT_NUMBER
       ,T16 + T15 + T14 + T13 + T12 + T11 + T10 + T09 + T08 + T07 + T06 + T05 + T04 + T03 + T02 AS TOTAL

FROM(
SELECT 
       SIS_NUMBER, ADMIN_DATE, TEST_NAME, PERFORMANCE_LEVEL,EVER_ELL,STATE_STUDENT_NUMBER
       ,CASE WHEN LEFT(CAST(ADMIN_DATE AS DATE),4) > 2016 THEN 0 ELSE [2016] END AS T16
       ,CASE WHEN LEFT(CAST(ADMIN_DATE AS DATE),4) > 2015 THEN 0 ELSE [2015]  END AS T15
       ,CASE WHEN LEFT(CAST(ADMIN_DATE AS DATE),4)> 2014 THEN 0 ELSE [2014]  END AS T14
       ,CASE WHEN LEFT(CAST(ADMIN_DATE AS DATE),4)> 2013 THEN 0 ELSE [2013]  END AS T13
       ,CASE WHEN LEFT(CAST(ADMIN_DATE AS DATE),4)> 2012 THEN 0 ELSE [2012]  END AS T12
       ,CASE WHEN LEFT(CAST(ADMIN_DATE AS DATE),4)> 2011 THEN 0 ELSE [2011]  END AS T11
       ,CASE WHEN LEFT(CAST(ADMIN_DATE AS DATE),4)> 2010 THEN 0 ELSE [2010]  END AS T10
       ,CASE WHEN LEFT(CAST(ADMIN_DATE AS DATE),4)> 2009 THEN 0 ELSE [2009] END AS T09
       ,CASE WHEN LEFT(CAST(ADMIN_DATE AS DATE),4)> 2008 THEN 0 ELSE [2008]  END AS T08
       ,CASE WHEN LEFT(CAST(ADMIN_DATE AS DATE),4)> 2007 THEN 0 ELSE [2007]  END AS T07
       ,CASE WHEN LEFT(CAST(ADMIN_DATE AS DATE),4)> 2006 THEN 0 ELSE [2006]  END AS T06
       ,CASE WHEN LEFT(CAST(ADMIN_DATE AS DATE),4)> 2005 THEN 0 ELSE [2005] END AS T05
       ,CASE WHEN LEFT(CAST(ADMIN_DATE AS DATE),4)> 2004 THEN 0 ELSE [2004]  END AS T04
       ,CASE WHEN LEFT(CAST(ADMIN_DATE AS DATE),4)> 2003 THEN 0 ELSE [2003]  END AS T03
       ,CASE WHEN LEFT(CAST(ADMIN_DATE AS DATE),4)> 2002 THEN 0 ELSE [2002]  END AS T02

FROM 

(

SELECT 
       STU.SIS_NUMBER, TEST.ADMIN_DATE, TEST_NAME, PERFORMANCE_LEVEL, IS_ELL, STU.STATE_STUDENT_NUMBER
       ,CASE WHEN ELL.STUDENT_GU IS NOT NULL THEN 'Y' ELSE 'N' END AS EVER_ELL
       ,CASE WHEN [2016].STUDENT_GU IS NOT NULL AND IS_ELL = 0 THEN 1 ELSE 0 END AS [2016]
              ,CASE  WHEN [2015].STUDENT_GU IS NOT NULL AND IS_ELL = 0 THEN 1 ELSE 0 END AS [2015]
              ,CASE  WHEN [2014].STUDENT_GU IS NOT NULL AND IS_ELL = 0 THEN 1 ELSE 0 END AS [2014]
              ,CASE WHEN [2013].STUDENT_GU IS NOT NULL AND IS_ELL = 0 THEN 1 ELSE 0 END AS [2013]
              ,CASE  WHEN [2012].STUDENT_GU IS NOT NULL AND IS_ELL = 0 THEN 1 ELSE 0 END AS [2012]
              ,CASE  WHEN [2011].STUDENT_GU IS NOT NULL AND IS_ELL = 0 THEN 1 ELSE 0 END AS [2011]
              ,CASE WHEN [2010].STUDENT_GU IS NOT NULL AND IS_ELL = 0 THEN 1 ELSE 0 END AS [2010]
              ,CASE  WHEN [2009].STUDENT_GU IS NOT NULL AND IS_ELL = 0 THEN 1 ELSE 0 END AS [2009]
              ,CASE  WHEN [2008].STUDENT_GU IS NOT NULL AND IS_ELL = 0 THEN 1 ELSE 0 END AS [2008]
              ,CASE WHEN [2007].STUDENT_GU IS NOT NULL AND IS_ELL = 0 THEN 1 ELSE 0 END AS [2007]
              ,CASE  WHEN [2006].STUDENT_GU IS NOT NULL AND IS_ELL = 0 THEN 1 ELSE 0 END AS [2006]
              ,CASE  WHEN [2005].STUDENT_GU IS NOT NULL AND IS_ELL = 0 THEN 1 ELSE 0 END AS [2005]
              ,CASE WHEN [2004].STUDENT_GU IS NOT NULL AND IS_ELL = 0 THEN 1 ELSE 0 END AS [2004]
              ,CASE  WHEN [2003].STUDENT_GU IS NOT NULL AND IS_ELL = 0 THEN 1 ELSE 0 END AS [2003]
              ,CASE  WHEN [2002].STUDENT_GU IS NOT NULL AND IS_ELL = 0 THEN 1 ELSE 0 END AS [2002]


FROM 
APS.PrimaryEnrollmentsAsOf('2015-10-01') AS PRIM
LEFT JOIN 
APS.LCEEverELLStudentAsOf('2015-10-01') AS ELL
ON
PRIM.STUDENT_GU = ELL.STUDENT_GU
INNER JOIN
APS.LCELatestEvaluationAsOf('2015-10-01') AS TEST
ON
TEST.STUDENT_GU = PRIM.STUDENT_GU
INNER JOIN
rev.EPC_STU AS STU
ON
PRIM.STUDENT_GU = STU.STUDENT_GU
/*
2002   3D95815E-93DB-4E7A-9741-4252AB7D1DAA
2003   A1A45208-69FC-4E58-99B3-7501E9108D70
2004   F4F41066-7955-45DF-AD43-24A1462BFDAD
2005   BE3706A7-1239-4DAE-A038-F9A949DAA041
2006   CC1DCB76-576C-4414-B4BA-323A26EC8EBE
2007   48ADBFD4-1987-4E7C-9C22-6FD91E8FE424
2008   94A5BA26-69AD-4ADB-80E0-7FEDB7E686C9
2009   E5D120A6-6A1C-4C42-B1F0-4ADB36DE27EF
2010   87F1A309-F058-43E4-B55B-EF9AE4602639
2011   3732B795-5856-430E-996D-B75E6475EC32
2012   9864A8F3-6130-4F95-86D6-860A517D38D1
2013   1E61EA89-3410-49F8-909B-1B749957EDDA
2014   26F066A3-ABFC-4EDB-B397-43412EDABC8B
2015   BCFE2270-A461-4260-BA2B-0087CB8EC26A
2016   F7D112F7-354D-4630-A4BC-65F586BA42EC
*/
LEFT JOIN 
APS.LatestPrimaryEnrollmentInYear('F7D112F7-354D-4630-A4BC-65F586BA42EC') AS [2016]
ON
PRIM.STUDENT_GU = [2016].STUDENT_GU

LEFT JOIN 
APS.LatestPrimaryEnrollmentInYear('BCFE2270-A461-4260-BA2B-0087CB8EC26A') AS [2015]
ON
PRIM.STUDENT_GU = [2015].STUDENT_GU

LEFT JOIN 
APS.LatestPrimaryEnrollmentInYear('26F066A3-ABFC-4EDB-B397-43412EDABC8B') AS [2014]
ON
PRIM.STUDENT_GU = [2014].STUDENT_GU

LEFT JOIN 
APS.LatestPrimaryEnrollmentInYear('1E61EA89-3410-49F8-909B-1B749957EDDA') AS [2013]
ON
PRIM.STUDENT_GU = [2013].STUDENT_GU

LEFT JOIN 
APS.LatestPrimaryEnrollmentInYear('9864A8F3-6130-4F95-86D6-860A517D38D1') AS [2012]
ON
PRIM.STUDENT_GU = [2012].STUDENT_GU

LEFT JOIN 
APS.LatestPrimaryEnrollmentInYear('3732B795-5856-430E-996D-B75E6475EC32') AS [2011]
ON
PRIM.STUDENT_GU = [2011].STUDENT_GU

LEFT JOIN 
APS.LatestPrimaryEnrollmentInYear('87F1A309-F058-43E4-B55B-EF9AE4602639') AS [2010]
ON
PRIM.STUDENT_GU = [2010].STUDENT_GU

LEFT JOIN 
APS.LatestPrimaryEnrollmentInYear('E5D120A6-6A1C-4C42-B1F0-4ADB36DE27EF') AS [2009]
ON
PRIM.STUDENT_GU = [2009].STUDENT_GU

LEFT JOIN 
APS.LatestPrimaryEnrollmentInYear('94A5BA26-69AD-4ADB-80E0-7FEDB7E686C9') AS [2008]
ON
PRIM.STUDENT_GU = [2008].STUDENT_GU

LEFT JOIN 
APS.LatestPrimaryEnrollmentInYear('48ADBFD4-1987-4E7C-9C22-6FD91E8FE424') AS [2007]
ON
PRIM.STUDENT_GU = [2007].STUDENT_GU

LEFT JOIN 
APS.LatestPrimaryEnrollmentInYear('CC1DCB76-576C-4414-B4BA-323A26EC8EBE') AS [2006]
ON
PRIM.STUDENT_GU = [2006].STUDENT_GU

LEFT JOIN 
APS.LatestPrimaryEnrollmentInYear('BE3706A7-1239-4DAE-A038-F9A949DAA041') AS [2005]
ON
PRIM.STUDENT_GU = [2005].STUDENT_GU

LEFT JOIN 
APS.LatestPrimaryEnrollmentInYear('F4F41066-7955-45DF-AD43-24A1462BFDAD') AS [2004]
ON
PRIM.STUDENT_GU = [2004].STUDENT_GU

LEFT JOIN 
APS.LatestPrimaryEnrollmentInYear('A1A45208-69FC-4E58-99B3-7501E9108D70') AS [2003]
ON
PRIM.STUDENT_GU = [2003].STUDENT_GU

LEFT JOIN 
APS.LatestPrimaryEnrollmentInYear('3D95815E-93DB-4E7A-9741-4252AB7D1DAA') AS [2002]
ON
PRIM.STUDENT_GU = [2002].STUDENT_GU



--TEST_NAME NOT IN ('SCREENER', 'WAPT', 'PRE-LAS')
--AND STU.SIS_NUMBER = 970105607

) AS T1

)AS T2

WHERE T16 + T15 + T14 + T13 + T12 + T11 + T10 + T09 + T08 + T07 + T06 + T05 + T04 + T03 + T02 
>= 6 




--*****************************************************************

--enrollments Table 1.4
/*
this is from RDAVM and pulls special ed/Ell (who are special ed) students with IEPs
*/	
	select
	S.[SY] AS [School Year], 
	[CURRENT GRADE LEVEL] as [Grade],
	COUNT([CURRENT GRADE LEVEL]) as [SPED]
FROM 
	[RDAVM.APS.EDU.ACTD].db_STARS_History.dbo.SPECIAL_ED_SNAP S
inner join
	[RDAVM.APS.EDU.ACTD].db_STARS_History.dbo.STUD_SNAPSHOT  ST
on
	S.[DISTRICT CODE] = ST.[DISTRICT CODE]
AND
	S.[STUDENT ID] = ST.[STUDENT ID]
AND
	S.[PERIOD] = ST.[PERIOD]
WHERE
	S.[DISTRICT CODE] = '001'
and 
	[CURRENT GRADE LEVEL] is not null
AND 
	S.[PERIOD] = '2014-10-01'
and
	[CURRENT GRADE LEVEL]  in ('KN', 'KF', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12')
and
	[ENGLISH PROFICIENCY] = 1
group by
	[CURRENT GRADE LEVEL],	S.SY
order by
	Grade
--******************************************************************************

--enrollments of SPED students Table 1.3 ALL SPECIAL ED STUDENTS BY GRADE

	select
	S.[SY] AS [School Year], 
	Field9 as [Grade],
	COUNT([FIELD9]) as [Count]	
FROM 
	[RDAVM.APS.EDU.ACTD].db_STARS_History.dbo.SPECIAL_ED_SNAP S
inner join
	[RDAVM.APS.EDU.ACTD].db_STARS_History.dbo.STUD_SNAPSHOT  ST
on
	s.[DISTRICT CODE] = ST.[DISTRICT CODE]
AND
	S.[STUDENT ID] = ST.[STUDENT ID]
AND
	S.[PERIOD] = ST.[PERIOD]
WHERE
	S.[DISTRICT CODE] = '001'
and 
	Field9 is not null
AND 
	S.[PERIOD] = '2014-10-01'
and
	Field9 in ('K','KN', 'KF','01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12')
group by
	Field9,	S.SY
order by
	Grade

--*********************************************************
--ELL enrollments RDAVM Table 1.2
SELECT
	[SY] AS [School Year], 
	[Current Grade Level],
	COUNT([Current Grade Level]) as [Count]	

FROM 
	[RDAVM.APS.EDU.ACTD].db_STARS_History.dbo.STUD_SNAPSHOT 
WHERE
	[DISTRICT CODE] = '001'
and 
	[English Proficiency] = 1
AND 
	[PERIOD] = '2014-10-01'
and
	[Current Grade Level] in ('KN', 'KF', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12')
group by
		[CURRENT GRADE LEVEL], SY
order by
	[Current Grade Level]

--***********************************************************
--total student enrollments from RDAVM Table 1.1

SELECT
	[SY] AS [School Year], 
	[Current Grade Level],
	COUNT([Current Grade Level]) as [Count]	
FROM 
	[RDAVM.APS.EDU.ACTD].db_STARS_History.dbo.STUD_SNAPSHOT 
WHERE
	[DISTRICT CODE] = '001'
and 
	[Current Grade Level] is not null
AND 
	[PERIOD] = '2014-10-01'
and
	[Current Grade Level]  in ('Kn', 'KF', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12')
group by
	[Current Grade Level],	SY
order by
	[Current Grade Level]

