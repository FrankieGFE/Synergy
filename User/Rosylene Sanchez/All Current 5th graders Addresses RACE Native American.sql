/* 
* Request by: Andy Gutierrez for Rigo Chavez
*
* Created: March 2016 by 053285
*
* Intial Request: All active 8th graders from 2015-2016 school year (R) who have any of the 5 race indicator = Native American
*
* Include:  student ID, Name, Address, Grade Level, School Code, School Name, RACE
*
* Tables Referenced: 
* Views:  APS.CurrentStudentMailingDetails, APS.StudentEnrolLmentDetails
*/

SELECT	A.sis_number, 
		[FIRST NAME],
		[LAST NAME],
		[MID INIT],
		A.MAIL_ADDRESS,
		CITY,
		Grade, 
		A.SCHOOL_CODE,
		A.SCHOOL_NAME
		--A.RACE

FROM	(
		SELECT	ROW_NUMBER () OVER (PARTITION BY CSMDETAIL.SIS_NUMBER ORDER BY SCHOOL.ENTER_DATE DESC
								) AS RN,
			CSMDETAIL.sis_number, 
			CSMDETAIL.first_name				AS [FIRST NAME], 
			CSMDETAIL.last_name					AS [LAST NAME], 
			Isnull(CSMDETAIL.middle_name, '')	AS [MID INIT],	--SIMPLIER THAN "CASE" 
			SCHOOL.grade AS Grade, 
			CSMDETAIL.MAIL_ADDRESS,
			CSMDETAIL.MAIL_CITY + ',' + CSMDETAIL.MAIL_STATE + '  ' + CSMDETAIL.MAIL_ZIP AS CITY,
			SCHOOL.SCHOOL_CODE,
			SCHOOL.SCHOOL_NAME,

			'Native American' AS RACE
				
		FROM	APS.CurrentStudentMailingDetails	AS CSMDETAIL

				LEFT JOIN APS.studentenrollmentdetails AS SCHOOL 
				ON CSMDETAIL.student_gu = SCHOOL.student_gu

				LEFT JOIN APS.BasicStudentWithMoreInfo AS RACE
				ON CSMDETAIL.sis_number = RACE.SIS_NUMBER

		WHERE	SCHOOL_YEAR = '2015' 
				AND SCHOOL.extension = 'R' 
				AND CSMDETAIL.grade IN ( '05' ) 
				AND SCHOOL.exclude_ada_adm IS NULL
				AND SUMMER_WITHDRAWL_CODE IS NULL

				AND (RACE_1 = 'Native American'
					OR RACE_2 = 'Native American'
					OR RACE_3 = 'Native American'
					OR RACE_4 = 'Native American'
					OR RACE_5 = 'Native American')
		) AS A

WHERE RN ='1'

ORDER BY	A.SCHOOL_NAME
			,A.sis_number