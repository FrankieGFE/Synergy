--<APS - SchoolNet student_contact data>

SELECT DISTINCT
         stu.SIS_NUMBER					                AS [student_contact_code]
	   , CONVERT(VARCHAR(10), per.BIRTH_DATE, 120)      AS [dob]
       , pper.LAST_NAME                                 AS [last_name]
       , pper.FIRST_NAME                                AS [first_name]
       , pper.MIDDLE_NAME                               AS [middle_name]
	   , per.LAST_NAME									AS [stud_lname]
	   , per.FIRST_NAME								    AS [stu_fname]
	   , spar.CONTACT_ALLOWED							AS [contact]
	   , sys.ACTIVATE_KEY								AS [key]
	  
FROM   rev.EPC_STU                    stu
       JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
       JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                              and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU          = oyr.YEAR_GU
       JOIN rev.EPC_STU_PARENT        spar ON spar.STUDENT_GU = stu.STUDENT_GU
       JOIN rev.REV_PERSON            pper ON pper.PERSON_GU  = spar.PARENT_GU
	   JOIN rev.REV_ADDRESS           hadr ON hadr.ADDRESS_GU = pper.HOME_ADDRESS_GU
	   JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
	   JOIN rev.REV_USER_NON_SYS      sys  ON sys.PERSON_GU = pper.PERSON_GU

where pper.LAST_NAME = 'ZWOYER' and pper.FIRST_NAME = 'Jonni'