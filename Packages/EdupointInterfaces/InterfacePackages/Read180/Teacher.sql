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
('0604a1','0604a2','0614a1','0614a2','2055e1','2055e2','2055j1',
'2055j2','2055n1','250311','250312','250341','250342') 
AND SCH.SCHOOL_CODE = '540')
OR
(SCH.[SCHOOL_CODE] IN ('206','496') AND SEC.PERIOD_BEGIN = 1)
OR
(SCH.SCHOOL_CODE = '496' AND crs.COURSE_ID = '10240000')
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
 , 'TEACHER1'            AS [PASSWORD]
 , scs.ORGANIZATION_NAME AS [SCHOOL_NAME]
 , scs.ClassName         AS [CLASS_NAME]
 , 'Y'                   AS [LAST_COL]
 , 2                     AS [Orderby]
FROM rev.EPC_STAFF                  stf
JOIN SelectedCourses                scs  ON scs.STAFF_GU = stf.STAFF_GU
order by [Orderby]