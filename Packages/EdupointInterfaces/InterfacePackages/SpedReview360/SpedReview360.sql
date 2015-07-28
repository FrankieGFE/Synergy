--<APS - Special Education - Review360-MAP>
; with EthList AS
(
select   ROW_NUMBER() over (partition by s.student_gu order by s.student_gu) rn
       , s.STUDENT_GU
	   , ethl.ETHNIC_CODE
	   , es.ALT_CODE_2
from   rev.epc_stu                          s
       join rev.REV_PERSON_SECONDRY_ETH_LST ethl ON ethl.PERSON_GU = s.STUDENT_GU 
	   left join rev.SIF_22_Common_GetLookupValues('Revelation', 'ETHNICITY') es on es.VALUE_CODE = ethl.ETHNIC_CODE
), Parent AS
(
SELECT   
        stu.STUDENT_GU
      , ROW_NUMBER() OVER(PARTITION BY stu.STUDENT_GU ORDER BY stupar.ORDERBY) PGNum
	  , rel.VALUE_DESCRIPTION Relation
	  , par.FIRST_NAME
	  , par.LAST_NAME
      , LEFT(phone.H,3) + '-'+ SUBSTRING(phone.H,4,3) + '-' + RIGHT(phone.H,4) HomePhone
      , LEFT(phone.W,3) + '-'+ SUBSTRING(phone.W,4,3) + '-' + RIGHT(phone.W,4) WorkPhone
      , hadr.ADDRESS
	  , hadr.CITY
	  , hadr.STATE
	  , hadr.ZIP_5
FROM  rev.EPC_STU_PARENT   stupar
      JOIN rev.REV_PERSON  par    ON par.PERSON_GU = stupar.PARENT_GU 
      JOIN rev.EPC_STU     stu    ON stu.STUDENT_GU = stupar.STUDENT_GU
      JOIN rev.REV_ADDRESS hadr   ON hadr.ADDRESS_GU = par.HOME_ADDRESS_GU
	  LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'RELATION_TYPE') rel ON rel.VALUE_CODE = stupar.RELATION_TYPE
      LEFT JOIN (SELECT phn.PERSON_GU, phn.PHONE, phn.PHONE_TYPE FROM rev.REV_PERSON_PHONE phn) pl
                 PIVOT (min(phone) FOR phone_type in ([H], [W])) phone ON phone.PERSON_GU = par.PERSON_GU
)
SELECT 
        stu.SIS_NUMBER                               AS [Student ID Number]
      , per.LAST_NAME                                AS [Student Last Name]
      , per.FIRST_NAME                               AS [Student First Name]
      --,ssy.ENTER_DATE
      , CONVERT(VARCHAR(10), per.BIRTH_DATE, 101)    AS [DOB]
      , per.GENDER                                   AS [Gender]
      , LEFT(el1.ALT_CODE_2,1)                       AS [Ethnicity 1]
      , LEFT(el2.ALT_CODE_2,1)                       AS [Ethnicity 2]
      , LEFT(el3.ALT_CODE_2,1)                       AS [Ethnicity 3]
      , LEFT(el4.ALT_CODE_2,1)                       AS [Ethnicity 4]
      , LEFT(el5.ALT_CODE_2,1)                       AS [Ethnicity 5]
      , per.HISPANIC_INDICATOR                       AS [HispanicIndicator]
      , ''                                           AS [ESL Status] --NULL (TBD)
      , ''                                           AS [Bilingual Status] --NULL (TBD)
      , CONVERT(VARCHAR(10), sped.next_iep_date,101) AS [IEP Date]
      , sped.PRIMARY_DISABILITY_CODE                 AS [Primary Disability]
      , sped.SECONDARY_DISABILITY_CODE               AS [Secondary Disability]
      , RIGHT('000' + sch.SCHOOL_CODE, 3)            AS [Registered Location]
      , grd.VALUE_DESCRIPTION                        AS [Grade]
      , p1.Relation                                  AS [Primary Parent Type]
      , p1.LAST_NAME                                 AS [Primary Parent Last Name]
      , p1.FIRST_NAME                                AS [Primary Parent First Name]
      , p1.ADDRESS                                   AS [Primary Parent Address]
      , p1.CITY                                      AS [Primary Parent City]
      , p1.STATE                                     AS [Primary Parent State]
      , p1.ZIP_5                                     AS [Primary Parent Zip]
      , p1.HomePhone                                 AS [Primary Parent Home Phone #]
      , LEFT(per.PRIMARY_PHONE,3) + '-' +
	    SUBSTRING(per.PRIMARY_PHONE,4,3) + '-' +
		RIGHT(per.PRIMARY_PHONE,4)                   AS [Home Phone #]
      , p1.WorkPhone                                 AS [Primary Parent Work Phone #]
      , p2.Relation                                  AS [Secondary Parent Type]
      , p2.LAST_NAME                                 AS [Secondary Parent Last Name]
      , p2.FIRST_NAME                                AS [Secondary Parent First Name]
      , p2.ADDRESS                                   AS [Secondary Parent Address]
      , p2.CITY                                      AS [Secondary Parent City]
      , p2.STATE                                     AS [Secondary Parent State]
      , p2.ZIP_5                                     AS [Secondary Parent Zip]
      , p2.HomePhone                                 AS [Secondary Parent Home Phone #]
      , p2.WorkPhone                                 AS [Secondary Parent Work Phone #]
	  , CONVERT(VARCHAR(10),GETDATE(),101)           AS [FileCreatedDate]
	  , ssy.EXCLUDE_ADA_ADM                          AS [Concurrent]
FROM  rev.EPC_STU                         stu
      JOIN rev.EPC_STU_SCH_YR             ssy  ON ssy.STUDENT_GU           = stu.STUDENT_GU
                                                  AND ssy.STATUS is null
      JOIN rev.REV_ORGANIZATION_YEAR      oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                                  --AND oyr.YEAR_GU          = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
                                                  AND oyr.YEAR_GU IN (SELECT YEAR_GU FROM APS.YearDates WHERE (GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE))
      JOIN rev.EPC_SCH                    sch  ON sch.ORGANIZATION_GU      = oyr.ORGANIZATION_GU
      JOIN rev.REV_PERSON                 per  ON per.PERSON_GU            = stu.STUDENT_GU
	  LEFT JOIN rev.EP_STUDENT_SPECIAL_ED sped ON sped.STUDENT_GU          = stu.STUDENT_GU
	  LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grd ON grd.VALUE_CODE = ssy.GRADE
	  -- Ethnicity
      LEFT JOIN EthList                   el1  ON el1.STUDENT_GU            = stu.STUDENT_GU and el1.rn = 1
      LEFT JOIN EthList                   el2  ON el2.STUDENT_GU            = stu.STUDENT_GU and el2.rn = 2
      LEFT JOIN EthList                   el3  ON el3.STUDENT_GU            = stu.STUDENT_GU and el3.rn = 3
      LEFT JOIN EthList                   el4  ON el4.STUDENT_GU            = stu.STUDENT_GU and el4.rn = 4
      LEFT JOIN EthList                   el5  ON el5.STUDENT_GU            = stu.STUDENT_GU and el5.rn = 5
	  -- Parent 1
	  LEFT JOIN Parent                    p1   ON p1.STUDENT_GU             = stu.STUDENT_GU and p1.PGNum = 1
	  -- Parent 2
	  LEFT JOIN Parent                    p2   ON p2.STUDENT_GU             = stu.STUDENT_GU and p2.PGNum = 2