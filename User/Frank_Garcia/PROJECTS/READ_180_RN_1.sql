--Use user QueryFileUser'
EXECUTE  AS  LOGIN='QueryFileUser'
GO
--Create table
IF OBJECT_ID('tempdb..##TempStuAddendum') IS NOT NULL DROP TABLE ##TempStuAddendum
CREATE TABLE ##TempStuAddendum(
   [USER_NAME]                    NVARCHAR(50) null
 , [PASSWORD]                     NVARCHAR(50) null
 , [SIS_ID]                       NVARCHAR(50) null
 , [FIRST_NAME]                   NVARCHAR(50) null
 , [MIDDLE_NAME]                  NVARCHAR(50) null
 , [LAST_NAME]                    NVARCHAR(50) null
 , [GRADE]                        NVARCHAR(50) null
 , [SCHOOL_NAME]                  NVARCHAR(50) null
 , [CLASS_NAME]                   NVARCHAR(50) null
 , [ETHNIC_CAUCASIAN]             NVARCHAR(50) null
 , [ETHNIC_AFRICAN_AM]            NVARCHAR(50) null
 , [ETHNIC_HISPANIC]              NVARCHAR(50) null
 , [ETHNIC_PACIFIC_ISL]           NVARCHAR(50) null
 , [ETHNIC_AM_IND_AK_NATIVE]      NVARCHAR(50) null
 , [ETHNIC_ASIAN]                 NVARCHAR(50) null
 , [GENDER_MALE]                  NVARCHAR(50) null
 , [GENDER_FEMALE]                NVARCHAR(50) null
 , [AYP_ECON_DISADVANTAGED]       NVARCHAR(50) null
 , [AYP_LTD_ENGLISH_PROFICIENCY]  NVARCHAR(50) null
 , [AYP_GIFTED_TALENTED]          NVARCHAR(50) null
 , [AYP_MIGRANT]                  NVARCHAR(50) null
 , [LAST_COL]                     NVARCHAR(50) null
 )

INSERT INTO ##TempStuAddendum
SELECT  
*
FROM

            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0',  
                  'Text;Database=\\SynTempSSIS\Files\TempQuery\;',  
                  'SELECT * from Student_addendum.csv'
                )  AS  [CAREER]



      REVERT
GO


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
,'54021', '540411', '540412','54031','540611','540612'
)
OR (crs.COURSE_ID IN
('0604a1','0604a2','0614a1','0614a2','2055e1','2055e2','2055j1','21206',
'2055j2','2055n1','250311','250312','250341','250342''0604b1','0604b2','0614b1','0614b2','0621011','0621012','0621021','0621022','0621031','0621032','0621041',
'0621042','0624b1','0624b2','0654cb1','0654cb2','0654gb1','0654gb2','2055b1','2055b2','2055f1','2055f2','2055k1','2055k2','2055p1','2055p2','215551','215552',
'250411','250412','250413','25041c','25041c1','25041c2','25041de1','25041de2','25041oc1','25041oc2','250441','250442','25044de','25044de2','25044oc1','25044oc2'
) 
AND SCH.SCHOOL_CODE IN ('540','570'))
OR
(SCH.[SCHOOL_CODE] IN ('206','496') AND SEC.PERIOD_BEGIN = 1)
OR
(SCH.SCHOOL_CODE = '496' AND crs.COURSE_ID = '10240000')
OR
(SCH.SCHOOL_CODE = '217' AND SSY.GRADE NOT IN ('100','110'))
)


