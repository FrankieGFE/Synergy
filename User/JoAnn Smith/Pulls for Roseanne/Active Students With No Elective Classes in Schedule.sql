/************************************************************************
* $Revison: 1
* $Last Changed By:   JoAnn Smith
* $Last Changed Date: 1/9/2017
**************************************************************************
Pull students who have no elective classes in their schedules,
Grades 6 and above
**************************************************************************/

with StudentEnrollmentCTE(SIS_Number, FirstName, LastName, OrganizationName, ElectiveCount, Grade)

as
( 
	select
		  SAO.SIS_NUMBER, bsc.FIRST_NAME, bsc.LAST_NAME, sao.ORGANIZATION_NAME,  count(sao.department) as ELECTIVE_COUNT,
		 case
			when ENROLLMENT_GRADE_LEVEL = '160' then '06'
			when ENROLLMENT_GRADE_LEVEL = '170' then '07'
			when ENROLLMENT_GRADE_LEVEL = '180' then '08'
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
		 ENROLLMENT_GRADE_LEVEL in ('160', '170', '180','190', '200', '210', '220') and department  = 'Ele'
		 and sao.COURSE_ENTER_DATE >= '2017-01-04'
	group by 
		sao.SIS_NUMBER, bsc.first_name, bsc.last_name, sao.organization_name, ENROLLMENT_GRADE_LEVEL, department
	 
				
)
select
	 * 
from
	 StudentEnrollmentCTE
--where
--	ElectiveCount = 4

order by
		OrganizationName, grade




