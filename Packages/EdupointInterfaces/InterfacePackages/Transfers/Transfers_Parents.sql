-- <APS - Transfer System – Parent/Student Groups Extract>
-- List to include all student that have a record – regardless of whether a current enrollment exists 
-- as of date list is run (DL) (may be no School of Record for Current SY)

SELECT
         STU.SIS_NUMBER                       AS [Student ID]
       , CONVERT(VARCHAR(10), GETDATE(), 101) AS [File Date]
       , pper.FIRST_NAME                      AS [Parent First Name]
       , pper.LAST_NAME                       AS [Parent Last Name]
       , rel.VALUE_DESCRIPTION                AS [Parent Relationship]
FROM   rev.EPC_STU                  stu
       JOIN rev.EPC_STU_YR          stuyr ON stuyr.STUDENT_GU   = stu.STUDENT_GU
       JOIN rev.REV_YEAR            yr    ON yr.YEAR_GU         = stuyr.YEAR_GU
	                                         AND yr.SCHOOL_YEAR = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)
	   LEFT JOIN rev.EPC_STU_PARENT stpar ON stpar.STUDENT_GU    = stu.STUDENT_GU
	   LEFT JOIN rev.REV_PERSON     pper  ON pper.PERSON_GU      = stpar.PARENT_GU
	   LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'RELATION_TYPE') rel ON rel.VALUE_CODE = stpar.RELATION_TYPE