AND (CLS.LEAVE_DATE IS NULL OR CLS.LEAVE_DATE >= GETDATE())
	AND CLS.ENTER_DATE <= GETDATE() 
	
),  EthCodes AS 
(
  SELECT ethl.PERSON_GU
  , ROW_NUMBER() OVER(PARTITION BY ethl.PERSON_GU ORDER BY ethl.PERSON_GU) rn
  , (select ''+RIGHT('000'+ ethl2.ETHNIC_CODE,3) from rev.REV_PERSON_SECONDRY_ETH_LST ethl2 where ethl2.PERSON_GU = ethl.PERSON_GU for xml path('')) ethlist
  FROM rev.REV_PERSON_SECONDRY_ETH_LST ethl
) SELECT [USER_NAME], PASSWORD, SIS_ID,FIRST_NAME, MIDDLE_NAME, LAST_NAME, GRADE,SCHOOL_NAME,CLASS_NAME,ETHNIC_CAUCASIAN,ETHNIC_AFRICAN_AM, ETHNIC_HISPANIC,ETHNIC_PACIFIC_ISL, ETHNIC_AM_IND_AK_NATIVE,ETHNIC_ASIAN,GENDER_MALE,GENDER_FEMALE,AYP_ECON_DISADVANTAGED,AYP_LTD_ENGLISH_PROFICIENCY,AYP_GIFTED_TALENTED,AYP_MIGRANT,LAST_COL,Orderby
FROM
(
SELECT
 ROW_NUMBER () OVER (PARTITION BY [SIS_ID], [SCHOOL_NAME] ORDER BY [CLASS_NAME] DESC) AS RN
 , t.[USER_NAME]
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
) AS G
WHERE rn = 1
--and SIS_ID = '970018732'
UNION  
SELECT [USER_NAME], PASSWORD, SIS_ID,FIRST_NAME, MIDDLE_NAME, LAST_NAME, GRADE,SCHOOL_NAME,CLASS_NAME,ETHNIC_CAUCASIAN,ETHNIC_AFRICAN_AM, ETHNIC_HISPANIC,ETHNIC_PACIFIC_ISL, ETHNIC_AM_IND_AK_NATIVE,ETHNIC_ASIAN,GENDER_MALE,GENDER_FEMALE,AYP_ECON_DISADVANTAGED,AYP_LTD_ENGLISH_PROFICIENCY,AYP_GIFTED_TALENTED,AYP_MIGRANT,LAST_COL,Orderby
FROM
(
SELECT
 ROW_NUMBER () OVER (PARTITION BY stu.SIS_NUMBER, org.ORGANIZATION_NAME ORDER BY scs.ClassName    DESC) AS RN
 ,  stu.SIS_NUMBER                                                    AS [USER_NAME]
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
 , 2            
                                              AS [Orderby]
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
--where  stu.SIS_NUMBER = '970018732'
) Y
WHERE RN = 1
Order by [Orderby]

EXECUTE  AS  LOGIN='QueryFileUser'
GO


--<APS - Read180 - Teacher Addendum>
-- Addendum file to be joined - Fixed rows from a temp table
IF OBJECT_ID('tempdb..##TempStfAddendum') IS NOT NULL DROP TABLE ##TempStfAddendum
CREATE TABLE ##TempStfAddendum(
   [DISTRICT_USER_ID]  NVARCHAR(50) null
 , [SPS_ID]            NVARCHAR(50) null
 , [PREFIX]            NVARCHAR(50) null
 , [FIRST_NAME]        NVARCHAR(50) null
 , [LAST_NAME]         NVARCHAR(50) null
 , [TITLE]             NVARCHAR(50) null
 , [SUFFIX]            NVARCHAR(50) null
 , [EMAIL]             NVARCHAR(50) null
 , [USER_NAME]         NVARCHAR(50) null
 , [PASSWORD]          NVARCHAR(50) null
 , [SCHOOL_NAME]       NVARCHAR(50) null
 , [CLASS_NAME]        NVARCHAR(50) null
 , [LAST_COL]          NVARCHAR(50) null
 )
 -- Load the data into the temp table 
INSERT INTO ##TempStfAddendum
SELECT  
*
FROM

            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0',  
                  'Text;Database=\\SynTempSSIS\Files\TempQuery\;',  
                  'SELECT * from Teacher_addendum.csv'
                )  AS  [CAREER]



      REVERT
GO


