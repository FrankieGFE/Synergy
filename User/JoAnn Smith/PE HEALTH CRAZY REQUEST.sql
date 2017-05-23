

/*********************************************************************
FIRST PULL KIDS WITH PE OR HEALTH ON THEIR SCHEDULES---------------

***********************************************************************/
SELECT 
	SCHEDULES.[W SCHOOL NAME] AS [School Name]
	,SCHEDULES.[W FIRST NAME] + ' ' + SCHEDULES.[W LAST NAME] AS [Student Name]
	,SCHEDULES.[W SIS NUMBER] AS [Student ID]
	,SCHEDULES.[W GRADE] AS [Grade Level]
	,SCHEDULES.[W COURSE ID]
	,SCHEDULES.[W COURSE TITLE]
	,SCHEDULES.[W CREDIT]
	,SCHEDULES.SUBJECT_AREA_1 AS [Subject Area]


	,TRANSCRIPTS.[C CREDIT ATTEMPTED] AS [Attempt Credits]
	,TRANSCRIPTS.[C COURSE ID]
	,TRANSCRIPTS.[C COURSE TITLE]
	,TRANSCRIPTS.[C MARK]
	,TRANSCRIPTS.[C CREDIT COMPLETED]

	,[F COURSE ID]
	,[F COURSE TITLE]
	,[F SIS NUMBER]
	


 FROM 

(
SELECT 
       --ROW_NUMBER() OVER(PARTITION BY ENR.STUDENT_GU ORDER BY ENR.STUDENT_GU) AS RN,
       enr.SCHOOL_NAME as [W SCHOOL NAME],
       B.STUDENT_GU AS [W STUDENT GU],
       B.SIS_NUMBER AS [W SIS NUMBER],
       B.LAST_NAME AS [W LAST NAME],
       B.FIRST_NAME AS [W FIRST NAME],
       ENR.GRADE AS [W GRADE],
       BS.COURSE_ID AS [W COURSE ID],
       BS.COURSE_TITLE [W COURSE TITLE],
       .5 AS [W CREDIT]
	   ,SUBJECT_AREA_1
FROM 
       (SELECT * FROM APS.PrimaryEnrollmentDetailsAsOf(GETDATE())
              WHERE grade in ('06', '07', '08'))

AS ENR
INNER JOIN 
APS.SCHEDULEDETAILSASOF(GETDATE()) BS
ON
ENR.STUDENT_GU = BS.STUDENT_GU
INNER JOIN
       REV.UD_CRS UC
ON
       UC.COURSE_GU = BS.COURSE_GU
INNER JOIN
       REV.UD_CRS_GROUP G
on
       BS.COURSE_GU = g.COURSE_GU
INNER JOIN
       APS.BasicStudentWithMoreInfo B
ON
       BS.STUDENT_GU = B.STUDENT_GU
WHERE
       [GROUP] IN ('008','009') --PE
	     -- and B.SIS_NUMBER = 970045594

) AS SCHEDULES


/*********************************************************************
PULL COURSE HISTORY PE AND HEALTH BUCKETS

***********************************************************************/

FULL OUTER JOIN 

(
SELECT 
       enr.SCHOOL_NAME AS [C SCHOOL NAME],
       B.STUDENT_GU AS [C STUDENT GU],
       B.SIS_NUMBER AS [C SIS NUMBER],
       B.LAST_NAME AS [C LAST NAME],
       B.FIRST_NAME AS [C FIRST NAME],
       ENR.GRADE AS [C GRADE],
       h.COURSE_ID AS [C COURSE ID],
       h.COURSE_TITLE AS [C COURSE TITLE],
       h.MARK AS [C MARK],
       h.CREDIT_ATTEMPTED AS [C CREDIT ATTEMPTED],
       h.CREDIT_COMPLETED AS [C CREDIT COMPLETED], 
	   CRS.SUBJECT_AREA_1
FROM 
       (SELECT * FROM APS.PrimaryEnrollmentDetailsAsOf(GETDATE())
              WHERE grade in ('06', '07', '08'))

AS ENR
INNER JOIN 
REV.EPC_STU_CRS_HIS H
ON
ENR.STUDENT_GU = H.STUDENT_GU
INNER JOIN
       REV.UD_CRS UC
ON
       UC.COURSE_GU = h.COURSE_GU
INNER JOIN
       REV.UD_CRS_GROUP G
on
       h.COURSE_GU = g.COURSE_GU
INNER JOIN
       APS.BasicStudentWithMoreInfo B
ON
       h.STUDENT_GU = B.STUDENT_GU
INNER JOIN 
rev.EPC_CRS AS CRS
ON
H.COURSE_GU = CRS.COURSE_GU

WHERE
       [GROUP] IN ('008', '009') --PE
	  -- and SIS_NUMBER = 970045594
) AS TRANSCRIPTS

