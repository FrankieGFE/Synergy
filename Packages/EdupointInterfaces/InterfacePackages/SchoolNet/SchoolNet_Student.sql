--<APS - SchoolNet student data>
SELECT distinct
         stu.SIS_NUMBER                            AS [student_code]
       , per.LAST_NAME                             AS [last_name]
       , per.FIRST_NAME                            AS [first_name]
       , per.MIDDLE_NAME                           AS [middle_name]
       , CASE
	         WHEN per.RESOLVED_ETHNICITY_RACE = '__HIS' THEN 'H'
			 WHEN per.RESOLVED_ETHNICITY_RACE = '__TWO' THEN 'M'
             WHEN per.RESOLVED_ETHNICITY_RACE = '1'     THEN 'C'
             WHEN per.RESOLVED_ETHNICITY_RACE = '600'   THEN 'B'
             WHEN per.RESOLVED_ETHNICITY_RACE = '100'   THEN 'I'
             WHEN per.RESOLVED_ETHNICITY_RACE = '299'   THEN 'A'
             WHEN per.RESOLVED_ETHNICITY_RACE = '399'   THEN 'P'
             WHEN per.RESOLVED_ETHNICITY_RACE = '401'   THEN 'X'
        END                                         AS [race_ethnicity_code]
       , CASE
             WHEN per.HISPANIC_INDICATOR = 'Y' THEN 'HL'
			 ELSE 'NHL'
	     END                                       AS [ethnicity_code]
       , per.GENDER AS [gender_code]
       , CONVERT(VARCHAR(10), per.BIRTH_DATE, 120) AS [dob]
       , adr.ADDRESS                               AS [address_1]
       , adr.ADDRESS2                              AS [address_2]
       , adr.CITY                                  AS [city]
       , adr.STATE                                 AS [state]
       , adr.ZIP_5
	     + '-' + COALESCE(adr.zip_4, '0000')       AS [zip]
       , LEFT(per.PRIMARY_PHONE,3)
	     + '-' + SUBSTRING(per.PRIMARY_PHONE, 4,3)
		 + '-' + RIGHT(per.primary_phone,4)         AS [phone]
       , '' AS [email]

 
FROM   rev.EPC_STU                    stu
       JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
       JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                              and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
       JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
       JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
	   LEFT JOIN rev.REV_ADDRESS      adr  ON adr.ADDRESS_GU = COALESCE(per.MAIL_ADDRESS_GU, per.home_address_gu)