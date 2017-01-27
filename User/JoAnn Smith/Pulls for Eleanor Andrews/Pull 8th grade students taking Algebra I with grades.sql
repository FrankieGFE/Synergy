/*
 * Revision 1
 * Last Changed By:    JoAnn Smith
 * Last Changed Date:  1/12/17
 ******************************************************
  Assessment is trying to get a handle on our current 8th graders who are taking algebra 1.
  We want to use this to understand what happens after schools administer the Iowa algebra placement test.
  Can we get a data pull from SY 2016-17 for 8th grade students taking Alg1.Columns to include:
  Student name, ID, grade level, school, math class, teacher, first semester Alg 1 course grade, SPED Y or N, ELL Y or N, FRL Y or N.
 ******************************************************
 1-11-2017 Initial query

*/

with Grade_CTE(StudentNumber, GradePeriod, CourseId, CourseTitle, Mark, CourseGroup)
as
(
	
       select
              Gra.SIS_NUMBER, GRA.GRADE_PERIOD, GRA.COURSE_ID, GRA.COURSE_TITLE, GRA.MARK, crsg.[GROUP]
       from
              aps.StudentGrades GRA
                      join rev.epc_crs as crs
                      on crs.COURSE_ID = gra.COURSE_ID

                      join rev.UD_CRS_GROUP as crsg
                      on crs.COURSE_GU = crsg.COURSE_GU

       where 1= 1
               and crsg.[group]  = 'R-9'
			   and gra.GRADE_PERIOD = 'S1'
            --and gra.SIS_NUMBER = 970090968

)
		select distinct
			--row_number() over(Partition by STU.Student_Gu order by sch.organization_name) as Rownum,
			STU.LAST_NAME + ', ' + STU.FIRST_NAME AS [Student Name],
			STU.SIS_NUMBER as [Student Number],
			'08' as Grade,
			sch.ORGANIZATION_NAME as [School Name],
			cte.CourseId as [Course ID],
			cte.CourseTitle as [Course Title],
			sch.[TEACHER NAME] as [Teacher Name],
			cte.mark as [Grade],
			STU.SPED_STATUS as [SPED Status],
			STU.ELL_STATUS as [ELL Status],
			STU.LUNCH_STATUS as [Lunch Status]

	from
		aps.BasicStudentWithMoreInfo STU
		inner join
			Grade_CTE CTE
			on CTE.StudentNumber = stu.SIS_NUMBER
		inner join
			aps.ScheduleDetailsAsOf(getdate())  SCH
			on sch.STUDENT_GU = stu.STUDENT_GU
		where
			cte.CourseId = sch.COURSE_ID
			--and stu.SIS_NUMBER = 970090968
		order by
			[School Name],
			[Student Number]
			

		


		
