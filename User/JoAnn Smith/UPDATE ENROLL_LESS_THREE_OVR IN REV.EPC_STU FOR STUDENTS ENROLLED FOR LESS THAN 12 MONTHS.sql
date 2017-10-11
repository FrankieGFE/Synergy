/*
JoAnn, it may have been Debbie who worked on the attached script last but regardless,
we need to please create a new script that will 1) identify students enrolled during the 2017.R
school year who do not have an APS enrollment in the previous school year 2016.R, similar to what
the attached script is doing but for 1 year not 3.
2) create an update script that will set this flag for all students that meet the criteria in #1).
This is needed right away today/tomorrow please for 40-Day state reporting.   Thanks - Andy 

JoAnn, file looks good except please disregard if student was in PK, P1 or P2 Grade Level
in the previous year for comparison purposes (example below from your file).  Sorry I wasn’t clear on that.    


Written by:		JoAnn Smith
Date Written:	10/10/2017

*/

begin tran
;WITH STUDENT_MONTHS_ENROLLED
AS
(		
	SELECT 
		S.STUDENT_GU,
		BS.SIS_NUMBER,
		BS.LAST_NAME,
		BS.FIRST_NAME,
		DATEDIFF(MONTH, ORIGINAL_ENTER_DATE, GETDATE()) AS MONTHS_ENROLLED,
		PE.GRADE,
		LU.VALUE_DESCRIPTION AS SCHOOL_GRADE
	FROM
		REV.EPC_STU S
	LEFT JOIN
		APS.PrimaryEnrollmentsAsOf(GETDATE()) PE	
	ON
		S.STUDENT_GU = PE.STUDENT_GU
	LEFT JOIN
		APS.BasicStudent BS
	ON
		BS.STUDENT_GU = S.STUDENT_GU
	LEFT JOIN
		APS.LOOKUPTABLE('K12', 'Grade') LU
	ON
		LU.VALUE_CODE = PE.GRADE				
)

/* ORDER THE ENROLLMENTS WITH THE LATEST ENROLLMENT DATE FIRST */
,INTERIM_ENROLLMENTS   

AS
(
SELECT 
	ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY STUDENT_GU, ENTER_DATE DESC) AS RN,
	SED.STUDENT_GU,
	SED.SIS_NUMBER,
	SED.ENTER_DATE,
	SED.GRADE
FROM
	APS.StudentEnrollmentDetails SED
)
--SELECT * FROM INTERIM_ENROLLMENTS WHERE GRADE = 'P1'
/* TAKE OUT THOSE STUDENTS WHO WERE IN PK THE YEAR BEFORE */

,OMIT_PRE_K_STUDENTS
AS
(
SELECT * FROM INTERIM_ENROLLMENTS where rn = 2 and grade = 'PK'
)
--SELECT * FROM OMIT_PRE_K_STUDENTS

/* Since I calculated months enrolled off of the original enter date and the
schools have been changing the original enter date, I had to remove those who
had a previous enrollment */

,OMIT_HIGH_SCHOOLERS_WITH_WRONG_ENTER_DATE
AS
(
SELECT
	I.SIS_NUMBER,
	I.STUDENT_GU,
	I.GRADE,
	I.ENTER_DATE,
	SED.SCHOOL_YEAR
FROM
	INTERIM_ENROLLMENTS I
LEFT JOIN
	APS.StudentEnrollmentDetails SED
ON
	I.STUDENT_GU = SED.STUDENT_GU
WHERE
	SCHOOL_YEAR < 2017
)
--SELECT * FROM OMIT_HIGH_SCHOOLERS_WITH_WRONG_ENTER_DATE

,FINAL_ENROLLMENTS
AS
(
SELECT
	 *
FROM
	 INTERIM_ENROLLMENTS
)
--SELECT * FROM FINAL_ENROLLMENTS

/* match them according to enter_date a year from today */
,RESULTS
AS
(
SELECT
	 F.STUDENT_GU,
	 F.SIS_NUMBER,
	 F.ENTER_DATE,
	 F.GRADE
FROM
	 FINAL_ENROLLMENTS F
LEFT JOIN
	STUDENT_MONTHS_ENROLLED S
ON
	S.STUDENT_GU = F.STUDENT_GU
WHERE
	 F.ENTER_DATE >= '2016-10-09'
AND
	 MONTHS_ENROLLED < 12
AND
	 SCHOOL_GRADE NOT IN ('PK', 'P1', 'P2', 'T1', 'T2', 'T3', 'T4', 'C1', 'C2', 'C3', 'C4')
AND
	 S.STUDENT_GU NOT IN (SELECT STUDENT_GU FROM OMIT_PRE_K_STUDENTS)
AND
	 S.STUDENT_GU NOT IN (SELECT STUDENT_GU FROM OMIT_HIGH_SCHOOLERS_WITH_WRONG_ENTER_DATE)
AND RN = 1
)
--SELECT STUDENT_GU FROM RESULTS


/* CHECK */
--SELECT * FROM RESULTS R
--INNER JOIN
--REV.EPC_STU S
--ON R.STUDENT_GU = S.STUDENT_GU



/* now update rev.EPC_STU ENROLL_LESS_THREE_OVR with 'Y' 
Edupoint is using the same field that used to say ‘Enrolled Less than 3 years in a US School’
to pull the flag for the new PED requirement ‘Enrolled in US Schools less than 12 months’,
so when you hoover over it is still shows the Business Object K12-Student_EnrollUSLessThanThreeYearOverride,
so it’s in the same table as the previous 3 year flag.  Assessment asked us to leave the Less Than 3 years data
available because those students can still test in Spanish, so that is why Jude created a UD field to store that
data (the other project you are working on).
*/
update rev.epc_stu
	set ENROLL_LESS_THREE_OVR = 'Y'
WHERE
	STUDENT_GU IN 
	(SELECT STUDENT_GU FROM RESULTS)
rollback

