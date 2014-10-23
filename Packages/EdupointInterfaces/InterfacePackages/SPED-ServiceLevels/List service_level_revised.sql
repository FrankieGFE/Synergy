-- List (union) of the service level from Current IEPs and service level from NM state reporting 40th day snapshot
-- TomMG
select  cm.LAST_NAME+', '+cm.FIRST_NAME   [CaseManager]
      , rl.ROLE_NAME_LARGE                [CMType]
      , per.LAST_NAME+', '+per.FIRST_NAME [Student]
      , stu.SIS_NUMBER                    [SisNumber]
      , org.ORGANIZATION_NAME             [School]
      , grd.Grade                         [Grade]
      , lvl.SrvLvl                        [ServiceLevel]
from rev.EP_STU                           spedstu
inner join rev.EPC_STU                    stu on (stu.STUDENT_GU = spedstu.STUDENT_GU)
inner join rev.REV_PERSON                 per on (per.PERSON_GU = stu.STUDENT_GU)
inner join rev.EPC_STU_YR                 syr on (syr.STUDENT_GU = stu.STUDENT_GU)
inner join rev.EPC_STU_SCH_YR             ssy on (ssy.STUDENT_SCHOOL_YEAR_GU = syr.STU_SCHOOL_YEAR_GU)
inner join rev.REV_ORGANIZATION_YEAR      oyr on (oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU)
inner join rev.REV_ORGANIZATION           org on (org.ORGANIZATION_GU = oyr.ORGANIZATION_GU)
inner join rev.EP_STUDENT_IEP             iep on (iep.STUDENT_GU = stu.STUDENT_GU)
inner join rev.EP_AZ_IEP_LRE              lre on (lre.IEP_GU = iep.IEP_GU)
inner join rev.EP_STUDENT_TEAM            st  on (st.STUDENT_GU = stu.STUDENT_GU)
inner join rev.REV_ROLE                   rl  on (rl.ROLE_GU = st.ROLE_GU and rl.ROLE_TYPE = 'CASE_MANAGER')
inner join rev.REV_PERSON                 cm  on (cm.PERSON_GU = st.STAFF_GU)
left outer join rev.EP_STUDENT_SPECIAL_ED sse on (sse.STUDENT_GU = stu.STUDENT_GU)
left outer join (select VALUE_CODE, VALUE_DESCRIPTION Grade from rev.REV_BOD_LOOKUP_VALUES
                 where LOOKUP_DEF_GU in (select LOOKUP_DEF_GU from rev.REV_BOD_LOOKUP_DEF
                 where LOOKUP_NAMESPACE = 'K12' and LOOKUP_DEF_CODE = 'GRADE'))
                 grd on (grd.VALUE_CODE = ssy.GRADE)
left outer join (select VALUE_CODE, VALUE_DESCRIPTION SrvLvl from rev.REV_BOD_LOOKUP_VALUES
                 where LOOKUP_DEF_GU in (select LOOKUP_DEF_GU from rev.REV_BOD_LOOKUP_DEF
                 where LOOKUP_NAMESPACE = 'K12.SpecialEd.IEP' and LOOKUP_DEF_CODE = 'LEVEL_INTEGRATION'))
                 lvl on (lvl.VALUE_CODE = lre.LEVEL_INTEGRATION)
where syr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
      and sse.EXIT_DATE is null and iep.IEP_STATUS = 'CU'
union all
select  cm.LAST_NAME+', '+cm.FIRST_NAME   [CaseManager]
      , rl.ROLE_NAME_LARGE                [CMType]
      , per.LAST_NAME+', '+per.FIRST_NAME [Student]
      , stu.SIS_NUMBER                    [SisNumber]
      , org.ORGANIZATION_NAME             [School]
      , grd.Grade                         [Grade]
      , lvl.SrvLvl                        [ServiceLevel]
from rev.EPC_STU stu
inner join rev.REV_PERSON                 per on (per.PERSON_GU = stu.STUDENT_GU)
inner join rev.EPC_STU_YR                 syr on (syr.STUDENT_GU = stu.STUDENT_GU)
inner join rev.EPC_STU_SCH_YR             ssy on (ssy.STUDENT_SCHOOL_YEAR_GU = syr.STU_SCHOOL_YEAR_GU)
inner join rev.REV_ORGANIZATION_YEAR      oyr on (oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU)
inner join rev.REV_ORGANIZATION           org on (org.ORGANIZATION_GU = oyr.ORGANIZATION_GU)
inner join rev.REV_YEAR                   yr  on (yr.YEAR_GU = syr.YEAR_GU)
inner join rev.EPC_NM_STU_SPED_RPT        sr  on (sr.STUDENT_GU = stu.STUDENT_GU and sr.SCHOOL_YEAR = yr.SCHOOL_YEAR and sr.SNAPSHOT_TYPE = '1')
inner join rev.EP_STUDENT_TEAM            st  on (st.STUDENT_GU = stu.STUDENT_GU)
inner join rev.REV_ROLE                   rl  on (rl.ROLE_GU = st.ROLE_GU and rl.ROLE_TYPE = 'CASE_MANAGER')
inner join rev.REV_PERSON                 cm  on (cm.PERSON_GU = st.STAFF_GU)
left outer join rev.EP_STUDENT_SPECIAL_ED sse on (sse.STUDENT_GU = stu.STUDENT_GU)
left outer join (select VALUE_CODE, VALUE_DESCRIPTION Grade from rev.REV_BOD_LOOKUP_VALUES
                 where LOOKUP_DEF_GU in (select LOOKUP_DEF_GU from rev.REV_BOD_LOOKUP_DEF
                 where LOOKUP_NAMESPACE = 'K12' and LOOKUP_DEF_CODE = 'GRADE'))
                 grd on (grd.VALUE_CODE = ssy.GRADE)
left outer join (select VALUE_CODE, VALUE_DESCRIPTION SrvLvl from rev.REV_BOD_LOOKUP_VALUES
                 where LOOKUP_DEF_GU in (select LOOKUP_DEF_GU from rev.REV_BOD_LOOKUP_DEF
                 where LOOKUP_NAMESPACE = 'K12.SpecialEd.IEP' and LOOKUP_DEF_CODE = 'LEVEL_INTEGRATION'))
                 lvl on (lvl.VALUE_CODE = sr.LEVEL_INTEGRATION)
where syr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
      and sse.EXIT_DATE is null and stu.STUDENT_GU not in (select STUDENT_GU from rev.EP_STUDENT_IEP where IEP_STATUS = 'CU')
order by CaseManager,CMType,Student,SisNumber
