--<APS - Naviance Student Data >
--All Active Enrolled students Grade Level 06-12

CREATE VIEW
APS.NAVIANCE_STUDENT
AS

with  gpainfo AS
(
SELECT
      ROW_NUMBER() OVER (partition by stu.student_gu order by stu.student_gu, type.gpa_type_name) rn 
    , stu.STUDENT_GU
    , stu.SIS_NUMBER 
    , def.GPA_CODE
    , gpa.GPA
    , gpa.CLASS_RANK
    , run.CLASS_SIZE
    , gpa.CLASS_RANK_PCTILE
    , type.GPA_TYPE_NAME
       
FROM REV.EPC_STU_SCH_YR          ssy
JOIN rev.EPC_STU                 stu  ON stu.STUDENT_GU                  = ssy.STUDENT_GU
JOIN rev.EPC_STU_GPA             gpa  ON ssy.STUDENT_SCHOOL_YEAR_GU      = gpa.STUDENT_SCHOOL_YEAR_GU
JOIN rev.EPC_SCH_YR_GPA_TYPE_RUN run  ON run.SCHOOL_YEAR_GPA_TYPE_RUN_GU = gpa.SCHOOL_YEAR_GPA_TYPE_RUN_GU
                                         and run.SCHOOL_YEAR_GRD_PRD_GU    is null
JOIN rev.EPC_GPA_DEF_TYPE        type ON type.GPA_DEF_TYPE_GU            = run.GPA_DEF_TYPE_GU
                                         and type.GPA_TYPE_NAME          in ('HS Cum Flat', 'MS Cum Flat')
JOIN rev.EPC_GPA_DEF             def  ON def.GPA_DEF_GU                  = type.GPA_DEF_GU
JOIN rev.REV_ORGANIZATION_YEAR   oy   ON oy.ORGANIZATION_YEAR_GU         = ssy.ORGANIZATION_YEAR_GU
JOIN rev.REV_YEAR                y    ON y.YEAR_GU                       = oy.YEAR_GU
                                         AND y.YEAR_GU                   = (SELECT YEAR_GU FROM REV.SIF_22_Common_CurrentYearGU)
WHERE  ssy.STATUS IS NULL
), gpawinfo AS
(
SELECT
      ROW_NUMBER() OVER (partition by stu.student_gu order by stu.student_gu, type.gpa_type_name) rn 
    , stu.STUDENT_GU
    , stu.SIS_NUMBER 
    , def.GPA_CODE
    , gpa.GPA
    , gpa.CLASS_RANK
    , run.CLASS_SIZE
    , gpa.CLASS_RANK_PCTILE
    , type.GPA_TYPE_NAME
       
FROM REV.EPC_STU_SCH_YR          ssy
JOIN rev.EPC_STU                 stu  ON stu.STUDENT_GU                  = ssy.STUDENT_GU
JOIN rev.EPC_STU_GPA             gpa  ON ssy.STUDENT_SCHOOL_YEAR_GU      = gpa.STUDENT_SCHOOL_YEAR_GU
JOIN rev.EPC_SCH_YR_GPA_TYPE_RUN run  ON run.SCHOOL_YEAR_GPA_TYPE_RUN_GU = gpa.SCHOOL_YEAR_GPA_TYPE_RUN_GU
                                         and run.SCHOOL_YEAR_GRD_PRD_GU    is null
JOIN rev.EPC_GPA_DEF_TYPE        type ON type.GPA_DEF_TYPE_GU            = run.GPA_DEF_TYPE_GU
                                         and type.GPA_TYPE_NAME          in ('HS Cum Weighted', 'MS Cum Weighted')
JOIN rev.EPC_GPA_DEF             def  ON def.GPA_DEF_GU                  = type.GPA_DEF_GU
JOIN rev.REV_ORGANIZATION_YEAR   oy   ON oy.ORGANIZATION_YEAR_GU         = ssy.ORGANIZATION_YEAR_GU
JOIN rev.REV_YEAR                y    ON y.YEAR_GU                       = oy.YEAR_GU
                                         AND y.YEAR_GU                   = (SELECT YEAR_GU FROM REV.SIF_22_Common_CurrentYearGU)
WHERE  ssy.STATUS IS NULL
)
SELECT
   stu.SIS_NUMBER                                             AS [Student_ID]
 , stu.EXPECTED_GRADUATION_YEAR                               AS [Class_Year]
 , per.LAST_NAME                                              AS [Last Name]
 , sch.SCHOOL_CODE                                            AS [Campus ID]
 , per.FIRST_NAME                                             AS [First Name]
 , per.MIDDLE_NAME                                            AS [Middle Name]
 , stu.STATE_STUDENT_NUMBER                                   AS [State Student ID]
 , per.GENDER                                                 AS [Gender]
 , stu.SIS_NUMBER                                             AS [FC User Name]
 ,  REPLACE(CONVERT(VARCHAR(10), per.BIRTH_DATE,101), '/','') AS [FC Password]
 , case
    when per.RESOLVED_ETHNICITY_RACE = '__HIS' THEN 'H'
    when per.RESOLVED_ETHNICITY_RACE = '__TWO' THEN 'M'
	else eth.ALT_CODE_3
   end                                                        AS [Ethnicity]
 , CONVERT(VARCHAR(10), per.BIRTH_DATE,101)                   AS [Date of Birth]
 , adr.ADDRESS                                                AS [Street Address 1]
 , ''                                                         AS [Street Address_2]
 , adr.CITY                                                   AS [City]
 , adr.STATE                                                  AS [State]
 , adr.ZIP_5                                                  AS [Zip_Code]
 , gpa.GPA                                                    AS [GPA]
 , gpaw.GPA                                                   AS [Weighted GPA]
