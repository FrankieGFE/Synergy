
SELECT *

FROM 
	
(
select
	 ROW_NUMBER() OVER (PARTITION BY STU.SIS_NUMBER, SED.SCHOOL_YEAR ORDER BY SED.ENTER_DATE DESC, SED.EXCLUDE_ADA_ADM) AS RN,
	 SED.SCHOOL_YEAR as [School Year],
	 STU.SIS_NUMBER as [Student APS ID],
	 SED.SCHOOL_CODE as [School Location Number],
	 SED.SCHOOL_NAME as [School Name],
	 SED.GRADE as [Student Grade Level],
	 convert(varchar,STU.BIRTH_DATE,110) as [Birth Date],
	 STU.RESOLVED_RACE as [Resolved Race],
	 STU.GENDER as [Gender],
	 STU.LUNCH_STATUS as [FRPL Status],
	 STU.ELL_STATUS as [ELL Status],
	 --SED.EXCLUDE_ADA_ADM,
	 --SED.CONCURRENT,
	 

	 --CHECK FOR GIFTED
	 CASE WHEN STU.PRIMARY_DISABILITY_CODE != 'GI' AND STU.PRIMARY_DISABILITY_CODE IS NOT NULL THEN 'Y' ELSE 'N' END AS [SPED Status]

from
	 aps.BasicStudentWithMoreInfo STU 

	 inner join aps.StudentEnrollmentDetails SED on STU.STUDENT_GU = SED.STUDENT_GU

--change for school year
WHERE SED.SCHOOL_YEAR = '2016'
		--R is for regular school year S is for summer school
		AND SED.EXTENSION = 'R'
		AND SED.GRADE IN ('P1', 'P2', 'PK', 'K', '01', '02', '03', '04', '05', '06', '07', '08')
		AND EXCLUDE_ADA_ADM is null
		--EXCLUDE CONCURRENT ENROLLMENTS
		AND CONCURRENT = ''

) AS t1
WHERE
	 RN = 1 

ORDER BY [Student Grade Level], [Student APS ID]

		



