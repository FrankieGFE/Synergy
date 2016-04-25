--<APS - SchoolNet - RDA - Student>
declare @SchYr INT
declare @SchExt varchar(1) = 'R'
declare @RunDate smalldatetime = getdate()
set @SchYr = (select school_year from rev.SIF_22_Common_CurrentYear) 
----**********  Comment out these post year roll over *******
set @RunDate = '08/04/2014'
set @SchYr = 2014  
------------------------------------------------------------
; with Rlist AS
(
select 
  pvt.PERSON_GU
, pvt.[1] as Race1
, pvt.[2] as Race2
, pvt.[3] as Race3
, pvt.[4] as Race4
, pvt.[5] as Race5
, ROW_NUMBER() OVER(PARTITION by pvt.PERSON_GU order by pvt.person_gu) rn
from 
  (select
       ROW_NUMBER() OVER(PARTITION by seth.PERSON_GU order by seth.Ethnic_code) rn
    ,  seth.PERSON_GU
    , seth.ETHNIC_CODE
   from rev.REV_PERSON_SECONDRY_ETH_LST seth
   ) pt
   pivot (min(ETHNIC_CODE) FOR rn in ([1],[2],[3],[4],[5])) pvt
)
SELECT
   stu.SIS_NUMBER                            AS [fld_ID_NBR]
 , ''                                        AS [fld_STATE_ID]
 , ''                                        AS [fld_PRIOR_ID]
 , per.FIRST_NAME                            AS [fld_FRST_NME]
 , per.LAST_NAME                             AS [fld_LST_NME]
 , per.MIDDLE_NAME                           AS [fld_M_NME]
 , convert(varchar(10), per.birth_date, 120) AS [fld_BRTH_DT]
 , per.GENDER                                AS [fld_GENDER]
 , CASE
             WHEN rl.Race1 = '1'     THEN 'C'
             WHEN rl.Race1 = '600'   THEN 'B'
             WHEN rl.Race1 = '100'   THEN 'I'
             WHEN rl.Race1 = '299'   THEN 'A'
             WHEN rl.Race1 = '399'   THEN 'P'
             WHEN rl.Race1 = '401'   THEN 'X'
   END                                       AS [fld_ETHN_CD]
 , CASE
             WHEN rl.Race1 = '1'     THEN 'WHITE-CAUCASION'
             WHEN rl.Race1 = '600'   THEN 'BBLACK-AFRICANAM'
             WHEN rl.Race1 = '100'   THEN 'AM INDIAN'
             WHEN rl.Race1 = '299'   THEN 'ASIAN'
             WHEN rl.Race1 = '399'   THEN 'PACIFIC ISLANDER'
             WHEN rl.Race1 = '401'   THEN 'X'
   END                                       AS [fld_ETHN_VALUE]
 ,  CASE
             WHEN rl.Race2 = '1'     THEN 'C'
             WHEN rl.Race2 = '600'   THEN 'B'
             WHEN rl.Race2 = '100'   THEN 'I'
             WHEN rl.Race2 = '299'   THEN 'A'
             WHEN rl.Race2 = '399'   THEN 'P'
             WHEN rl.Race2 = '401'   THEN 'X'
   END                                       AS [fld_ETHN_CD2]
 , CASE
             WHEN rl.Race2 = '1'     THEN 'WHITE-CAUCASION'
             WHEN rl.Race2 = '600'   THEN 'BBLACK-AFRICANAM'
             WHEN rl.Race2 = '100'   THEN 'AM INDIAN'
             WHEN rl.Race2 = '299'   THEN 'ASIAN'
             WHEN rl.Race2 = '399'   THEN 'PACIFIC ISLANDER'
             WHEN rl.Race2 = '401'   THEN 'X'
   END                                       AS [fld_ETHN2_VALUE]
 ,  CASE
             WHEN rl.Race3 = '1'     THEN 'C'
             WHEN rl.Race3 = '600'   THEN 'B'
             WHEN rl.Race3 = '100'   THEN 'I'
             WHEN rl.Race3 = '299'   THEN 'A'
             WHEN rl.Race3 = '399'   THEN 'P'
             WHEN rl.Race3 = '401'   THEN 'X'
   END                                       AS [fld_ETHN_CD3]
 , CASE
             WHEN rl.Race3 = '1'     THEN 'WHITE-CAUCASION'
             WHEN rl.Race3 = '600'   THEN 'BBLACK-AFRICANAM'
             WHEN rl.Race3 = '100'   THEN 'AM INDIAN'
             WHEN rl.Race3 = '299'   THEN 'ASIAN'
             WHEN rl.Race3 = '399'   THEN 'PACIFIC ISLANDER'
             WHEN rl.Race3 = '401'   THEN 'X'
   END                                       AS [fld_ETHN3_VALUE]
 ,  CASE
             WHEN rl.Race4 = '1'     THEN 'C'
             WHEN rl.Race4 = '600'   THEN 'B'
             WHEN rl.Race4 = '100'   THEN 'I'
             WHEN rl.Race4 = '299'   THEN 'A'
             WHEN rl.Race4 = '399'   THEN 'P'
             WHEN rl.Race4 = '401'   THEN 'X'
   END                                       AS [fld_ETHN_CD4]
 , CASE
             WHEN rl.Race4 = '1'     THEN 'WHITE-CAUCASION'
             WHEN rl.Race4 = '600'   THEN 'BBLACK-AFRICANAM'
             WHEN rl.Race4 = '100'   THEN 'AM INDIAN'
             WHEN rl.Race4 = '299'   THEN 'ASIAN'
             WHEN rl.Race4 = '399'   THEN 'PACIFIC ISLANDER'
             WHEN rl.Race4 = '401'   THEN 'X'
   END                                       AS [fld_ETHN4_VALUE]
 ,  CASE
             WHEN rl.Race5 = '1'     THEN 'C'
             WHEN rl.Race5 = '600'   THEN 'B'
             WHEN rl.Race5 = '100'   THEN 'I'
             WHEN rl.Race5 = '299'   THEN 'A'
             WHEN rl.Race5 = '399'   THEN 'P'
             WHEN rl.Race5 = '401'   THEN 'X'
   END                                       AS [fld_ETHN_CD5]
 , CASE
             WHEN rl.Race5 = '1'     THEN 'WHITE-CAUCASION'
             WHEN rl.Race5 = '600'   THEN 'BBLACK-AFRICANAM'
             WHEN rl.Race5 = '100'   THEN 'AM INDIAN'
             WHEN rl.Race5 = '299'   THEN 'ASIAN'
             WHEN rl.Race5 = '399'   THEN 'PACIFIC ISLANDER'
             WHEN rl.Race5 = '401'   THEN 'X'
   END                                       AS [fld_ETHN5_VALUE]
 , CASE WHEN per.HISPANIC_INDICATOR = 'Y' THEN 'HL'
        ELSE 'NHL'
   END                                       AS [fld_HISPLAT]
 , sch.SCHOOL_CODE                           AS [fld_SCH_NBR]
 , grd.VALUE_DESCRIPTION                     AS [fld_GRDE]
 , (select top 1 f.frm_code from rev.EPC_STU_PGM_FRM_HIS f where f.STUDENT_GU = stu.STUDENT_GU and f.EXIT_DATE is null)
                                             AS [fld_LNCH_FLG]
 , ''                                        AS [fld_ELL_STATUS]
 , ''                                        AS [fld_SPED]
 , ''                                        AS [fld_PRIM_DISAB]
 , ''                                        AS [fld_504]
 , @RunDate                                  AS [fld_DateCreate]
FROM  rev.EPC_STU                    stu
      JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU           = stu.STUDENT_GU
                                             AND ssy.STATUS is NULL
      JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
      JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU               = oyr.YEAR_GU
                                             AND yr.SCHOOL_YEAR       = @SchYr
                                             AND yr.EXTENSION         = @SchExt
      JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU      = oyr.ORGANIZATION_GU
      JOIN rev.REV_PERSON            per  ON per.PERSON_GU            = stu.STUDENT_GU
      LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grd on grd.VALUE_CODE = ssy.GRADE
      LEFT JOIN Rlist                rl   ON rl.PERSON_GU             = stu.STUDENT_GU and rl.rn = 1