FROM rev.EPC_STU                      stu
JOIN rev.EPC_STU_SCH_YR               ssyr  ON ssyr.STUDENT_GU            = stu.STUDENT_GU 
                                               AND ssyr.STATUS              IS NULL
JOIN rev.REV_ORGANIZATION_YEAR        oyr   ON oyr.ORGANIZATION_YEAR_GU   = ssyr.ORGANIZATION_YEAR_GU
                                               AND oyr.YEAR_GU            = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
JOIN rev.REV_ORGANIZATION             org   ON org.ORGANIZATION_GU        = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH                      sch   ON sch.ORGANIZATION_GU        = org.ORGANIZATION_GU
JOIN rev.REV_PERSON                   per   ON per.PERSON_GU              = stu.STUDENT_GU
LEFT JOIN rev.REV_ADDRESS             adr   ON adr.ADDRESS_GU             = per.HOME_ADDRESS_GU
LEFT JOIN rev.EPC_STAFF_SCH_YR        stfsy ON stfsy.STAFF_SCHOOL_YEAR_GU = ssyr.COUNSELOR_SCHOOL_YEAR_GU
LEFT JOIN rev.REV_PERSON              stf   ON stf.PERSON_GU              = stfsy.STAFF_GU
LEFT JOIN gpainfo                     gpa   ON gpa.STUDENT_GU             = stu.STUDENT_GU 
                                               and gpa.rn                 = 1
LEFT JOIN gpainfo                     gpaw  ON gpaw.STUDENT_GU            = stu.STUDENT_GU 
                                               and gpaw.rn                 = 1


LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','GRADE') tblgrd  ON tblgrd.VALUE_CODE  = ssyr.GRADE
LEFT JOIN rev.SIF_22_Common_GetLookupValues('Revelation','ETHNICITY') eth  ON eth.VALUE_CODE  = per.RESOLVED_ETHNICITY_RACE
JOIN rev.EPC_SCH_YR_OPT              sopt   ON sopt.ORGANIZATION_YEAR_GU   = oyr.ORGANIZATION_YEAR_GU
WHERE tblgrd.VALUE_DESCRIPTION in ('06','07','08','09','10','11','12')