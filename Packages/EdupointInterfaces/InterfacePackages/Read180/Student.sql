--<APS - Read180 - Students>
-- Addendum file to be joined - Fixed rows from a temp table
; with SelectedCourses AS
(
SELECT
   stu.STUDENT_GU
   --courses at Hayes Middle School the number 416 will need to precede the course number
 , crs.COURSE_TITLE + ' '+
   CASE WHEN sch.SCHOOL_CODE = '416' THEN '416' ELSE '' END +
   crs.COURSE_ID + ' '+
   sec.SECTION_ID + ' ' +
   CAST(sec.PERIOD_BEGIN as VARCHAR(2)) ClassName
 , ssy.STUDENT_SCHOOL_YEAR_GU
FROM 
	REV.EPC_STU_SCH_YR              SSY 
	JOIN REV.EPC_STU                STU    ON STU.STUDENT_GU = SSY.STUDENT_GU
	JOIN REV.EPC_STU_CLASS          CLS    ON CLS.STUDENT_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU
	JOIN REV.EPC_SCH_YR_SECT        SEC    ON CLS.SECTION_GU = SEC.SECTION_GU
	JOIN REV.EPC_SCH_YR_CRS         SYCRS  ON SYCRS.SCHOOL_YEAR_COURSE_GU = SEC.SCHOOL_YEAR_COURSE_GU
	JOIN REV.EPC_CRS                CRS    ON CRS.COURSE_GU = SYCRS.COURSE_GU
	JOIN REV.REV_ORGANIZATION_YEAR  OY     ON OY.ORGANIZATION_YEAR_GU = SSY.ORGANIZATION_YEAR_GU
	JOIN REV.REV_YEAR               Y      ON Y.YEAR_GU = OY.YEAR_GU 
	                                          AND Y.YEAR_GU = (SELECT YEAR_GU FROM REV.SIF_22_Common_CurrentYearGU)
	JOIN REV.EPC_SCH                SCH    ON OY.ORGANIZATION_GU = SCH.ORGANIZATION_GU

WHERE  SSY.STATUS IS NULL
AND (crs.COURSE_ID IN (
'540111','540112','540211','540212','540311','540312','21206','212061','212062','21207'
,'212071','212072','21208','212081','212082','210421','210422','210431','210432','210441'
,'210442','212091','212092','212101','212102','212111','212112','212121','212122','54011'
,'54021', '540411', '540412'
)
OR (crs.COURSE_ID IN
('0604a1','0604a2','0614a1','0614a2','2055e1','2055e2','2055j1',
'2055j2','2055n1','250311','250312','250341','250342') 
AND SCH.SCHOOL_CODE = '540'))


AND (CLS.LEAVE_DATE IS NULL OR CLS.LEAVE_DATE >= GETDATE())
	AND CLS.ENTER_DATE <= GETDATE() 
	
),  EthCodes AS 
(
  SELECT ethl.PERSON_GU
  , ROW_NUMBER() OVER(PARTITION BY ethl.PERSON_GU ORDER BY ethl.PERSON_GU) rn
  , (select ''+RIGHT('000'+ ethl2.ETHNIC_CODE,3) from rev.REV_PERSON_SECONDRY_ETH_LST ethl2 where ethl2.PERSON_GU = ethl.PERSON_GU for xml path('')) ethlist
  FROM rev.REV_PERSON_SECONDRY_ETH_LST ethl
)
SELECT
   t.[USER_NAME]
 , t.[PASSWORD]
 , t.[SIS_ID]
 , t.[FIRST_NAME]
 , t.[MIDDLE_NAME]
 , t.[LAST_NAME]
 , t.[GRADE]
 , t.[SCHOOL_NAME]
 , t.[CLASS_NAME]
 , t.[ETHNIC_CAUCASIAN]
 , t.[ETHNIC_AFRICAN_AM]
 , t.[ETHNIC_HISPANIC]
 , t.[ETHNIC_PACIFIC_ISL]
 , t.[ETHNIC_AM_IND_AK_NATIVE]
 , t.[ETHNIC_ASIAN]
 , t.[GENDER_MALE]
 , t.[GENDER_FEMALE]
 , t.[AYP_ECON_DISADVANTAGED]
 , t.[AYP_LTD_ENGLISH_PROFICIENCY]
 , t.[AYP_GIFTED_TALENTED]
 , t.[AYP_MIGRANT]
 , t.[LAST_COL]
 , 1 [Orderby]
