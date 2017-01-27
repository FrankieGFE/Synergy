/************************************************************************
* $Revison: 1
* $Last Changed By:   JoAnn Smith
* $Last Changed Date: 1/4/2017
**************************************************************************
Pull students taking English Language Arts (ELA) classes whose grade level
doesn't match the class grade level
**************************************************************************/

with StudentEnrollmentCTE(SIS_Number, FirstName, LastName, OrganizationName, CourseTitle, EnrollmentGradeLevel, Grade)

as
( 
	select
		  SAO.SIS_NUMBER, bsc.FIRST_NAME, bsc.LAST_NAME, sao.organization_name, COURSE_TITLE, ENROLLMENT_GRADE_LEVEL,
		 case
			when ENROLLMENT_GRADE_LEVEL = '190' then '09'
			when ENROLLMENT_GRADE_LEVEL = '200' then '10'
			when ENROLLMENT_GRADE_LEVEL = '210' then '11'
			when ENROLLMENT_GRADE_LEVEL = '220' then '12'
			end as GRADE
	from
		 aps.scheduleasof(getdate()) SAO
	inner join 
		 aps.BasicStudent BSC on SAO.SIS_NUMBER = bsc.SIS_NUMBER
	 where
		 ENROLLMENT_GRADE_LEVEL in ('190', '200', '210', '220') and COURSE_TITLE like 'English%'
		 and sao.COURSE_ENTER_DATE >= '2017-01-04'
		
		
)

	select
		 se.SIS_Number, se.FirstName, se.LastName, se.OrganizationName, SE.CourseTitle,  SE.Grade
	from 
		StudentEnrollmentCTE SE
	where
		substring(CourseTitle,9,2) != SE.Grade
	order by
		se.SIS_Number

		
			
