--Created by: e207878/Sean McMurray
--Created on: 1/24/2016
--Purpose: Data extract to pull truancy information
--Note: Need to create function/report




Select
  rev.EPC_STU.SIS_NUMBER AS [Student ID]
  ,rev.REV_PERSON.LAST_NAME AS [Last Name]
  ,rev.REV_PERSON.FIRST_NAME AS [First Name]
  ,rev.REV_PERSON.MIDDLE_NAME AS [Middle Name]
  ,APS.StudentEnrollmentDetails.GRADE AS [Grade]
  ,APS.StudentEnrollmentDetails.SCHOOL_NAME [School]
  ,rev.UD_TRUANCY_LOG.CONTACT_TYPE AS [Contact Type]
  ,rev.UD_TRUANCY_LOG.CONTACT_WITH AS [Contact With]
  ,rev.UD_TRUANCY_LOG.NOTES AS [Notes]
  ,rev.UD_TRUANCY_LOG.OUTCOME_1 AS [Outcome]
  ,rev.UD_TRUANCY_LOG.OUTCOME_2 AS [Outcome 2]
  ,rev.UD_TRUANCY_LOG.TRUANCY_STAFF AS [Staff]
  ,rev.UD_TRUANCY_LOG.TRUANCY_STAFF_TITLE AS [Staff Title]
  ,rev.UD_TRUANT_STUDENT.FIVE_DAY_TRUANT AS [Five Day Truant]
  ,rev.UD_TRUANT_STUDENT.SCHOOL_YEAR AS [School Year]
  ,rev.UD_TRUANT_STUDENT.TEN_DAY_TRUANT AS [Ten Day Truant]
  ,rev.UD_TRUANT_STUDENT.TWO_DAY_TRUANT AS [Two Day Truant]

From

  rev.EPC_STU
  INNER JOIN
  rev.REV_PERSON ON rev.EPC_STU.STUDENT_GU = rev.REV_PERSON.PERSON_GU
  INNER JOIN
  rev.REV_PERSON_CONTACT ON rev.REV_PERSON.PERSON_GU = rev.REV_PERSON_CONTACT.PERSON_GU
  INNER JOIN
  rev.UD_TRUANCY_LOG ON rev.EPC_STU.STUDENT_GU = rev.UD_TRUANCY_LOG.STUDENT_GU
  INNER JOIN
  rev.UD_TRUANT_STUDENT on rev.EPC_STU.STUDENT_GU = rev.UD_TRUANT_STUDENT.STUDENT_GU
  INNER JOIN
  APS.StudentEnrollmentDetails on rev.EPC_STU.STUDENT_GU = APS.StudentEnrollmentDetails.STUDENT_GU


WHERE 
rev.UD_TRUANCY_LOG.UDTRUANCY_LOG_GU IS NOT NULL
AND APS.StudentEnrollmentDetails.EXCLUDE_ADA_ADM IS NULL
AND APS.StudentEnrollmentDetails.SCHOOL_YEAR = '2015'
AND APS.StudentEnrollmentDetails.EXTENSION = 'R'

ORDER BY
SCHOOL_NAME