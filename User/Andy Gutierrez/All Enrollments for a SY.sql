--  withdrawals lists all enrollments for the year and extension indicated including Leave Dates except summerand no shows

 /**
 * $Revision: 227 $
 * $LastChangedBy: e134728 $
 * $LastChangedDate: 2015-09-24 10:09:18 -0600 (Mon, 13 Oct 2014) $
 *
 * This query withdrawals lists all enrollments for the year and extension indicated including Leave Dates except summerand no shows
 */

SELECT
      [STUDENT].[SIS_NUMBER]
      ,[STUDENT].[FIRST_NAME]
      ,[STUDENT].[LAST_NAME]
      ,[STUDENT].[MIDDLE_NAME]
      ,[STUDENT].[GENDER]
      ,[ENROLLMENT].*
      
FROM
      APS.StudentEnrollmentDetails AS [ENROLLMENT]
      
      INNER JOIN
      APS.BasicStudent AS [STUDENT]
      ON
      [ENROLLMENT].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
      
WHERE
      [ENROLLMENT].[SCHOOL_YEAR] = '2015'
      AND [ENROLLMENT].[EXTENSION] = 'R'
