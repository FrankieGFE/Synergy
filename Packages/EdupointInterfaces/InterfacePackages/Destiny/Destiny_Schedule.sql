---<APS - Destiny --Schedule>
IF OBJECT_ID('tempdb..##Terms') IS NOT NULL DROP TABLE ##Terms
CREATE TABLE ##Terms(
   OrgGu uniqueidentifier null
   , SchYr varchar(4) null
   , TermCode varchar(4) null
   , TermStart smalldatetime
   , TermEnd smalldatetime
)
--
insert into ##Terms
select 
       t.OrgGU
     , t.SchoolYear
       , t.TermCode
       , TermBegin
       , TermEnd
from rev.SIF_22_TermInfo() t 
     join rev.REV_ORGANIZATION_YEAR oyr on oyr.ORGANIZATION_GU = t.OrgGU
     join rev.REV_YEAR              y   on y.YEAR_GU = oyr.YEAR_GU 
                                              and y.YEAR_GU IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
---
IF OBJECT_ID('tempdb..##SummerTerms') IS NOT NULL DROP TABLE ##SummerTerms
CREATE TABLE ##SummerTerms(
     OrgGu uniqueidentifier null
   , SchYr varchar(4) null
   , TermCode varchar(4) null
   , TermStart smalldatetime
   , TermEnd smalldatetime
)
--
insert into ##SummerTerms
select 
       org.ORGANIZATION_GU
     , yr.SCHOOL_YEAR
       , tcd.TERM_CODE
       , acalo.START_DATE
       , tdef.EVENT_DATE
from rev.rev_organization      org
join rev.REV_ORGANIZATION_YEAR oyr   on oyr.ORGANIZATION_GU = org.ORGANIZATION_GU
join rev.REV_YEAR              yr    on yr.YEAR_GU IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
                                      
                                                                  and yr.YEAR_GU = oyr.YEAR_GU
join rev.EPC_SCH_YR_TRM_DEF    tdef  on tdef.ORGANIZATION_YEAR_GU = oyr.ORGANIZATION_YEAR_GU
join rev.EPC_SCH_YR_TRM_CODES  tcd   on tcd.SCHOOL_YEAR_TRM_DEF_GU = tdef.SCHOOL_YEAR_TRM_DEF_GU
join rev.EPC_SCH_ATT_CAL_OPT   acalo on acalo.ORG_YEAR_GU = oyr.ORGANIZATION_YEAR_GU
--------
IF OBJECT_ID('tempdb..##JumpStartTerms') IS NOT NULL DROP TABLE ##JumpStartTerms
CREATE TABLE ##JumpStartTerms(
     OrgGu uniqueidentifier null
   , SchYr varchar(4) null
   , TermCode varchar(4) null
   , TermStart smalldatetime
   , TermEnd smalldatetime
)
--
insert into ##JumpStartTerms
select 
       org.ORGANIZATION_GU
     , yr.SCHOOL_YEAR
       , tcd.TERM_CODE
       , acalo.START_DATE
       , tdef.EVENT_DATE
from rev.rev_organization      org
join rev.REV_ORGANIZATION_YEAR oyr   on oyr.ORGANIZATION_GU = org.ORGANIZATION_GU
join rev.REV_YEAR              yr    on yr.YEAR_GU IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
          
                                                                  and yr.YEAR_GU = oyr.YEAR_GU
join rev.EPC_SCH_YR_TRM_DEF    tdef  on tdef.ORGANIZATION_YEAR_GU = oyr.ORGANIZATION_YEAR_GU
join rev.EPC_SCH_YR_TRM_CODES  tcd   on tcd.SCHOOL_YEAR_TRM_DEF_GU = tdef.SCHOOL_YEAR_TRM_DEF_GU
join rev.EPC_SCH_ATT_CAL_OPT   acalo on acalo.ORG_YEAR_GU = oyr.ORGANIZATION_YEAR_GU