FROM ##TempStuAddendum t
WHERE t.USER_NAME != '' and t.PASSWORD != '' and t.SIS_ID != '' and t.FIRST_NAME != ''
UNION  
SELECT
   stu.SIS_NUMBER                                                    AS [USER_NAME]
 , SUBSTRING(REPLACE(CONVERT(VARCHAR(10), per.BIRTH_DATE, 101), '/',''),1,4)
                                                                     AS [PASSWORD]
 , stu.SIS_NUMBER                                                    AS [SIS_ID]
 , per.FIRST_NAME                                                    AS [FIRST_NAME]
 , per.MIDDLE_NAME                                                   AS [MIDDLE_NAME]
 , per.LAST_NAME                                                     AS [LAST_NAME]
 , grade.VALUE_DESCRIPTION                                           AS [GRADE]
 , org.ORGANIZATION_NAME                                             AS [SCHOOL_NAME]
 , scs.ClassName                                                     AS [CLASS_NAME]
 , CASE WHEN per.RESOLVED_ETHNICITY_RACE = '001'  THEN 'Y' ELSE 'N' END   AS [ETHNIC_CAUCASIAN]
 , CASE WHEN per.RESOLVED_ETHNICITY_RACE = '600'  THEN 'Y' ELSE 'N' END   AS [ETHNIC_AFRICAN_AM]
 , CASE WHEN per.RESOLVED_ETHNICITY_RACE = '500'  THEN 'Y' ELSE 'N' END   AS [ETHNIC_HISPANIC]
 , CASE WHEN per.RESOLVED_ETHNICITY_RACE = '399'  THEN 'Y' ELSE 'N' END   AS [ETHNIC_PACIFIC_ISL]
 , CASE WHEN per.RESOLVED_ETHNICITY_RACE = '100'  THEN 'Y' ELSE 'N' END   AS [ETHNIC_AM_IND_AK_NATIVE]
 , CASE WHEN per.RESOLVED_ETHNICITY_RACE = '299'  THEN 'Y' ELSE 'N' END   AS [ETHNIC_ASIAN]
 , CASE WHEN per.GENDER = 'M' THEN 'Y' ELSE 'N' END                  AS [GENDER_MALE]
 , CASE WHEN per.GENDER = 'F' THEN 'Y' ELSE 'N' END                  AS [GENDER_FEMALE]
 , CASE WHEN stu.DISADVANTAGED is not null then 'Y' ELSE 'N' END     AS [AYP_ECON_DISADVANTAGED]
 , CASE WHEN ell.PROGRAM_CODE is not NULL THEN 'Y' ELSE 'N' END      AS [AYP_LTD_ENGLISH_PROFICIENCY]
 , CASE WHEN sped.PRIMARY_DISABILITY_CODE is not null THEN 'Y' ELSE 'N' END AS [AYP_GIFTED_TALENTED]
 , CASE WHEN stu.MIGRANT = 'Y' THEN 'Y' ELSE 'N' END                 AS [AYP_MIGRANT]
 , 'Y'                                                               AS [LAST_COL]
 , 2                                                                 AS [Orderby]
FROM rev.EPC_STU                    stu
JOIN rev.EPC_STU_SCH_YR             ssyr ON ssyr.STUDENT_GU = stu.STUDENT_GU
                                            AND ssyr.STATUS IS NULL
JOIN rev.REV_ORGANIZATION_YEAR      oyr  ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
                                            AND oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
JOIN rev.REV_ORGANIZATION           org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH                    sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.REV_PERSON                 per  ON per.PERSON_GU = stu.STUDENT_GU
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grade ON grade.VALUE_CODE = ssyr.GRADE
JOIN SelectedCourses                scs  ON scs.STUDENT_GU = stu.STUDENT_GU
                                            and scs.STUDENT_SCHOOL_YEAR_GU = ssyr.STUDENT_SCHOOL_YEAR_GU
LEFT JOIN EthCodes                  eth  ON eth.PERSON_GU = stu.STUDENT_GU and eth.rn = 1
LEFT JOIN rev.EP_STUDENT_SPECIAL_ED sped ON sped.STUDENT_GU = stu.STUDENT_GU and sped.PRIMARY_DISABILITY_CODE = 'GI'
LEFT JOIN rev.EPC_STU_PGM_ELL       ell  ON ell.STUDENT_GU = stu.STUDENT_GU

Order by [Orderby]