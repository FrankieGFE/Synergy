--<APS - DataDirector - Student Demographics>
; with ParentNames AS
(
SELECT
   PNm.STUDENT_GU
 , ROW_NUMBER() OVER(PARTITION BY PNm.STUDENT_GU order by PNm.STUDENT_GU) rno
 , Parents = STUFF(  COALESCE(', ' + Pnm.[1], '')
                   + COALESCE(', ' + Pnm.[2], '') 
                   + COALESCE(', ' + Pnm.[3], '') 
                   + COALESCE(', ' + Pnm.[4], '') 
                   , 1, 1,'')
FROM
  (
    SELECT 
           stu.STUDENT_GU
         , COALESCE(spar.ORDERBY, (ROW_NUMBER() OVER(PARTITION BY spar.STUDENT_GU order by spar.STUDENT_GU))) rn
         , pper.FIRST_NAME + ' ' +  pper.LAST_NAME [pname]
    FROM rev.EPC_STU stu
         JOIN rev.EPC_STU_PARENT spar ON spar.STUDENT_GU = stu.STUDENT_GU AND spar.CONTACT_ALLOWED = 'Y'
         JOIN rev.REV_PERSON pper     ON pper.PERSON_GU  = spar.PARENT_GU
  )  pn PIVOT (min(pname) for rn in ([1], [2], [3], [4])) PNm
), FRMHistory AS
(
SELECT
           ROW_NUMBER() OVER (PARTITION BY stu.student_gu order by f.ENTER_DATE,stu.STUDENT_gu) rn
         , stu.STUDENT_GU
         , f.FRM_CODE
    FROM rev.EPC_STU stu
         LEFT JOIN rev.EPC_STU_PGM_FRM_HIS f on f.STUDENT_GU = stu.STUDENT_GU
                                                AND f.ENTER_DATE is not null 
                                                and (f.EXIT_DATE is null or f.EXIT_DATE > getdate())
)

SELECT DISTINCT
       stu.SIS_NUMBER                           AS [student_id]
     , stu.STATE_STUDENT_NUMBER                 AS [state_id]
     , per.FIRST_NAME                           AS [first_name]
     , per.LAST_NAME                            AS [last_name]
     , per.MIDDLE_NAME                          AS [middle_name]
     , CONVERT(VARCHAR(10), per.BIRTH_DATE,101) AS [dob]
     , per.GENDER                               AS [gender]
     , ''                                       AS [track]
     , pnm.Parents                              AS [Guardian]
     , hadr.ADDRESS                             AS [address_1]
     , ''                                       AS [address_2]
     , hadr.CITY                                AS [city]
     , hadr.STATE                               AS [state]
     , hadr.ZIP_5                               AS [zip]
     , per.PRIMARY_PHONE                        AS [phone]
     , stu.HOME_LANGUAGE                        AS [language]
     , CASE WHEN per.RESOLVED_ETHNICITY_RACE = '__HIS' THEN 'H'
            WHEN per.RESOLVED_ETHNICITY_RACE = '__TWO' THEN 'M'
            ELSE eth.ALT_CODE_3
       END                                      AS [ethnicity]
     , CASE WHEN ssyr.TITLE_1_PROGRAM is not null THEN 'Y' 
            ELSE 'N' 
       END                                      AS [title1]
     , CASE WHEN ell.PROGRAM_CODE is not NULL THEN 'ELL' 
       END                                      AS [english_proficiency]
     , COALESCE(sped.PRIMARY_DISABILITY_CODE, ssyr.ENR_USER_DD_6) AS [PRIM_DISAB]
     , frm.FRM_CODE                             AS [NSPL]

FROM rev.EPC_STU                         stu
     JOIN rev.EPC_STU_SCH_YR             ssyr  ON ssyr.STUDENT_GU         = stu.STUDENT_GU
                                                  AND ssyr.STATUS IS NULL
     JOIN rev.REV_ORGANIZATION_YEAR      oyr  ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
     JOIN rev.REV_YEAR                   yr   ON yr.YEAR_GU                = oyr.YEAR_GU
                                                 and yr.SCHOOL_YEAR        = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)
     JOIN rev.REV_PERSON                 per  ON per.PERSON_GU            = stu.STUDENT_GU
     LEFT JOIN rev.REV_ADDRESS           hadr ON hadr.ADDRESS_GU          = per.HOME_ADDRESS_GU
     LEFT JOIN ParentNames               pnm  ON pnm.STUDENT_GU           = stu.STUDENT_GU and pnm.rno = 1
     --ELL                               
     LEFT JOIN rev.EPC_STU_PGM_ELL       ell  ON ell.STUDENT_GU           = stu.STUDENT_GU
     --Disability
     LEFT JOIN rev.EP_STUDENT_SPECIAL_ED sped ON sped.STUDENT_GU          = stu.STUDENT_GU
     --FRM
     LEFT JOIN FRMHistory                frm  ON frm.STUDENT_GU           = stu.STUDENT_GU and frm.rn = 1
     LEFT JOIN rev.SIF_22_Common_GetLookupValues('Revelation', 'ETHNICITY') eth on eth.VALUE_CODE = per.RESOLVED_ETHNICITY_RACE