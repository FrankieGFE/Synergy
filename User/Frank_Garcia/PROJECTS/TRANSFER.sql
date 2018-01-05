SELECT DISTINCT
         stu.SIS_NUMBER					                AS [student_contact_code]
	   , CONVERT(VARCHAR(10), per.BIRTH_DATE, 120)      AS [dob]
       , pper.LAST_NAME                                 AS [last_name]
       , pper.FIRST_NAME                                AS [first_name]
       , pper.MIDDLE_NAME                               AS [middle_name]
	   , PPER.PRIMARY_PHONE
	   , PPER.EMAIL
	   , PPER.HOME_ADDRESS_GU
	   , per.LAST_NAME									AS [stud_lname]
	   , per.FIRST_NAME								    AS [stud_fname]
	   , sch.SCHOOL_CODE								AS school_code
	   , org.ORGANIZATION_NAME							AS SCHOOL_NAME
	   , BS.HOME_ADDRESS
	   , BS.HOME_ADDRESS_2
	   , BS.HOME_CITY
	   , BS.HOME_STATE
	   , BS.HOME_ZIP
	   , spar.CONTACT_ALLOWED							AS [contact]
	   , rpt.LEVEL_INTEGRATION							AS [sped_level]
	   , stu.STUDENT_GU								    AS student_gu
	   , spar.PARENT_GU									AS parent_gu
	   --, sys.ACTIVATE_KEY								AS [key]
    --   , sys.USER_ID							        AS [user_id]
	   , spar.CONTACT_ALLOWED							AS [allowed]
FROM   rev.EPC_STU                    stu
       JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
       JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                              and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU          = oyr.YEAR_GU
	   JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
	   JOIN rev.REV_ORGANIZATION	  org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
       JOIN rev.EPC_STU_PARENT        spar ON spar.STUDENT_GU = stu.STUDENT_GU
       JOIN rev.REV_PERSON            pper ON pper.PERSON_GU  = spar.PARENT_GU
	   JOIN rev.REV_ADDRESS           hadr ON hadr.ADDRESS_GU = pper.HOME_ADDRESS_GU
	   JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
	   LEFT JOIN rev.REV_USER_NON_SYS      sys  ON sys.PERSON_GU = pper.PERSON_GU
	   LEFT JOIN rev.EPC_NM_STU_SPED_RPT rpt ON rpt.STUDENT_GU = stu.STUDENT_GU
	   LEFT JOIN APS.LookupTable ('K12.SpecialEd.IEP', 'LEVEL_INTEGRATION') AS LI
	   ON LI.VALUE_CODE = rpt.LEVEL_INTEGRATION
	   LEFT JOIN
	   APS.BasicStudentWithMoreInfo AS BS
	   ON stu.STUDENT_GU = BS.STUDENT_GU

	   WHERE STU.SIS_NUMBER = '970027595'
	   --WHERE SPAR.PARENT_GU = '6380A9D1-6E6D-401F-BD24-1BECDE3053A5'