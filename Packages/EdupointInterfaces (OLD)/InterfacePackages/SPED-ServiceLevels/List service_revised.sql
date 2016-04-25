-- List (union) of the services from Current IEPs and services from NM state reporting 40th day snapshot
select  per.LAST_NAME+', '+per.FIRST_NAME [Student]
       , stu.SIS_NUMBER                   [SisNumber]
       , org.ORGANIZATION_NAME            [School]
       , grd.Grade                        [Grade]
       , srv.SERVICE_DESCRIPTION          [Service]
       , isv.NUM_MINUTES                  [Minutes]
       , frq.Frequency                    [Frequency]
from rev.EP_STU                           spedstu
inner join rev.EPC_STU                    stu on (stu.STUDENT_GU = spedstu.STUDENT_GU)
inner join rev.REV_PERSON                 per on (per.PERSON_GU = stu.STUDENT_GU)
inner join rev.EPC_STU_YR                 syr on (syr.STUDENT_GU = stu.STUDENT_GU)
inner join rev.EPC_STU_SCH_YR             ssy on (ssy.STUDENT_SCHOOL_YEAR_GU = syr.STU_SCHOOL_YEAR_GU)
inner join rev.REV_ORGANIZATION_YEAR      oyr on (oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU)
inner join rev.REV_ORGANIZATION           org on (org.ORGANIZATION_GU = oyr.ORGANIZATION_GU)
inner join rev.EP_STUDENT_IEP             iep on (iep.STUDENT_GU = stu.STUDENT_GU)
inner join rev.EP_STU_IEP_SERVICE         isv on (isv.IEP_GU = iep.IEP_GU)
inner join rev.EP_SPECIAL_ED_SERVICE      srv on (srv.SERVICE_GU = isv.SERVICE_GU)
left outer join rev.EP_STUDENT_SPECIAL_ED sse on (sse.STUDENT_GU = stu.STUDENT_GU)
left outer join (select VALUE_CODE, VALUE_DESCRIPTION Grade from rev.REV_BOD_LOOKUP_VALUES
                 where LOOKUP_DEF_GU in (select LOOKUP_DEF_GU from rev.REV_BOD_LOOKUP_DEF
                 where LOOKUP_NAMESPACE = 'K12' and LOOKUP_DEF_CODE = 'GRADE'))
                 grd on (grd.VALUE_CODE = ssy.GRADE)
left outer join (select VALUE_CODE, VALUE_DESCRIPTION Frequency from rev.REV_BOD_LOOKUP_VALUES
                 where LOOKUP_DEF_GU in (select LOOKUP_DEF_GU from rev.REV_BOD_LOOKUP_DEF
                 where LOOKUP_NAMESPACE = 'K12.SpecialEd.IEP' and LOOKUP_DEF_CODE = 'SERVICE_FREQUENCY'))
                 frq on (frq.VALUE_CODE = isv.FREQUENCY_UNIT_DD)
where syr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       and sse.EXIT_DATE is null and iep.IEP_STATUS = 'CU'
union all
select  per.LAST_NAME+', '+per.FIRST_NAME [Student]
      , stu.SIS_NUMBER                    [SisNumber]
      , org.ORGANIZATION_NAME             [School]
      , grd.Grade                         [Grade]
      , srv.[Service]                     [Service]
      , srsv.SERVICE_FREQ                 [Minutes]
      , frq.Frequency                     [Frequency]
from rev.EPC_STU stu
inner join rev.REV_PERSON                 per  on (per.PERSON_GU = stu.STUDENT_GU)
inner join rev.EPC_STU_YR                 syr  on (syr.STUDENT_GU = stu.STUDENT_GU)
inner join rev.EPC_STU_SCH_YR             ssy  on (ssy.STUDENT_SCHOOL_YEAR_GU = syr.STU_SCHOOL_YEAR_GU)
inner join rev.REV_ORGANIZATION_YEAR      oyr  on (oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU)
inner join rev.REV_ORGANIZATION           org  on (org.ORGANIZATION_GU = oyr.ORGANIZATION_GU)
inner join rev.REV_YEAR                   yr   on (yr.YEAR_GU = syr.YEAR_GU)
inner join rev.EPC_NM_STU_SPED_RPT        sr   on (sr.STUDENT_GU = stu.STUDENT_GU and sr.SCHOOL_YEAR = yr.SCHOOL_YEAR and sr.SNAPSHOT_TYPE = '1')
inner join rev.EPC_NM_STU_SPED_RPT_SRV    srsv on (srsv.STU_SPED_RPT_GU = sr.STU_SPED_RPT_GU)
left outer join rev.EP_STUDENT_SPECIAL_ED sse  on (sse.STUDENT_GU = stu.STUDENT_GU)
left outer join (select VALUE_CODE, VALUE_DESCRIPTION Grade from rev.REV_BOD_LOOKUP_VALUES
                 where LOOKUP_DEF_GU in (select LOOKUP_DEF_GU from rev.REV_BOD_LOOKUP_DEF
                 where LOOKUP_NAMESPACE = 'K12' and LOOKUP_DEF_CODE = 'GRADE'))
                 grd on (grd.VALUE_CODE = ssy.GRADE)
left outer join (select VALUE_CODE, VALUE_DESCRIPTION "Service" from rev.REV_BOD_LOOKUP_VALUES
                 where LOOKUP_DEF_GU in (select LOOKUP_DEF_GU from rev.REV_BOD_LOOKUP_DEF
                 where LOOKUP_NAMESPACE = 'K12.SpecialEd.IEP' and LOOKUP_DEF_CODE = 'SPED_SERVICE'))
                 srv on (srv.VALUE_CODE = srsv.SERVICE_CODE)
left outer join (select VALUE_CODE, VALUE_DESCRIPTION Frequency from rev.REV_BOD_LOOKUP_VALUES
                 where LOOKUP_DEF_GU in (select LOOKUP_DEF_GU from rev.REV_BOD_LOOKUP_DEF
                 where LOOKUP_NAMESPACE = 'K12.SpecialEd.IEP' and LOOKUP_DEF_CODE = 'SERVICE_FREQUENCY'))
                 frq on (frq.VALUE_CODE = srsv.SERVICE_CYCLE)
where syr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
      and sse.EXIT_DATE is null and stu.STUDENT_GU not in (select STUDENT_GU from rev.EP_STUDENT_IEP where IEP_STATUS = 'CU')
order by Student,SisNumber,"Service"