----------------------------------------------------- Regular Enrollments -------------------------------------
;with  OnlySummer AS
(
  SELECT
     stu.student_gu
  FROM rev.EPC_STU                  stu
     JOIN rev.EPC_STU_SCH_YR        ssyr ON ssyr.STUDENT_GU = stu.STUDENT_GU
                                            AND ssyr.STATUS IS NULL
                                                                           AND ssyr.EXCLUDE_ADA_ADM is null
     JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
     JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU = ssyr.YEAR_GU
                                            AND yr.YEAR_GU IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
                    
)
SELECT DISTINCT

   sch.SCHOOL_CODE                   AS [Sch #]
, crs.COURSE_TITLE                  AS [Course Name]
, crs.COURSE_ID                     AS [Course #]
, sect.SECTION_ID                   AS [Section]
, 'E'+RIGHT('000000000'+ replace(lower(stf.badge_num),'e',''),9)
    AS [Employee Num]
, sect.PERIOD_BEGIN                 AS [Period]
, stu.SIS_NUMBER                    AS [Student ID]
, crs.SUBJECT_AREA_1                AS [Dept]
, CASE WHEN NOT EXISTS           
         (SELECT symd.MEET_DAY_CODE 
       FROM rev.EPC_SCH_YR_SECT_MET_DY sysmd
       JOIN rev.EPC_SCH_YR_MET_DY      symd ON symd.SCH_YR_MET_DY_GU = sysmd.SCH_YR_MET_DY_GU
       WHERE sysmd.SECTION_GU = sect.SECTION_GU
      )
  THEN 'M,T,W,R,F'   
  ELSE               
         STUFF((SELECT [*]=', '+(LEFT(symd.MEET_DAY_CODE,1))  
                FROM rev.EPC_SCH_YR_SECT sec    
                JOIN rev.EPC_SCH_YR_SECT_MET_DY sysmd ON sysmd.SECTION_GU      = sec.SECTION_GU
                JOIN rev.EPC_SCH_YR_MET_DY      symd  ON symd.SCH_YR_MET_DY_GU = sysmd.SCH_YR_MET_DY_GU
                WHERE sec.SECTION_GU  = sect.SECTION_GU       
                ORDER BY symd.ORDERBY    
                FOR XML PATH('')
               ),1,2,'')    
  END                                        AS [Cycle Days]
, CONVERT(VARCHAR(10), trms.TermStart, 101) AS [Class Start Day]
, CONVERT(VARCHAR(10), trms.TermEnd, 101)   AS [Class End Date]
FROM   rev.EPC_STU                          stu
       JOIN rev.EPC_STU_SCH_YR              ssy  ON ssy.STUDENT_GU                 = stu.STUDENT_GU
                                                    and ssy.STATUS is NULL
       JOIN rev.REV_ORGANIZATION_YEAR       oyr  ON oyr.ORGANIZATION_YEAR_GU       = ssy.ORGANIZATION_YEAR_GU
       JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU = ssy.YEAR_GU
                                            AND yr.YEAR_GU IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
                                    
       JOIN rev.REV_ORGANIZATION            org  ON org.ORGANIZATION_GU            = oyr.ORGANIZATION_GU
       JOIN rev.EPC_SCH                     sch  ON sch.ORGANIZATION_GU            = oyr.ORGANIZATION_GU
       JOIN rev.EPC_STU_CLASS               cls  ON cls.STUDENT_SCHOOL_YEAR_GU     = ssy.STUDENT_SCHOOL_YEAR_GU
       JOIN rev.EPC_SCH_YR_SECT             sect ON sect.SECTION_GU                = cls.SECTION_GU
       JOIN rev.EPC_SCH_YR_CRS              scrs ON scrs.SCHOOL_YEAR_COURSE_GU     = sect.SCHOOL_YEAR_COURSE_GU
       JOIN rev.EPC_CRS                     crs  ON crs.COURSE_GU                  = scrs.COURSE_GU
       JOIN rev.EPC_STAFF_SCH_YR            stfy ON stfy.STAFF_SCHOOL_YEAR_GU      = sect.STAFF_SCHOOL_YEAR_GU
          JOIN rev.EPC_STAFF                   stf  ON stf.STAFF_GU                   = stfy.STAFF_GU
       JOIN rev.REV_PERSON                  stfp ON stfp.PERSON_GU                 = stfy.STAFF_GU
          JOIN ##Terms                         trms ON trms.OrgGu                     = oyr.ORGANIZATION_GU
                                                       AND trms.TermCode              = sect.TERM_CODE 
       LEFT JOIN OnlySummer               Summer ON Summer.STUDENT_GU = stu.STUDENT_GU
WHERE (cls.LEAVE_DATE IS NULL OR cls.LEAVE_DATE >= GETDATE())
       AND cls.ENTER_DATE <= GETDATE()
          AND GETDATE() between trms.TermStart and trms.TermEnd
       AND summer.STUDENT_GU is null
---------------------------------------- Summer Term Enrollments ------------------------------------
UNION 
SELECT 

   sch.SCHOOL_CODE                   AS [Sch #]
, crs.COURSE_TITLE                  AS [Course Name]
, crs.COURSE_ID                     AS [Course #]
, sect.SECTION_ID                   AS [Section]
, 'E'+RIGHT('000000000'+ replace(lower(stf.badge_num),'e',''),9)
    AS [Employee Num]
, sect.PERIOD_BEGIN                 AS [Period]
, stu.SIS_NUMBER                    AS [Student ID]
, crs.SUBJECT_AREA_1                AS [Dept]
, CASE WHEN NOT EXISTS           
         (SELECT symd.MEET_DAY_CODE 
       FROM rev.EPC_SCH_YR_SECT_MET_DY sysmd
       JOIN rev.EPC_SCH_YR_MET_DY      symd ON symd.SCH_YR_MET_DY_GU = sysmd.SCH_YR_MET_DY_GU
       WHERE sysmd.SECTION_GU = sect.SECTION_GU
      )
  THEN 'M,T,W,R,F'   
  ELSE               
         STUFF((SELECT [*]=', '+(LEFT(symd.MEET_DAY_CODE,1))  
                FROM rev.EPC_SCH_YR_SECT sec    
                JOIN rev.EPC_SCH_YR_SECT_MET_DY sysmd ON sysmd.SECTION_GU      = sec.SECTION_GU
                JOIN rev.EPC_SCH_YR_MET_DY      symd  ON symd.SCH_YR_MET_DY_GU = sysmd.SCH_YR_MET_DY_GU
                WHERE sec.SECTION_GU  = sect.SECTION_GU       
                ORDER BY symd.ORDERBY    
                FOR XML PATH('')
               ),1,2,'')    
  END                                        AS [Cycle Days]
, CONVERT(VARCHAR(10), trms.TermStart, 101) AS [Class Start Day]
, CONVERT(VARCHAR(10), trms.TermEnd, 101)   AS [Class End Date]
FROM   rev.EPC_STU                          stu
       JOIN rev.EPC_STU_SCH_YR              ssy  ON ssy.STUDENT_GU                 = stu.STUDENT_GU
                                                    and ssy.STATUS is NULL
       JOIN rev.REV_ORGANIZATION_YEAR       oyr  ON oyr.ORGANIZATION_YEAR_GU       = ssy.ORGANIZATION_YEAR_GU
       JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU = ssy.YEAR_GU
                                            AND yr.YEAR_GU IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
                                            
       JOIN rev.REV_ORGANIZATION            org  ON org.ORGANIZATION_GU            = oyr.ORGANIZATION_GU
       JOIN rev.EPC_SCH                     sch  ON sch.ORGANIZATION_GU            = oyr.ORGANIZATION_GU
       JOIN rev.EPC_STU_CLASS               cls  ON cls.STUDENT_SCHOOL_YEAR_GU     = ssy.STUDENT_SCHOOL_YEAR_GU
       JOIN rev.EPC_SCH_YR_SECT             sect ON sect.SECTION_GU                = cls.SECTION_GU
       JOIN rev.EPC_SCH_YR_CRS              scrs ON scrs.SCHOOL_YEAR_COURSE_GU     = sect.SCHOOL_YEAR_COURSE_GU
       JOIN rev.EPC_CRS                     crs  ON crs.COURSE_GU                  = scrs.COURSE_GU
       JOIN rev.EPC_STAFF_SCH_YR            stfy ON stfy.STAFF_SCHOOL_YEAR_GU      = sect.STAFF_SCHOOL_YEAR_GU
          JOIN rev.EPC_STAFF                   stf  ON stf.STAFF_GU                   = stfy.STAFF_GU
       JOIN rev.REV_PERSON                  stfp ON stfp.PERSON_GU                 = stfy.STAFF_GU
          JOIN ##SummerTerms                   trms ON trms.OrgGu                     = oyr.ORGANIZATION_GU
                                                       AND trms.TermCode              = sect.TERM_CODE 
WHERE (cls.LEAVE_DATE IS NULL OR cls.LEAVE_DATE >= GETDATE())

------------------------------------------------ Jump Start Enrollments ---------------------------------------

UNION 
SELECT 

   sch.SCHOOL_CODE                   AS [Sch #]
, crs.COURSE_TITLE                  AS [Course Name]
, crs.COURSE_ID                     AS [Course #]
, sect.SECTION_ID                   AS [Section]
, 'E'+RIGHT('000000000'+ replace(lower(stf.badge_num),'e',''),9)
    AS [Employee Num]
, sect.PERIOD_BEGIN                 AS [Period]
, stu.SIS_NUMBER                    AS [Student ID]
, crs.SUBJECT_AREA_1                AS [Dept]
, CASE WHEN NOT EXISTS           
         (SELECT symd.MEET_DAY_CODE 
       FROM rev.EPC_SCH_YR_SECT_MET_DY sysmd
       JOIN rev.EPC_SCH_YR_MET_DY      symd ON symd.SCH_YR_MET_DY_GU = sysmd.SCH_YR_MET_DY_GU
       WHERE sysmd.SECTION_GU = sect.SECTION_GU
      )
  THEN 'M,T,W,R,F'   
  ELSE               
         STUFF((SELECT [*]=', '+(LEFT(symd.MEET_DAY_CODE,1))  
                FROM rev.EPC_SCH_YR_SECT sec    
                JOIN rev.EPC_SCH_YR_SECT_MET_DY sysmd ON sysmd.SECTION_GU      = sec.SECTION_GU
                JOIN rev.EPC_SCH_YR_MET_DY      symd  ON symd.SCH_YR_MET_DY_GU = sysmd.SCH_YR_MET_DY_GU
                WHERE sec.SECTION_GU  = sect.SECTION_GU       
                ORDER BY symd.ORDERBY    
                FOR XML PATH('')
               ),1,2,'')    
  END                                        AS [Cycle Days]
, CONVERT(VARCHAR(10), trms.TermStart, 101) AS [Class Start Day]
, CONVERT(VARCHAR(10), trms.TermEnd, 101)   AS [Class End Date]
FROM   rev.EPC_STU                          stu
       JOIN rev.EPC_STU_SCH_YR              ssy  ON ssy.STUDENT_GU                 = stu.STUDENT_GU
                                                    and ssy.STATUS is NULL
       JOIN rev.REV_ORGANIZATION_YEAR       oyr  ON oyr.ORGANIZATION_YEAR_GU       = ssy.ORGANIZATION_YEAR_GU
       JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU = ssy.YEAR_GU
                                            AND yr.YEAR_GU IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
       JOIN rev.REV_ORGANIZATION            org  ON org.ORGANIZATION_GU            = oyr.ORGANIZATION_GU
       JOIN rev.EPC_SCH                     sch  ON sch.ORGANIZATION_GU            = oyr.ORGANIZATION_GU
       JOIN rev.EPC_STU_CLASS               cls  ON cls.STUDENT_SCHOOL_YEAR_GU     = ssy.STUDENT_SCHOOL_YEAR_GU
       JOIN rev.EPC_SCH_YR_SECT             sect ON sect.SECTION_GU                = cls.SECTION_GU
       JOIN rev.EPC_SCH_YR_CRS              scrs ON scrs.SCHOOL_YEAR_COURSE_GU     = sect.SCHOOL_YEAR_COURSE_GU
       JOIN rev.EPC_CRS                     crs  ON crs.COURSE_GU                  = scrs.COURSE_GU
       JOIN rev.EPC_STAFF_SCH_YR            stfy ON stfy.STAFF_SCHOOL_YEAR_GU      = sect.STAFF_SCHOOL_YEAR_GU
          JOIN rev.EPC_STAFF                   stf  ON stf.STAFF_GU                   = stfy.STAFF_GU
       JOIN rev.REV_PERSON                  stfp ON stfp.PERSON_GU                 = stfy.STAFF_GU
          JOIN ##JumpStartTerms                trms ON trms.OrgGu                     = oyr.ORGANIZATION_GU
                                                       AND trms.TermCode              = sect.TERM_CODE 


WHERE (cls.LEAVE_DATE IS NULL OR cls.LEAVE_DATE >= GETDATE())
       AND cls.ENTER_DATE <= GETDATE()
          AND GETDATE() between trms.TermStart and trms.TermEnd