ON
SCHEDULES.[W STUDENT GU] = TRANSCRIPTS.[C STUDENT GU]
--AND SCHEDULES.[W COURSE ID] = TRANSCRIPTS.[C COURSE ID]

--WHERE
--[W SIS NUMBER] = 970045594


/*********************************************************************
PULL COURSE REQUESTS FOR NEXT SCHOOL YEAR IN PE AND HEALTH BUCKETS

***********************************************************************/

FULL OUTER JOIN 

(
SELECT DISTINCT
       --ROW_NUMBER() over(partition by b.SIS_NUMBER order by b.SIS_NUMBER) as RN,
       Student.STUDENT_GU AS [F STUDENT GU],
       B.SIS_NUMBER AS [F SIS NUMBER],
       b.LAST_NAME AS [F LAST NAME],
       b.FIRST_NAME AS [F FIRST NAME],
       Levels.VALUE_DESCRIPTION as [F GRADE],
       Courses.COURSE_ID as [F COURSE ID],
       Courses.COURSE_TITLE as [F COURSE TITLE],
       .5 as [F CREDIT]
from
    [rev].[EPC_CRS] AS [Courses]

    INNER HASH JOIN
    [rev].[EPC_SCH_YR_CRS] AS [SchoolYearCourse]
    ON
    [Courses].[COURSE_GU]=[SchoolYearCourse].[COURSE_GU]

    INNER HASH JOIN
    [rev].[EPC_STU_SCHD_REQUEST] AS [Requests]
    ON
    [SchoolYearCourse].[SCHOOL_YEAR_COURSE_GU]=[Requests].[SCHOOL_YEAR_COURSE_GU]

    INNER HASH JOIN
    [rev].[EPC_SCH_YR_SCHD_SECT] AS [Sections]
    ON
    [Requests].[SCHOOL_YEAR_COURSE_GU]=[Sections].[SCHOOL_YEAR_COURSE_GU]

    INNER HASH JOIN
    [rev].[EPC_STU_SCH_YR] AS [SSY]
    ON
    [Requests].[STUDENT_SCHOOL_YEAR_GU]=[SSY].[STUDENT_SCHOOL_YEAR_GU]

    INNER HASH JOIN
    [rev].[EPC_STU] AS [Student]
    ON
    [SSY].[STUDENT_GU]=[Student].[STUDENT_GU]

    INNER HASH JOIN
    [rev].[REV_PERSON] AS [StudentPerson]
    ON
    [Student].[STUDENT_GU]=[StudentPerson].[PERSON_GU]

    INNER HASH JOIN
    [rev].[REV_YEAR] AS [Year]
    ON
    [SSY].[YEAR_GU]=[Year].[YEAR_GU]
    LEFT JOIN
    [APS].[LookupTable]('K12','GRADE') AS [Levels]
    ON
    [SSY].[GRADE]=[Levels].[VALUE_CODE]
INNER JOIN
       REV.UD_CRS UC
ON
       UC.COURSE_GU = Courses.COURSE_GU
INNER JOIN
       REV.UD_CRS_GROUP G
on
       Courses.COURSE_GU = g.COURSE_GU
INNER JOIN
       APS.BasicStudentWithMoreInfo B
ON
       Student.STUDENT_GU = B.STUDENT_GU
WHERE
       [GROUP] IN ('009', '008') --HEALTH
and
       Levels.VALUE_DESCRIPTION in ('07', '08')
and
       [Year].[SCHOOL_YEAR]=2017 AND [Year].[EXTENSION]='R'

) AS FUTURE

ON
FUTURE.[F STUDENT GU] = SCHEDULES.[W STUDENT GU]