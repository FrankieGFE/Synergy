



-- Create a UD View (create the UD Table, then drop it and then create the View)
-- List (union) of the services from Current IEPs and services from NM state reporting 40th day snapshot
-- On 2/12/2015, ticket 240193, added convert(datetime,convert(varchar,getdate(),112),112)
--                              to check for IEP Services being delivered as of today
-- On 11/18/2016, ticket 290988, Services that end on the next IEP review date should continue (stay-put IEP).
--begin tran




USE ST_SPED
GO

/****** Object:  View [dbo].[Email_v]    Script Date: 8/31/2017 1:36:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--drop table rev.UD_SPED_IEP_SERVICES
--drop view rev.UD_SPED_IEP_SERVICES

CREATE view rev.UD_SPED_IEP_SERVICES as

select iep.IEP_GU UDSPEDIEPSERVICE_GU,
       iep.STUDENT_GU,
	   srv.SERVICE_DESCRIPTION,
	   isv.NUM_MINUTES,
       isv.FREQUENCY_UNIT_DD FREQUENCY
from rev.EP_STUDENT_IEP iep
inner join REV.EP_STU_IEP_SERVICE isv on (isv.IEP_GU = iep.IEP_GU)
inner join REV.EP_SPECIAL_ED_SERVICE srv on (srv.SERVICE_GU = isv.SERVICE_GU)
left outer join REV.EP_STUDENT_SPECIAL_ED sse on (sse.STUDENT_GU = iep.STUDENT_GU)
where sse.EXIT_DATE is null and iep.IEP_STATUS = 'CU'
  and convert(datetime,convert(varchar,getdate(),112),112) >= isv.[START_DATE]
  and (isv.END_DATE = iep.NEXT_IEP_DATE or convert(datetime,convert(varchar,getdate(),112),112) <= isv.END_DATE)
union all
select sr.STU_SPED_RPT_GU,sr.STUDENT_GU,srv.SERVICE_DESCRIPTION,srsv.SERVICE_FREQ NUM_MINUTES,
       srsv.SERVICE_CYCLE FREQUENCY
from (select row_number() over (partition by STUDENT_GU order by SNAPSHOT_TYPE desc) RowNum,*
      from REV.EPC_NM_STU_SPED_RPT
      where SCHOOL_YEAR = (select SCHOOL_YEAR from REV.SIF_22_Common_CurrentYear)) sr
inner join REV.EPC_NM_STU_SPED_RPT_SRV srsv on (srsv.STU_SPED_RPT_GU = sr.STU_SPED_RPT_GU and sr.RowNum = 1)
left outer join REV.EP_STUDENT_SPECIAL_ED sse on (sse.STUDENT_GU = sr.STUDENT_GU)
left outer join (select VALUE_CODE, VALUE_DESCRIPTION SERVICE_DESCRIPTION from REV.REV_BOD_LOOKUP_VALUES
                 where LOOKUP_DEF_GU in (select LOOKUP_DEF_GU from REV.REV_BOD_LOOKUP_DEF
                 where LOOKUP_NAMESPACE = 'K12.SpecialEd.IEP' and LOOKUP_DEF_CODE = 'SPED_SERVICE'))
                 srv on (srv.VALUE_CODE = srsv.SERVICE_CODE)
where sse.EXIT_DATE is null and sr.STUDENT_GU not in
  (select STUDENT_GU from REV.EP_STUDENT_IEP where IEP_STATUS = 'CU')

go

--rollback
