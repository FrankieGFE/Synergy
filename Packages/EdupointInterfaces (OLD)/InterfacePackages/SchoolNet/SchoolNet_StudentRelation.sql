--<APS - SchoolNet student_relation data>

SELECT DISTINCT
         stu.SIS_NUMBER                    AS [student_code]
       , stu.SIS_NUMBER + pper.FIRST_NAME  AS [student_contact_code]
FROM   rev.EPC_STU                    stu
       JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
       JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                              and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU          = oyr.YEAR_GU
       JOIN rev.EPC_STU_PARENT        spar ON spar.STUDENT_GU = stu.STUDENT_GU
       JOIN rev.REV_PERSON            pper ON pper.PERSON_GU  = spar.PARENT_GU
	   JOIN rev.REV_ADDRESS           hadr ON hadr.ADDRESS_GU = pper.HOME_ADDRESS_GU