--<APS - Read180 - teacher>
-- Addendum file to be joined - Fixed rows from a temp table
; with SelectedCourses AS
(
SELECT
   STF.STAFF_GU
 , REPLACE(STF.BADGE_NUM, 'e', '') BADGE_NUM
   --courses at Hayes Middle School the number 416 will need to precede the course number
 , crs.COURSE_TITLE + ' '+
   CASE WHEN sch.SCHOOL_CODE = '416' THEN '416' ELSE '' END +
   crs.COURSE_ID + ' '+
   sec.SECTION_ID + ' ' +
   CAST(sec.PERIOD_BEGIN as VARCHAR(2)) ClassName
 , stfp.FIRST_NAME
 , stfp.LAST_NAME
 , COALESCE(stfp.JOB_TITLE, 'Administrator') TITLE
 , COALESCE(stfp.EMAIL, 'aps.edu') email
 , org.ORGANIZATION_NAME
FROM 
	REV.EPC_STU_SCH_YR              SSY 
	JOIN REV.EPC_STU                STU    ON STU.STUDENT_GU = SSY.STUDENT_GU
	JOIN REV.EPC_STU_CLASS          CLS    ON CLS.STUDENT_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU
	JOIN REV.EPC_SCH_YR_SECT        SEC    ON CLS.SECTION_GU = SEC.SECTION_GU
	JOIN REV.EPC_STAFF_SCH_YR       STFSSY ON STFSSY.STAFF_SCHOOL_YEAR_GU = SEC.STAFF_SCHOOL_YEAR_GU
	JOIN rev.EPC_STAFF              STF    ON STF.STAFF_GU = STFSSY.STAFF_GU
	JOIN REV.REV_PERSON             STFP   ON STFP.PERSON_GU              = STFSSY.STAFF_GU
	JOIN REV.EPC_SCH_YR_CRS         SYCRS  ON SYCRS.SCHOOL_YEAR_COURSE_GU = SEC.SCHOOL_YEAR_COURSE_GU
	JOIN REV.EPC_CRS                CRS    ON CRS.COURSE_GU = SYCRS.COURSE_GU
	JOIN REV.REV_ORGANIZATION_YEAR  OY     ON OY.ORGANIZATION_YEAR_GU = SSY.ORGANIZATION_YEAR_GU
	JOIN REV.REV_YEAR               Y      ON Y.YEAR_GU = OY.YEAR_GU 
	                                          AND Y.YEAR_GU = (SELECT YEAR_GU FROM REV.SIF_22_Common_CurrentYearGU)
    JOIN REV.EPC_SCH                SCH    ON SCH.ORGANIZATION_GU = OY.ORGANIZATION_GU
	JOIN REV.REV_ORGANIZATION       ORG    ON ORG.ORGANIZATION_GU = oy.ORGANIZATION_GU
WHERE  SSY.STATUS IS NULL
AND (crs.COURSE_ID IN (
'540111','540112','540211','540212','540311','540312','21206','212061','212062','21207'
,'212071','212072','21208','212081','212082','210421','210422','210431','210432','210441'
,'210442','212091','212092','212101','212102','212111','212112','212121','212122','54011'
,'54021', '540411', '540412','54031','540611','540612'
)
OR (crs.COURSE_ID IN
('0604a1','0604a2','0614a1','0614a2','2055e1','2055e2','2055j1','21206',
'2055j2','2055n1','250311','250312','250341','250342''0604b1','0604b2','0614b1','0614b2','0621011','0621012','0621021','0621022','0621031','0621032','0621041',
'0621042','0624b1','0624b2','0654cb1','0654cb2','0654gb1','0654gb2','2055b1','2055b2','2055f1','2055f2','2055k1','2055k2','2055p1','2055p2','215551','215552',
'250411','250412','250413','25041c','25041c1','25041c2','25041de1','25041de2','25041oc1','25041oc2','250441','250442','25044de','25044de2','25044oc1','25044oc2'
) 
AND SCH.SCHOOL_CODE IN ('540','570'))
OR
(SCH.[SCHOOL_CODE] IN ('206','496') AND SEC.PERIOD_BEGIN = 1)
OR
(SCH.SCHOOL_CODE = '496' AND crs.COURSE_ID = '10240000')
OR
(SCH.SCHOOL_CODE = '217' AND SSY.GRADE NOT IN ('100','110'))
)


)
SELECT
 
    [DISTRICT_USER_ID]  
  , [SPS_ID]            
  , ' ' [PREFIX]            
  , [FIRST_NAME]        
  , [LAST_NAME]         
  , [TITLE]             
  , ' ' [SUFFIX]            
  , [EMAIL]             
  , [USER_NAME]         
  , [PASSWORD]          
  , [SCHOOL_NAME]       
  , [CLASS_NAME]        
  , [LAST_COL]          
  , 1 [Orderby] 
 

FROM ##TempStfAddendum t
WHERE t.USER_NAME != '' and t.PASSWORD != '' and t.SPS_ID != '' and t.FIRST_NAME != ''
UNION  
SELECT DISTINCT
   scs.BADGE_NUM         AS [DISTRICT_USER_ID]
 , scs.BADGE_NUM         AS [SPS_ID]
 , ' '                   AS [PREFIX]
 , scs.FIRST_NAME        AS [FIRST_NAME]
 , scs.LAST_NAME         AS [LAST_NAME]
 , scs.TITLE             AS [TITLE]
 , ' '                   AS [SUFFIX]
 , scs.email             AS [EMAIL]
 , scs.BADGE_NUM         AS [USER_NAME]
 , 'Teacher1'            AS [PASSWORD]
 , scs.ORGANIZATION_NAME AS [SCHOOL_NAME]
 , scs.ClassName         AS [CLASS_NAME]
 , 'Y'                   AS [LAST_COL]
 , 2                     AS [Orderby]
FROM rev.EPC_STAFF                  stf
JOIN SelectedCourses                scs  ON scs.STAFF_GU = stf.STAFF_GU
order by [Orderby]

