

/*
* Revision 1
* Last Changed By:    JoAnn Smith
* Last Changed Date:  3/2/2017
******************************************************
  Assessment is trying to get a handle on our current 8th graders
  who are taking a high school math class.
  Columns to include:
  Student name, ID, grade level, school, course, course title, 
  teacher, SPED Y or N, ELL Y or N, FRL Y or N,
  School Year, Gender, Race
******************************************************

*/

;with CourseCTE
as
(
       
SELECT
       COURSE_ID, COURSE_TITLE, [GROUP]
FROM 
       REV.EPC_CRS AS CRS
INNER JOIN 
       REV.UD_CRS_GROUP AS CRSGRP
ON
       CRS.COURSE_GU = CRSGRP.COURSE_GU

WHERE
       [GROUP] LIKE '%ALG%'
       OR [GROUP] LIKE '%GEOM%'
)

,StudentCTE
as
(
       select
			  row_number() over(Partition by STU.Student_Gu order by sch.organization_name) as Rownum,
              STU.LAST_NAME + ', ' + STU.FIRST_NAME AS [Student Name],
              STU.SIS_NUMBER as [Student ID],
              '08' as [Grade Level],
              sch.ORGANIZATION_NAME as [School Name],
              CTE.COURSE_ID as [Course ID],
              CTE.COURSE_TITLE as [Course Title],
              sch.[TEACHER NAME] as [Teacher Name],
			  g.mark as [Grade],
              STU.SPED_STATUS as [SPED Status],
              STU.ELL_STATUS as [ELL Status],
              STU.LUNCH_STATUS as [Lunch Status],
			  sch.SCHOOL_YEAR as [School Year],
              stu.gender AS [Gender],
              stu.RESOLVED_RACE as [Race]
       from
              aps.BasicStudentWithMoreInfo STU
	   INNER JOIN
			  APS.StudentGrades g
		ON
			 G.SIS_NUMBER = STU.SIS_NUMBER	    

       INNER JOIN 
              (SELECT STUDENT_GU, SIS_NUMBER, COURSE_ID, [TEACHER NAME], SCHOOL_YEAR, SECTION_ID, SCH.ORGANIZATION_YEAR_GU, SCH.STAFF_GU
              ,SCH.PERIOD_BEGIN, SCH.PRIMARY_STAFF, SCH.TERM_CODE, SCH.COURSE_GU, SCH.DEPARTMENT, sch.COURSE_TITLE,sch.ORGANIZATION_NAME
              ,sch.ORGANIZATION_GU, sch.ENROLLMENT_GRADE_LEVEL
              FROM
              APS.ScheduleDetailsAsOf(GETDATE()) AS SCH

              INNER HASH JOIN 
              APS.TermDatesAsOf(GETDATE()) AS TRMS
              ON
              SCH.TERM_CODE = TRMS.TermCode
              AND TRMS.OrgYearGU = SCH.ORGANIZATION_YEAR_GU
              AND GETDATE() BETWEEN TRMS.TermBegin AND TRMS.TermEnd
              )  AS SCH 


       on sch.STUDENT_GU = stu.STUDENT_GU
       inner join
              CourseCTE CTE
       on
              CTE.COURSE_ID = SCH.COURSE_ID
       inner join
              rev.epc_sch school
       on
              school.ORGANIZATION_GU = sch.ORGANIZATION_GU
       WHERE
              CTE.COURSE_ID = SCH.COURSE_ID
       AND
              SCH.ENROLLMENT_GRADE_LEVEL = 180
       AND
              SCHOOL.SCHOOL_CODE > '500'
	   and	
			  grade_period = '4th 6 Wk'
)

       select
              *
       from
              StudentCTE s
	   WHERE
			Rownum = 1
    
       ORDER BY
              [School Name],
              [Student ID]
