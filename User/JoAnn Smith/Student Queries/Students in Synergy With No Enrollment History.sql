/**
 * Revision 1
 * Last Changed By:		e211395
 * Last Changed Date:	1-17-2017
 ****************************************************************************************************

 Pulls a file of all students (student records) in Synergy that have no enrollment history.  Includes
 Student Name, Perm ID, State ID and DOB. 
       
 ****************************************************************************************************/



with EnrollmentCTE(StudentGU, StudentNumber, OrgYearGu, SchoolYearGU, EnrollmentGU, Grade, EnterDate,
LeaveDate, ExcludeADAADM)
as

(
	select
             SSY.STUDENT_GU
             ,STU.SIS_NUMBER
             ,SSY.ORGANIZATION_YEAR_GU
             ,SSY.STUDENT_SCHOOL_YEAR_GU
             ,Enrollment.ENROLLMENT_GU
             ,Enrollment.GRADE
             ,Enrollment.ENTER_DATE
             ,Enrollment.LEAVE_DATE
             ,Enrollment.EXCLUDE_ADA_ADM
             --YearDates and OrgYears help us focus our search 
    FROM
             APS.YearDates
    INNER JOIN
             rev.REV_ORGANIZATION_YEAR AS OrgYear
             ON YearDates.YEAR_GU = OrgYear.YEAR_GU

             -- Student School Year - Everything flows through here
    INNER JOIN
             rev.EPC_STU_SCH_YR AS SSY
             ON OrgYear.ORGANIZATION_YEAR_GU = SSY.ORGANIZATION_YEAR_GU

             -- Enrollment because enter and leave dates truly reside here, and not most recent as it is bubbled up to SSY
    INNER JOIN
             rev.EPC_STU_ENROLL AS Enrollment
             ON SSY.STUDENT_SCHOOL_YEAR_GU = Enrollment.STUDENT_SCHOOL_YEAR_GU
    INNER JOIN
             REV.EPC_STU AS STU
             ON STU.STUDENT_GU = SSY.STUDENT_GU
)
	SELECT 
             
             PER.FIRST_NAME
             ,PER.LAST_NAME
			 ,STU.SIS_NUMBER AS STU_SIS_NUMBER
             ,STU.STATE_STUDENT_NUMBER
			 ,convert(varchar(10), PER.BIRTH_DATE, 126) as BIRTH_DATE
	FROM
             REV.EPC_STU AS STU
    LEFT JOIN
			EnrollmentCTE CTE 
			on CTE.StudentGU = STU.STUDENT_GU

	INNER JOIN
			REV.REV_PERSON AS PER
			ON PER.PERSON_GU = STU.STUDENT_GU

	WHERE CTE.StudentNumber IS NULL

	ORDER BY STU.SIS_NUMBER
